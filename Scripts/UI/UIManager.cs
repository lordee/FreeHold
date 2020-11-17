using Godot;
using System;

public class UIManager : Node
{
    static UIManager that;

    string UIRes = "res://Scenes/UI/UI.tscn";
    PackedScene UIScene;
    UI _ui;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        that = this;
        UIScene = ResourceLoader.Load(UIRes) as PackedScene;
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }

    public void AttachUI()
    {
        _ui = (UI)UIScene.Instance();
        this.AddChild(_ui);
    }

    static public void LoadUI()
    {
        that.AttachUI();
    }
}
