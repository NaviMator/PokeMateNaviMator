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
function getPositionCode(getInfo)
	positionCode = Trainer.GetMapID().."-"..Trainer.GetX().."-"..Trainer.GetY()
	if bool_Hidden_Setting_Debug == true and getInfo == true then print("Position-Code: " .. positionCode) end
	return positionCode
end


-- Use Hotkey
function useHotkey(hotkey, command)
	if hotkey > 0 then
		KeyTyped("H"..hotkey)
	else
		MessageBox("Hotkey "..command.." not set. Please set and start again.")
		stop()
	end
end

-- Wait to attack
function isItMyTurnJet()

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
	elseif Battle.IsInEvolution() == true then
		readDatabase()
		if bool_Strategy_Training_SkipEvolve == true then
			print("Skipping evolution.")
			while Battle.IsInEvolution() == true do
				sleep(500)
				KeyTyped("B")
			end
		end
	end
end


-- Check if player got interrupted and react
function checkInterruption()

  while Trainer.IsInLoadingZone() or Trainer.IsInBattle() or Trainer.IsInDialog() do
    print("Interrupted.")

    if Trainer.IsInLoadingZone() then
      array_Hidden_Record_CurrentState[1] = "Loading"
      writeDatabase()
      while Trainer.IsInLoadingZone() and Trainer.IsInBattle() == false and Trainer.IsInDialog() == false do
        pingLoadingZone = true
        sleepRandom(500)
      end
    end

    if Trainer.IsInBattle() then
      print("Battle detected.")
      array_Hidden_Record_CurrentState[1] = "In battle"
      writeDatabase()
      battlePilotDecision()
      sleepRandom(400)
    end

    if Trainer.IsInDialog() then
      print("Dialog detected.")
      array_Hidden_Record_CurrentState[1] = "In dialog"
      writeDatabase()
      
      --if array_Activities_Basic_Mode[1] == "Record" and bool_Rec_Settings_TalkAutomatically then
        while Trainer.IsInDialog() do
          if bool_Hidden_Setting_Debug then print("Dialog Type: " .. Trainer.GetDialogType()) end
          if Trainer.GetDialogType() == "MSG_YESNO" then
            KeyTyped("A")
            --MSG_YESNO = "Dialog that wants to hear yes"
          elseif Trainer.GetDialogType() == "MSG_YESNO" then
            KeyTyped("A")
            --MULTICHOICE = "Use computer (and propably more)"
          elseif Trainer.GetDialogType() == "STARTER_SELECT_DIALOG" then
            -- UNTESTED
            -- STARTER_SELECT_DIALOG = "Box to chose Starter MAYBE?"
            if array_Activities_Playthrough_Starter[1] == 'Grass' then
              KeyTyped("A")
            elseif array_Activities_Playthrough_Starter[1] == 'Fire' then
              KeyTyped("Down")
              KeyTyped("A")
            elseif array_Activities_Playthrough_Starter[1] == 'Water' then
              KeyTyped("Down")
              KeyTyped("Down")
              KeyTyped("A")
            end


          else
            KeyTyped("B")
            -- MSG_FACEPLAYER = "Detected by trainer-NPC"
            -- MSG_LOCK = "Spoke to trainer-NPC"
            -- MSG_NOCLOSE = "Spoke to NPC"
            -- CLIENT_ONLY = "Spoke to NPC that wants to be skipped"
            -- MSG_SIGN = "Spoke to sign or collected item"

            -- UNKNOWN
            --MSG_OBTAIN
            --MSG_FIND
            --MSG_ITEM
            --MSG_NAV_TOOL
            --MSG_SELECT_PARTY_MONSTER
            --BUY_COINS
            --VENDING_MACHINE
            --MOVE_TUTOR
            --MAP_SELECTOR
            --ITEM_SELECTION
            --BRAILLE
            --REQUEST_BATTLE
            --REQUEST_FRIEND
            --REQUEST_TRADE
            --REQUEST_LINK
            --REQUEST_GUILD_INVITE
            --MSG_SELECT_DAYCARE_MONSTER
            --MSG_BREED_DIALOG
            --MSG_SELECT_MONSTER_SKILL
            --BERRY_PLANTING_DIALOG
            --BERRY_BLEND_DIALOG
            --COINS_SHOP_MONSTERS
            --MSG_STRING
            --MOVE_TUTOR_COST
            --MOVE_TUTOR_FIRST_IN_PARTY
            --EASY_CHAT
            --MSG_NOYES
            --WAIT
            --WAIT_CANCELABLE
            --BF_DIALOG
            --NDS
            --NDS_WAIT_BUTTON
            --NDS_INPUT_WAIT_BUTTON
            --NDS_INPUT_YESNO
            --NDS_INPUT_MULTICHOICE
            --NDS_SHOW_AT
            --NDS_CLOSE_SHOW_AT
            --ITEM_SELECTION_COUNTS
            --MSG_LOCK_AUTOCLOSE
            --MONSTER_SELECT
            --CLOSE

          end
          sleepRandom(500)
        end
      --end
    end
  end

  sleepRandom(200)
  array_Hidden_Record_CurrentState[1] = "Waiting for input"
  writeDatabase()

end


-- Use sweet scent
function useSweetScent()

	readDatabase() -- Read Database
	
	if int_PP_Current_SweetScent >= 5 then -- Check if PP are left
		print("Go sweet scent!") -- Note the user
		useHotkey(int_Setting_HotkeyFM_SweetScent, "Sweet Scent")
		int_PP_Current_SweetScent = int_PP_Current_SweetScent - 5 -- Substract used ammount from variable
		writeDatabase() -- write variable to database
		sleep(5000)
	else
		print("No more sweet scent PP left.")
		runHome()
	end

end

-- Go fishing
function fishing()
	readDatabase()
	print ("Throwing bait")
	while Trainer.IsInBattle() == false do
		if array_Activities_Behavior_RodToUse[1] == "Old Rod" then
			useHotkey(int_Setting_Hotkey_OldRod, "Old Rod")
		elseif array_Activities_Behavior_RodToUse[1] == "Good Rod" then
			useHotkey(int_Setting_Hotkey_GoodRod, "Good Rod")
		elseif array_Activities_Behavior_RodToUse[1] == "Super Rod" then
			useHotkey(int_Setting_Hotkey_SuperRod, "Super Rod")
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
	
	if newestPokemon == -1 then
		print("No pokemon caught.")
	else
		newestPokemonID = PC.GetPokemonUID(newestPokemon)
		
		if newestPokemonID == int_Hidden_Setting_LastPokemonCaught then
			print("No pokemon caught.")
		else
			print("Good Catch. Everybody clap. Roll on snare drum. Curtains.")
			int_Hidden_Setting_LastPokemonCaught = newestPokemonID
			writeDatabase()
			keepIf31(keepOnlyIfIV31, newestPokemon)
		end
	end
end