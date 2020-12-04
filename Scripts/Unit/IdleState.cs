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
        IUnitState newState = null;
        GD.Print(owner.Name + " in IdleState");
        if (owner.Workplace != null)
        {
            // go to work place
            newState = new MoveState(owner, owner.Workplace.GlobalTransform.origin);
        }

        return newState;
    }
}