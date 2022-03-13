--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~A~T~T~A~C~K~S~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]

-- List of return-values for function "Battle.Active.GetEffect(team, i)"
-- BETA: This list is propably not complete. Feel free to contribute.
statusEffects = {
	["0"] = "noEffect",
	["2"] = "sleep",
	["3"] = "sleep",
	["4"] = "sleep",
	["8"] = "poison",
	["16"] = "burn",
	["32"] = "freeze",
	["64"] = "paralize",
	["-128"] = "badpoison"
}


-- Listed of attack-IDs that cause status-effects without damaging the oppponent.
-- The names of following attacks are complete, but not the IDs. Feel free to contribute.
attacksThatCauseEffects = {
    Sleep = {
        47,  -- Sing
        79,  -- Sleep Powder
        95,  -- Hypnosis
        142, -- Lovely Kiss
        147, -- Spore
        281, -- Yawn
        320, -- Grass Whistle
        464, -- Dark Void
    },
    Poison = {
        77,  -- Poison Powder
        139, -- Poison Gas
    },
    BadPoison = {
        92, -- Toxic
    },
    Burn = {
        261, -- Will-O-Wisp
    },
    Paralize = {
        78,  -- Stun Spore
        86,  -- Thunder Wave
        137, -- Glare
    },
}

attacksThatFlee = {
	46,  -- Roar
	100, -- Teleport
	18,  -- Whirlwind
}

attacksThatDontDamage = {
	LowerEnemyAttack = {
		45,  --Growl
	},
	RiseOwnAttack = {
		14,  -- Swords Dance
		96,  -- Meditate
		187, -- Belly Drum
		159, -- Sharpen
	},
	LowerEnemyDefense = {
		39,  -- Tail Whip
		43,  -- Leer
		103, -- Screech
	},
	RiseOwnDefense = {
		106, -- Harden
		110, -- Withdraw
		111, -- Defense Curl
		112, -- Barrier
		151, -- Acid Armor
	},
	LowerEnemySpecialAttack = {
		74,  -- Growth
	},
	RiseOwnSpecialAttack = {
		347, -- Calm Mind
	},
	LowerEnemySpecialDefense = {
		319, -- Metal Sound
	},
	RiseOwnSpecialDefense = {
		133, -- Amnesia
	},
	LowerEnemySpeed = {
		81,  -- String Shot
	},
	RiseOwnSpeed = {
		97,  -- Agility
	},
	LowerEnemyAccuracy = {
		28,  -- Sand Attack
		148, -- Flash
		108, -- Smokescreen
		134, -- Kinesis
	},
	RiseOwnEvasion = {
		104, -- Double Team
		107, -- Minimize
	},
	Confuse = {
		48,  -- Supersonic
		109, -- Confuse Ray
	},
	Protect = {
		54,  -- Mist
		113, -- Light Screen
		115, -- Reflect
		182, -- Protect
		501, -- Quick Guard
	},
	Heal = {
		105, -- Recover
		135, -- Soft-Boiled
		156, -- Rest
		208, -- Milk Drink
		235, -- Synthesis
		273, -- Wish
		355, -- Roost
	}
	Weather = {
		201, -- Sandstorm
		240, -- Rain Dance
		241, -- Sunny Day
	}
	SpecialTactics = {
		50,  -- Disable
		73,  -- Leech Seed
		114, -- Haze
		116, -- Focus Energy
		118, -- Metronome
		119, -- Mirror Move
		160, -- Conversion
		164, -- Substitute
		169, -- Spider Web
		174, -- Curse
		191, -- Spikes
		194, -- Destiny Bond
		195, -- Perish Song
		212, -- Mean Look
		214, -- Sleep Talk
		170, -- Mind Reader
		171, -- Nightmare
		176, -- Conversion Two
	},
	SpecialBattle = {
		144, -- Transform
		150, -- Splash
	},
	Unsorted = {
		178, -- Cotton Spore
		180, -- Spite
		184, -- Scary Face
		186, -- Sweet Kiss
		193, -- Foresight
		197, -- Detect
		199, -- Lock-On
		203, -- Endure
		204, -- Charm
		207, -- Swagger
		213, -- Attract
		215, -- Heal Bell
		219, -- Safeguard
		220, -- Pain Split
		227, -- Encore
		230, -- Sweet Scent
		234, -- Morning Sun
		236, -- Moonlight
		244, -- Psych Up
		254, -- Stockpile
		256, -- Swallow
		258, -- Hail
		259, -- Torment
		260, -- Flatter
		262, -- Memento
		266, -- Follow Me
		267, -- Nature Power
		268, -- Charge
		269, -- Taunt
		270, -- Helping Hand
		271, -- Trick
		272, -- Role Play
		274, -- Assist
		275, -- Ingrain
		277, -- Magic Coat
		278, -- Recycle
		285, -- Skill Swap
		286, -- Imprison
		287, -- Refresh
		288, -- Grudge
		289, -- Snatch
		293, -- Camouflage
		294, -- Tail Glow
		297, -- Feather Dance
		298, -- Teeter Dance
		300, -- Mud Sport
		303, -- Slack Off
		312, -- Aromatherapy
		313, -- Fake Tears
		316, -- Odor Sleuth
		321, -- Tickle
		322, -- Cosmic Power
		334, -- Iron Defense
		335, -- Block
		336, -- Howl
		339, -- Bulk Up
		346, -- Water Sport
		349, -- Dragon Dance
		356, -- Gravity
		357, -- Miracle Eye
		361, -- Healing Wish
		366, -- Tailwind
		367, -- Acupressure
		373, -- Embargo
		375, -- Psycho Shift
		377, -- Heal Block
		379, -- Power Trick
		380, -- Gastro Acid
		381, -- Lucky Chant
		382, -- Me First
		383, -- Copycat
		384, -- Power Swap
		385, -- Guard Swap
		388, -- Worry Seed
		390, -- Toxic Spikes
		391, -- Heart Swap
		392, -- Aqua Ring
		393, -- Magnet Rise
		397, -- Rock Polish
		415, -- Switcheroo
		417, -- Nasty Plot
		432, -- Defog
		433, -- Trick Room
		445, -- Captivate
		446, -- Stealth Rock
		455, -- Defend Order
		456, -- Heal Order
		461, -- Lunar Dance
		468, -- Hone Claws
		469, -- Wide Guard
		470, -- Guard Split
		471, -- Power Split
		472, -- Wonder Room
		475, -- Autotomize
		476, -- Rage Powder
		477, -- Telekinesis
		478, -- Magic Room
		483, -- Quiver Dance
		487, -- Soak
		489, -- Coil
		493, -- Simple Beam
		494, -- Entrainment
		495, -- After You
		501, -- Quick Guard
		502, -- Ally Switch
		504, -- Shell Smash
		505, -- Heal Pulse
		508, -- Shift Gear
		511, -- Quash
		513, -- Reflect Type
		516, -- Bestow
		526, -- Work Up
		538, -- Cotton Guard
	},
}

