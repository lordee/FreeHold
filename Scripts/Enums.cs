public class ButtonInfo
{
	public enum TYPE {UNSET, SCANCODE, MOUSEBUTTON, MOUSEWHEEL, MOUSEAXIS, CONTROLLERBUTTON, CONTROLLERAXIS}
	public enum DIRECTION {UP, DOWN, RIGHT, LEFT};
}

public enum ClickState
{
	NoSelection,
	PlacingBuilding,
    ButtonClick,
}

public enum CollisionMask
{
	None = 0,
	All = 1,
	Unit = 3,
}

public enum UnitType
{
    None,
    Conscript,
    Spearman,
    Archer,
    Crossbowman,
    Maceman,
    Pikeman,
    Swordman,
    Knight,
    Sergeant,
    // mercenaries
    Slave,
    SlaveDriver,
    ArabianBowman,
    HorseArcher,
    WhirlingDervish,
    ArabianSwordsman,
    Assassin,
    OilPotThrower,
    SassanidKnight,
    Healer,
    // siege units
    Cat,
    Mantlet,
    Catapult,
    Trebuchet,
    BurningCart,
    FireBallista,
    BatteringRam,
    WarWagon,
    Mangonel,
    Ballista,
    HaybaleLauncher
}

public enum BtnPosition
{
    Above,
    Below,
    Left,
    Right,
}

public enum PropType
{
    StartLocation
}

public enum MenuType
{
    None,
    Main,
    Food,
    Town,
    Military,
    Industry,
    Castle,
    CastleFortifications,
    CastleTowers,
    CastleDefenses,
    Barracks,
    Mercenaries,
    Siege,
    CreateBuilding,
    CreateUnit,
}

public enum BuildingType
{
    None,
    // food
    Granary,
    Orchard,
    PigFarm,
    Grain,
    HopsFarm,
    DairyFarm,
    Brewery,
    Mill,
    Bakery,
    // industry
    Stockpile,
    WoodcutterHut,
    Quarry,
    OxTether,
    IronMine,
    PitchRig,
    // town
    Hovel,
    Church,
    Apothecary,
    Well,
    WaterPot,
    Inn,
    Market,
    Chandler,
    // military
    Armoury,
    Barracks,
    MercenaryPost,
    SiegeCamp,
    Stable,
    Fletcher,
    Artillator,
    Poleturner,
    Weaponsmith,
    Blacksmith,
    Forge,
    Armourer,
    // castle fortifications
    Wall,
    Gatehouse,
    Stairs,
    Mangonel,
    Ballista,
    HaybaleLauncher, //??
    // castle towers
    SmallTower,
    MediumTower,
    LargeTower,
    // castle defenses
    Brazier,
    Hoarding,
    ManTrap,
    Barricades,
    Wardog,
    OilSmelter,
    PitchDitch,
    // starting building
    Keep
}

public enum REASON
{
    RESOURCES,
    PLACEMENT,
}