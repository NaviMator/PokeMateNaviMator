--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~I~N~T~E~R~A~C~T~I~N~G~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]

-- Wait random time
function randomWaitingTime()
	sleep(random(int_Setting_WaitingTime_Min,int_Setting_WaitingTime_Max))
end
function sleepRandom(time)
	sleep(time)
	randomWaitingTime()
end


-- Position code
function getPositionCode()
	positionCode = Trainer.GetMapID().."-"..Trainer.GetX().."-"..Trainer.GetY()
	if bool_Hidden_Setting_Debug == true then print("Position-Code: " .. positionCode) end
	return positionCode
end



-- Wait to attack
function isItMyTurnJet()

	-- print("Waiting...")
	countLoop = 0
	while(not Battle.CanAttack()) do
		if countLoop >= 40 then
			print("Still waiting...")
			countLoop = 0
		end
		sleep(250)
		countLoop = countLoop + 1
		if Trainer.IsInBattle() == false then
			break
		end
		if Battle.Active.GetPokemonHealth(0, 0) <= 0 then
			if Battle.IsTrainerSwapping(0) then
				randomWaitingTime()
				sleep(1500)
				print("Pokemon defeated. Swapping to next pokemon.")
				pokemonSwap(0)
				sleep(5000)
			end
		end
		levelUpControl()
	end

	randomWaitingTime()
end


-- Swap pokemon
function pokemonSwap(swapToPokemon)

	swapToPokemon = swapToPokemon or 0
	pokemonSwapped = false
	
	for PokemonSwapNr = swapToPokemon, 5 do
		if Battle.Bench.GetPokemonHealth(0, PokemonSwapNr) > 0 and pokemonSwapped ~= true then
			sleepRandom(500)
			print("I chose you #" .. PokemonSwapNr + 1)
			Battle.DoAction(0,0,"SWAP",PokemonSwapNr,0)
			sleepRandom(500)
			Battle.DoAction(0,0,"SWAP",PokemonSwapNr,0) -- Has to be fired again to work
			pokemonSwapped = true
			sleepRandom(500)
		end
	end
	isItMyTurnJet()
	--checkIfLostAtPokeCenter()

end

-- Learn new move and evolve (or not)
function levelUpControl()
	if Battle.IsInMovetutor() == true then
		readDatabase()
		if array_Strategy_Training_LearnNewMoves[1] == "Replace first" then
			KeyTyped("A")
			sleep(1000)
			KeyTyped("A")
			sleepRandom(4000)
		elseif array_Strategy_Training_LearnNewMoves[1] == "Skip" then
			KeyTyped("B")
			sleep(1000)
			KeyTyped("A")
			sleepRandom(1000)
		elseif array_Strategy_Training_LearnNewMoves[1] == "Stop bot" then
			MessageBox("Switching to manual to decide a move.")
			stop()
		end
			--elseif Battle.IsInEvolution() == true then -- Not supported at the moment
			--	readDatabase() -- Read Database
			--	if bool_Strategy_Training_SkipEvolve == true then
			--		print("Skipping evolution.")
			--		while Battle.IsInEvolution() == true do
			--			sleep(500)
			--			KeyTyped("B")
			--		end
			--	end
	end
end


-- Check if player got interrupted by a fight while walking and react to fight
function checkInterruption()
	while Trainer.IsInBattle() do
		sleep(150)
		print("Interrupted. Will continue path after battle.")
		battlePilotDecision()
		sleep(200)
	end
end


-- Use sweet scent
function useSweetScent()

	readDatabase() -- Read Database
	
	if int_PP_Current_SweetScent >= 5 then -- Check if PP are left
		print("Go sweet scent!") -- Note the user
		KeyTyped("H"..int_Setting_HotkeyFM_SweetScent) -- Use Sweet Scent
		int_PP_Current_SweetScent = int_PP_Current_SweetScent - 5 -- Substract used ammount from variable
		writeDatabase() -- write variable to database
		sleep(5000)
	else
		print("No more sweet scent PP left. Goint to heal.")
		goHeal = true
		returnAfterHealing = true
	end

end

-- Go fishing
function fishing()
	readDatabase()
	print ("Throwing bait")
	while Trainer.IsInBattle() == false do
		if array_Activities_Behavior_RodToUse[1] == "Old Rod" then
			KeyTyped("H"..int_Setting_Hotkey_OldRod)
		elseif array_Activities_Behavior_RodToUse[1] == "Good Rod" then
			KeyTyped("H"..int_Setting_Hotkey_GoodRod)
		elseif array_Activities_Behavior_RodToUse[1] == "Super Rod" then
			KeyTyped("H"..int_Setting_Hotkey_SuperRod)
		end
		sleep(2000)
		randomWaitingTime()
		KeyTyped("A")
	end
	sleep(3000)
	KeyTyped("A")
end

-- Check IV and release pokemon if unwanted
function keepIf31(keepOnlyIfIV31, newestPokemon)

	newestPokemonIVs = {}
	for newestPokemonIV = 0, 5 do
		newestPokemonIVs[newestPokemonIV + 1] = PC.GetPokemonIVs(newestPokemon, newestPokemonIV)
	end
	print("Caught Pokemon IVs: " .. table_to_string(newestPokemonIVs))
	if arrayContains(newestPokemonIVs, 31) then
		print("Nice, IV31.")
		KeyTyped("RIGHT")
		sleep(200)
		KeyTyped("RIGHT")
		sleep(200)
		KeyTyped("RIGHT")
		sleep(5000)
		KeyTyped("B")
	else
		print("Crap, no IV31.")
		if keepOnlyIfIV31 == true then
			print("Releasing.")
			KeyTyped("LEFT")
			sleep(200)
			KeyTyped("DOWN")
			sleep(200)
			KeyTyped("A")
			sleep(200)
			KeyTyped("UP")
			sleep(200)
			KeyTyped("A")
		else
			KeyTyped("B")
		end
	end
end

-- Check if pokemon got caught
function checkIfCaught(keepOnlyIfIV31)

	newestPokemon = PC.GetLastCaughtPokemon()
	newestPokemonID = PC.GetPokemonUID(newestPokemon)

	if newestPokemonID == -1 or newestPokemonID == int_Hidden_Setting_LastPokemonCaught then
		print("No pokemon caught.")
	else
		print("Good Catch. Everybody clap. Roll on snare drum. Curtains.")
		int_Hidden_Setting_LastPokemonCaught = newestPokemonID
		writeDatabase()
		keepIf31(keepOnlyIfIV31, newestPokemon)
	end
end