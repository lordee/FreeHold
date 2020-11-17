using Godot;

public class UIButton
{
    public string Texture;
    public string Name;
    public string MethodName;
    public Vector2 Position;
    public Godot.Collections.Array Args;

    public UIButton(string texture, string name, string methodName, Vector2 position, Godot.Collections.Array args)
    {
        Texture = texture;
        Name = name;
        MethodName = methodName;
        Position = position;
        Args = args;
    }
}    