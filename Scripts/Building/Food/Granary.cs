using Godot;
using System;

public class Granary : Building
{
    static public new int GoldCost = 0;
    static public new int WoodCost = 5;
    static public new int PitchCost = 0;
    static public new int StoneCost = 0;
    static public new string Resource = "res://Scenes/Building/Granary.tscn";

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        base._Ready();
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
