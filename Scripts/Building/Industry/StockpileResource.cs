using Godot;
using System;

public class StockpileResource : Building
{
    public RESOURCE ResourceType = RESOURCE.NONE;
    public int Value = 0;
    public int ReservedValue = 0;
    
    public override void _Ready()
    {
        base._Ready();
    }
}
