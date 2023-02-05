class_name Enums

enum BUTTON_TYPE {
	UNSET,
	SCANCODE,
	MOUSEBUTTON,
	MOUSEWHEEL,
	MOUSEAXIS,
	CONTROLLERBUTTON,
	CONTROLLERAXIS
}

enum RESOURCE {
	NOT_SET,
	WOOD,
	STONE,
	GOLD,
	FLOUR,
	WOODEN_PLANKS,
	IRON,
	WHEAT,
	FRUIT,
	BREAD,
	MEAT,
	VEGETABLE,
	HOPS,
	ALE,
	CANDLES,
	PITCH
}

enum RESOURCE_PROCESS_POINT {
	NOT_SET,
	WAREHOUSE,
	WORKPLACE,
}

enum STATE {
	IDLE,
	CHOPPING,
	MOVING,
	MOVING_TO_WORK,
	WORKING,
	MOVING_TO_WAREHOUSE,
}

enum UNIT_TYPE {
	CIVILIAN,
	MILITARY,
	NOT_SET
}

enum ENTITY_CATEGORY {
	NOT_SET,
	UNIT,
	BUILDING,
	RESOURCE
}

enum ENTITY {
	NOT_SET,
	BUILDING_CASTLE = 1,
	UNIT_UNEMPLOYED,
	UNIT_WOODCHOPPER,
	UNIT_QUARRYWORKER,
	BUILDING_WOODCHOPPER,
	BUILDING_WAREHOUSE,
	BUILDING_QUARRY,
	RESOURCE_TREE, # done
	RESOURCE_STONE, # done
	RESOURCE_IRON,
	RESOURCE_WHEAT,
	RESOURCE_FRUIT,
	RESOURCE_BREAD,
	RESOURCE_MEAT,
	RESOURCE_VEGETABLE,
	RESOURCE_HOPS,
	RESOURCE_ALE,
	RESOURCE_CANDLES,
	RESOURCE_PITCH,
	BUILDING_IRONMINE,
	UNIT_IRONMINER,
	BUILDING_ORCHARD,
	UNIT_ORCHARDWORKER,
}

enum LIFE_STAGE {
	SPROUT,
	SAPLING,
	POLE,
	MATURE
}
