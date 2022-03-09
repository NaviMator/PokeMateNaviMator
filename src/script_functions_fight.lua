--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~F~I~G~H~T~I~N~G~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]

-- Fight analysis
function fightAnalysis()
	-- Current enemy values
	enemyStatus = Battle.Active.GetEffect(1,0)
	enemyHealth = Battle.Active.GetPokemonHealth(1, 0)
	enemyTypes = {Battle.Active.GetPokemonType1(1, 0), Battle.Active.GetPokemonType2(1, 0)}
	
	-- Current own values
	ownPokemonTypes = {Battle.Active.GetPokemonType1(0, 0), Battle.Active.GetPokemonType2(0, 0)}
	ownPokemonAttacks = {}
	for AttackNr = 0, 3 do
		if Battle.Moves.GetID(0, 0, AttackNr) ~= 0 then
			AttackNr = {
				["Position"] = AttackNr, -- Position in UI to use move
				["ID"] = Battle.Moves.GetID(0, 0, AttackNr),
				["Name"] = Battle.Moves.GetName(0, 0, AttackNr),
				["Type"] = Battle.Moves.GetAttackType(0, 0, AttackNr),
				["PP"] = Battle.Moves.GetPP(0, 0, AttackNr),
				["Prio"] = 100
			}
			table.insert(ownPokemonAttacks, AttackNr)
		end
	end
end

-- Prioritize moves
function prioritizeMoves()
	for attack, attackInfos in pairs(ownPokemonAttacks) do
		if bool_Hidden_Setting_Debug == true then print("Available move " .. attack .. ": " .. attackInfos.Name .. " (" .. attackInfos.ID .. ")") end

		for pokemonType, attackTypes in pairs(notEffectiveAgainst) do
			if arrayContains(enemyTypes, pokemonType) then
				if arrayContains(attackTypes, attackInfos.Type) then
					if bool_Hidden_Setting_Debug == true then print("Invincibility for " .. pokemonType .. " found. Decreasing priority of " .. attackInfos.Name .. " by 100 points.") end
					attackInfos.Prio = attackInfos.Prio - 200
				end
			end
		end

		for pokemonType, attackTypes in pairs(notVeryEffectiveAgainst) do
			if arrayContains(enemyTypes, pokemonType) then
				if arrayContains(attackTypes, attackInfos.Type) then
					if bool_Hidden_Setting_Debug == true then print("Resistance for " .. pokemonType .. " found. Decreasing priority of " .. attackInfos.Name .. " by 10 points.") end
					attackInfos.Prio = attackInfos.Prio - 20
				end
			end
		end

		for pokemonType, attackTypes in pairs(veryEffectiveAgainst) do
			if arrayContains(enemyTypes, pokemonType) then
				if arrayContains(attackTypes, attackInfos.Type) then
					if bool_Hidden_Setting_Debug == true then print("Weakness for " .. pokemonType .. " found. Increasing priority of " .. attackInfos.Name .. " by 10 points.") end
					attackInfos.Prio = attackInfos.Prio + 20
				end
			end
		end

		if arrayContains(ownPokemonTypes, pokemonTypes[attackInfos.Type]) then
			if bool_Hidden_Setting_Debug == true then print("Same-type-attack-bonus for " .. pokemonTypes[attackInfos.Type] .. " found. Increasing priority of " .. attackInfos.Name .. " by 10 points.") end
			attackInfos.Prio = attackInfos.Prio + 10
		end

		for effect, effectAttacks in pairs(attacksThatCauseEffects) do
			if arrayContains(effectAttacks, attackInfos.ID) then
				if bool_Hidden_Setting_Debug == true then print("Will cause " .. effect .. ". Decreasing priority of " .. attackInfos.Name .. " by 80 points.") end
				attackInfos.Prio = attackInfos.Prio - 80
			end
		end

		for status, statusAttacks in pairs(attacksThatCauseStatus) do
			if arrayContains(statusAttacks, attackInfos.ID) then
				if bool_Hidden_Setting_Debug == true then print("Will cause " .. status .. ". Decreasing priority of " .. attackInfos.Name .. " by 80 points.") end
				attackInfos.Prio = attackInfos.Prio - 80
			end
		end

		if Battle.GetBattleType() == "SINGLE_BATTLE" then
			if arrayContains(attacksThatdamageGroups, attackInfos.ID) and bool_Strategy_Fighting_SaveUpMultiTargetMoves then
				attackInfos.Prio = attackInfos.Prio - 40
				if bool_Hidden_Setting_Debug == true then print("Should be saved for multiple enemies. Decreasing priority of " .. attackInfos.Name .. " by 30 points.") end
			end
		else
			if arrayContains(attacksThatdamageGroups, attackInfos.ID) then
				attackInfos.Prio = attackInfos.Prio + 40
				if bool_Hidden_Setting_Debug == true then print("Will attack multiple enemies. Increasing priority of " .. attackInfos.Name .. " by 30 points.") end
			end
		end

		if bool_Hidden_Setting_Debug == true then print("Resulting priority of attack " .. attackInfos.Name .. " is " .. attackInfos.Prio .. ". Attack position is " .. attackInfos.Position) end

	end

	table.sort(ownPokemonAttacks, function(valueA, valueB)
		return valueA["Prio"] > valueB["Prio"]
	end)

