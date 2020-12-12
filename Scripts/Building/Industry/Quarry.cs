using Godot;
using System;

public class Quarry : Building
{
    static public new int GoldCost = 0;
    static public new int WoodCost = 15;
    static public new int PitchCost = 0;
    static public new int StoneCost = 0;
    static public new string Resource = "res://Scenes/Building/Industry/Quarry.tscn";

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        base._Ready();
    }

    public override void Init(BUILDINGTYPE bt, Vector3 origin, Player owner)
    {
        base.Init(bt, origin, owner);
        CanPlace = false;
        WorkersNeeded = 3;
    }
}
