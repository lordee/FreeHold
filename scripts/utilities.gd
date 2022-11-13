extends Object
class_name utilities

static func get_recursive_child(node) -> Node:
	for child in node.get_children():
		get_recursive_child(child)
		
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
