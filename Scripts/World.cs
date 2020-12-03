using Godot;
using System;
using System.Collections.Generic;

public class World : Spatial
{
    public List<Player> Players = new List<Player>();
    public MeshInstance Floor;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        Floor = Utilities.GetRecursiveChildByName(this, "Floor") as MeshInstance;
    }

    public override void _PhysicsProcess(float delta)
    {
        
    }

}
