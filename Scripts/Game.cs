using Godot;
using System;
using System.Collections.Generic;

public class Game : Spatial
{
    static Game that;
 
    // Settings
    static public float Gravity = 10f;
    static public float PeasantSpawnTime = 1f;

    // Scenes/Nodes
    PackedScene WorldScene;
    static public World World;
    static public UIManager UIManager;
    string playerResource = "res://Scenes/Player.tscn";
    PackedScene playerScene;
    static public Player Player;
    static public RtsCameraController CameraController;
    static public BuildingManager BuildingManager;
    static public UnitManager UnitManager;

    static public List<BindingObject> Binds = new List<BindingObject>();
   
    public override void _Ready()
    {
        Setup();
        that = this;
        UIManager = GetNode("UIManager") as UIManager;
        playerScene = ResourceLoader.Load(playerResource) as PackedScene;
        CameraController = GetNode("InputManager/RtsCameraController") as RtsCameraController;
        BuildingManager = GetNode("BuildingManager") as BuildingManager;
        UnitManager = GetNode("UnitManager") as UnitManager;
    }

    private void LoadWorld()
    {
        WorldScene = ResourceLoader.Load("res://Scenes/World.tscn") as PackedScene;
        World = WorldScene.Instance() as World;
        this.AddChild(World);
    }

    private void AddPlayer()
    {
        // for now just single player
        Player = playerScene.Instance() as Player;
        this.AddChild(Player);

        Player.Init();

        World.Players.Add(Player);
    }

    static public void Start()
    {
        that.LoadWorld();
        UIManager.LoadUI();
        that.AddPlayer();
    }

    private void Setup()
    {
        InputManager.Bind("camera_zoom_in", "wheelup", InputManager.CameraZoomIn);
        InputManager.Bind("camera_zoom_out", "wheeldown", InputManager.CameraZoomOut);
        InputManager.Bind("camera_rotate", "mousethree", InputManager.CameraRotate);
        InputManager.Bind("camera_pan", "e", InputManager.CameraPan);
        InputManager.Bind("camera_forward", "w", InputManager.CameraForward);
        InputManager.Bind("camera_backward", "s", InputManager.CameraBackward);
        InputManager.Bind("camera_right", "d", InputManager.CameraRight);
        InputManager.Bind("camera_left", "a", InputManager.CameraLeft);
        InputManager.Bind("click_left", "mouseone", InputManager.ClickLeft);
        InputManager.Bind("click_right", "mousetwo", InputManager.ClickRight);
    }

    
}