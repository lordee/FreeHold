using Godot;
using System;

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

    public Vector3 StartingSpot;

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
                    BuildingManager.Spawn(BuildingType.Keep, p.GlobalTransform.origin, TeamID);
                    StartingSpot = p.GlobalTransform.origin;

                    // spawn starting units
                    
                    break;
                }
            }
        }
    }
}
