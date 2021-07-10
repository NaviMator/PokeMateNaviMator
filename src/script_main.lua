--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~Walking~to~destination~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]
	
function walkingToDestination()

	readDatabase()

	if array_Activities_Routes_Route[1] ~= "!No Route!" then
		
		if goHeal == true then
			print("Highway to heal.")
			routes(array_Activities_Routes_Route[1], true)
			regenerate()
			if returnAfterHealing ~= false then
				initialWalkDone = false
			end
		end

		if initialWalkDone ~= true then
			print("Walking " .. array_Activities_Routes_Route[1])
			leavePokeCenter()
			routes(array_Activities_Routes_Route[1])
			initialWalkDone = true
		end

	else

		if goHeal == true then
			MessageBox("Need to heal but no route defined.")
			stop()
		end

	end

end


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~Behavior~at~destination~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]

function behaviorAtDestination()

	readDatabase()

	if array_Activities_Routes_BehaviorAtDestination[1] == "Move (left/right)" then
		runningAround("horizontally")
	elseif array_Activities_Routes_BehaviorAtDestination[1] == "Move (up/down)" then
		runningAround("vertically")
	elseif array_Activities_Routes_BehaviorAtDestination[1] == "Fishing" then
		fishing()
	elseif array_Activities_Routes_BehaviorAtDestination[1] == "Sweet Scent" then
		useSweetScent()
	elseif array_Activities_Routes_BehaviorAtDestination[1] == "Walk back" then
		goHeal = true
		returnAfterHealing = true
	elseif array_Activities_Routes_BehaviorAtDestination[1] == "Do nothing" then
		stop();
	end

end




--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~Behavior~in~battle~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]

function behaviorInBattle()

	readDatabase()
	print("Enemy spotted.")

	-- Check for shiny
	for PokemonNr = 0, Battle.GetFightingTeamSize(1)-1 do
		-- Note: tostring(Battle.GetFightingTeamSize(1)) -- Function always returns 1 or 5
		if Battle.Active.GetPokemonRarity(1, PokemonNr) == "SHINY" then
			MessageBox("ENEMY IS SERIOUSLY SHINY!!!")
			catchIt = true
			Stop() -- Temporary Trust-Workaround
		end
	end

	-- Analyse enemy
	for PokemonNr = 0, Battle.GetFightingTeamSize(1)-1 do
		enemyPokemonID = Battle.Active.GetPokemonID(1, PokemonNr)
		if enemyPokemonID > 0 then
			if Battle.Active.GetPokemonType1(1, 0) == Battle.Active.GetPokemonType2(1, 0) then
				print("Enemy is Pokemon # " .. tostring(enemyPokemonID) .. " and Type " .. tostring(Battle.Active.GetPokemonType1(1, PokemonNr)))
			else
				print("Enemy is Pokemon # " .. tostring(enemyPokemonID) .. " and Type " .. tostring(Battle.Active.GetPokemonType1(1, PokemonNr)) .. " and " .. tostring(Battle.Active.GetPokemonType2(1, PokemonNr)))
			end
		end
	end

	-- Check if horde battle
	if Battle.GetBattleType() == "HORDE_BATTLE" then
		print("Enemys brought friends")
		if array_Activities_Behavior_Task[1] == "EXP-Training" and bool_Strategy_Fighting_FightAgainstHordes == true then
			if bool_Hidden_Setting_Debug == true then print("Fighting Horde") end
		else
			actionRunAway()
		end
	end

	--[[
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~Farming~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--]]

	if array_Activities_Behavior_Task[1] == "Farming" then

		-- Set initial states
		catchIt = false
		keepOnlyIfIV31 = false

		-- Decision making
		if arrayContains(pokemonArray_Pokemon_Catch_CatchAlways, enemyPokemonID) or bool_Pokemon_Catch_CatchAlways then
			print("Will catch enemy.")
			catchIt = true
			if arrayContains(pokemonArray_Pokemon_Catch_OnlyKeepIfIV, enemyPokemonID) or bool_Pokemon_Catch_OnlyKeepIfIV then
				print("But will release if no IV31.")
				keepOnlyIfIV31 = true
			end
		end

		-- Strategy
		if catchIt then
			actionSpecialAttack("catch")
			checkIfCaught(keepOnlyIfIV31)
		else
			actionRunAway()
		end

	--[[
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~EXP-Training~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--]]

	elseif array_Activities_Behavior_Task[1] == "EXP-Training" then
		actionFight()


	--[[
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~Pay~Day~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--]]
	elseif array_Activities_Behavior_Task[1] == "Pay Day" then
		actionSpecialAttack("payday", bool_Strategy_PayDayThief_SkipResistantEnemies)


	--[[
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~~Thief~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--]]
	elseif array_Activities_Behavior_Task[1] == "Thief" then
		actionSpecialAttack("thief", bool_Strategy_PayDayThief_SkipResistantEnemies)

	else
		MessageBox("Task not implemented.")
		stop()
	end
end


	




--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~M~A~I~N~~L~O~G~I~C~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]


function startTask()
	while true do
				
		while Trainer.IsInBattle() == false do
			walkingToDestination()
			behaviorAtDestination()
		end

		while Trainer.IsInBattle() do
			behaviorInBattle()
		end

	end
end