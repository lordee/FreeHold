using Godot;
using System;

public class Prop : Spatial
{
    [Export]
    public PROP PropType;

    public bool InUse = false;
    public Area PropArea;

    private float _lifeTime = 0f;

    public override void _Ready()
    {
        if (PropType == PROP.STARTLOCATION)
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
            case PROP.TREE:
                if (_lifeTime >= Game.World.TreePropagationTime)
                {
                    _lifeTime = 0;
                    // TODO - get this going, put in a tree prop class
                }
                break;
        }
    }

    public void PropAreaBodyEntered(Node n)
    {
        if (n is Unit u)
        {
            u.PropAreas.Add(this);
        }
    }

    public void PropAreaBodyExited(Node n)
    {
        if (n is Unit u)
        {
            u.PropAreas.Remove(this);
        }
    }
}
