using Godot;
using System;

public interface IUnitState
{
    void Enter();
    IUnitState Update(float delta);
    void Exit();
}


/*
    Idle
    Moving
    Working

    Idle -> Move to assigned workplace
    Idle at assigned workplace -> look for work as employee -> move to tree to chop down
    arrive at tree -> chop tree down
    carry wood back to workplace
    arrive workplace -> saw wood in to planks


*/