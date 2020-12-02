using Godot;
using System;
using System.Collections.Generic;

public class World : Spatial
{
    public List<Player> Players = new List<Player>();

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        
    }

    public override void _PhysicsProcess(float delta)
    {
        
    }

}