end


-- Run away
function runFromBattle()
	print("Screw you.")
	triedToRun = 0
	while Trainer.IsInBattle() do

		isItMyTurnJet()
		randomWaitingTime()

		-- Swap if trapped or something is wrong (still not tested)
		if triedToRun >= 5 then
			print("Propably trapped. Trying to fight.")
			battle()
		end
		triedToRun = triedToRun + 1

		Battle.DoAction(0,0,"RUN",0,0)

		sleep(2500)

	end
end

-- Run away, heal and return
function runHome(runFromCurrentBattle)
	goHeal = true
	returnAfterHealing = true
	if runFromCurrentBattle == true then
		print("Going to heal and return.")
		runFromBattle()
	else
		print("Going to heal and return (after this battle).")
	end
end


-- Throw ball
function throwBall()

	isItMyTurnJet()
	randomWaitingTime()
	readDatabase()

	if int_Item_Current_Pokeball > 0 then
		Battle.DoItemInteraction(0,0,"ITEM",5004,0,-1)
		int_Item_Current_Pokeball = int_Item_Current_Pokeball -1
		print("Go Pokeball! (" .. int_Item_Current_Pokeball .. " left)")
	elseif int_Item_Current_Greatball > 0 then
		Battle.DoItemInteraction(0,0,"ITEM",5003,0,-1)
		int_Item_Current_Greatball = int_Item_Current_Greatball -1
		print("Go Greatball! (" .. int_Item_Current_Greatball .. " left)")
	elseif int_Item_Current_Ultraball > 0 then
		Battle.DoItemInteraction(0,0,"ITEM",5002,0,-1)
		int_Item_Current_Ultraball = int_Item_Current_Ultraball -1
		print("Go Ultraball! (" .. int_Item_Current_Ultraball .. " left)")
	elseif int_Item_Current_Masterball > 0 then
		Battle.DoItemInteraction(0,0,"ITEM",5001,0,-1)
		int_Item_Current_Masterball = int_Item_Current_Masterball -1
		print("Go Masterball! (" .. int_Item_Current_Masterball .. " left)")
	else
		print("No more balls left. Will go regenerate and Stop.")
		goHeal = true
		returnAfterHealing = false
		runFromBattle()
	end
	writeDatabase()
end


