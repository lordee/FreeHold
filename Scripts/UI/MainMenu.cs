using Godot;
using System;

public class MainMenu : Control
{
    Button _start;
    public override void _Ready()
    {
        _start = GetNode("VBoxContainer/Start") as Button;
        _start.Connect("pressed", this, "Start_Click");
    }

    private void Start_Click()
    {
        // FIXME - load world
        Game.Start();
        this.Hide();
    }
}
