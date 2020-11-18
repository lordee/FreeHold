using Godot;
using System;

public class Building : StaticBody
{
    MeshInstance _selector;
    Area _area;
    MeshInstance _body;

    public int TeamID = 1;
    public float Health = 500;
    public float MaxHealth = 500;

    public bool CanPlace = true;
    Material _colour;
    public BuildingType BuildingType;

    public override void _Ready()
    {
        _selector = (MeshInstance)GetNode("Selector");
        this.Deselect();

        _body = (MeshInstance)this.GetNode("MeshInstance");
        if (Utilities.TeamColours.ContainsKey(this.TeamID))
        {
            _colour = (Material)ResourceLoader.Load(Utilities.TeamColours[this.TeamID]);
            _body.MaterialOverride = _colour;
        }

        _area = _body.GetNode("Area") as Area;
        _area.Connect("body_entered", this, "AreaBodyEntered");
        _area.Connect("body_exited", this, "AreaBodyExited");
    }

    public void Init(BuildingType bt, Vector3 origin, int teamID)
    {
        BuildingType = bt;
        Transform t = this.GlobalTransform;
        t.origin = origin;
        this.GlobalTransform = t;

        TeamID = teamID;

        switch (bt)
        {
            case BuildingType.Keep:
                Health = 5000;
                MaxHealth = 5000;
                break;
        }
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
        switch(BuildingType)
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

        // update UI with building stats

    }

    public void Deselect()
    {
        _selector.Hide();
    }
}
