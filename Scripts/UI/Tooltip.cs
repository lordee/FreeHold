using Godot;
using System;

public class Tooltip : Control
{
    Panel _pnl;
    Label _lbl;
    int _border = 5;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        _pnl = GetNode("Panel") as Panel;
        _lbl = GetNode("Label") as Label;
    }

    public void Init(Vector2 position, string text)
    {
        _pnl.SetGlobalPosition(position);
        position.x += _border;
        position.y += _border;
        _lbl.SetGlobalPosition(position);
        _lbl.Text = text;

        Vector2 size = _lbl.GetFont("normal_font", "").GetStringSize(_lbl.Text);
        _lbl.RectSize = size;

        size.x += _border*2;
        size.y += _border*2;
        _pnl.RectSize = size;
    }
}
