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