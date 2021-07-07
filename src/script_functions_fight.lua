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
		--print("Available move " .. attack .. ": " .. attackInfos.Name .. " (" .. attackInfos.ID .. ")")

		for pokemonType, attackTypes in pairs(notEffectiveAgainst) do
			if arrayContains(enemyTypes, pokemonType) then
				if arrayContains(attackTypes, attackInfos.Type) then
					--print("Invincibility for " .. pokemonType .. " found. Decreasing priority of " .. attackInfos.Name .. " by 100 points.")
					attackInfos.Prio = attackInfos.Prio - 100
				end
			end
		end

		for pokemonType, attackTypes in pairs(notVeryEffectiveAgainst) do
			if arrayContains(enemyTypes, pokemonType) then
				if arrayContains(attackTypes, attackInfos.Type) then
					--print("Resistance for " .. pokemonType .. " found. Decreasing priority of " .. attackInfos.Name .. " by 10 points.")
					attackInfos.Prio = attackInfos.Prio - 10
				end
			end
		end

		for pokemonType, attackTypes in pairs(veryEffectiveAgainst) do
			if arrayContains(enemyTypes, pokemonType) then
				if arrayContains(attackTypes, attackInfos.Type) then
					--print("Weakness for " .. pokemonType .. " found. Increasing priority of " .. attackInfos.Name .. " by 10 points.")
					attackInfos.Prio = attackInfos.Prio + 10
				end
			end
		end

		if arrayContains(ownPokemonTypes, pokemonTypes[attackInfos.Type]) then
			--print("Same-type-attack-bonus for " .. pokemonTypes[attackInfos.Type] .. " found. Increasing priority of " .. attackInfos.Name .. " by 10 points.")
			attackInfos.Prio = attackInfos.Prio + 10
		end

		for status, statusAttacks in pairs(attacksThatCauseEffects) do
			if arrayContains(statusAttacks, attackInfos.ID) then
				--print("Will cause " .. status .. ". Decreasing priority of " .. attackInfos.Name .. " by 80 points.")
				attackInfos.Prio = attackInfos.Prio - 80
			end
		end

		if Battle.GetBattleType() == "SINGLE_BATTLE" then
			if arrayContains(attacksThatdamageGroups, attackInfos.ID) and bool_Strategy_Fighting_SaveUpMultiTargetMoves then
				attackInfos.Prio = attackInfos.Prio - 30
				--print("Should be saved for multiple enemies. Decreasing priority of " .. attackInfos.Name .. " by 30 points.")
			end
		else
			if arrayContains(attacksThatdamageGroups, attackInfos.ID) then
				attackInfos.Prio = attackInfos.Prio + 30
				--print("Will attack multiple enemies. Increasing priority of " .. attackInfos.Name .. " by 30 points.")
			end
		end

		--print("Resulting priority of attack " .. attackInfos.Name .. " is " .. attackInfos.Prio .. ". Attack position is " .. attackInfos.Position)

	end

	table.sort(ownPokemonAttacks, function(valueA, valueB)
		return valueA["Prio"] > valueB["Prio"]
	end)

end


-- Run away
function actionRunAway()
	print("Screw you.")
	triedToRun = 0
	while Trainer.IsInBattle() do

		isItMyTurnJet()
		randomWaitingTime()

		-- Swap if trapped or something is wrong
		if triedToRun >= 2 then
			MessageBox("Propably trapped. Fight manually.") -- Temporary function. Should start to fight.
			break
		end
		triedToRun = triedToRun + 1

		Battle.DoAction(0,0,"RUN",0,0)

		sleep(2500)

	end
end

-- Run away, heal and return
function actionRunHome()
	print("Going to heal and return")
	goHeal = true
	returnAfterHealing = true
	actionRunAway()
end


-- Throw ball
function actionThrowBall()

	isItMyTurnJet()
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
		print("No more balls.")
		goHeal = true
		returnAfterHealing = false
		actionRunAway()
	end
	writeDatabase()

end


