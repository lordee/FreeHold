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
        SpawnPeasants(delta);
    }

    public void SpawnPeasants(float delta)
    {
        foreach (Player p in Game.World.Players)
        {
            p.PeasantLastSpawn += delta;
            if (p.Population < p.PopulationMax && p.PeasantLastSpawn >= Game.PeasantSpawnTime)
            {
                p.PeasantLastSpawn = 0f;
                SpawnUnit(UNITTYPE.Peasant, p, p.StartingSpot, p.Buildings[0]);
            }
        }
    }

    private void SpawnUnit(UNITTYPE unitType, Player owner, Vector3 pos, Building building)
    {
        Unit u = _unitScene.Instance() as Unit;
        AddChild(u);
        // test pos
        u.Init(unitType, owner, pos);

        if (building != null)
        {
            AABB bounds = building.Body.GetAabb();
            Vector3 val = bounds.Size;
            u.MoveTo(pos + val);
        }
        
    }
}
