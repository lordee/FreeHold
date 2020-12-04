using Godot;
using System;

public class Unit : KinematicBody
{
    MeshInstance _selector;
    MeshInstance _body;
    //private Node _missileManager;
    static public string Resource = "res://Scenes/Unit/Unit.tscn";

    // state
    private IUnitState _currentState;

    // nav stuff
    /*Navigation _nav;
    Vector3[] _path = new Vector3[0];
    private int _pathInd = 0;
    private int _moveTry = 0;
    private float _firstMoveLength = 0;*/
    private int _moveSpeed = 12;
    public int MoveSpeed { get { return _moveSpeed; }}

    // shoot stuff
    Unit _target = null;
    private float _projSpeed = 10f;
    private float _lastAttack = 0f;
    private float _attackCooldown = 1f;

    [Export]
    public int TeamID = 0;

    private Player _playerOwner;

    public UNITTYPE UnitType;
    public float Health = 300;
    public float MaxHealth = 300;

    public bool Unemployed = false;
    public Building Workplace = null;

    public override void _Ready()
    {
        //_nav = Game.World.GetNode("Navigation") as Navigation;
        AddToGroup("Units", true);
        _selector = (MeshInstance)GetNode("Selector");

        _body = (MeshInstance)this.GetNode("MeshInstance");
        _currentState = new IdleState(this);
    }

    public void Init(UNITTYPE u, Player owner, Vector3 pos)
    {
        UnitType = u;
        _playerOwner = owner;
        TeamID = owner.TeamID;
        owner.Units.Add(this);
        Utilities.SetGlobalPosition(this, pos);
        if (Utilities.TeamColours.ContainsKey(this.TeamID))
        {
            _body.MaterialOverride = (Material)ResourceLoader.Load(Utilities.TeamColours[this.TeamID]);
        }

        switch (UnitType)
        {
            case UNITTYPE.Peasant:
                Unemployed = true;
                break;
        }
    }

    public override void _PhysicsProcess(float delta)
    {
        _lastAttack += delta;

        IUnitState newState = _currentState.Update();
        if (newState != null)
        {
            _currentState = newState;
        }
        
/*
        // check for targets, units for now
        if (_target == null)
        {
            Godot.Collections.Array res = FindTargetsInRadius();
            _target = GetClosestEnemy(res);
        }
        
        if (_target != null)
        {
            this.Attack(_target);
        }
        */
    }

  
/*
    private Unit GetClosestEnemy(Godot.Collections.Array result)
    {
        Unit closest = null;
        float closestdist = -1;
        foreach (Godot.Collections.Dictionary r in result) {
            if (r["collider"] is Unit u)
            {
                if (u.Name != this.Name)
                {
                    float dist = this.Transform.origin.DistanceTo(u.Transform.origin);
                    closestdist = (closestdist == -1) ? dist : (closestdist > dist) ? dist : closestdist;
                    if (closestdist == dist)
                    {
                        closest = u;
                    }
                }
            }
        }
        return closest;
    }

    private Godot.Collections.Array FindTargetsInRadius()
    {
        // might be faster to have this permanently in use and use body on_enter fr all units to add them to inrange list
        SphereShape s = new SphereShape();
        float _shootRange = fts.ballistic_range(_projSpeed, _world.Gravity, this.Transform.origin.y);
        s.Radius = _shootRange;

        // Get space and state of the subject body
        RID space = PhysicsServer.BodyGetSpace(this.GetRid());
        PhysicsDirectSpaceState state = PhysicsServer.SpaceGetDirectState(space);

        // Setup shape query parameters
        PhysicsShapeQueryParameters par = new PhysicsShapeQueryParameters();
        par.ShapeRid = s.GetRid();
        par.Transform = this.Transform;
        
        Godot.Collections.Array result = state.IntersectShape(par);

        return result;
    }

    public void Attack(Unit targ)
    {
        if (_lastAttack >= _attackCooldown)
        {
            // solve for arc etc
            // todo, just check for range of unit
            // todo have unit face target
            Vector3[] solutions = new Vector3[2];
            int numSolutions = fts.solve_ballistic_arc(this.Transform.origin, _projSpeed, targ.Transform.origin, _world.Gravity, out solutions[0], out solutions[1]);
            
            if (numSolutions > 0)
            {
                _lastAttack = 0;
                PackedScene pas = ResourceLoader.Load("res://Scenes/Arrow.tscn") as PackedScene;
                Arrow a = pas.Instance() as Arrow;
                
                _missileManager.AddChild(a);
                a.Init(this.Transform, _projSpeed, this.Team, targ.Transform.origin);
            }
        }
    }
*/
    public void MoveTo(Vector3 dest)
    {
        _currentState = new MoveState(this, dest);
    }

    public void Select()
    {
        _selector.Show();
    }

    public void Deselect()
    {
        _selector.Hide();
    }

    public void Employ(Building workplace)
    {
        this.Unemployed = false;
        this.Workplace = workplace;
        this._playerOwner.UnemployedPeasants -= 1;
    }
}