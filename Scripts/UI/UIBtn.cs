using Godot;
using System;

public class UIBtn : Button
{
    [Export]
    public BtnPosition DrawToolTip;
    [Export]
    public MenuType MenuType;
    [Export]
    public BuildingType BuildingType;
    [Export]
    public UnitType UnitType;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
