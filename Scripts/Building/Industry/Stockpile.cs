using Godot;
using System;
using System.Collections.Generic;

public class Stockpile : Building
{
    static public new int GoldCost = 0;
    static public new int WoodCost = 1;
    static public new int PitchCost = 0;
    static public new int StoneCost = 0;
    static public new string Resource = "res://Scenes/Building/Industry/Stockpile.tscn";

    List<StockpileResource> _slots = new List<StockpileResource>();

    private StockpileResource _slot1;
    private StockpileResource _slot2;
    private StockpileResource _slot3;
    private StockpileResource _slot4;

// FIXME - on initial build of stockpile, default player resources need to be assigned to a slot
    public override void _Ready()
    {
        base._Ready();
        _slot1 = GetNode("StockpileResource1") as StockpileResource;
        _slot2 = GetNode("StockpileResource2") as StockpileResource;
        _slot3 = GetNode("StockpileResource3") as StockpileResource;
        _slot4 = GetNode("StockpileResource4") as StockpileResource;
        _slots.Add(_slot1);
        _slots.Add(_slot2);
        _slots.Add(_slot3);
        _slots.Add(_slot4);
    }

    public Tuple<bool, Building> ReserveDropPoint(RESOURCE res)
    {
        Tuple<bool, Building> ret = null;
        bool found = false;
        foreach (StockpileResource sr in _slots)
        {
            if (CheckSlot(sr, res))
            {
                sr.ReservedValue += GetDropVal(res);
                ret = new Tuple<bool, Building>(true, sr);
                found = true;
                break;
            }
        }

        if (!found)
        {
            ret = new Tuple<bool, Building>(false, null);
        }

        return ret;
    }

    public bool CheckSlot(StockpileResource slot, RESOURCE res)
    {
        if (slot.ResourceType == RESOURCE.NONE)
        {
            return true;
        }
        if (slot.ResourceType == res)
        {
            int dropVal = GetDropVal(res);
            if (slot.Value + slot.ReservedValue + dropVal <= Game.MaxStockpileStackValue)
            {
                return true;
            }
        }

        return false;
    }

    static public int GetDropVal(RESOURCE res)
    {
        int ret = 9999;
        switch (res)
        {
            case RESOURCE.PLANKS:
                ret = 20;
                break;
            case RESOURCE.STONE:
                ret = 20;
                break;
        }
        return ret;
    }
}
