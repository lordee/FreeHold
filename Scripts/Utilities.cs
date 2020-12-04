using Godot;
using System;
using System.Collections.Generic;

public static class Utilities
{
    public static Dictionary<int, string> TeamColours = new Dictionary<int, string>
    {
        {0, @"res://Materials/RedMaterial.tres"},
        {1, @"res://Materials/TeamOneMaterial.tres"},
        {2, @"res://Materials/TeamTwoMaterial.tres"},
    };

    public static Material RedMaterial = (Material)ResourceLoader.Load(Utilities.TeamColours[0]);

    public static void SetGlobalPosition(Spatial node, Vector3 pos)
    {
        node.GlobalTransform = (new Transform(node.GlobalTransform.basis, pos));
    }

    // FIXME - not perfect.... ugly hack job and really bad, rewrite it
    public static void MoveToFloor(Spatial node)
    {
        Vector3 down = new Vector3(0, -1f, 0);
        MoveRecursively(node, down);
    }

    private static void MoveRecursively(Spatial node, Vector3 dir)
    {
        RayCast rc = new RayCast();
        node.AddChild(rc);
        rc.GlobalTransform = node.GlobalTransform;
        if (node is Building b)
        {
            AABB bb = b.Body.GetAabb();
            float x = bb.Size.x / 2;
            float y = bb.Size.y / 2;
            float z = bb.Size.z / 2;

            dir.x += (dir.x > 0) ? x : (dir.x < 0) ? x * -1 : 0;
            dir.y += (dir.y > 0) ? y : (dir.y < 0) ? y * -1 : 0;
            dir.z += (dir.z > 0) ? z : (dir.z < 0) ? z * -1 : 0;
        }
        
        rc.CastTo = dir;
        rc.ForceRaycastUpdate();

        if (rc.IsColliding() || node.GlobalTransform.origin.y < 1)
        {
            //Godot.Object obj = rc.GetCollider();
            node.RemoveChild(rc);
        }
        else
        {
            node.RemoveChild(rc);
            node.TranslateObjectLocal(dir);
            
            MoveRecursively(node, dir);
        }
    }

    public static Node GetRecursiveChildByName(Node n, string name)
    {
        foreach (Node n2 in n.GetChildren())
        {
            if (n2.Name == name)
            {
                return n2;
            }
            Node n3 = GetRecursiveChildByName(n2, name);
            if (n3 != null)
            {
                return n3;
            }
        }
        return null;
    }
}