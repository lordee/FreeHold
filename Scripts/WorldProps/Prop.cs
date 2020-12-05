using Godot;
using System;

public class Prop : Spatial
{
    [Export]
    public PropType PropType;

    public bool InUse = false;
    public Area PropArea;

    private float _lifeTime = 0f;

    public override void _Ready()
    {
        if (PropType == PropType.StartLocation)
        {
            this.Hide();
        }
        PropArea = GetNodeOrNull("PropArea") as Area;
        PropArea.Connect("body_entered", this, nameof(PropAreaBodyEntered));
        PropArea.Connect("body_exited", this, nameof(PropAreaBodyExited));
    }

    public override void _PhysicsProcess(float delta)
    {
        _lifeTime += delta;
        switch(PropType)
        {
            case PropType.Tree:
                if (_lifeTime >= Game.World.TreePropagationTime)
                {
                    _lifeTime = 0;
                    // TODO - get this going, put in a tree prop class
                }
                break;
        }
    }

    public void PropAreaBodyEntered(KinematicBody kb)
    {
        if (kb is Unit u)
        {
            u.PropAreas.Add(this);
        }
    }

    public void PropAreaBodyExited(KinematicBody kb)
    {
        if (kb is Unit u)
        {
            u.PropAreas.Remove(this);
        }
    }
}
