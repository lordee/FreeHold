using Godot;
using System;
using System.Collections.Generic;

public class Player : Node
{
    public int TeamID = 1;
    public int PlayerID;
    public int Gold = 0;
    public int Wood = 30;
    public int Bread;
    public int Meat;
    public int Apples;
    public int Cheese;
    public int Hops;
    public int Ale;
    public int Candles;
    public int Iron;
    public int Stone;
    public int Pitch;

    public int PopulationMax;
    public int Population;
    public int Reputation = 100;
    public int ReputationMax = 100;

    public float PeasantLastSpawn = 0f;

    public Vector3 StartingSpot;

    public List<Building> Buildings = new List<Building>();
    public List<Unit> Units = new List<Unit>();

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        
    }

    public void Init()
    {
        // grab a starting spot
        Godot.Collections.Array children = Game.World.GetChildren();

        foreach (Node n in children)
        {
            if (n is Prop p)
            {
                // spawn keep there
                if (p.PropType == PropType.StartLocation && !p.InUse)
                {
                    p.InUse = true;
                    BuildingManager.Spawn(BUILDINGTYPE.Keep, p.GlobalTransform.origin, this);
                    StartingSpot = p.GlobalTransform.origin;                   
                    break;
                }
            }
        }
    }

    public override void _PhysicsProcess(float delta)
    {
        UpdatePopulation(delta);
    }

    private void UpdatePopulation(float delta)
    {
        int pop = 0;
        foreach(Building b in Buildings)
        {
            pop += b.Population;
        }
        PopulationMax = pop;

        pop = 0;
        foreach(Unit u in Units)
        {
            if (u.UnitType == UNITTYPE.Peasant)
            {
                pop += 1;
            }
        }
        Population = pop;
    }

    public void DeductBuildCost(BUILDINGTYPE buildingType)
    {
        int goldCost = Game.BuildingManager.GetGoldReq(buildingType);
        int woodCost = Game.BuildingManager.GetWoodReq(buildingType);
        int pitchCost = Game.BuildingManager.GetPitchReq(buildingType);
        int stoneCost = Game.BuildingManager.GetStoneReq(buildingType);
        Wood -= woodCost;
        Gold -= goldCost;
        Pitch -= pitchCost;
        Stone -= stoneCost;
    }
}
