using Godot;
using System;

public class WorkState : IUnitState
{
    Unit _owner;


    public WorkState(Unit u)
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
        //GD.Print(_owner.Name + " in MoveState");
        IUnitState newState = null;
        
        // if at work place, look for task
        switch (_owner.WorkPlace)
        {
            case WoodcutterHut w:
                if (_owner.CarriedResource == RESOURCE.WOOD)
                {
                    newState = new TaskState(_owner);
                }
                else
                {
                    // at wp, find closest tree
                    float dist = 0;
                    Prop targ = null;
                    foreach (Prop p in Game.World.Trees)
                    {
                        if (!p.InUse)
                        {
                            float currdist = (p.GlobalTransform.origin - _owner.GlobalTransform.origin).Length();
                            if (dist == 0 || currdist < dist)
                            {
                                dist = currdist;
                                targ = p;
                            }
                        }
                    }
                    if (targ != null)
                    {
                        _owner.PropTarg = targ;
                        _owner.BuildingTarg = null;
                        newState = new MoveState(_owner, targ.GlobalTransform.origin);
                    }
                }
                
                break;
        }
        
        return newState;
    }
}