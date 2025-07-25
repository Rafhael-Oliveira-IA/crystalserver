local mType = Game.createMonsterType("Armadile")
local monster = {}

monster.description = "an armadile"
monster.experience = 3200
monster.outfit = {
	lookType = 487,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 880
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 1.",
}

monster.health = 3800
monster.maxHealth = 3800
monster.race = "undead"
monster.corpse = 15868
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Creak!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 100000, maxCount = 100 },
	{ name = "gold coin", chance = 100000, maxCount = 98 },
	{ name = "platinum coin", chance = 95000, maxCount = 7 },
	{ id = 3053, chance = 1000 }, -- time ring
	{ name = "tower shield", chance = 620 },
	{ name = "titan axe", chance = 1540 },
	{ name = "bonebreaker", chance = 1150 },
	{ name = "strong health potion", chance = 14285, maxCount = 2 },
	{ name = "strong mana potion", chance = 15000, maxCount = 2 },
	{ name = "great mana potion", chance = 15920, maxCount = 2 },
	{ name = "great health potion", chance = 15000, maxCount = 2 },
	{ name = "mana potion", chance = 14285, maxCount = 3 },
	{ name = "terra boots", chance = 2850 },
	{ name = "crystalline armor", chance = 230 },
	{ name = "battle stone", chance = 12460 },
	{ id = 12600, chance = 6000 }, -- coal
	{ name = "green crystal splinter", chance = 3920, maxCount = 2 },
	{ name = "green crystal fragment", chance = 5690, maxCount = 2 },
	{ name = "crystalline spikes", chance = 14540 },
	{ name = "drill bolt", chance = 7692, maxCount = 5 },
	{ name = "envenomed arrow", chance = 10230, maxCount = 10 },
	{ name = "jade conical hat", chance = 1000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150 },
	{ name = "drunk", interval = 2000, chance = 10, radius = 4, effect = CONST_ME_FIREAREA, target = true, duration = 5000 },
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -200, maxDamage = -400, radius = 4, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 66,
	mitigation = 1.96,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 45 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
