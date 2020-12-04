using Godot;
using System;

public class BuildingManager : Node
{
    static BuildingManager that;
    PackedScene _keepScene;
    PackedScene _granaryScene;
    PackedScene _stockpileScene;
    PackedScene _woodcutterHutScene;

    public Building PlacingBuilding = null;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        that = this;
        _keepScene = ResourceLoader.Load(Keep.Resource) as PackedScene;
        _granaryScene = ResourceLoader.Load(Granary.Resource) as PackedScene;
        _stockpileScene = ResourceLoader.Load(Stockpile.Resource) as PackedScene;
        _woodcutterHutScene = ResourceLoader.Load(WoodcutterHut.Resource) as PackedScene;
    }

    static public Building Spawn(BUILDINGTYPE buildingType, Vector3 origin, Player owner)
    {
        Building b = that.GetBuilding(buildingType);
        that.AddChild(b);
        b.Init(buildingType, origin, owner);
        b.IsBuilt = true;
        Utilities.MoveToFloor(b);

        return b;
    }

    public void BuildingPlacement(Player player, BUILDINGTYPE buildingType)
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

    private Building GetBuilding(BUILDINGTYPE buildingType)
    {
        Building b = null;
        switch (buildingType)
        {
            case BUILDINGTYPE.WoodcutterHut:
                b = _woodcutterHutScene.Instance() as Building;
                break;
            case BUILDINGTYPE.Stockpile:
                b = _stockpileScene.Instance() as Building;
                break;
            case BUILDINGTYPE.Granary:
                b = _granaryScene.Instance() as Building;
                break;
            case BUILDINGTYPE.Keep:
                b = _keepScene.Instance() as Building;
                break;
        }

        return b;
    }

    private bool CanBuild(Player player, BUILDINGTYPE buildingType)
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

    public int GetStoneReq(BUILDINGTYPE buildingType)
    {
        switch (buildingType)
        {
            case BUILDINGTYPE.Stockpile:
                return Stockpile.StoneCost;
            case BUILDINGTYPE.WoodcutterHut:
                return WoodcutterHut.StoneCost;
            case BUILDINGTYPE.Granary:
                return Granary.StoneCost;
            default:
                return 99999;
        }
    }

    public int GetPitchReq(BUILDINGTYPE buildingType)
    {
        switch (buildingType)
        {
            case BUILDINGTYPE.WoodcutterHut:
                return WoodcutterHut.PitchCost;
            case BUILDINGTYPE.Stockpile:
                return Stockpile.PitchCost;
            case BUILDINGTYPE.Granary:
                return Granary.PitchCost;
            default:
                return 99999;
        }
    }

    public int GetWoodReq(BUILDINGTYPE buildingType)
    {
        switch (buildingType)
        {
            case BUILDINGTYPE.WoodcutterHut:
                return WoodcutterHut.WoodCost;
            case BUILDINGTYPE.Stockpile:
                return Stockpile.WoodCost;
            case BUILDINGTYPE.Granary:
                return Granary.WoodCost;
            default:
                return 99999;
        }
    }

    public int GetGoldReq(BUILDINGTYPE buildingType)
    {
        switch (buildingType)
        {
            case BUILDINGTYPE.WoodcutterHut:
                return WoodcutterHut.GoldCost;
            case BUILDINGTYPE.Stockpile:
                return Stockpile.GoldCost;
            case BUILDINGTYPE.Granary:
                return Granary.GoldCost;
            default:
                return 99999;
        }
    }
}