-- Use move on enemy
function attackEnemy(ownPokemonAttacks, forceAttack, attackName, skipResistant)

	isItMyTurnJet()
	randomWaitingTime()

	-- Aim next enemy
	if Battle.GetBattleType() == "HORDE_BATTLE" then
		nextEnemyFound = false
		for PokemonNr = 0, Battle.GetFightingTeamSize(1)-1 do
			-- Note: tostring(Battle.GetFightingTeamSize(1)) -- Function always returns 1 or 5
			if Battle.Active.IsValidPokemon(1, PokemonNr) == true and nextEnemyFound == false then
				nextEnemyTargetNumber = PokemonNr
				nextEnemyTargetID = PokemonNr * 16 + 1 -- This equals the ID of the place for some reason (1, 17, 33, 49, 65)
				nextEnemyFound = true
				if bool_Hidden_Setting_Debug == true then print("Next target is Enemy on Seat " .. nextEnemyTargetNumber + 1 .. " (Target #" .. nextEnemyTargetID .. ").") end
			end
		end
	else
		nextEnemyTargetNumber = 0
		nextEnemyTargetID = 1
	end

	-- Loop own attacks and use forced or best one available
	didAttack = false
	expiredPPAttacks = 0
	
	if bool_Hidden_Setting_Debug == true then print("Attacking to " .. attackName) end
	for attack, attackInfos in pairs(ownPokemonAttacks) do -- Loop through available attacks
		if didAttack == false and Trainer.IsInBattle() then -- Continue loop if no attack has been done
			if forceAttack ~= false then -- Check if attack is forced
				if arrayContains(forceAttack, attackInfos.ID) then -- Check if attack matches strategy
					-- Skip attack if enemy is immune or resistant (optional)
					if arrayContains(notEffectiveAgainst[Battle.Active.GetPokemonType1(1, nextEnemyTargetNumber)], attackInfos.Type) or arrayContains(notEffectiveAgainst[Battle.Active.GetPokemonType2(1, nextEnemyTargetNumber)], attackInfos.Type) then
						print("Enemy is immune against " .. attackInfos.Name .. " (" .. pokemonTypes[attackInfos.Type] .. ")")
					elseif skipResistant == true then
						if arrayContains(notVeryEffectiveAgainst[Battle.Active.GetPokemonType1(1, nextEnemyTargetNumber)], attackInfos.Type) or arrayContains(notVeryEffectiveAgainst[Battle.Active.GetPokemonType2(1, nextEnemyTargetNumber)], attackInfos.Type) then
							print("Enemy is resistant against " .. attackInfos.Name .. " (" .. pokemonTypes[attackInfos.Type] .. ")")
							runFromBattle()
						end
					else
						-- Use attack if PP are left
						if attackInfos.PP > 0 then
							print("Attacking with " .. attackInfos.Name .. " (" .. attackInfos.PP - 1 .. " PP left)")
							Battle.DoAction(0, 0, "SKILL", attackInfos.ID, nextEnemyTargetID)
							if attackInfos.PP > 1 then -- Ensures heal after last PP usage 
								didAttack = true
							else
								print("0 PP for " .. attackInfos.Name .. " left")
							end
						else
							print("0 PP for " .. attackInfos.Name .. " left")
						end
					end
				end
			else
				if bool_Hidden_Setting_Debug == true then print(attack .. ". priority attack is: " .. attackInfos.Name .. " (ID " .. attackInfos.ID .. ")" .. " | " .. attackInfos.PP .. " PP left.") end
				if attackInfos.PP > 0 then -- Use attack with highest priority if PP are left
					print("Attacking with " .. attackInfos.Name .. " (" .. attackInfos.PP - 1 .. " PP left)")
					Battle.DoAction(0, 0, "SKILL", attackInfos.ID, nextEnemyTargetID)
					didAttack = true
				else
					print("0 PP for " .. attackInfos.Name .. " left")
					expiredPPAttacks = expiredPPAttacks + 1
				end

			end

		end
	end
	
	-- Use struggle if no PP are left
	if expiredPPAttacks == tableLength(ownPokemonAttacks) and strategy ~= "catch" and Trainer.IsInBattle() then
		isItMyTurnJet()
		print("Struggle is real.")
		Battle.DoAction(0, 0, "SKILL", 165, nextEnemyTargetID)
		didAttack = true
	end

	-- Block a unuseable attack from being tried again
	if didAttack == false and Trainer.IsInBattle() then
		table.insert(unuseableAttacks, attackName)
		print ("Attack to " .. attackName .. " not useable. Will not try again this battle.")

		-- Regenerate if forced strategies fail
		if attackName == "sleep" and bool_Strategy_Catching_HealWhenSleepPPAreEmpty then
			runHome(false)
		elseif attackName == "paralize" and bool_Strategy_Catching_HealWhenParalizePPAreEmpty then
			runHome(false)
		elseif attackName == "weaken" and bool_Strategy_Catching_HealWhenFalseSwipePPAreEmpty then
			runHome(false)
		elseif attackName == "payday" and bool_Strategy_PayDayThief_HealWhenPayDayPPAreEmpty then
			runHome(true)
		elseif attackName == "thief" and bool_Strategy_PayDayThief_HealWhenThiefPPAreEmpty then
			runHome(true)
		else
			print("Unknown Error: PP left, but nothing to fight with. Better run.")
			runHome(true)
		end

		if bool_Hidden_Setting_Debug == true then print("Failed Attacks: " .. table_to_string(unuseableAttacks)) end
	end

	isItMyTurnJet()

end



-- Function to chose how to battle
function battle(strategy)

	unuseableAttacks = {} -- Reset for new battle
	strategy = strategy or "defeat"
	skipResistant = false

	print("Strategy wanted: " .. strategy)

	while Trainer.IsInBattle() do

		isItMyTurnJet()
		randomWaitingTime()
		readDatabase()

		fightAnalysis()

		forceAttack = {}

		-- Figure out next move
		if strategy == "catch" then
			if arrayContains(pokemonToCatchFirstTurn, Battle.Active.GetPokemonID(1, 0)) == false then
				if bool_Strategy_Catching_Sleep and enemyStatus == 0 and arrayContains(unuseableAttacks, "sleep") == false then
					forceAttack = attacksThatCauseEffects["Sleep"]
					attackName = "sleep"
				elseif bool_Strategy_Catching_Paralize and enemyStatus == 0 and arrayContains(unuseableAttacks, "paralize") == false then
					forceAttack = attacksThatCauseEffects["Paralize"]
					attackName = "paralize"
				elseif bool_Strategy_Catching_FalseSwipe and enemyHealth >= int_Strategy_Catching_LeftOverHP and arrayContains(unuseableAttacks, "weaken") == false then
					forceAttack = {206} -- False Swipe
					attackName = "weaken"
				else
					attackName = "throwBall"
				end
			else
				print("Pokemon ID " .. Battle.Active.GetPokemonID(1, 0) .. " should be immediately.")
				attackName = "throwBall"
			end
		else
			attackName = strategy
			if strategy == "payday" then
				forceAttack = {6} -- PayDay
				skipResistant = bool_Strategy_PayDayThief_SkipResistantEnemies
			elseif strategy == "thief" then
				forceAttack = {168} -- Thief
				skipResistant = bool_Strategy_PayDayThief_SkipResistantEnemies
			else
				prioritizeMoves()
				forceAttack = false
			end
		end

		if attackName == "throwBall" then
			throwBall()
		else
			attackEnemy(ownPokemonAttacks, forceAttack, attackName, skipResistant)
		end
		writeDatabase()
		isItMyTurnJet()

	end
end

