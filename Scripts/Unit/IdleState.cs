using Godot;
using System;

public class IdleState : IUnitState
{
    Unit owner;

    public IdleState(Unit u)
    {
        owner = u;
    }
    public void Enter()
    {

    }
    
    public void Exit()
    {

    }

    public IUnitState Update()
    {
        //GD.Print(owner.Name + " in IdleState");
        IUnitState newState = null;
        if (owner.WorkPlace != null)
        {
            // if in starting area, go to work place
            if (owner.AtCampfire)
            {
                newState = new MoveState(owner, owner.WorkPlace.EntranceArea.GlobalTransform.origin);
            }
            else if (owner.AtWorkPlace)
            {
                // if at work place, look for task
                switch (owner.WorkPlace)
                {
                    case WoodcutterHut w:
                        // at wp, find closest tree
                        float dist = 0;
                        Prop targ = null;
                        foreach (Prop p in Game.World.Trees)
                        {
                            if (!p.InUse)
                            {
                                float currdist = (p.GlobalTransform.origin - owner.GlobalTransform.origin).Length();
                                if (dist == 0 || currdist < dist)
                                {
                                    dist = currdist;
                                    targ = p;
                                }
                            }
                        }
                        if (targ != null)
                        {
                            owner.PropTarg = targ;
                            newState = new MoveState(owner, targ.GlobalTransform.origin);
                        }
                        break;
                }
            }
            else if (owner.PropAreas.Contains(owner.PropTarg))
            {
                // if at task place, perform task
                GD.Print("cutting down tree");
            }
            else
            {
                GD.Print("end of idle state if");
            }

            

            
        }

        return newState;
    }
}