using Godot;
using System;

public class TaskState : IUnitState
{
    Unit _owner;
    float _taskTime = 0f;

    float _chopWoodTimeReq = 5f;
    float _sawWoodTimeReq = 5f;
    float _stoneBlockCreateTimeReq = 5f;
    float _stoneBlockDropTimeReq = 5f;

    public TaskState(Unit u)
    {
        _owner = u;
    }

    public void Enter()
    {
        
    }
    
    public void Exit()
    {

    }

    public IUnitState Update(float delta)
    {
        _taskTime += delta;
        //GD.Print(_owner.Name + " in MoveState");
        IUnitState newState = null;
        
        switch (_owner.WorkPlace)
        {
            case Quarry q:
                if (_owner.CarriedResource == RESOURCE.STONE)
                {
                    if (_taskTime >= _stoneBlockDropTimeReq)
                    {
                        _owner.WorkPlace.DroppedOffResources += Stockpile.GetDropVal(_owner.CarriedResource);
                        _owner.CarriedResource = RESOURCE.NONE;

                        newState = new MoveState(_owner, _owner.WorkPlace.EntranceLoc);                        
                    }
                }
                else if (_taskTime >= _stoneBlockCreateTimeReq)
                {
                    _owner.CarriedResource = RESOURCE.STONE;

                    // send unit to drop off with stone
                    newState = new MoveState(_owner, _owner.WorkPlace.DropOffLoc);
                }
                break;
            case WoodcutterHut w:
                if (_owner.CarriedResource == RESOURCE.WOOD)
                {
                    // saw planks
                    if (_taskTime >= _sawWoodTimeReq)
                    {
                        _owner.CarriedResource = RESOURCE.PLANKS;
                        Building stockPile = _owner.PlayerOwner.Buildings.Find(e => e.BuildingType == BUILDINGTYPE.STOCKPILE);
                        if (stockPile != null)
                        {
                            _owner.BuildingTarg = stockPile;
                            newState = new MoveState(_owner, stockPile.EntranceLoc);
                        }
                        else
                        {
                            GD.Print("Stockpile not found");
                        }  
                    }
                }
                else
                {
                    // chopping tree
                    if (_taskTime >= _chopWoodTimeReq)
                    {
                        // remove tree node
                        Prop t = _owner.PropTarg;
                        t.GetParent().RemoveChild(t);
                        Game.World.Trees.Remove(t);
                        _owner.PropAreas.Remove(t);
                        t = null;

                        // give unit wood
                        _owner.CarriedResource = RESOURCE.WOOD;

                        // send unit back to workplace with wood
                        _owner.BuildingTarg = _owner.WorkPlace;
                        newState = new MoveState(_owner, _owner.WorkPlace.EntranceLoc);
                    }
                }
                break;
        }
        
        return newState;
    }
}