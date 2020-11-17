using Godot;
using Godot.Collections;
using System;
using System.Collections.Generic;

public class UI : CanvasLayer
{
    List<UIButton> mainButtonDefs = new List<UIButton>();
    List<Button> mainButtons = new List<Button>();

    List<UIButton> indButtonDefs = new List<UIButton>();
    List<Button> indButtons = new List<Button>();

    List<UIButton> foodButtonDefs = new List<UIButton>();
    List<Button> foodButtons = new List<Button>();

    List<UIButton> townButtonDefs = new List<UIButton>();
    List<Button> townButtons = new List<Button>();

    List<UIButton> milButtonDefs = new List<UIButton>();
    List<Button> milButtons = new List<Button>();

    List<UIButton> castleButtonDefs = new List<UIButton>();
    List<Button> castleButtons = new List<Button>();

    List<UIButton> fortificationButtonDefs = new List<UIButton>();
    List<Button> fortificationButtons = new List<Button>();

    List<UIButton> towerButtonDefs = new List<UIButton>();
    List<Button> towerButtons = new List<Button>();

    List<UIButton> defenseButtonDefs = new List<UIButton>();
    List<Button> defenseButtons = new List<Button>();

    List<UIButton> barracksButtonDefs = new List<UIButton>();
    List<Button> barracksButtons = new List<Button>();

    List<UIButton> mercenariesButtonDefs = new List<UIButton>();
    List<Button> mercenariesButtons = new List<Button>();

    List<UIButton> siegeButtonDefs = new List<UIButton>();
    List<Button> siegeButtons = new List<Button>();

    List<List<Button>> allButtons = new List<List<Button>>();

    RtsCameraController _player;
    Building _activeBuilding;

    Tooltip _tooltip;

