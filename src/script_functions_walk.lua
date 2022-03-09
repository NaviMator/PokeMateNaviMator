--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~W~A~L~K~I~N~G~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]

-- Credits to Fiereu for position correction and much more



-- Get direction and random steps 
function randomSteps(direction)
	readDatabase()
	stepAmount = random(int_Setting_Steps_Min,int_Setting_Steps_Max)
	if direction == "r" then
		Trainer.MoveRight(bool_Setting_Steps_AlwaysRun, stepAmount)
	elseif direction == "l" then
		Trainer.MoveLeft(bool_Setting_Steps_AlwaysRun, stepAmount)
	elseif direction == "u" then
		Trainer.MoveUp(bool_Setting_Steps_AlwaysRun, stepAmount)
	elseif direction == "d" then
		Trainer.MoveDown(bool_Setting_Steps_AlwaysRun, stepAmount)
	end
	randomWaitingTime()
end


-- Running around
function runningAround(path)
	readDatabase()
	if bool_Setting_Steps_AlwaysRun == true then
		print("Running around.")
	else
		print("Sneaking around.")
	end
	while Trainer.IsInBattle() == false do
		if path == "vertically" then
			randomSteps("d")
			randomSteps("u")
		elseif path == "horizontally" then
			randomSteps("r")
			randomSteps("l")
		end
	end
end


-- Try to correct position
function ErrorCorrection(X, Y)
	cX = Trainer.GetX()
	cY = Trainer.GetY()
	dX = X - cX
	dY = Y - cY

	if(not (dX < 5 and dX > -5) or not (dY < 5 and dY > -5)) then
		return
	end

	if(dX == 0 and dY == 0) then
		return
	end

	print("Trainer has wrong Position trying to correct")

	if(dX > 0) then
		while(Trainer.GetX() < X) do
			checkInterruption()
			Trainer.MoveRight(bool_Setting_Steps_AlwaysRun, 1)
		end
	end
	if(dX < 0) then
		while(Trainer.GetX() > X) do
			checkInterruption()
			Trainer.MoveLeft(bool_Setting_Steps_AlwaysRun, 1)
		end
	end
	if(dY > 0) then
		while(Trainer.GetY() < Y) do
			checkInterruption()
			Trainer.MoveDown(bool_Setting_Steps_AlwaysRun, 1)
		end
	end
	if(dY < 0) then
		while(Trainer.GetY() > Y) do
			checkInterruption()
			Trainer.MoveUp(bool_Setting_Steps_AlwaysRun, 1)
		end
	end
end


-- Checks if player is standing on rigth spot
-- trys to correct the position if not correct
function CheckPosition(X, Y)
	if X and Y then
		ErrorCorrection(X, Y)
		if(not (Trainer.GetX() == X and Trainer.GetY() == Y)) then
			MessageBox("Player has wrong Position.\nExpected "..X.." and "..Y.."\nGot "..Trainer.GetX().." and "..Trainer.GetY())
			stop()
		end
	end
end


-- Do until Map changed
function doUntilMapChanged(doAfterMapChangeAction, running)
	oldMapID = Trainer.GetMapID()
	if running == nil then
		running = bool_Setting_Steps_AlwaysRun
	end
	stepsTaken = 0
	while true do
		newMapID = Trainer.GetMapID()
		if newMapID == oldMapID then
			if bool_Hidden_Setting_Debug == true then print("Map not changed from " .. oldMapID) end
			if doAfterMapChangeAction == "MoveDown" then
				Trainer.MoveDown(running, 1)
				stepsTaken = stepsTaken + 1
			else
				sleep(200)
			end
		else
			if bool_Hidden_Setting_Debug == true then print("Map changed from " .. oldMapID .. " to " .. newMapID) end
			sleep(1000)
			randomWaitingTime()
			return true
		end
		if stepsTaken >= 15 then
			MessageBox("Something went wrong. Expected map change.")
			stop()
		end
	end
end


-- Levelchange (doors or caves)
function levelChange()
	-- if region == Unova -- not possible yet
	--	while(Trainer.IsMovementBlocked()) do
	--		sleep(1000)
	--		if Trainer.GetMapID() <= 0 then
	--			print("Crazy Map-ID. Will ignore and continue.")
	--			sleep(1000)
	--			break
	--		end
	--	end
	-- else
	if bool_Hidden_Setting_Debug == true then print("Waiting for levelchange") end
	doUntilMapChanged()
	print("Closing door behind me.")
	-- end
end


-- Leave PokeCenter from Nurse
function leavePokeCenter(fastShoesAvailable)
	if fastShoesAvailable == false then
		running = false
	else
		running = bool_Setting_Steps_AlwaysRun
	end
	doUntilMapChanged("MoveDown", running)
	print ("Outside Pokecenter. Starting Route.")
end

-- Enter PokeCenter to Nurse
function goToNurse(fastShoesAvailable)
	print("Heading to nurse")
	Trainer.MoveUp(false, 1)
	levelChange()
	if fastShoesAvailable == false then
		running = false
	else
		running = bool_Setting_Steps_AlwaysRun
	end
	Trainer.MoveUp(running, 8) -- Alternative to walk until player is blocked seems not to be supported in 3d yet
