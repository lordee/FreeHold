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

public enum UNITTYPE
{
    None,
    Peasant,
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

public enum PROP
{
    STARTLOCATION,
    TREE,
    STONE,
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

public enum BUILDINGTYPE
{
    NONE,
    // FOOD
    GRANARY,
    ORCHARD,
    PIGFARM,
    GRAINFARM,
    HOPSFARM,
    DAIRYFARM,
    BREWERY,
    MILL,
    BAKERY,
    // INDUSTRY
    STOCKPILE,
    WOODCUTTERHUT,
    QUARRY,
    OXTETHER,
    IRONMINE,
    PITCHRIG,
    // TOWN
    HOVEL,
    CHURCH,
    APOTHECARY,
    WELL,
    WATERPOT,
    INN,
    MARKET,
    CHANDLER,
    // MILITARY
    ARMOURY,
    BARRACKS,
    MERCENARYPOST,
    SIEGECAMP,
    STABLE,
    FLETCHER,
    ARTILLATOR,
    POLETURNER,
    WEAPONSMITH,
    BLACKSMITH,
    FORGE,
    ARMOURER,
    // CASTLE FORTIFICATIONS
    WALL,
    GATEHOUSE,
    STAIRS,
    MANGONEL,
    BALLISTA,
    HAYBALELAUNCHER, //??
    // CASTLE TOWERS
    SMALLTOWER,
    MEDIUMTOWER,
    LARGETOWER,
    // CASTLE DEFENSES
    BRAZIER,
    HOARDING,
    MANTRAP,
    BARRICADES,
    WARDOG,
    OILSMELTER,
    PITCHDITCH,
    // STARTING BUILDING
    KEEP,
    CAMPFIRE
}

public enum REASON
{
    RESOURCES,
    PLACEMENT,
}

public enum RESOURCE
{
    NONE,
    WOOD,
    STONE,
    GOLD,
    PITCH,
    PLANKS,
    IRON
    // TODO - all food types, intermediary resources
}