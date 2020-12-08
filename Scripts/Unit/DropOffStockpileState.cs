using Godot;
using System;

public class DropOffStockpileState : IUnitState
{
    Unit _owner;

    public DropOffStockpileState(Unit u)
    {
        _owner = u;
    }
    public void Enter()
    {

    }
    
    public void Exit()
    {

    }

// FIXME - this state and stockpile management is a mess
    public IUnitState Update(float delta)
    {
        IUnitState newState = null;
        // test drop point in stockpile
        Building origBuildingTarg = _owner.BuildingTarg;
        bool dropPointFound = false;

        if (TryDrop(_owner.BuildingTarg))
        {
            dropPointFound = true;
        }
        else
        {
            // check if there are other stockpiles
            foreach (Building b in _owner.PlayerOwner.Buildings)
            {
                if (TryDrop(b))
                {
                    dropPointFound = true;
                    break;
                }
            }
        }

        if (dropPointFound)
        {
            newState = new MoveState(_owner, _owner.BuildingTarg.EntranceLoc);
        }
        else
        {
            GD.Print("Stockpile is full or does not exist");
        }

        return newState;
    }

    private bool TryDrop(Building b)
    {
        bool dropPointFound = false;
        if (b is Stockpile s)
        {
            Tuple<bool, Building> dropPoint = s.ReserveDropPoint(_owner.CarriedResource);

            if (dropPoint.Item1) // reservation success
            {
                dropPointFound = true;
                // if near enough, do drop off
                if ((dropPoint.Item2.EntranceLoc - _owner.GlobalTransform.origin).Length() <= Game.MinimumInteractDistance)
                {
                    DropResource(dropPoint.Item2);
                }
                else
                {
                    _owner.BuildingTarg = dropPoint.Item2;
                }
            }
        }

        return dropPointFound;
    }

    private void DropResource(Building b)
    {
        if (b is StockpileResource sr)
        {
            int val = Stockpile.GetDropVal(_owner.CarriedResource);
            sr.Value += val;
            sr.ReservedValue -= val;
            _owner.PlayerOwner.AddResource(_owner.CarriedResource, val);
            _owner.CarriedResource = RESOURCE.NONE;
            _owner.BuildingTarg = _owner.WorkPlace;
        }
    }
}