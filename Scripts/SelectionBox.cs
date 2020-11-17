using Godot;
using System;

public class SelectionBox : Control
{
    public bool DrawBox = false;
    public Vector2 MPos = new Vector2();
    public Vector2 StartPos = new Vector2();
    private Color lineColour = new Color(0,1,0);
    private int lineWidth = 3;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta)
    {
        this.Update();
    }

    public override void _Draw()
    {
        if (this.DrawBox && this.StartPos != MPos)
        {
            DrawLine(StartPos, new Vector2(MPos.x, StartPos.y), lineColour, lineWidth);
            DrawLine(StartPos, new Vector2(StartPos.x, MPos.y), lineColour, lineWidth);
            DrawLine(MPos, new Vector2(MPos.x, StartPos.y), lineColour, lineWidth);
            DrawLine(MPos, new Vector2(StartPos.x, MPos.y), lineColour, lineWidth);
        }
    }
}
