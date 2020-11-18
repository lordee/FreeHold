using Godot;
using System;

public class Unit : KinematicBody
{
    MeshInstance _selector;
    //private Node _missileManager;

    // nav stuff
    Navigation _nav;
    Vector3[] _path = new Vector3[0];
    private int _pathInd = 0;
    private int _moveSpeed = 12;

    // shoot stuff
    Unit _target = null;
    private float _projSpeed = 10f;
    private float _lastAttack = 0f;
    private float _attackCooldown = 1f;

    public int Team = 1;

    public UnitType UnitType;
    public float Health = 300;
    public float MaxHealth = 300;

    public override void _Ready()
    {
        _nav = Game.World.GetNode("Navigation") as Navigation;
        AddToGroup("Units", true);
        _selector = (MeshInstance)GetNode("Selector");

        MeshInstance body = (MeshInstance)this.GetNode("MeshInstance");
        if (Utilities.TeamColours.ContainsKey(this.Team))
        {
            body.MaterialOverride = (Material)ResourceLoader.Load(Utilities.TeamColours[this.Team]);
        }
        //_world = GetNode("/root/World") as World;
        //_missileManager = GetNode("/root/World/MissileManager") as Node;
    }

    public void Init(UnitType u, int team, Vector3 pos)
    {
        UnitType = u;
        Team = team;
        this.Translation = pos;
    }

    public override void _PhysicsProcess(float delta)
    {
        _lastAttack += delta;

        if (_pathInd < _path.Length)
        {
            Vector3 move = (_path[_pathInd] - GlobalTransform.origin);
            if (move.Length() < 0.1)
            {
                _pathInd++;
            }
            else
            {
                MoveAndSlide(move.Normalized() * _moveSpeed, new Vector3(0,1,0));
            }
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
    public void MoveTo(Vector3 targ)
    {
        _path = _nav.GetSimplePath(GlobalTransform.origin, targ);
        _pathInd = 0;
    }

    public void Select()
    {
        _selector.Show();
    }

    public void Deselect()
    {
        _selector.Hide();
    }
}