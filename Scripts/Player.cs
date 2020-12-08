using Godot;
using System;
using System.Collections.Generic;

public class Player : Node
{
    static public int DefaultGold = 0;
    static public int DefaultWood = 30;
    static public int DefaultStone = 0;
    static public int DefaultIron = 0; 
    static public int DefaultPitch = 0; 
    static public int DefaultBread = 0; 
    static public int DefaultMeat = 0; 
    static public int DefaultApples = 0; 
    static public int DefaultCheese = 0; 
    static public int DefaultHops = 0; 
    static public int DefaultAle = 0; 
    static public int DefaultCandles = 0;

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
    public int UnemployedPeasants = 0;

    public Vector3 StartingSpot;

    public Campfire Campfire;

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

        SetStartingResources(Player.DefaultGold, Player.DefaultWood, Player.DefaultStone, 
        Player.DefaultIron, Player.DefaultPitch, Player.DefaultBread, Player.DefaultMeat, 
        Player.DefaultApples, Player.DefaultCheese, Player.DefaultHops, Player.DefaultAle, 
        Player.DefaultCandles);
    }

    public override void _PhysicsProcess(float delta)
    {
        UpdatePopulation(delta);
    }

    public void SetStartingResources(int gold, int wood, int stone,
    int iron, int pitch, int bread, int meat, int apples, int cheese,
    int hops, int ale, int candles)
    {
        Gold = gold;
        Wood = wood;
        Stone = stone;
        Iron = iron;
        Pitch = pitch;
        Bread = bread;
        Meat = meat;
        Apples = apples;
        Cheese = cheese;
        Hops = hops;
        Ale = ale;
        Candles = candles;
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

    public void AddResource(RESOURCE res, int val)
    {
        // TODO - all resources
        switch (res)
        {
            case RESOURCE.PLANKS:
                Wood += val;
                break;
            case RESOURCE.STONE:
                Stone += val;
                break;
            case RESOURCE.IRON:
                Iron += val;
                break;
        }
    }
}
