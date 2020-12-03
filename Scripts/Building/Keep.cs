using Godot;
using System;

public class Keep : Building
{
    static public new string Resource = "res://Scenes/Building/Keep.tscn";
    Area _doorArea;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        base._Ready();
        Health = 5000;
        MaxHealth = 5000;
        Population = 10;
        _doorArea = GetNode("DoorMesh/DoorArea") as Area;
        _doorArea.Connect("body_entered", this, nameof(DoorAreaBodyEntered));
    }

    public override void Init(BUILDINGTYPE bt, Vector3 origin, Player owner)
    {
        base.Init(bt, origin, owner);
        UnitSpawnPoint = _doorArea.GlobalTransform.origin;
    }

    private void DoorAreaBodyEntered(KinematicBody kb)
    {
        
    }
}