end

-- Reset values after healing
function healed()
	readDatabase()
	int_PP_Current_SweetScent = int_PP_Base_SweetScent
	goHeal = false
	writeDatabase()
end

-- Talk to Nurse
function regenerate()
	print("Regernerating")
	--CheckPosition(7,4) -- Kanto
	Trainer.TalkToNPC();
	for i=1, 5 do
		sleep(1200)
		randomWaitingTime()
		KeyTyped("A")
	end
	for i=1, 5 do
		sleep(1200)
		randomWaitingTime()
		KeyTyped("B")
	end
	healed()
	randomWaitingTime()
	print("Regenerated")
end

-- Check if stranded in Pokecenter
function checkIfLostAtPokeCenter()
	if mapOnBattleEntry ~= getPositionCode() then
		print("Propably died and stranded in Pokecenter. Will continue with journey.")
		initialWalkDone = false
		walkingToDestination()
	end
end


-- How to walk and use HM
function pathFinder(walkRouteWay, fastShoesAvailable)
	for i,walkLine in ipairs(walkRouteWay) do
		randomWaitingTime()
		walkInstruction = splitString(walkLine,"-")

		-- Dont run long ways because steps get skipped sometimes
		if walkInstruction[1] == "U" or walkInstruction[1] == "R" or walkInstruction[1] == "D" or walkInstruction[1] == "L" then
			--if tonumber(walkInstruction[2]) >= 10 or fastShoesAvailable == false then
			if fastShoesAvailable == false then
				running = false
			else
				running = bool_Setting_Steps_AlwaysRun
			end
		end

		-- Walking (has to be split up to single steps because of possible interruption)
		if walkInstruction[1] == "U" then
			if bool_Hidden_Setting_Debug == true then print("Walking Up ".. walkInstruction[2]) end
			for i=1, walkInstruction[2] do
				Trainer.MoveUp(running, 1)
				checkInterruption()
			end
		elseif walkInstruction[1] == "D" then
			if bool_Hidden_Setting_Debug == true then print("Walking Down ".. walkInstruction[2]) end
			for i=1, walkInstruction[2] do
				Trainer.MoveDown(running, 1)
				checkInterruption()
			end
		elseif walkInstruction[1] == "L" then
			if bool_Hidden_Setting_Debug == true then print("Walking Left ".. walkInstruction[2]) end
			for i=1, walkInstruction[2] do
				Trainer.MoveLeft(running, 1)
				checkInterruption()
			end
		elseif walkInstruction[1] == "R" then
			if bool_Hidden_Setting_Debug == true then print("Walking Right ".. walkInstruction[2]) end
			for i=1, walkInstruction[2] do
				Trainer.MoveRight(running, 1)
				checkInterruption()
			end

		-- Interaction
		elseif walkInstruction[1] == "Wait" then
			print("Waiting ".. walkInstruction[2] .. " Seconds.")
			waitingTime = walkInstruction[2] * 1000
			sleepRandom(waitingTime)
			checkInterruption()
		elseif walkInstruction[1] == "Press" then
			print("Pressing ".. walkInstruction[2])
			KeyTyped(walkInstruction[2])
			sleepRandom(200)
		elseif walkInstruction[1] == "Speak" then
			print("Greeting.")
			sleepRandom(200)
			Trainer.TalkToNPC();
		elseif walkInstruction[1] == "Talk" then
			print("Negotiating.")
			sleepRandom(200)
			for i=1, walkInstruction[2] do
				sleepRandom(1000)
				KeyTyped("B")
			end
			sleepRandom()
			checkInterruption()

		-- More movement
		elseif walkInstruction[1] == "Door" then
			print("Walking through door.")
			levelChange()
		elseif walkInstruction[1] == "Ledge" then
			print("Jumping down ledge.")
			sleepRandom(1000)
			checkInterruption()
		elseif walkInstruction[1] == "Cut" then
			print("Trimming tree.")
			useHotkey(int_Setting_HotkeyFM_Cut, walkInstruction[1])
			sleepRandom(3000)
		elseif walkInstruction[1] == "Surf" then
			print("Going for a swim.")
			useHotkey(int_Setting_HotkeyFM_Surf, walkInstruction[1])
			sleepRandom(3000)
		elseif walkInstruction[1] == "Strength" then
			print("Pushing boulders.")
			useHotkey(int_Setting_HotkeyFM_Strength, walkInstruction[1])
			sleepRandom(3000)
		elseif walkInstruction[1] == "RockSmash" then
			print("Smashing boulders.")
			useHotkey(int_Setting_HotkeyFM_RockSmash, walkInstruction[1])
			sleepRandom(2000)
			KeyTyped("A")
			sleepRandom(1000)
			KeyTyped("A")
			sleepRandom(2000)
			checkInterruption()
		elseif walkInstruction[1] == "RockClimb" then
			print("Walking up walls.")
			useHotkey(int_Setting_HotkeyFM_RockClimb, walkInstruction[1])
			sleepRandom(3000)
		elseif walkInstruction[1] == "Waterfall" then
			print("Swimming up walls.")
			useHotkey(int_Setting_HotkeyFM_Waterfall, walkInstruction[1])
			sleepRandom(3000)
		elseif walkInstruction[1] == "Whirlpool" then
			print("Entering hot tub.")
			useHotkey(int_Setting_HotkeyFM_Whirlpool, walkInstruction[1])
			sleepRandom(3000)
		elseif walkInstruction[1] == "Dive" then
			print("Taking a deep breath.")
			useHotkey(int_Setting_HotkeyFM_Dive, walkInstruction[1])
			sleepRandom(3000)
		elseif walkInstruction[1] == "Dig" then
			print("Burrowing.")
			useHotkey(int_Setting_HotkeyFM_Dig, walkInstruction[1])
			sleepRandom(3000)
		elseif walkInstruction[1] == "Teleport" then
			print("Initializing hyperdrive.")
			useHotkey(int_Setting_HotkeyFM_Teleport, walkInstruction[1])
			sleepRandom(3000)
		end
	end
