using Godot;
using System;
using System.Collections.Generic;

public class RtsCameraController : Spatial
{
    // settings
    float _movementSpeed = 20f;
    float _rotationSpeed = 20f;
    bool _invertedY = false;
    float _minElevationAngle = 10;
    float _maxElevationAngle = 80;
    float _zoomSpeed = 20;
    float _zoomSpeedDamp = 0.8f;
    float _minZoom = 3;
    float _maxZoom = 40;
    int RAY_LENGTH = 1000;
    bool _zoomToCursor = false;
    float _panSpeed = 2;

    // state
    bool _lockMovement = false;
    bool _isRotating = false;
    bool _isPanning = false;
    Vector2 _lastMousePosition = new Vector2();
    float _zoomDirection = 0;
    float _moveForward = 0;
    float _moveLeft = 0;
    float _clickLeft = 0;
    bool _isHoldingClickLeft = false;
    float _clickRight = 0;
    bool _isHoldingClickRight = false;
    ClickState _clickState = ClickState.NoSelection;
    Vector2 _startSelPos = new Vector2();

    static public List<InputCommand> InputCommands = new List<InputCommand>();
    List<Unit> _selectedUnits = new List<Unit>();
    List<Building> _selectedBuildings = new List<Building>();

    // nodes
    Spatial _elevation;
    Camera _camera;
    SelectionBox _selectionBox;

    public override void _Ready()
    {
        _elevation = GetNode("Elevation") as Spatial;
        _camera =  GetNode("Elevation/Camera") as Camera;
        _selectionBox = GetNode("SelectionBox") as SelectionBox;
    }

    public override void _Process(float delta)
    {
        if (_lockMovement)
            return;

        InputCommand cmd = new InputCommand();
        Vector2 mPos = GetViewport().GetMousePosition();
        if (InputCommands.Count > 0)
        {
            cmd = InputCommands[0];
            _zoomDirection = cmd.ZoomDirection != 0 ? cmd.ZoomDirection : _zoomDirection;
            if (cmd.IsRotating == 1)
            {
                _isRotating = true;
                _lastMousePosition = GetViewport().GetMousePosition();
            }
            else if (cmd.IsRotating == -1)
            {
                _isRotating = false;
            }

            if (cmd.IsPanning == 1)
            {
                _isPanning = true;
                _lastMousePosition = GetViewport().GetMousePosition();
            }
            else if (cmd.IsPanning == -1)
            {
                _isPanning = false;
            }
            _moveForward = cmd.MoveForward;
            _moveLeft = cmd.MoveLeft;

            if (cmd.ClickLeft == 1 && _clickLeft == 1)
            {
                _isHoldingClickLeft = true;
            }
            else if (cmd.ClickLeft == 1 && _clickLeft != 1)
            {
                _startSelPos = mPos;
            }
            else
            {
                _isHoldingClickLeft = false;
            }
            _clickLeft = cmd.ClickLeft;

            if (cmd.ClickRight == 1 && _clickRight == 1)
            {
                _isHoldingClickRight = true;
            }
            else
            {
                _isHoldingClickRight = false;
            }
            _clickRight = cmd.ClickRight;
        }

        Move(delta);
        RotateAndElevate(delta);
        Zoom(delta);
        Pan(delta);
        
        switch (_clickState)
        {
            case ClickState.NoSelection:
                InputNoSelection(mPos);
                break;
        }

        _clickLeft = _clickLeft == -1 ? 0 : _clickLeft;
        InputCommands.Clear();
    }

    private void InputNoSelection(Vector2 mPos)
    {
        if (_clickRight == 1)
        {
            MoveSelectedUnits(mPos);
        }

        if (_clickLeft == 1 && !_isHoldingClickLeft) // first click
        {
            _selectionBox.StartPos = mPos;
        }

        if (_isHoldingClickLeft)
        {
            _selectionBox.MPos = mPos;
            _selectionBox.DrawBox = true;
        }
        else
        {
            _selectionBox.DrawBox = false;
        }

        if (_clickLeft == -1) // just released
        {
            SelectObjects(mPos);
        }
    }

    private void MoveSelectedUnits(Vector2 mPos)
    {
        Godot.Collections.Dictionary targ = RaycastFromMouse(CollisionMask.All);
        if (targ.Count > 0)
        {
            foreach(Unit u in _selectedUnits)
            {
                u.MoveTo((Vector3)targ["position"]);
            }
        }
    }

    private void SelectObjects(Vector2 mPos)
    {
        foreach (Unit u in _selectedUnits)
        {
            u.Deselect();
        }
        _selectedUnits.Clear();

        foreach(Building u in _selectedBuildings)
        {
            u.Deselect();
        }
        _selectedBuildings.Clear();

        // test to figure out if building or something else
        if (mPos.DistanceSquaredTo(_startSelPos) < 16)
        {
            // single select
            Godot.Collections.Dictionary res = RaycastFromMouse(CollisionMask.Unit);
            if (res.Count > 0)
            {
                if (res["collider"] is Unit u)
                {
                    if (u.Team == Game.Player.TeamID)
                    {
                        _selectedUnits.Add(u);
                    }
                }
                else if (res["collider"] is Building b)
                {
                    if (b.TeamID == Game.Player.TeamID)
                    {
                        _selectedBuildings.Add(b);
                    }
                }
                else
                {
                    //_ui.ShowMenu(MenuType.None);
                }
            }
        }
        else
        {
            SelectObjectsInSelectBox(_selectionBox.StartPos, _selectionBox.MPos);            
        }

        foreach(Unit u in _selectedUnits)
        {
            u.Select();
        }

        foreach(Building u in _selectedBuildings)
        {
            u.Select();
        }
    }