attacksThatneedUserInput = {
	102, -- Mimic
	226, -- Baton Pass
	166, -- Sketch
}


-- List of special moves for group-battles
-- this list is very incomplete. Feel free to contribute.
attacksThatdamageGroups = {
	57, -- Surf
	89, -- Earthquake
}



--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~E~F~F~E~C~T~I~V~I~T~Y~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]
-- These lists should be complete, but errors may exist. Feel free to verify.



-- Pokemon types

pokemonTypes = {
	[0] = "NORMAL",
	[1] = "FIGHTING",
	[2] = "FLYING",
	[3] = "POISON",
	[4] = "GROUND",
	[5] = "ROCK",
	[6] = "BUG",
	[7] = "GHOST",
	[8] = "STEEL",
	-- 9
	[10] = "FIRE",
	[11] = "WATER",
	[12] = "GRASS",
	[13] = "ELECTRIC",
	[14] = "PSYCHIC",
	[15] = "ICE",
	[16] = "DRAGON",
	[17] = "DARK",
	-- FAIRY
}



-- Very effective moves

veryEffectiveAgainst = {

	NORMAL = {
		1, -- FIGHTING
	},
	
	FIRE = {
		11, -- WATER
		4, -- GROUND
		5, -- ROCK
	},

	WATER = {
		13, -- ELECTRIC
		12, -- GRASS
	},

	ELECTRIC = {
		4, -- GROUND
	},

	GRASS = {
		10, -- FIRE
		15, -- ICE
		3, -- POISON
		2, -- FLYING
		6, -- BUG
	},

	ICE = {
		10, -- FIRE
		1, -- FIGHTING
		5, -- ROCK
		8, -- STEEL
	},

	FIGHTING = {
		2, -- FLYING
		14, -- PSYCHIC
		--	FAIRY
	},

	POISON = {
		4, -- GROUND
		14, -- PSYCHIC
	},

	GROUND = {
		11, -- WATER
		12, -- GRASS
		15, -- ICE
	},

	FLYING = {
		13, -- ELECTRIC
		15, -- ICE
		5, -- ROCK
	},

	PSYCHIC = {
		6, -- BUG
		7, -- GHOST
		17, -- DARK
	},

	BUG = {
		10, -- FIRE
		2, -- FLYING
		5, -- ROCK
	},

	ROCK = {
		11, -- WATER
		12, -- GRASS
		1, -- FIGHTING
		4, -- GROUND
		8, -- STEEL
	},

	GHOST = {
		7, -- GHOST
		17 -- DARK
	},

	DRAGON = {
		15, -- ICE
		16, -- DRAGON
	},

	DARK = {
		1, -- FIGHTING
		6, -- BUG
		-- FAIRY
	},

	STEEL = {
		10, -- FIRE
		1, -- FIGHTING
		4, -- GROUND
	}

	-- FAIRY = {
		--	3, -- POISON
		--	8 -- STEEL
	--}
	
}


