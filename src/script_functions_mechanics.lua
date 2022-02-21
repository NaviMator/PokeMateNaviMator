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
        95 -- Hypnosis
        -- Yawn
        -- Spore
        -- Dark Void
        -- Sleep Powder
        -- Lovely Kiss
        -- Sing
        -- Grass Whistle
    },

    Poison = {
        -- Poison Gas
        -- Poison Powder
    },

    BadPoison = {
        -- Toxic
    },

    Burn = {
        -- Will-O-Wisp
    },

    Paralize = {
        -- Nuzzle
        -- Thunder Wave
        -- Glare
        -- Stun Spore
    },

	Other = {
		212, -- Mean Look
		100 -- Teleport
	}
}

attacksThatCauseStatus = {
	LowerEnemyAttack = {
		45 --Growl
	}
}


-- List of special moves for group-battles
-- this list is very incomplete. Feel free to contribute.
attacksThatdamageGroups = {
	57, -- Surf
	89 -- Earthquake
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
		1 -- FIGHTING
	},
	
	FIRE = {
		11, -- WATER
		4, -- GROUND
		5 -- ROCK
	},

	WATER = {
		13, -- ELECTRIC
		12 -- GRASS
	},

	ELECTRIC = {
		4 -- GROUND
	},

	GRASS = {
		10, -- FIRE
		15, -- ICE
		3, -- POISON
		2, -- FLYING
		6 -- BUG
	},

	ICE = {
		10, -- FIRE
		1, -- FIGHTING
		5, -- ROCK
		8 -- STEEL
	},

	FIGHTING = {
		2, -- FLYING
		14 -- PSYCHIC
		--	FAIRY
	},

	POISON = {
		4, -- GROUND
		14 -- PSYCHIC
	},

	GROUND = {
		11, -- WATER
		12, -- GRASS
		15 -- ICE
	},

	FLYING = {
		13, -- ELECTRIC
		15, -- ICE
		5 -- ROCK
	},

	PSYCHIC = {
		6, -- BUG
		7, -- GHOST
		17 -- DARK
	},

	BUG = {
		10, -- FIRE
		2, -- FLYING
		5 -- ROCK
	},

	ROCK = {
		11, -- WATER
		12, -- GRASS
		1, -- FIGHTING
		4, -- GROUND
		8 -- STEEL
	},

	GHOST = {
		7, -- GHOST
		17 -- DARK
	},

	DRAGON = {
		15, -- ICE
		16 -- DRAGON
	},

	DARK = {
		1, -- FIGHTING
		6 -- BUG
		-- FAIRY
	},

	STEEL = {
		10, -- FIRE
		1, -- FIGHTING
		4 -- GROUND
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
		8 -- STEEL
		-- FAIRY
	},

	WATER = {
		10, -- FIRE
		11, -- WATER
		15, -- ICE
		8 -- STEEL
	},

	ELECTRIC = {
		13, -- ELECTRIC
		2, -- FLYING
		8 -- STEEL
	},

	GRASS = {
		11, -- WATER
		13, -- ELECTRIC
		12, -- GRASS
		4 -- GROUND
	},

	ICE = {
		15 -- ICE
	},

	FIGHTING = {
		6, -- BUG
		5, -- ROCK
		17 -- DARK
	},

	POISON = {
		12, -- GRASS,
		1, -- FIGHTING
		3, -- POISON
		6 -- BUG
		-- FAIRY
	},

	GROUND = {
		5, -- ROCK
		15 -- ICE
	},

	FLYING = {
		12, -- GRASS,
		1, -- FIGHTING
		6 -- BUG
	},

	PSYCHIC = {
		1, -- FIGHTING
		14 -- PSYCHIC
	},

	BUG = {
		12, -- GRASS,
		1, -- FIGHTING
		4 -- GROUND
	},

	ROCK = {
		0, -- NORMAL
		10, -- FIRE
		3, -- POISON
		2 -- FLYING
	},

	GHOST = {
		3, -- POISON
		6 -- BUG
	},

	DRAGON = {
		10, -- FIRE
		11, -- WATER
		13, -- ELECTRIC
		12 -- GRASS
	},

	DARK = {
		7, -- GHOST
		17 -- DARK
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
		8 -- STEEL
		-- FAIRY
	}
	-- FAIRY = {
		--	1, -- FIGHTING
		--	6, -- BUG
		--	16 -- DRAGON
	--}
}


-- Not effective moves
notEffectiveAgainst = {
	
	NORMAL = {
		7 -- GHOST
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
		13 -- ELECTRIC
	},

	FLYING = {
		4 -- GROUND
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
		1 -- FIGHTING
	},

	DRAGON = {
		-- Empty
	},

	DARK = {
		14 -- PSYCHIC
	},

	STEEL = {
		3 -- POISON
	}
	-- FAIRY = {
		--	16 -- DRAGON
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
		285 -- Shroomish
	},
	ATK = {
		261 -- Poochyena
	},
	DEF = {
		290, -- Nincada
		273 -- Seedot
	},
	SPATK = {
		280 -- Ralts

	},
	SPDEF = {
		270 -- Lotad
	},
	SPD = {
		263, -- Zigzagoon
		264, -- Linoone
		278, -- Wingull
		276, -- Taillow
		283 -- Surskit
	},
	Mixed = { -- Thats always bad to calculate

	}
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

pokecenters = {
	Hoenn = {
		51 -- Littleoot Towrn (Own Room)
	},
	Unova = {
		115 -- Nevaio City
	}
}