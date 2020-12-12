using Godot;
using System;

public class Campfire : Building
{
    static public new string Resource = "res://Scenes/Building/Campfire.tscn";

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        base._Ready();
    }

    public override void Init(BUILDINGTYPE bt, Vector3 origin, Player owner)
    {
        base.Init(bt, origin, owner);
        owner.Campfire = this;
    }
}
