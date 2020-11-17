using Godot;
using System;

public class Building : StaticBody
{
    MeshInstance _selector;
    Area _area;
    MeshInstance _body;
    //UI _ui;

    public int Team = 1;

    public bool CanPlace = true;
    Material _colour;
    private BuildingType _buildingType;

    public override void _Ready()
    {
        _selector = (MeshInstance)GetNode("Selector");
        this.Deselect();

        _body = (MeshInstance)this.GetNode("MeshInstance");
        if (Utilities.TeamColours.ContainsKey(this.Team))
        {
            _colour = (Material)ResourceLoader.Load(Utilities.TeamColours[this.Team]);
            _body.MaterialOverride = _colour;
        }

        _area = _body.GetNode("Area") as Area;
        _area.Connect("body_entered", this, "AreaBodyEntered");
        _area.Connect("body_exited", this, "AreaBodyExited");

        //_ui = GetNode("/root/World/CamBase/UI") as UI;
    }

    public void Init(BuildingType bt)
    {
        _buildingType = bt;
    }

    public void AreaBodyEntered(KinematicBody b)
    {
        CanPlace = false;
        _body.MaterialOverride = Utilities.RedMaterial;
    }

    public void AreaBodyExited(KinematicBody b)
    {
        CanPlace = true;
        if (_colour != null)
        {
            _body.MaterialOverride = _colour;
        }
    }
    
    public void Select()
    {
        _selector.Show();
        switch(_buildingType)
        {
            case BuildingType.Barracks:
                //_ui.ShowMenu(MenuType.Barracks, this);
                break;
            case BuildingType.MercenaryPost:
                //_ui.ShowMenu(MenuType.Mercenaries, this);
                break;
            case BuildingType.SiegeCamp:
                //_ui.ShowMenu(MenuType.Siege, this);
                break;
            case BuildingType.Granary:

                break;
            case BuildingType.Market:

                break;
            case BuildingType.Stockpile:

                break;
        }
    }

    public void Deselect()
    {
        _selector.Hide();
    }
}
