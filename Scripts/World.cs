using Godot;
using System;
using System.Collections.Generic;

public class World : Spatial
{
    public List<Player> Players = new List<Player>();
    public MeshInstance Floor;
    public List<Prop> Trees = new List<Prop>();
    public float TreePropagationTime = 5f;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        Floor = Utilities.GetRecursiveChildByName(this, "Floor") as MeshInstance;

        foreach (Node n in GetChildren())
        {
            if (n is Prop p)
            {
                Utilities.MoveToFloor(p);
                if (p.PropType == PropType.Tree)
                {
                    Trees.Add(p);
                }
            }
        }
    }

    public override void _PhysicsProcess(float delta)
    {
        
    }

}
