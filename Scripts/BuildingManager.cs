using Godot;
using System;

public class BuildingManager : Node
{
    string _buildingResource = "res://Scenes/Building.tscn";
    PackedScene _buildingScene;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        _buildingScene = ResourceLoader.Load(_buildingResource) as PackedScene;
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }

    static public void Spawn(BuildingType buildingType, Vector3 origin)
    {
        // FIXME - align origin to Floor node


    }
}