    int buttonSpacer = 35;
    int menuLine1 = 60;
    int menuLine2 = 0;
    public override void _Ready()
    {
        _tooltip = GetNode("Tooltip") as Tooltip;
        _player = this.GetParent() as RtsCameraController;
        menuLine2 = menuLine1 - buttonSpacer;
        Vector2 vp = GetViewport().Size;
        int butCount = 0;
        int ySpacer = menuLine1;       

        mainButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Industry", "ShowMenu", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { MenuType.Industry }));
        butCount++;
        mainButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Food", "ShowMenu", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { MenuType.Food }));
        butCount++;
        mainButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Town", "ShowMenu", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { MenuType.Town }));
        butCount = 0;
        ySpacer = menuLine2;
        mainButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Military", "ShowMenu", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { MenuType.Military }));
        butCount++;
        mainButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Castle", "ShowMenu", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { MenuType.Castle }));

        foreach(UIButton b in mainButtonDefs)
        {
            mainButtons.Add(MakeButton(b));
        }

        butCount = 0;
        ySpacer = menuLine1;

        indButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Stockpile", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Stockpile }));
        butCount++;
        indButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Woodcutter's Hut", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.WoodcutterHut }));
        butCount++;
        indButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Quarry", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Quarry }));
        butCount++;
        indButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Ox Tether", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.OxTether }));
        butCount++;
        indButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Iron Mine", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.IronMine }));
        butCount = 0;
        ySpacer = menuLine2;
        indButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Pitch Rig", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.PitchRig }));

        foreach(UIButton b in indButtonDefs)
        {
            indButtons.Add(MakeButton(b));
        }

        butCount = 0;
        ySpacer = menuLine1;
        foodButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Granary", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Granary }));
        butCount++;
        foodButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Orchard", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Orchard }));
        butCount++;
        foodButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Pig Farm", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.PigFarm }));
        butCount++;
        foodButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Dairy Farm", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.DairyFarm }));
        butCount++;
        foodButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Grain Farm", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Grain }));
        butCount = 0;
        ySpacer = menuLine2;
        foodButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Mill", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Mill }));
        butCount++;
        foodButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Bakery", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Bakery }));
        butCount++;
        foodButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Hops Farm", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.HopsFarm }));
        butCount++;
        foodButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Brewery", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Brewery }));
        
        foreach(UIButton b in foodButtonDefs)
        {
            foodButtons.Add(MakeButton(b));
        }

        butCount = 0;
        ySpacer = menuLine1;
        townButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Hovel", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Hovel }));
        butCount++;
        townButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Church", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Church }));
        butCount++;
        townButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Apothecary", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Apothecary }));
        butCount++;
        townButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Well", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Well }));
        butCount++;
        townButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Water Pot", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.WaterPot }));
        butCount = 0;
        ySpacer = menuLine2;
        townButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Inn", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Inn }));
        butCount++;
        townButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Market", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Market }));
        butCount++;
        townButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Chandler", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Chandler }));
        butCount++;
        townButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Brewery", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Brewery }));
        
        foreach(UIButton b in townButtonDefs)
        {
            townButtons.Add(MakeButton(b));
        }

        butCount = 0;
        ySpacer = menuLine1;
        milButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Armoury", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Armoury }));
        butCount++;
        milButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Barracks", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Barracks }));
        butCount++;
        milButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Mercenary Post", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.MercenaryPost }));
        butCount++;
        milButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Siege Camp", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.SiegeCamp }));
        butCount++;
        milButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Stable", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Stable }));
        butCount = 0;
        ySpacer = menuLine2;
        milButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Fletcher", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Fletcher }));
        butCount++;
        milButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Artillator", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Artillator }));
        butCount++;
        milButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Poleturner", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Poleturner }));
        butCount++;
        milButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Weaponsmith", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Weaponsmith }));
        butCount++;
        milButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Blacksmith", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Blacksmith }));
        butCount++;
        milButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Forge", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Forge }));
        butCount++;
        milButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Armourer", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Armourer }));
        
        foreach(UIButton b in milButtonDefs)
        {
            milButtons.Add(MakeButton(b));
        }

        butCount = 0;
        ySpacer = menuLine1;
        castleButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Fortifications", "ShowMenu", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { MenuType.CastleFortifications }));
        butCount++;
        castleButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Towers", "ShowMenu", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { MenuType.CastleTowers }));
        butCount++;
        castleButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Defenses", "ShowMenu", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { MenuType.CastleDefenses }));
        
        foreach(UIButton b in castleButtonDefs)
        {
            castleButtons.Add(MakeButton(b));
        }

        butCount = 0;
        ySpacer = menuLine1;
        fortificationButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Wall", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Wall }));
        butCount++;
        fortificationButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Gatehouse", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Gatehouse }));
        butCount++;
        fortificationButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Stairs", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Stairs }));
        butCount++;
        fortificationButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Mangonel", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Mangonel }));
        butCount++;
        fortificationButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Ballista", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Ballista }));
        butCount = 0;
        ySpacer = menuLine2;
        fortificationButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "HaybaleLauncher", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.HaybaleLauncher }));

        foreach(UIButton b in fortificationButtonDefs)
        {
            fortificationButtons.Add(MakeButton(b));
        }

        butCount = 0;
        ySpacer = menuLine1;
        towerButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Small Tower", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.SmallTower }));
        butCount++;
        towerButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Medium Tower", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.MediumTower }));
        butCount++;
        towerButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Large Tower", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.LargeTower }));
        
        foreach(UIButton b in towerButtonDefs)
        {
            towerButtons.Add(MakeButton(b));
        }

        butCount = 0;
        ySpacer = menuLine1;
        defenseButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Brazier", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Brazier }));
        butCount++;
        defenseButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Hoarding", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Hoarding }));
        butCount++;
        defenseButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "ManTrap", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.ManTrap }));
        butCount++;
        defenseButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Barricades", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Barricades }));
        butCount++;
        defenseButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "War dogs", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.Wardog }));
        butCount = 0;
        ySpacer = menuLine2;
        defenseButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Oil Smelter", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.OilSmelter }));
        butCount++;
        defenseButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Pitch Ditch", "Build_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { BuildingType.PitchDitch }));

        foreach(UIButton b in defenseButtonDefs)
        {
            defenseButtons.Add(MakeButton(b));
        }

        butCount = 0;
        ySpacer = menuLine1;
        barracksButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Conscript", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Conscript }));
        butCount++;
        barracksButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Spearman", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Spearman }));
        butCount++;
        barracksButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Archer", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Archer }));
        butCount++;
        barracksButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Crossbowman", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Crossbowman }));
        butCount++;
        barracksButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Maceman", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Maceman }));
        butCount = 0;
        ySpacer = menuLine2;
        barracksButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Pikeman", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Pikeman }));
        butCount++;
        barracksButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Swordman", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Swordman }));
        butCount++;
        barracksButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Knight", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Knight }));
        butCount++;
        barracksButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Sergeant", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Sergeant }));
        
        foreach(UIButton b in barracksButtonDefs)
        {
            barracksButtons.Add(MakeButton(b));
        }

        butCount = 0;
        ySpacer = menuLine1;
        mercenariesButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Slave", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Slave }));
        butCount++;
        mercenariesButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "SlaveDriver", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.SlaveDriver }));
        butCount++;
        mercenariesButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "ArabianBowman", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.ArabianBowman }));
        butCount++;
        mercenariesButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "HorseArcher", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.HorseArcher }));
        butCount++;
        mercenariesButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "WhirlingDervish", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.WhirlingDervish }));
        butCount = 0;
        ySpacer = menuLine2;
        mercenariesButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "ArabianSwordsman", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.ArabianSwordsman }));
        butCount++;
        mercenariesButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Assassin", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Assassin }));
        butCount++;
        mercenariesButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "OilPotThrower", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.OilPotThrower }));
        butCount++;
        mercenariesButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "SassanidKnight", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.SassanidKnight }));
        butCount++;
        mercenariesButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Healer", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Healer }));

        foreach(UIButton b in mercenariesButtonDefs)
        {
            mercenariesButtons.Add(MakeButton(b));
        }

        butCount = 0;
        ySpacer = menuLine1;
        siegeButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Mantlet", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Mantlet }));
        butCount++;
        siegeButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Cat", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Cat }));
        butCount++;
        siegeButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Catapult", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Catapult }));
        butCount++;
        siegeButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Trebuchet", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Trebuchet }));
        butCount++;
        siegeButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "BurningCart", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.BurningCart }));
        butCount++;
        siegeButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "FireBallista", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.FireBallista }));
        butCount = 0;
        ySpacer = menuLine2;
        siegeButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "BatteringRam", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.BatteringRam }));
        butCount++;
        siegeButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "WarWagon", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.WarWagon }));
        butCount++;
        siegeButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Mangonel", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Mangonel }));
        butCount++;
        siegeButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "Ballista", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.Ballista }));
        butCount++;
        siegeButtonDefs.Add(new UIButton("res://Assets/UI/temp.png", "HaybaleLauncher", "CreateUnit_Click", new Vector2(vp.x/2 + buttonSpacer * butCount, vp.y-ySpacer), new Godot.Collections.Array() { UnitType.HaybaleLauncher }));   

        foreach(UIButton b in siegeButtonDefs)
        {
            siegeButtons.Add(MakeButton(b));
        }

        allButtons.Add(mainButtons);
        allButtons.Add(indButtons);
        allButtons.Add(foodButtons);
        allButtons.Add(townButtons);
        allButtons.Add(milButtons);
        allButtons.Add(castleButtons);
        allButtons.Add(fortificationButtons);
        allButtons.Add(towerButtons);
        allButtons.Add(defenseButtons);
        allButtons.Add(barracksButtons);
        allButtons.Add(mercenariesButtons);
        allButtons.Add(siegeButtons);

        ShowMenu(MenuType.Main);
    }

    private Button MakeButton(UIButton b)
    {
        Button btn = new Button();
        Texture tex = ResourceLoader.Load(b.Texture) as Texture;
        btn.Icon = tex;
        this.AddChild(btn);
        btn.SetPosition(b.Position);
        btn.Name = b.Name;
        btn.RectScale = new Vector2(.25f, .25f);
        btn.Connect("pressed", this, b.MethodName, b.Args);
        btn.Connect("mouse_entered", this, nameof(DrawToolTip), new Godot.Collections.Array() { b.Position, b.Name });
        btn.Connect("mouse_exited", this, nameof(HideToolTip));
        
        return btn;
    }

    private void DrawToolTip(Vector2 position, string text)
    {
        Vector2 vp = GetViewport().Size;
        // FIXME - change all this to a panel for buttons etc
        Vector2 pos = new Vector2(vp.x/2 + buttonSpacer, vp.y-menuLine1 - 30);
        _tooltip.Init(pos, text);
        _tooltip.Show();
    }

    private void HideToolTip()
    {
        _tooltip.Hide();
    }

    public void ShowMenu(MenuType type)
    {
        ShowMenu(type, null);
    }

    public void ShowMenu(MenuType type, Building building)
    {
        _activeBuilding = building;
        foreach(List<Button> lst in allButtons)
        {
            foreach(Button b in lst)
            {
                b.Hide();
            }
        }

        List<Button> active = null;

        switch (type)
        {
            case MenuType.Main:
                active = mainButtons;
                break;
            case MenuType.Food:
                active = foodButtons;
                break;
            case MenuType.Town:
                active = townButtons;
                break;
            case MenuType.Military:
                active = milButtons;
                break;
            case MenuType.Industry:
                active = indButtons;
                break;
            case MenuType.Castle:
                active = castleButtons;
                break;
            case MenuType.CastleFortifications:
                active = fortificationButtons;
                break;
            case MenuType.CastleTowers:
                active = towerButtons;
                break;
            case MenuType.CastleDefenses:
                active = defenseButtons;
                break;
            case MenuType.Barracks:
                active = barracksButtons;
                break;
            case MenuType.Mercenaries:
                active = mercenariesButtons;
                break;
            case MenuType.Siege:
                active = siegeButtons;
                break;
        }

        if (active == null)
        {
            active = mainButtons;
        }
        foreach(Button b in active)
        {
            b.Show();
        }
    }

    public void Build_Click(BuildingType b)
    {
        //_player.Build(b);
    }

    public void CreateUnit_Click(UnitType u)
    {
        Vector3 pos = _activeBuilding.Transform.origin;
        pos.x += _activeBuilding.Scale.x*2;
        //_player.CreateUnit(u, pos);
    }
}
                                        
