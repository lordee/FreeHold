using Godot;
using System;

public class BuildingManager : Node
{
    static BuildingManager that;
    PackedScene _buildingScene;
    PackedScene _granaryScene;

    public Building PlacingBuilding = null;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        that = this;
        _buildingScene = ResourceLoader.Load(Building.Resource) as PackedScene;
        _granaryScene = ResourceLoader.Load(Granary.Resource) as PackedScene;
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }

    private void Spawn2(BuildingType buildingType, Vector3 origin, Player owner)
    {
        // FIXME - align origin to Floor node
        Building b = GetBuilding(buildingType);
        this.AddChild(b);
        b.Init(buildingType, origin, owner);
        b.IsBuilt = true;
    }

    static public void Spawn(BuildingType buildingType, Vector3 origin, Player owner)
    {
        that.Spawn2(buildingType, origin, owner);
    }

    public void BuildingPlacement(Player player, BuildingType buildingType)
    {
        // check requirements
        if (CanBuild(player, buildingType))
        {
            Game.CameraController.ClickState = ClickState.PlacingBuilding;
            Building b = GetBuilding(buildingType);
            AddChild(b);
            PlacingBuilding = b;
            b.Init(buildingType, new Vector3(0,0,0), player);
        }
        else
        {
            UnableToBuild(REASON.RESOURCES);
        }
    }

    public void Build()
    {
        if (!CanBuild(PlacingBuilding.PlayerOwner, PlacingBuilding.BuildingType))
        {
            UnableToBuild(REASON.RESOURCES);
            return;
        }
        
        if (!PlacingBuilding.CanPlace)
        {
            UnableToBuild(REASON.PLACEMENT);
            return;
        }

        PlacingBuilding.PlayerOwner.DeductBuildCost(PlacingBuilding.BuildingType);
        PlacingBuilding.IsBuilt = true;
        PlacingBuilding = null;
    }

    private void UnableToBuild(REASON reason)
    {
        // FIXME - put on a status panel or something, play a sound
        switch (reason)
        {
            case REASON.PLACEMENT:
                GD.Print("You can't place this here");
                break;
            case REASON.RESOURCES:
                GD.Print("You don't have enough resources to build this");
                break;
        }
    }

    public void CancelBuildingPlacement()
    {
        // TODO - message, sound about cancel
        ClearBuildingPlacement();
        
    }

    private void ClearBuildingPlacement()
    {
        RemoveChild(PlacingBuilding);
        PlacingBuilding = null;
    }

    private Building GetBuilding(BuildingType buildingType)
    {
        Building b = null;
        switch (buildingType)
        {
            case BuildingType.Granary:
                b = _granaryScene.Instance() as Building;
                break;
            case BuildingType.Keep:
                b = _buildingScene.Instance() as Building;
                break;
        }

        return b;
    }

    private bool CanBuild(Player player, BuildingType buildingType)
    {
        bool canBuild = false;
        int goldCost = GetGoldReq(buildingType);
        int woodCost = GetWoodReq(buildingType);
        int pitchCost = GetPitchReq(buildingType);
        int stoneCost = GetStoneReq(buildingType);

        if (player.Gold >= goldCost && player.Wood >= woodCost
            && player.Pitch >= pitchCost && player.Stone >= stoneCost)
        {
            canBuild = true;
        }

        return canBuild;
    }

    private int GetStoneReq(BuildingType buildingType)
    {
        switch (buildingType)
        {
            case BuildingType.Granary:
                return Granary.StoneCost;
            default:
                return 99999;
        }
    }

    private int GetPitchReq(BuildingType buildingType)
    {
        switch (buildingType)
        {
            case BuildingType.Granary:
                return Granary.PitchCost;
            default:
                return 99999;
        }
    }

    private int GetWoodReq(BuildingType buildingType)
    {
        switch (buildingType)
        {
            case BuildingType.Granary:
                return Granary.WoodCost;
            default:
                return 99999;
        }
    }

    private int GetGoldReq(BuildingType buildingType)
    {
        switch (buildingType)
        {
            case BuildingType.Granary:
                return Granary.GoldCost;
            default:
                return 99999;
        }
    }
}
