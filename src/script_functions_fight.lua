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
					attackInfos.Prio = attackInfos.Prio - 100
				end
			end
		end

		for pokemonType, attackTypes in pairs(notVeryEffectiveAgainst) do
			if arrayContains(enemyTypes, pokemonType) then
				if arrayContains(attackTypes, attackInfos.Type) then
					if bool_Hidden_Setting_Debug == true then print("Resistance for " .. pokemonType .. " found. Decreasing priority of " .. attackInfos.Name .. " by 10 points.") end
					attackInfos.Prio = attackInfos.Prio - 10
				end
			end
		end

		for pokemonType, attackTypes in pairs(veryEffectiveAgainst) do
			if arrayContains(enemyTypes, pokemonType) then
				if arrayContains(attackTypes, attackInfos.Type) then
					if bool_Hidden_Setting_Debug == true then print("Weakness for " .. pokemonType .. " found. Increasing priority of " .. attackInfos.Name .. " by 10 points.") end
					attackInfos.Prio = attackInfos.Prio + 10
				end
			end
		end

		if arrayContains(ownPokemonTypes, pokemonTypes[attackInfos.Type]) then
			if bool_Hidden_Setting_Debug == true then print("Same-type-attack-bonus for " .. pokemonTypes[attackInfos.Type] .. " found. Increasing priority of " .. attackInfos.Name .. " by 10 points.") end
			attackInfos.Prio = attackInfos.Prio + 10
		end

		for status, statusAttacks in pairs(attacksThatCauseEffects) do
			if arrayContains(statusAttacks, attackInfos.ID) then
				if bool_Hidden_Setting_Debug == true then print("Will cause " .. status .. ". Decreasing priority of " .. attackInfos.Name .. " by 80 points.") end
				attackInfos.Prio = attackInfos.Prio - 80
			end
		end

		if Battle.GetBattleType() == "SINGLE_BATTLE" then
			if arrayContains(attacksThatdamageGroups, attackInfos.ID) and bool_Strategy_Fighting_SaveUpMultiTargetMoves then
				attackInfos.Prio = attackInfos.Prio - 30
				if bool_Hidden_Setting_Debug == true then print("Should be saved for multiple enemies. Decreasing priority of " .. attackInfos.Name .. " by 30 points.") end
			end
		else
			if arrayContains(attacksThatdamageGroups, attackInfos.ID) then
				attackInfos.Prio = attackInfos.Prio + 30
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
function attackEnemy(ownPokemonAttacks, strategy, skippingResistantEnemies)

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
		availableAttacks = {206} -- False Swipe
		dontDefeat = true
	elseif strategy == "payday" then
		availableAttacks = {6} -- PayDay
	elseif strategy == "thief" then
		availableAttacks = {168} -- Thief
	elseif strategy == "group" then
		availableAttacks = attacksThatdamageGroups
	else
		strategy = "random"
	end

	-- Analyse hordes
	nextEnemyFound = false
	if Battle.GetBattleType() == "HORDE_BATTLE" then
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

	if bool_Hidden_Setting_Debug == true then print("Starting strategy: " .. strategy) end
	didAttack = false
	expiredPPAttacks = 0

	for attack, attackInfos in pairs(ownPokemonAttacks) do
		if didAttack == false and Trainer.IsInBattle() then
			if bool_Hidden_Setting_Debug == true then print("Priority Attack is Atrack #".. attack .. ", " .. attackInfos.Name .. " (ID " .. attackInfos.ID .. ")" .. " | " .. attackInfos.PP - 1 .. " PP left.") end
			if availableAttacks then

				if arrayContains(availableAttacks, attackInfos.ID) then

					if arrayContains(notEffectiveAgainst[Battle.Active.GetPokemonType1(1, nextEnemyTargetNumber)], attackInfos.Type) or arrayContains(notEffectiveAgainst[Battle.Active.GetPokemonType2(1, nextEnemyTargetNumber)], attackInfos.Type) then
					
						print("Enemy is immune against " .. attackInfos.Name .. " (" .. pokemonTypes[attackInfos.Type] .. ")")

					elseif arrayContains(notVeryEffectiveAgainst[Battle.Active.GetPokemonType1(1, nextEnemyTargetNumber)], attackInfos.Type) or arrayContains(notVeryEffectiveAgainst[Battle.Active.GetPokemonType2(1, nextEnemyTargetNumber)], attackInfos.Type) then
				
						if skippingResistantEnemies then
							print("Enemy is strong against " .. attackInfos.Name .. " (" .. pokemonTypes[attackInfos.Type] .. ")")
						end
	
					else

						if attackInfos.PP > 0 then

							isItMyTurnJet()
							print("Attacking with " .. attackInfos.Name .. " (" .. attackInfos.PP - 1 .. " PP left)")
							Battle.DoAction(0, 0, "SKILL", attackInfos.ID, nextEnemyTargetID)
							didAttack = true
						else
							print ("0 PP for strategy " .. strategy .. " left")
							if strategy == "sleep" and bool_Strategy_Catching_HealWhenSleepPPAreEmpty then
								actionRunHome()
							elseif strategy == "paralize" and bool_Strategy_Catching_HealWhenParalizePPAreEmpty then
								actionRunHome()
							elseif strategy == "weaken" and bool_Strategy_Catching_HealWhenFalseSwipePPAreEmpty then
								actionRunHome()
							elseif strategy == "payday" and bool_Strategy_PayDay_HealWhenPayDayPPAreEmpty then
								actionRunHome()
							elseif strategy == "thief" and bool_Strategy_Thief_HealWhenThiefPPAreEmpty then
								actionRunHome()
							end
						end

					end

				end
			else
				if attackInfos.PP > 0 then
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


	if expiredPPAttacks == tableLength(ownPokemonAttacks) and dontDefeat ~= true and Trainer.IsInBattle() then
		Battle.DoAction(0, 0, "SKILL", 165, nextEnemyTargetID)
		print("Struggle is real")
		didAttack = true
	end

	if didAttack == false and Trainer.IsInBattle() then
		-- block a unuseable strategy from being tried again
		table.insert(failedStrategies, strategy)
		print ("No attack for strategy " .. strategy .. " available. Will not try again this battle.")
		if bool_Hidden_Setting_Debug == true then print("Failed Strategies: " .. table_to_string(failedStrategies)) end
	end
