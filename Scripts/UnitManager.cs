using Godot;
using System;

public class UnitManager : Node
{
    static UnitManager that;
    PackedScene _unitScene;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        that = this;
        _unitScene = ResourceLoader.Load(Unit.Resource) as PackedScene;
    }

    public override void _PhysicsProcess(float delta)
    {
        if (Game.World == null)
        {
            return;
        }

        foreach(Player p in Game.World.Players)
        {
            SpawnPeasants(p, delta);
            AssignJobs(p);
        }
    }

    private void AssignJobs(Player p)
    {
        foreach (Building b in p.Buildings)
        {
            if (b.NeedsWorker && !b.HasWorker && p.UnemployedPeasants > 0)
            {
                // assign a worker
                foreach (Unit u in p.Units)
                {
                    if (u.UnitType == UNITTYPE.Peasant && u.Unemployed)
                    {
                        b.AssignWorker(u);
                    }
                }
            }
        }
    }

    private void SpawnPeasants(Player p, float delta)
    {
        p.PeasantLastSpawn += delta;
        if (p.Population < p.PopulationMax && p.PeasantLastSpawn >= Game.PeasantSpawnTime)
        {
            p.PeasantLastSpawn = 0f;
            Unit u = SpawnUnit(UNITTYPE.Peasant, p, p.StartingSpot, p.Buildings[0]);
            p.UnemployedPeasants += 1;
        }
    }

    private Unit SpawnUnit(UNITTYPE unitType, Player owner, Vector3 pos, Building building)
    {
        if (building != null)
        {
            pos = building.UnitSpawnPoint;
        }

        Unit u = _unitScene.Instance() as Unit;
        AddChild(u);
        u.Init(unitType, owner, pos);
        Utilities.MoveToFloor(u);
        pos += new Vector3(3, 0, 0);
        u.MoveTo(pos);

        return u;
    }
}