-- Use move on enemy
function attackEnemy(ownPokemonAttacks, strategy)

	isItMyTurnJet()
	randomWaitingTime()

	-- Look for possible attacks
	if strategy == "sleep" then
		availableAttacks = attacksThatCauseEffects["Sleep"]
		dontDefeat = true
	elseif strategy == "paralize" then
		availableAttacks = attacksThatCauseEffects["Paralize"]
		dontDefeat = true
	elseif strategy == "weaken" then
		availableAttacks = attacksThatCauseEffects["Weaken"]
		dontDefeat = true
	elseif strategy == "group" then
		availableAttacks = attacksThatdamageGroups
	else
		strategy = "random"
	end

	-- Analyse hordes
	if Battle.GetBattleType() == "HORDE_BATTLE" then
		for PokemonNr = 0, Battle.GetFightingTeamSize(1)-1 do
			-- Note: tostring(Battle.GetFightingTeamSize(1)) -- Function always returns 1 or 5
			if Battle.Active.IsValidPokemon(1, PokemonNr) == true then
				if PokemonNr == 0 then enemyTargetNumber = 1
				elseif PokemonNr == 1 then enemyTargetNumber = 17
				elseif PokemonNr == 2 then enemyTargetNumber = 33
				elseif PokemonNr == 3 then enemyTargetNumber = 49
				elseif PokemonNr == 4 then enemyTargetNumber = 65
				end
				--print("Next target is Enemy #" .. PokemonNr .. " (Target #" .. enemyTargetNumber .. ").")
			end
		end
	else
		enemyTargetNumber = 0
	end

	--print("Starting strategy: " .. strategy);
	didAttack = false
	expiredPPAttacks = 0
	for attack, attackInfos in pairs(ownPokemonAttacks) do
		--print("Attack #".. attack .. " is: " .. attackInfos.Name .. " (ID " .. attackInfos.ID .. ") " .. " | " .. attackInfos.PP - 1 .. " PP left.")
		if didAttack == false and Trainer.IsInBattle() then
			if availableAttacks then
				if arrayContains(availableAttacks, attackInfos.ID) then
					if attackInfos.PP > 0 then
						isItMyTurnJet()
						print("Attacking with " .. attackInfos.Name .. " (" .. attackInfos.PP - 1 .. " PP left)")
						Battle.DoAction(0, 0, "SKILL", attackInfos.ID, enemyTargetNumber)
						didAttack = true
					else
						print ("0 PP for strategy " .. strategy .. " left")
						if strategy == "sleep" and bool_Strategy_Catching_HealWhenSleepPPAreEmpty then
							actionRunHome()
						elseif strategy == "paralize" and bool_Strategy_Catching_HealWhenParalizePPAreEmpty then
							actionRunHome()
						elseif strategy == "weaken" and bool_Strategy_Catching_HealWhenFalseSwipePPAreEmpty then
							actionRunHome()
						end
					end
				end
			else
				if attackInfos.PP > 0 then
					print("Attacking with " .. attackInfos.Name .. " (" .. attackInfos.PP - 1 .. " PP left)")
					Battle.DoAction(0, 0, "SKILL", attackInfos.ID, enemyTargetNumber)
					didAttack = true
				else
					print("0 PP for " .. attackInfos.Name .. " left")
					expiredPPAttacks = expiredPPAttacks + 1
				end
			end
		end
	end


	if expiredPPAttacks == tableLength(ownPokemonAttacks) and dontDefeat ~= true and Trainer.IsInBattle() then
		Battle.DoAction(0, 0, "SKILL", 165, enemyTargetNumber)
		print("Struggle is real")
		didAttack = true
	end

	if didAttack == false and Trainer.IsInBattle() then
		-- block a unuseable strategy from being tried again
		table.insert(failedStrategies, strategy)
		print ("No attack for strategy " .. strategy .. " available. Will not try again this battle.")
		-- print("Failed Strategies: " .. table_to_string(failedStrategies))
	end
end




-- Catch enemy
function actionCatchEnemy()

	print("Trying to catch.")
	-- Reset for new battle
	failedStrategies = {}

	while Trainer.IsInBattle() do

		isItMyTurnJet()
		randomWaitingTime()
		readDatabase()
		
		-- Run away and walk home if I die
		if Battle.Active.GetPokemonHealth(0, 0) <= 0 then
			print("Died in battle :(")
			pokemonSwap(0)
			goHeal = true
			returnAfterHealing = true
			actionRunHome()
		end

		fightAnalysis()

		-- Experiment against bot detection
		KeyTyped("B")
		randomWaitingTime()
		KeyTyped("A")

		-- Figure out next move
		availableAttacks = {}
		if bool_Strategy_Catching_Sleep and enemyStatus == 0 and arrayContains(failedStrategies, "sleep") == false then
			attackEnemy(ownPokemonAttacks, "sleep")
		elseif bool_Strategy_Catching_Paralize and enemyStatus == 0 and arrayContains(failedStrategies, "paralize") == false then
			attackEnemy(ownPokemonAttacks, "paralize")
		elseif bool_Strategy_Catching_FalseSwipe and enemyHealth >= int_Strategy_Catching_LeftOverHP and arrayContains(enemyTypes,"GHOST") == false and arrayContains(failedStrategies, "weaken") == false then
			attackEnemy(ownPokemonAttacks, "weaken")
		else
			actionThrowBall()
		end

		writeDatabase()
		isItMyTurnJet()

	end
end

-- Fight  enemy
function actionFight()

	print("Trying to defeat.")

	while Trainer.IsInBattle() do
		isItMyTurnJet()
		randomWaitingTime()
		readDatabase()
		
		fightAnalysis()
		prioritizeMoves()

		attackEnemy(ownPokemonAttacks)

		writeDatabase()
		isItMyTurnJet()
	end

end