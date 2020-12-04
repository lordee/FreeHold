using Godot;
using Godot.Collections;
using System;
using System.Collections.Generic;

public class UI : CanvasLayer
{
    static public UI that;
    Control UIBtnContainer;
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

    Control ResourcesContainer;

    Building _activeBuilding;
    Label Gold;
    Label Wood;
    Label Ale;
    Label Food;
    Label Candles;
    Label Stone;
    Label Iron;
    Label Pitch;
    Label Population;
    Label Reputation;

    RichTextLabel Status;

    Tooltip _tooltip;

    public override void _Ready()
    {
        that = this;
        UIBtnContainer = GetNode("UIBtnContainer") as Control;
        UIBtnMain = UIBtnContainer.GetNode("UIBtnMain") as Control;
        UIBtnIndustry = UIBtnContainer.GetNode("UIBtnIndustry") as Control;
        UIBtnFood = UIBtnContainer.GetNode("UIBtnFood") as Control;
        UIBtnTown = UIBtnContainer.GetNode("UIBtnTown") as Control;
        UIBtnMilitary = UIBtnContainer.GetNode("UIBtnMilitary") as Control;
        UIBtnCastle = UIBtnContainer.GetNode("UIBtnCastle") as Control;
        UIBtnCastleFortifications = UIBtnContainer.GetNode("UIBtnCastleFortifications") as Control;
        UIBtnCastleTowers = UIBtnContainer.GetNode("UIBtnCastleTowers") as Control;
        UIBtnCastleDefenses = UIBtnContainer.GetNode("UIBtnCastleDefenses") as Control;
        UIBtnBarracks = UIBtnContainer.GetNode("UIBtnBarracks") as Control;
        UIBtnMercenaries = UIBtnContainer.GetNode("UIBtnMercenaries") as Control;
        UIBtnSiege = UIBtnContainer.GetNode("UIBtnSiege") as Control;

        foreach(Control c in UIBtnContainer.GetChildren())
        {
            ConnectButtons(c);
        }

        ResourcesContainer = GetNode("ResourcesContainer") as Control;
        ResourcesContainer.AddConstantOverride("hseparation", 5); // container margin

        Gold = ResourcesContainer.GetNode("GridContainer/Gold") as Label;
        Wood = ResourcesContainer.GetNode("GridContainer/Wood") as Label;
        Ale = ResourcesContainer.GetNode("GridContainer/Ale") as Label;
        Food = ResourcesContainer.GetNode("GridContainer/Food") as Label;
        Candles = ResourcesContainer.GetNode("GridContainer/Candles") as Label;
        Stone = ResourcesContainer.GetNode("GridContainer/Stone") as Label;
        Iron = ResourcesContainer.GetNode("GridContainer/Iron") as Label;
        Pitch = ResourcesContainer.GetNode("GridContainer/Pitch") as Label;
        Population = ResourcesContainer.GetNode("GridContainer/Population") as Label;
        Reputation = ResourcesContainer.GetNode("GridContainer/Reputation") as Label;
        Status = GetNode("Status/StatusLabel") as RichTextLabel;

        _tooltip = GetNode("Tooltip") as Tooltip;

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
        Population.Text = Game.Player.Population.ToString() + "/" + Game.Player.PopulationMax.ToString();
        Reputation.Text = Game.Player.Reputation.ToString();

        // reposition elements
        Vector2 scrSize = GetViewport().Size;
        Vector2 pos = new Vector2(
            (scrSize.x / 2) - (UIBtnContainer.RectMinSize.x / 2),
            scrSize.y - UIBtnContainer.RectMinSize.y - 30
        );
        
        UIBtnContainer.RectGlobalPosition = pos;

        pos.x = scrSize.x - ResourcesContainer.RectMinSize.x - 30;
        pos.y = 30;
        ResourcesContainer.RectGlobalPosition = pos;
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

        if (Game.CameraController.ClickState != ClickState.ButtonClick)
        {
            Game.CameraController.LastClickState = Game.CameraController.ClickState;
        }
        Game.CameraController.ClickState = ClickState.ButtonClick;
    }

    private void HideToolTip()
    {
        Game.CameraController.ClickState = Game.CameraController.LastClickState != ClickState.ButtonClick ? Game.CameraController.LastClickState : ClickState.NoSelection;
        _tooltip.Hide();
    }

    static public void ShowMenu(MenuType type)
    {
        that.ShowMenu(type, null);
    }

    public void ShowMenu(MenuType type, Building building)
    {
        _activeBuilding = building;
        foreach(Control c in UIBtnContainer.GetChildren())
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

    public void Build_Click(BUILDINGTYPE b)
    {
        Game.BuildingManager.BuildingPlacement(Game.Player, b);
    }

    public void CreateUnit_Click(UNITTYPE u)
    {
        Vector3 pos = _activeBuilding.Transform.origin;
        pos.x += _activeBuilding.Scale.x*2;
        //_player.CreateUnit(u, pos);
    }

    static public void SetStatus(string text)
    {
        if (that != null && that.Status != null)
        {
            that.Status.Text = text;
        }
    }
}
                                        