-- Not very effective moves
notVeryEffectiveAgainst = {

	NORMAL = {
		-- Empty
	},

	FIRE = {
		10, -- FIRE
		12, -- GRASS
		15, -- ICE
		8, -- STEEL
		-- FAIRY
	},

	WATER = {
		10, -- FIRE
		11, -- WATER
		15, -- ICE
		8, -- STEEL
	},

	ELECTRIC = {
		13, -- ELECTRIC
		2, -- FLYING
		8, -- STEEL
	},

	GRASS = {
		11, -- WATER
		13, -- ELECTRIC
		12, -- GRASS
		4, -- GROUND
	},

	ICE = {
		15, -- ICE
	},

	FIGHTING = {
		6, -- BUG
		5, -- ROCK
		17, -- DARK
	},

	POISON = {
		12, -- GRASS,
		1, -- FIGHTING
		3, -- POISON
		6, -- BUG
		-- FAIRY
	},

	GROUND = {
		5, -- ROCK
		15, -- ICE
	},

	FLYING = {
		12, -- GRASS,
		1, -- FIGHTING
		6, -- BUG
	},

	PSYCHIC = {
		1, -- FIGHTING
		14, -- PSYCHIC
	},

	BUG = {
		12, -- GRASS,
		1, -- FIGHTING
		4, -- GROUND
	},

	ROCK = {
		0, -- NORMAL
		10, -- FIRE
		3, -- POISON
		2, -- FLYING
	},

	GHOST = {
		3, -- POISON
		6, -- BUG
	},

	DRAGON = {
		10, -- FIRE
		11, -- WATER
		13, -- ELECTRIC
		12, -- GRASS
	},

	DARK = {
		7, -- GHOST
		17, -- DARK
	},

	STEEL = {
		0, -- NORMAL
		12, -- GRASS,
		15, -- ICE
		2, -- FLYING
		14, -- PSYCHIC
		7, -- GHOST -- Unverified because of generation changes
		17, -- DARK -- Unverified because of generation changes
		6, -- BUG
		5, -- ROCK
		16, -- DRAGON
		8, -- STEEL
		-- FAIRY
	}
	-- FAIRY = {
		--	1, -- FIGHTING
		--	6, -- BUG
		--	16, -- DRAGON
	--}
}


-- Not effective moves
notEffectiveAgainst = {
	
	NORMAL = {
		7, -- GHOST
	},

	FIRE = {
		-- Empty
	},

	WATER = {
		-- Empty
	},

	ELECTRIC = {
		-- Empty
	},

	GRASS = {
		-- Empty
	},

	ICE = {
		-- Empty
	},

	FIGHTING = {
		-- Empty
	},

	POISON = {
		-- Empty
	},

	GROUND = {
		13, -- ELECTRIC
	},

	FLYING = {
		4, -- GROUND
	},

	PSYCHIC = {
		-- Empty
	},

	BUG = {
		-- Empty
	},

	ROCK = {
		-- Empty
	},

	GHOST = {
		0, -- NORMAL
		1, -- FIGHTING
	},

	DRAGON = {
		-- Empty
	},

	DARK = {
		14, -- PSYCHIC
	},

	STEEL = {
		3, -- POISON
	}
	-- FAIRY = {
		--	16, -- DRAGON
	--}

}



--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~P~O~K~E~M~O~N~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]
-- List of pokemon that are great for ev-training
-- Not startet yet. Feel free to contribute.

pokemonForEV = {
	HP = {
		296, -- Makuhita
		297, -- Hariyama
		265, -- Wurmple
		293, -- Whismur
		287, -- Slakoth
		285, -- Shroomish
	},
	ATK = {
		261, -- Poochyena
	},
	DEF = {
		290, -- Nincada
		273, -- Seedot
	},
	SPATK = {
		280, -- Ralts

	},
	SPDEF = {
		270, -- Lotad
	},
	SPD = {
		263, -- Zigzagoon
		264, -- Linoone
		278, -- Wingull
		276, -- Taillow
		283, -- Surskit
	},
	Mixed = { -- Thats always bad to calculate

	}
}

pokemonToCatchFirstTurn = {
	63, -- Abra
}


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~L~O~C~A~T~I~O~N~S~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]
-- Area for function World.GetRegionId()

regions = {
	0, -- Kanto
	1, -- Hoenn
}