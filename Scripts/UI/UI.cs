using Godot;
using Godot.Collections;
using System;
using System.Collections.Generic;

public class UI : CanvasLayer
{
    static public UI that;
    Control UIBtnMain;
    Control UIBtnIndustry;
    Control UIBtnFood;
    Control UIBtnTown;
    Control UIBtnMilitary;
    Control UIBtnCastle;
    Control UIBtnCastleFortifications;
    Control UIBtnCastleTowers;
    Control UIBtnCastleDefenses;
    Control UIBtnBarracks;
    Control UIBtnMercenaries;
    Control UIBtnSiege;

    List<Control> allMenus = new List<Control>();

    RtsCameraController _player;
    Building _activeBuilding;
    Label Gold;
    Label Wood;
    Label Ale;
    Label Food;
    Label Candles;
    Label Stone;
    Label Iron;
    Label Pitch;

    RichTextLabel Status;

    Tooltip _tooltip;

    int buttonSpacer = 35;
    int menuLine1 = 60;
    int menuLine2 = 0;
    public override void _Ready()
    {
        that = this;
        UIBtnMain = GetNode("UIBtnMain") as Control;
        allMenus.Add(UIBtnMain);
        UIBtnIndustry = GetNode("UIBtnIndustry") as Control;
        allMenus.Add(UIBtnIndustry);
        UIBtnFood = GetNode("UIBtnFood") as Control;
        allMenus.Add(UIBtnFood);
        UIBtnTown = GetNode("UIBtnTown") as Control;
        allMenus.Add(UIBtnTown);
        UIBtnMilitary = GetNode("UIBtnMilitary") as Control;
        allMenus.Add(UIBtnMilitary);
        UIBtnCastle = GetNode("UIBtnCastle") as Control;
        allMenus.Add(UIBtnCastle);
        UIBtnCastleFortifications = GetNode("UIBtnCastleFortifications") as Control;
        allMenus.Add(UIBtnCastleFortifications);
        UIBtnCastleTowers = GetNode("UIBtnCastleTowers") as Control;
        allMenus.Add(UIBtnCastleTowers);
        UIBtnCastleDefenses = GetNode("UIBtnCastleDefenses") as Control;
        allMenus.Add(UIBtnCastleDefenses);
        UIBtnBarracks = GetNode("UIBtnBarracks") as Control;
        allMenus.Add(UIBtnBarracks);
        UIBtnMercenaries = GetNode("UIBtnMercenaries") as Control;
        allMenus.Add(UIBtnMercenaries);
        UIBtnSiege = GetNode("UIBtnSiege") as Control;
        allMenus.Add(UIBtnSiege);

        foreach(Control c in allMenus)
        {
            ConnectButtons(c);
        }

        Gold = GetNode("Resources/Gold") as Label;
        Wood = GetNode("Resources/Wood") as Label;
        Ale = GetNode("Resources/Ale") as Label;
        Food = GetNode("Resources/Food") as Label;
        Candles = GetNode("Resources/Candles") as Label;
        Stone = GetNode("Resources/Stone") as Label;
        Iron = GetNode("Resources/Iron") as Label;
        Pitch = GetNode("Resources/Pitch") as Label;
        Status = GetNode("Status/StatusLabel") as RichTextLabel;

        _tooltip = GetNode("Tooltip") as Tooltip;
        _player = this.GetParent() as RtsCameraController;

        ShowMenu(MenuType.Main);
    }

    private void ConnectButtons(Control ctl)
    {
        foreach (Control n in ctl.GetChildren())
        {
            if (n is UIBtn c)
            {
                c.Connect("mouse_entered", this, nameof(DrawToolTip), new Godot.Collections.Array() { c });
                c.Connect("mouse_exited", this, nameof(HideToolTip));
                c.Connect("pressed", this, nameof(UIButton_Click), new Godot.Collections.Array() { c });
            }
            ConnectButtons(n);
        }
    }

    public override void _Process(float delta)
    {
        // FIXME - adjust all UI elements based on current screen size
        Gold.Text = Game.Player.Gold.ToString();
        Wood.Text = Game.Player.Wood.ToString();
        Ale.Text = Game.Player.Ale.ToString();
        int food = Game.Player.Bread + Game.Player.Cheese + Game.Player.Meat + Game.Player.Apples;
        Food.Text = food.ToString();
        Candles.Text = Game.Player.Candles.ToString();
        Stone.Text = Game.Player.Stone.ToString();
        Iron.Text = Game.Player.Iron.ToString();
        Pitch.Text = Game.Player.Pitch.ToString();
    }

    private void UIButton_Click(UIBtn btn)
    {
        switch (btn.MenuType)
        {
            case MenuType.CreateUnit:
                CreateUnit_Click(btn.UnitType);
                break;
            case MenuType.CreateBuilding:
                Build_Click(btn.BuildingType);
                break;
            default:
                ShowMenu(btn.MenuType);
                break;
        }
    }

    private void DrawToolTip(UIBtn btn)
    {
        Vector2 position = btn.GetGlobalTransform().origin;
        position.y += (btn.DrawToolTip == BtnPosition.Above) ? -30 : 30;
        string text = btn.Name;

        _tooltip.Init(position, text);
        _tooltip.Show();
    }

    private void HideToolTip()
    {
        _tooltip.Hide();
    }

    static public void ShowMenu(MenuType type)
    {
        that.ShowMenu(type, null);
    }

    public void ShowMenu(MenuType type, Building building)
    {
        _activeBuilding = building;
        foreach(Control c in allMenus)
        {
            c.Hide();
        }

        switch (type)
        {
            case MenuType.Main:
                UIBtnMain.Show();
                break;
            case MenuType.Food:
                UIBtnFood.Show();
                break;
            case MenuType.Town:
                UIBtnTown.Show();
                break;
            case MenuType.Military:
                UIBtnMilitary.Show();
                break;
            case MenuType.Industry:
                UIBtnIndustry.Show();
                break;
            case MenuType.Castle:
                UIBtnCastle.Show();
                break;
            case MenuType.CastleFortifications:
                UIBtnCastleFortifications.Show();
                break;
            case MenuType.CastleTowers:
                UIBtnCastleTowers.Show();
                break;
            case MenuType.CastleDefenses:
                UIBtnCastleDefenses.Show();
                break;
            case MenuType.Barracks:
                UIBtnBarracks.Show();
                break;
            case MenuType.Mercenaries:
                UIBtnMercenaries.Show();
                break;
            case MenuType.Siege:
                UIBtnSiege.Show();
                break;
            default:
                UIBtnMain.Show();
                break;
        }
    }

    public void Build_Click(BuildingType b)
    {
        //_player.Build(b);
    }

    public void CreateUnit_Click(UnitType u)
    {
        Vector3 pos = _activeBuilding.Transform.origin;
        pos.x += _activeBuilding.Scale.x*2;
        //_player.CreateUnit(u, pos);
    }

    static public void SetStatus(string text)
    {
        that.Status.Text = text;
    }
}
                                        