end



-- Fight enemy
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


-- Function to catch enemy or use payday, thief, etc
function actionSpecialAttack(specialAttackStrategy, skippingResistantEnemies)

	print("Strategy: " .. specialAttackStrategy)
	failedStrategies = {} -- Reset for new battle

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

		-- Figure out next move
		availableAttacks = {}
		if specialAttackStrategy == "catch" then
			if bool_Strategy_Catching_Sleep and enemyStatus == 0 and arrayContains(failedStrategies, "sleep") == false then
				attackEnemy(ownPokemonAttacks, "sleep")
			elseif bool_Strategy_Catching_Paralize and enemyStatus == 0 and arrayContains(failedStrategies, "paralize") == false then
				attackEnemy(ownPokemonAttacks, "paralize")
			elseif bool_Strategy_Catching_FalseSwipe and enemyHealth >= int_Strategy_Catching_LeftOverHP and arrayContains(failedStrategies, "weaken") == false then
				attackEnemy(ownPokemonAttacks, "weaken")
			else
				actionThrowBall()
			end
		else
			if arrayContains(failedStrategies, specialAttackStrategy) == false then
				attackEnemy(ownPokemonAttacks, specialAttackStrategy, skippingResistantEnemies)
			else
				print("No PP for " .. specialAttackStrategy .. " left.")
				if specialAttackStrategy == "payday" and bool_Strategy_PayDayThief_HealWhenPayDayPPAreEmpty then
					actionRunHome()
				elseif specialAttackStrategy == "thief" and bool_Strategy_PayDayThief_HealWhenThiefPPAreEmpty then
					actionRunHome()
				end
			end
		end

		writeDatabase()
		isItMyTurnJet()

	end
end
