--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~Walking~to~destination~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]
	
function walkingToDestination()

	readDatabase()
	
	if array_Activities_Basic_Mode[1] == "Record" then
		if bool_Hidden_Setting_Debug == true then print("Recording mode is on. Will not try to walk.") end
	elseif array_Activities_Basic_Mode[1] == "Playthrough" then
		playthrough(array_Activities_Playthrough_Chapter[1])
	elseif array_Activities_Basic_Mode[1] == "Walk routes" then
		if goHeal == true then
			print("Highway to heal.")
			routes(array_Activities_Routes_Route[1], true)
			regenerate()
			if bool_Activities_Routes_Repeat == false then
				MessageBox("Job done.")
				stop()
			elseif returnAfterHealing ~= false then
				initialWalkDone = false
			else
				stop()
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
	if array_Activities_Basic_Mode[1] == "Record" then
		record()
	elseif bool_Activities_Routes_HealWhenFirstPokemonIsDefeated and Party.GetPokemonHealth(0, 0) <= 0 then
		print("Teamleader is defeated.")
		runHome()
	elseif array_Activities_Behavior_MovementAtDestination[1] == "Move (left/right)" then
		runningAround("horizontally")
	elseif array_Activities_Behavior_MovementAtDestination[1] == "Move (up/down)" then
		runningAround("vertically")
	elseif array_Activities_Behavior_MovementAtDestination[1] == "Fishing" then
		fishing()
	elseif array_Activities_Behavior_MovementAtDestination[1] == "Sweet Scent" then
		useSweetScent()
	elseif array_Activities_Behavior_MovementAtDestination[1] == "Walk back" then
		runHome()
	elseif array_Activities_Behavior_MovementAtDestination[1] == "Do nothing" then
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
	mapOnBattleEntry = getPositionCode()
	shiny = false

	-- Check for shiny
	for PokemonNr = 0, Battle.GetFightingTeamSize(1)-1 do
		if Battle.Bench.IsShiny(1, PokemonNr) then

			print("ENEMY (Slot ".. PokemonNr+1 ..") IS SERIOUSLY SHINY!!!")

			if Battle.GetBattleType() == "HORDE_BATTLE" then
				-- Unsure if picking from horde is safe enough
				Alert(true)
				stop()
				MessageBox("SHINY IN HORDE!!!")
				stop()
			elseif array_Strategy_Catching_ShinyBehaviour[1] == "Alert and stop bot" then 
				Alert(true)
				stop()
				MessageBox("SHINY!!!")
				stop()
			elseif array_Strategy_Catching_ShinyBehaviour[1] == "Throw Masterball" and int_Item_Current_Masterball > 0 then
				-- To do. Untested Alpha.
				while Trainer.IsInBattle() do
					throwBall("masterball")
				end
			else
				shiny = true
			end
		end
	end

	-- Analyse enemy
	for PokemonNr = 0, Battle.GetFightingTeamSize(1)-1 do
		enemyPokemonID = Battle.Active.GetPokemonID(1, PokemonNr)
		if enemyPokemonID > 0 then
			if Battle.Active.GetPokemonType1(1, 0) == Battle.Active.GetPokemonType2(1, 0) then
				print("Enemy is Pokemon #" .. tostring(enemyPokemonID) .. " and Type " .. tostring(Battle.Active.GetPokemonType1(1, PokemonNr)))
			else
				print("Enemy is Pokemon #" .. tostring(enemyPokemonID) .. " and Type " .. tostring(Battle.Active.GetPokemonType1(1, PokemonNr)) .. " and " .. tostring(Battle.Active.GetPokemonType2(1, PokemonNr)))
			end
		end
	end

	-- Check if horde battle for training
	if Battle.GetBattleType() == "HORDE_BATTLE" then
		print("Enemys brought friends")
		if array_Activities_Behavior_TaskInBattle[1] == "EXP-Training" or array_Activities_Behavior_TaskInBattle[1] == "EV-Training" then
			if bool_Strategy_Fighting_FightAgainstHordes == true then
				if bool_Hidden_Setting_Debug == true then print("Fighting Horde") end
				battle()
			else
				runFromBattle()
			end
		else
			runFromBattle()
		end
	end



	--[[
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~Farming~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--]]

	if array_Activities_Behavior_TaskInBattle[1] == "Farming" then

		-- Set initial states
		catchIt = false
		keepOnlyIfIV31 = false

		-- Decision making
		if arrayContains(pokemonArray_Pokemon_Catch_CatchAlways, Battle.Active.GetPokemonID(1, 0)) or bool_Pokemon_Catch_CatchAlways then
			print("Will catch enemy.")
			catchIt = true
			if arrayContains(pokemonArray_Pokemon_Catch_OnlyKeepIfIV, Battle.Active.GetPokemonID(1, 0)) or bool_Pokemon_Catch_OnlyKeepIfIV then
				print("But will release if no IV31.")
				keepOnlyIfIV31 = true
			end
		end

		if shiny == true then
			catchIt = true
			keepOnlyIfIV31 = false
		end

		-- Strategy
		if catchIt then
			battle("catch")
			if bool_Hidden_Setting_Debug == true then print("Battle ended.") end
			checkIfCaught(keepOnlyIfIV31)
		else
			if bool_Strategy_Catching_FightIfUnwanted == true then
				print ("Won't catch but fight instead of run")
				battle() -- To do: decide between ev- and exp-training
			else
				runFromBattle()
			end
		end

	--[[
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~EV-Training~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--]]

	elseif array_Activities_Behavior_TaskInBattle[1] == "EV-Training" then
		battle("evtraining")


	--[[
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~EXP-Training~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--]]

	elseif array_Activities_Behavior_TaskInBattle[1] == "EXP-Training" then
		battle("training")


	--[[
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~Pay~Day~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--]]
	elseif array_Activities_Behavior_TaskInBattle[1] == "Pay Day" then
		battle("payday")


	--[[
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~~Thief~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--]]
	elseif array_Activities_Behavior_TaskInBattle[1] == "Thief" then
		battle("thief")

	else
		MessageBox("Task not implemented.")
		stop()
	end

	checkIfLostAtPokeCenter()

end


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~Autopilot~Decision~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]
	

function battlePilotDecision()
	print("Enemy spotted.")
	readDatabase()

	if array_Activities_Basic_Mode[1] == "Record" then
		if bool_Rec_Settings_FightAutomatically == false then
			print("Waiting for player to finish fight.")
			while Trainer.IsInBattle() == true do
				sleep(1000)
			end
		else
			print("Automatic battle engaged.")
			if Battle.IsWildEncounter() == true then
				behaviorInBattle()
			else
				print("Trainer battle detected. Won't try to fatch.")
				battle()
			end
		end
	else
		if Battle.IsWildEncounter() == true then
			behaviorInBattle()
		else
			print("Trainer battle detected. Won't try to fatch.")
			battle()
		end
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
			battlePilotDecision()
		end

	end
end