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
            }
            //else if (owner.AtTaskPlace)
            //{
                // if at task place, perform task
            //}

            

            
        }

        return newState;
    }
}