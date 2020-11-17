using Godot;
using System;

public class BuildingManager : Node
{
    static BuildingManager that;
    string _buildingResource = "res://Scenes/Building.tscn";
    PackedScene _buildingScene;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        that = this;
        _buildingScene = ResourceLoader.Load(_buildingResource) as PackedScene;
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }

    private void Spawn2(BuildingType buildingType, Vector3 origin, int teamID)
    {
        // FIXME - align origin to Floor node
        Building b = _buildingScene.Instance() as Building;
        this.AddChild(b);
        b.Init(buildingType, origin, teamID);
    }

    static public void Spawn(BuildingType buildingType, Vector3 origin, int teamID)
    {
        that.Spawn2(buildingType, origin, teamID);
    }
}
