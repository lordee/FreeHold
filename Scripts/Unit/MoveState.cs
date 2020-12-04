using Godot;
using System;

public class MoveState : IUnitState
{
    Unit _owner;
    Vector3 _destination;

    Navigation _nav;
    Vector3[] _path = new Vector3[0];
    private int _pathInd = 0;
    private int _moveTry = 0;
    private float _firstMoveLength = 0;

    public MoveState(Unit u, Vector3 dest)
    {
        _nav = Game.World.GetNode("Navigation") as Navigation;
        _owner = u;
        _destination = dest;
        _path = _nav.GetSimplePath(u.GlobalTransform.origin, dest);
        _pathInd = 0;
    }

    public void Enter()
    {
        
    }
    
    public void Exit()
    {

    }

    public IUnitState Update()
    {
        //GD.Print(_owner.Name + " in MoveState");
        IUnitState newState = null;
        
        if (_pathInd < _path.Length)
        {
            Vector3 move = (_path[_pathInd] - _owner.GlobalTransform.origin);

            // fix jiggle/fighting over single dest vector
            bool incrementMove = false;
            if (_moveTry == 0)
            {
                _firstMoveLength = move.Length();
            }
            else if (_moveTry == 10)
            {
                _moveTry = -1;
                if (_firstMoveLength - move.Length() <= 0.1)
                {
                    // next point
                    incrementMove = true;
                }
            }

            // FIXME - use flow/flocking movement
            if (move.Length() < 0.1 || incrementMove)
            {
                _pathInd++;
                _moveTry = 0;
            }
            else
            {
                _moveTry++;
                _owner.MoveAndSlide(move.Normalized() * _owner.MoveSpeed, new Vector3(0,1,0));
            }
        }
        else
        {
            newState = new IdleState(_owner);
        }
        return newState;
    }
}