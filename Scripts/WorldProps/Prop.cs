using Godot;
using System;

public class Prop : Spatial
{
    [Export]
    public PropType PropType;

    public bool InUse = false;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        this.Hide();
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
