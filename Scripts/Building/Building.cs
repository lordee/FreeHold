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
    public Vector3 UnitSpawnPoint = new Vector3();

    public bool CanPlace = true;
    public bool IsBuilt = false;
    Material _colour;
    public BUILDINGTYPE BuildingType;
    public Player PlayerOwner;

    public override void _Ready()
    {
        _selector = (MeshInstance)GetNode("Selector");
        this.Deselect();

        _body = (MeshInstance)this.GetNode("MeshInstance");

        _area = _body.GetNode("Area") as Area;
        _area.Connect("body_entered", this, nameof(AreaBodyEntered));
        _area.Connect("body_exited", this, nameof(AreaBodyExited));
    }

    virtual public void Init(BUILDINGTYPE bt, Vector3 origin, Player owner)
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

        owner.Buildings.Add(this);
    }

    public void AreaBodyEntered(KinematicBody kb)
    {
        if (this.Name != kb.Name)
        {
            if (!IsBuilt)
            {
                CanPlace = false;
                _body.MaterialOverride = Utilities.RedMaterial;
            }
            else if (kb is Unit u)
            {
                // TODO enter/exit building
            }
            
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
            case BUILDINGTYPE.Barracks:
                //_ui.ShowMenu(MenuType.Barracks, this);
                break;
            case BUILDINGTYPE.MercenaryPost:
                //_ui.ShowMenu(MenuType.Mercenaries, this);
                break;
            case BUILDINGTYPE.SiegeCamp:
                //_ui.ShowMenu(MenuType.Siege, this);
                break;
            case BUILDINGTYPE.Granary:

                break;
            case BUILDINGTYPE.Market:

                break;
            case BUILDINGTYPE.Stockpile:

                break;
        }

        // update UI with building stats

    }

    public void Deselect()
    {
        _selector.Hide();
    }
}