end


-- Walking to and back from route logic
function walkRoute(startX, stratY, endX, endY, availableRoutes, walkingBack)

	if availableRoutes == NULL then
		MessageBox("Error: No routes defined. Check if spelled correctly.")
		stop()
	end

	choice = random(1,tableLength(availableRoutes))
	chosenRoute = (availableRoutes[choice])

	if walkingBack ~= true then
		print("Using Route #".. choice)
		CheckPosition(startX,stratY)
		pathFinder(chosenRoute)
		CheckPosition(endX,endY)
	else
		if bool_Activities_Routes_DigAndTeleportBack == true and int_Setting_HotkeyFM_Dig > 0 and int_Setting_HotkeyFM_Teleport > 0 then
			print("Using a shortcut")
			KeyTyped("H"..int_Setting_HotkeyFM_Dig)
			sleep(3000)
			levelChange()
			KeyTyped("H"..int_Setting_HotkeyFM_Teleport)
			sleep(3000)
			levelChange()
		else
			print("Using Route #".. choice)
			CheckPosition(endX,endY)
			pathFinder(chosenRoute)
			CheckPosition(startX,stratY)
			goToNurse()
		end
	end
end

-- Play a chapter of the game
function playChapter(chapter, startX, stratY, endX, endY, interactions, fastShoesAvailable, startFromPokeCenter)

	readDatabase()

	print("Playing ".. chapter)
	if startFromPokeCenter ~= false then
		leavePokeCenter()
	end
	CheckPosition(startX,stratY)
	for i,subparts in ipairs(interactions) do
		print("Starting Part " .. i .. " of chapter.")
		if bool_Hidden_Setting_Debug == true then print(table_to_string(subparts)) end
		pathFinder(subparts, fastShoesAvailable)
	end
	CheckPosition(endX,endY)
	print("Chapter done. Will go heal.")
	goToNurse(fastShoesAvailable)
	regenerate(fastShoesAvailable)

	if bool_Activities_Playthrough_ContinueNextChapter == true then -- This is ugly but actually genius
		
		readDatabase()

		chapter = splitString(chapter, ": ")
		if bool_Hidden_Setting_Debug == true then print("Chapter finished: " .. table_to_string(chapter)) end
		chapter = splitString(chapter[1], " ")
		nextChapterNumber = tonumber(chapter[3]) + 1
		if bool_Hidden_Setting_Debug == true then print("Next chapter number: " .. nextChapterNumber) end
		nextChapter = chapter[1].." "..chapter[2].." "..nextChapterNumber
		listOfChapters = table_to_string(array_Activities_Playthrough_Chapter)
		SplitAtMatchingChapters = splitString(listOfChapters, chapter[1].." "..chapter[2])
		numberOfMatchingChapters = tonumber(tableLength(SplitAtMatchingChapters)) - 1
		if bool_Hidden_Setting_Debug == true then print(numberOfMatchingChapters .. " matching chapters found.") end
		splitOfChaptersAtNextChapter = splitString(listOfChapters, nextChapter)
		chaptersBeforeNextChapter = splitString(splitOfChaptersAtNextChapter[1], ": ")	
		nextChapterPositionInArray = tableLength(chaptersBeforeNextChapter)	
		nextChapterName = array_Activities_Playthrough_Chapter[nextChapterPositionInArray]
		
		
		if nextChapterNumber <= numberOfMatchingChapters then
			
			print("Autodetected next chapter: " .. nextChapterName)
	
			table.remove(array_Activities_Playthrough_Chapter, nextChapterPositionInArray)
			table.sort(array_Activities_Playthrough_Chapter) -- done by navimator now
			table.insert(array_Activities_Playthrough_Chapter, 1, nextChapterName)
	
			if array_Activities_Playthrough_Chapter then
				writeDatabase()
				walkingToDestination()
			else
				MessageBox("Error occurred.")
				stop()
			end

		else
			MessageBox("No next Chapter. Playthrough ended.")
			stop()
		end
	else
		MessageBox("Chapter done. Best luck to you.")
		stop()
	end

end
