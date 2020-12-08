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
    public bool HasWorker = false;
    public bool NeedsWorker = false;
    private Unit Worker = null;

    public bool CanPlace = true;
    public bool IsBuilt = false;
    Material _colour;
    public BUILDINGTYPE BuildingType;
    public Player PlayerOwner;

    public Area EntranceArea;
    public Vector3 EntranceLoc { get { return EntranceArea.GlobalTransform.origin; }}

    public override void _Ready()
    {
        _selector = (MeshInstance)GetNodeOrNull("Selector");
        this.Deselect();

        _body = (MeshInstance)this.GetNodeOrNull("MeshInstance");

        _area = _body.GetNodeOrNull("Area") as Area;
        if (_area != null)
        {
            _area.Connect("body_entered", this, nameof(AreaBodyEntered));
            _area.Connect("body_exited", this, nameof(AreaBodyExited));
        }

        EntranceArea = GetNodeOrNull("Entrance/EntranceArea") as Area;
        if (EntranceArea != null)
        {
            EntranceArea.Connect("body_entered", this, nameof(EntranceAreaBodyEntered));
            EntranceArea.Connect("body_exited", this, nameof(EntranceAreaBodyExited));
        }
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

        // FIXME - seperate out campfire as another scene, spawn it on keep build instead
        if (this is Keep k)
        {
            Campfire c = k.GetNode("Campfire") as Campfire;
            c.TeamID = TeamID;
            c.PlayerOwner = owner;
            c.BuildingType = BUILDINGTYPE.CAMPFIRE;
            owner.Buildings.Add(c);
            owner.Campfire = c;
        }
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
        if (_selector != null)
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
    }

    public void Deselect()
    {
        if (_selector != null)
        {
            _selector.Hide();
        }
    }

    public void AssignWorker(Unit u)
    {
        Worker = u;
        HasWorker = true;
        u.Employ(this);
    }

    public void EntranceAreaBodyEntered(KinematicBody kb)
    {
        if (kb is Unit u)
        {
            if (u.WorkPlace == this)
            {
                u.AtWorkPlace = true;
            }
            else if (this is Campfire c)
            {
                u.AtCampfire = true;
            }
            else if (this is Stockpile s)
            {
                u.AtStockpile = true;
            }
        }
    }

    public void EntranceAreaBodyExited(KinematicBody kb)
    {
        if (kb is Unit u)
        {
            if (u.WorkPlace == this)
            {
                u.AtWorkPlace = false;
            }
            else if (this is Campfire c)
            {
                u.AtCampfire = false;
            }
            else if (this is Stockpile s)
            {
                u.AtStockpile = false;
            }
        }
    }
}
