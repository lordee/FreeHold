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

enum RESOURCE_PROCESS_POINT {
	NOT_SET,
	WAREHOUSE,
	WORKPLACE,
	MAP,
	ARMOURY
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
	BUILDING_CASTLE = 1, # done
	UNIT_UNEMPLOYED, # done
	UNIT_WOODCHOPPER, # done
	UNIT_QUARRYWORKER, # done
	BUILDING_WOODCHOPPER, # done
	BUILDING_WAREHOUSE, # done
	BUILDING_QUARRY, # done
	RESOURCE_TREE, # done
	RESOURCE_STONE, # done
	RESOURCE_IRON, # done
	RESOURCE_WHEAT, # done
	RESOURCE_FRUIT, # done
	RESOURCE_BREAD, # done
	RESOURCE_MEAT, # done
	RESOURCE_VEGETABLE, # done
	RESOURCE_HOPS, # done
	RESOURCE_ALE, # done
	RESOURCE_CANDLES, # done
	RESOURCE_PITCH, # done
	BUILDING_IRONMINE, # done
	UNIT_IRONMINER, # done
	BUILDING_ORCHARD, # done
	UNIT_ORCHARDWORKER, # done
	BUILDING_VEGETABLEFARM, # done
	UNIT_VEGETABLEFARMER, # done
	BUILDING_WHEATFARM, # done
	UNIT_WHEATFARMER, # done
	BUILDING_WINDMILL, # done
	UNIT_MILLWORKER, # done
	RESOURCE_FLOUR, # done
	RESOURCE_WOODEN_PLANKS, # done
	RESOURCE_WOOD, # done
	RESOURCE_GOLD, # done
	RESOURCE_CHEESE, # done
	BUILDING_BAKERY, # done
	UNIT_BAKER, # done
	RESOURCE_MILK, # done
	UNIT_DAIRYFARMER, # done
	BUILDING_DAIRYFARM, # done
	UNIT_PIGFARMER, # done
	BUILDING_PIGFARM, # done
	RESOURCE_PIG, # done
	BUILDING_HOPSFARM, # done
	UNIT_HOPSFARMER, # done
	BUILDING_BREWERY, # done
	UNIT_BREWER, # done
	BUILDING_TAVERN, # done
	UNIT_INNKEEPER, # done
	BUILDING_CHANDLERY, # done
	UNIT_CHANDLER, # done
	BUILDING_CHURCH, # done
	UNIT_PRIEST, # done
	RESOURCE_CANDLE_PRECURSOR, # done
	BUILDING_PITCHWORKSHOP, # done
	UNIT_PITCHGATHERER, # done
	RESOURCE_PITCH_PRECURSOR, # done
	BUILDING_FLETCHERWORKSHOP, # done
	UNIT_FLETCHER, # done
	RESOURCE_BOW, # done
	RESOURCE_HOPS_PRECURSOR, # done
	RESOURCE_WHEAT_PRECURSOR, # done
	RESOURCE_STONE_PRECURSOR, # done
	RESOURCE_IRON_PRECURSOR, # done
	RESOURCE_FRUIT_PRECURSOR, # done
	RESOURCE_VEGETABLE_PRECURSOR, # done
	BUILDING_ARMOURY, # done
	BUILDING_BARRACKS,
	UNIT_ARCHER
}

enum LIFE_STAGE {
	SPROUT,
	SAPLING,
	POLE,
	MATURE
}
