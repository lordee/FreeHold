using Godot;
using System;

public class Building : StaticBody
{
    MeshInstance _selector;
    Area _area;
    MeshInstance _body;
    public MeshInstance Body { get { return _body; }}

    static public string Resource = "res://Scenes/Building/Building.tscn";

    public int TeamID = 1;
    public float Health = 500;
    public float MaxHealth = 500;
    static public int GoldCost = 0;
    static public int WoodCost = 0;
    static public int PitchCost = 0;
    static public int StoneCost = 0;
    public int Population = 0;

    public bool CanPlace = true;
    public bool IsBuilt = false;
    Material _colour;
    public BuildingType BuildingType;
    public Player PlayerOwner;

    public override void _Ready()
    {
        _selector = (MeshInstance)GetNode("Selector");
        this.Deselect();

        _body = (MeshInstance)this.GetNode("MeshInstance");

        _area = _body.GetNode("Area") as Area;
        _area.Connect("body_entered", this, "AreaBodyEntered");
        _area.Connect("body_exited", this, "AreaBodyExited");
    }

    public void Init(BuildingType bt, Vector3 origin, Player owner)
    {
        PlayerOwner = owner;
        BuildingType = bt;
        Transform t = this.GlobalTransform;
        t.origin = origin;
        this.GlobalTransform = t;

        TeamID = owner.TeamID;

        if (Utilities.TeamColours.ContainsKey(this.TeamID))
        {
            _colour = (Material)ResourceLoader.Load(Utilities.TeamColours[this.TeamID]);
            _body.MaterialOverride = _colour;
        }

        switch (bt)
        {
            case BuildingType.Keep:
                Health = 5000;
                MaxHealth = 5000;
                Population = 10;
                break;
        }
        owner.Buildings.Add(this);
    }

    public void AreaBodyEntered(KinematicBody kb)
    {
        if (this.Name != kb.Name && !IsBuilt)
        {
            CanPlace = false;
            _body.MaterialOverride = Utilities.RedMaterial;
        }
        
    }

    public void AreaBodyExited(KinematicBody kb)
    {
        if (this.Name != kb.Name && !IsBuilt)
        {
            CanPlace = true;
            if (_colour != null)
            {
                _body.MaterialOverride = _colour;
            }
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
