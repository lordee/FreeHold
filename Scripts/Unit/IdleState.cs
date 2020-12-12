using Godot;
using System;

public class IdleState : IUnitState
{
    Unit _owner;

    public IdleState(Unit u)
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
        //GD.Print(owner.Name + " in IdleState");
        IUnitState newState = null;
        if (_owner.WorkPlace != null)
        {
            Building b = _owner.BuildingTarg;
            if (b != null)
            {
                if (b == _owner.PlayerOwner.Campfire && _owner.AtCampfire)
                {
                    _owner.BuildingTarg = _owner.WorkPlace;
                    newState = new MoveState(_owner, _owner.WorkPlace.EntranceLoc);
                }
                else if (b == _owner.WorkPlace && _owner.AtWorkPlace)
                {
                    if (_owner.AtWorkPlaceDropOff && _owner.CarriedResource != RESOURCE.NONE)
                    {
                        newState = new TaskState(_owner);
                    }
                    else if (_owner.AtWorkPlace)
                    {
                        b = null;
                        newState = new WorkState(_owner);
                    }
                    else
                    {
                        GD.Print("Idlestate branch should not occur");
                    }
                }
                else if ((
                            (b is Stockpile && _owner.PlayerOwner.Buildings.Contains(b)) 
                            || b is StockpileResource) 
                        && _owner.AtStockpile)
                {
                    newState = new DropOffStockpileState(_owner);
                }
                else
                {
                    newState = new MoveState(_owner, _owner.BuildingTarg.EntranceLoc);
                }
            }
            else if (_owner.PropTarg != null && _owner.PropAreas.Contains(_owner.PropTarg))
            {
                // if at task place, perform task
                newState = new TaskState(_owner);
            }
            else
            {
                GD.Print("end of idle state if");
            }
        }
        else
        {
            if (_owner.BuildingTarg != null)
            {
                newState = new MoveState(_owner, _owner.BuildingTarg.EntranceLoc);
            }
        }

        return newState;
    }
}