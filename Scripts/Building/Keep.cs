using Godot;
using System;

public class Keep : Building
{
    static public new string Resource = "res://Scenes/Building/Keep.tscn";
    Area _doorArea;
    public MeshInstance Campfire;
    Area _campfireArea;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        base._Ready();
        Health = 5000;
        MaxHealth = 5000;
        Population = 10;
        _doorArea = GetNode("DoorMesh/DoorArea") as Area;
        _doorArea.Connect("body_entered", this, nameof(DoorAreaBodyEntered));

        Campfire = GetNode("Campfire") as MeshInstance;
        _campfireArea = GetNode("Campfire/CampfireArea") as Area;
        _campfireArea.Connect("body_entered", this, nameof(CampfireAreaBodyEntered));
        _campfireArea.Connect("body_exited", this, nameof(CampfireAreaBodyExited));
    }

    public override void Init(BUILDINGTYPE bt, Vector3 origin, Player owner)
    {
        base.Init(bt, origin, owner);
        UnitSpawnPoint = _doorArea.GlobalTransform.origin;
    }

    private void DoorAreaBodyEntered(KinematicBody kb)
    {
        
    }

    private void CampfireAreaBodyEntered(KinematicBody kb)
    {
        if (kb is Unit u)
        {
            u.AtCampfire = true;
        }
    }
    private void CampfireAreaBodyExited(KinematicBody kb)
    {
        if (kb is Unit u)
        {
            u.AtCampfire = false;
        }
    }
}
