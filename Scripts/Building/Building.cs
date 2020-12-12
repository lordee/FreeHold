using Godot;
using System;
using System.Collections.Generic;

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
    public int WorkersNeeded = 0;
    public List<Unit> WorkersAssigned = new List<Unit>();

    private bool _canPlace = true;
    public bool CanPlace {
        get { return _canPlace; }
        set { 
            _canPlace = value;
            if (value)
            {
                if (_colour != null)
                {
                    _body.MaterialOverride = _colour;
                }
            }
            else
            {
                _body.MaterialOverride = Utilities.RedMaterial;
            }
        }
    }
    public bool IsBuilt = false;
    Material _colour;
    public BUILDINGTYPE BuildingType;
    public Player PlayerOwner;

    private Area _entranceArea;
    public Vector3 EntranceLoc { get { return _entranceArea.GlobalTransform.origin; }}

    public Area _dropOffArea;
    public Vector3 DropOffLoc { get { return _dropOffArea.GlobalTransform.origin; }}

    public List<Prop> OverlappingProps = new List<Prop>();
    public List<Building> OverlappingBuildings = new List<Building>();
    public List<Unit> OverlappingUnits = new List<Unit>();

    public int DroppedOffResources = 0;

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
            _area.Connect("area_entered", this, nameof(AreaEntered));
            _area.Connect("area_exited", this, nameof(AreaExited));
        }

        _entranceArea = GetNodeOrNull("Entrance/Area") as Area;
        if (_entranceArea != null)
        {
            _entranceArea.Connect("body_entered", this, nameof(EntranceAreaBodyEntered));
            _entranceArea.Connect("body_exited", this, nameof(EntranceAreaBodyExited));
        }

        _dropOffArea = GetNodeOrNull("DropOff/Area") as Area;
        if (_dropOffArea != null)
        {
            _dropOffArea.Connect("body_entered", this, nameof(DropOffAreaBodyEntered));
            _dropOffArea.Connect("body_exited", this, nameof(DropOffAreaBodyExited));
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
    }

    public void Select()
    {
        if (_selector != null)
        {
            _selector.Show();

            // TODO update UI with building stats
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
        WorkersAssigned.Add(u);
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

    public void DropOffAreaBodyExited(KinematicBody kb)
    {
        if (kb is Unit u)
        {
            if (u.WorkPlace == this)
            {
                u.AtWorkPlaceDropOff = false;
            }
        }
    }

    public void DropOffAreaBodyEntered(KinematicBody kb)
    {
        if (kb is Unit u)
        {
            if (u.WorkPlace == this)
            {
                u.AtWorkPlaceDropOff = true;
            }
        }
    }

    public void CheckIfPlacable()
    {
        if (OverlappingUnits.Count > 0)
        {
            CanPlace = false;
        }
        else if (OverlappingBuildings.Count > 0)
        {
            CanPlace = false;
        }
        else if (OverlappingProps.Count > 0)
        {
            foreach(Prop p in OverlappingProps)
            {
                if (p.PropType == PROP.STONE && this is Quarry)
                {
                    CanPlace = true;
                }
                else
                {
                    CanPlace = false;
                    break;
                }
            }
        }
        else
        {
            if (this is Quarry)
            {
                CanPlace = false;
            }
            else
            {
                CanPlace = true;
            }
        }
    }

    public void AreaEntered(Node n)
    {
        if (n.Name == "PropArea")
        {
            Prop p = n.GetParent() as Prop;
            if (p.PropType != PROP.STARTLOCATION)
            {
                OverlappingProps.Add(p);
                if (!IsBuilt)
                {
                    CheckIfPlacable();
                }
            }
        }
    }

    public void AreaExited(Node n)
    {
        if (n.Name == "PropArea")
        {
            Prop p = n.GetParent() as Prop;
            OverlappingProps.Remove(p);
            if (!IsBuilt)
            {
                CheckIfPlacable();
            }
        }
    }

    public void AreaBodyEntered(Node n)
    {
        if (n is Unit u)
        {
            OverlappingUnits.Add(u);
            
            if (!IsBuilt)
            {
                CheckIfPlacable();
            }
        }
        else if (n is Building b)
        {
            if (this.Name != b.Name)
            {
                OverlappingBuildings.Add(b);
                if (!IsBuilt)
                {
                    CheckIfPlacable();
                }
            }
        }        
    }

    public void AreaBodyExited(Node n)
    {
        if (n is Unit u)
        {
            OverlappingUnits.Remove(u);
            if (!IsBuilt)
            {
                CheckIfPlacable();
            }

        }
        else if (n is Building b)
        {
            if (this.Name != b.Name)
            {
                OverlappingBuildings.Remove(b);
                if (!IsBuilt)
                {
                    CheckIfPlacable();
                }
            }
        }        
    }
}