    private void SelectObjectsInSelectBox(Vector2 topLeft, Vector2 botRight)
    {
        List<Unit> units = new List<Unit>();
        if (topLeft.x > botRight.x)
        {
            float tmp = topLeft.x;
            topLeft.x = botRight.x;
            botRight.x = tmp;
        }
        if (topLeft.y > botRight.y)
        {
            float tmp = topLeft.y;
            topLeft.y = botRight.y;
            botRight.y = tmp;
        }

        Rect2 box = new Rect2(topLeft, botRight - topLeft);
        foreach (Unit u in GetTree().GetNodesInGroup("Units"))
        {
            if (//u.Team == this.Player.Team && 
            box.HasPoint(_camera.UnprojectPosition(u.GlobalTransform.origin)))
            {
                units.Add(u);
            }
        }

        _selectedUnits = units;
    }

    private void Move(float delta)
    {
        Vector3 velocity = GetDesiredVelocity() * delta * _movementSpeed;
        TranslatePosition(velocity);
    }

    private void RotateAndElevate(float delta)
    {
        if (!_isRotating)
            return;
        
        Vector2 mouseSpeed = GetMouseSpeed();
        Rotate(mouseSpeed.x, delta);
        Elevate(mouseSpeed.y, delta);
    }

    private void Rotate(float amount, float delta)
    {
        Vector3 rot = RotationDegrees;
        rot.y += _rotationSpeed * amount * delta;
        RotationDegrees = rot;
    }

    private void Pan(float delta)
    {
        if (!_isPanning)
            return;
        
        Vector2 mSpeed = GetMouseSpeed();
        Vector3 vel = (GlobalTransform.basis.z * mSpeed.y + GlobalTransform.basis.x * mSpeed.x) * delta * _panSpeed;
        TranslatePosition(-vel);
    }

    private Vector3 GetDesiredVelocity()
    {
        Vector3 vel = new Vector3();
        // dont move if panning
        if (_isPanning)
            return vel;

        // FIXME - move to playercmd packet
        if (_moveForward == 1)
        {
            vel -= Transform.basis.z;
        }           
        if (_moveForward == -1)
            vel += Transform.basis.z;
        if (_moveLeft == 1)
            vel -= Transform.basis.x;
        if (_moveLeft == -1)
            vel += Transform.basis.x;

        return vel.Normalized();
    }

	private void Elevate(float amount, float delta)
    {
        float newElevation = _elevation.RotationDegrees.x;
        
        if (_invertedY)
        {
            newElevation += _rotationSpeed * amount * delta;
        }
        else
        {
            newElevation -= _rotationSpeed * amount * delta;
        }

        Vector3 rot = _elevation.RotationDegrees;
        rot.x = Mathf.Clamp(newElevation, -_maxElevationAngle, -_minElevationAngle);
        _elevation.RotationDegrees = rot;
    }

    private void Zoom(float delta)
    {
        if (_zoomDirection == 0)
            return;

        float newZoom = Mathf.Clamp(_camera.Translation.z + _zoomDirection * _zoomSpeed * delta, _minZoom, _maxZoom);
        Godot.Collections.Dictionary res = RaycastFromMouse(CollisionMask.All);

        Vector3 trans = _camera.Translation;
        trans.z = newZoom;
        _camera.Translation = trans;
        
        if (res.Count > 0)
        {
            Vector3 pointingAt = (Vector3)res["position"];
            
            // pan if need to zoom to cursor
            if (_zoomToCursor)
            {
                RealignCamera(pointingAt);
            }
        }

        // phase out speed
        _zoomDirection *= _zoomSpeedDamp;
        if (Mathf.Abs(_zoomDirection) < 0.0001)
        {
            _zoomDirection = 0;
        }
    }

    private void RealignCamera(Vector3 point)
    {
        Godot.Collections.Dictionary dict = RaycastFromMouse(CollisionMask.All);
        if (dict.Count > 0)
        {
            TranslatePosition(point - (Vector3)dict["position"]);
        }
    }

    private Vector2 GetMouseSpeed()
    {
        Vector2 currPos = GetViewport().GetMousePosition();
        Vector2 mSpeed = currPos - _lastMousePosition;
        _lastMousePosition = currPos;

        return mSpeed;
    }       

    private void TranslatePosition(Vector3 v)
    {
        Translation += v;
    }

    private Godot.Collections.Dictionary RaycastFromMouse(CollisionMask collisionMask)
    {
        Vector2 mPos = GetViewport().GetMousePosition();
        Vector3 rayFrom = _camera.ProjectRayOrigin(mPos);
        Vector3 rayTo = rayFrom + _camera.ProjectRayNormal(mPos) * RAY_LENGTH;
        PhysicsDirectSpaceState spaceState = GetWorld().DirectSpaceState;
        return spaceState.IntersectRay(rayFrom, rayTo, null, (uint)collisionMask);
    }
}
