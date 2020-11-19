using Godot;
using System;

public class UnitManager : Node
{
    static UnitManager that;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        that = this;
    }

    //  // Called every frame. 'delta' is the elapsed time since the previous frame.
    //  public override void _Process(float delta)
    //  {
    //      
    //  }

    public override void _PhysicsProcess(float delta)
    {
        // for every player

        // check pop
    }
}
