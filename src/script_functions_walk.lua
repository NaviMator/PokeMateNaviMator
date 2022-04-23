--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~W~A~L~K~I~N~G~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]

-- Credits to Fiereu for position correction and much more


-- Fix of movement to fix timing of interruption
function walking(direction, stepAmount, running)
  
  stepAmount = tonumber(stepAmount)
  
  if bool_Hidden_Setting_Debug == true then
    if stepAmount == 1 then stepGrammar = "step" else stepGrammar = "steps" end
    if running == true then speedGrammar = "Running" else speedGrammar = "Walking" end
    print(speedGrammar .. " " .. direction .. " " .. stepAmount .. " " .. stepGrammar .. ".")
  end
  
  --array_Hidden_Record_CurrentState[1] = "Walking"
	--writeDatabase()

	for step = 1, stepAmount do
    mapCodeBeforeStep = getPositionCode()
    if bool_Hidden_Setting_Debug == true and stepAmount > 1 then print("Step " .. step .. "/" .. stepAmount .. ".") end
    Trainer["Move"..direction](running, 1)
    if mapCodeBeforeStep == getPositionCode() then
      if bool_Hidden_Setting_Debug == true then print("Rotated. Will repeat step.") end
      Trainer["Move"..direction](running, 1)
    end
	end
  checkInterruption()

end


-- Get direction and random steps 
function randomSteps(direction)
	readDatabase()
	if bool_Setting_Steps_AlwaysRun == true then
		print("Running " .. direction .. ".")
	else
		print("Sneaking " .. direction .. ".")
	end
	stepAmount = random(int_Setting_Steps_Min,int_Setting_Steps_Max)
	walking(direction, stepAmount, bool_Setting_Steps_AlwaysRun)
	randomWaitingTime()
end


-- Running around
function runningAround(path)
	readDatabase()
	if path == "vertically" then
		randomSteps("Down")
		randomSteps("Up")
	elseif path == "horizontally" then
		randomSteps("Right")
		randomSteps("Left")
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
			walking("Right", 1, bool_Setting_Steps_AlwaysRun)
		end
	end
	if(dX < 0) then
		while(Trainer.GetX() > X) do
			walking("Left", 1, bool_Setting_Steps_AlwaysRun)
		end
	end
	if(dY > 0) then
		while(Trainer.GetY() < Y) do
			walking("Down", 1, bool_Setting_Steps_AlwaysRun)
		end
	end
	if(dY < 0) then
		while(Trainer.GetY() > Y) do
			walking("Up", 1, bool_Setting_Steps_AlwaysRun)
		end
	end
end


-- Checks if player is standing on rigth spot
-- trys to correct the position if not correct
function CheckPosition(X, Y)
	if X and Y then
		ErrorCorrection(X, Y)
		if(not (Trainer.GetX() == X and Trainer.GetY() == Y)) then
			stop()
			MessageBox("Player has wrong Position.\nExpected "..X.." and "..Y.."\nGot "..Trainer.GetX().." and "..Trainer.GetY())
		end
	end
end


-- Leave PokeCenter from Nurse
function leavePokeCenter(fastShoesAvailable)
	if fastShoesAvailable == false then
		running = false
	else
		running = bool_Setting_Steps_AlwaysRun
	end
  pingLoadingZone = false
  while pingLoadingZone == false do
    walking("Down", 1, running)
  end
  pingLoadingZone = false
  checkInterruption()
	print ("Outside Pokecenter. Starting Route.")
end


-- Enter PokeCenter to Nurse
function goToNurse(fastShoesAvailable)
	print("Heading to nurse")
	walking("Up", 1, false)
  checkInterruption()
	if fastShoesAvailable == false then
		running = false
	else
		running = bool_Setting_Steps_AlwaysRun
	end
	walking("Up", 8, running) -- Alternative to walk until player is blocked seems not to be supported in 3d yet
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
	if mapOnBattleEntry ~= getPositionCode(true) then
		print("Propably died and stranded in Pokecenter.")
		initialWalkDone = false
		if array_Activities_Basic_Mode[1] == "Stay in area" then
			print("Will stop and for player input.")
			stop()
		else
			print("Will continue with journey.")
			walkingToDestination()
		end
	end
end


-- How to walk and interact
function pathFinder(walkRouteWay, fastShoesAvailable, reverseThisWay)
	for i,walkLine in ipairs(walkRouteWay) do
		randomWaitingTime()
		walkInstruction = splitString(walkLine,"-")

		if walkInstruction[1] == "U" or walkInstruction[1] == "R" or walkInstruction[1] == "D" or walkInstruction[1] == "L" then		
			--if tonumber(walkInstruction[2]) >= 10 or fastShoesAvailable == false then -- Dont run long ways because steps get skipped sometimes
			if fastShoesAvailable == false then
				running = false
			else
				running = bool_Setting_Steps_AlwaysRun
			end

      if reverseThisWay ~= true then
            if walkInstruction[1] == "U" then direction = "Up"
        elseif walkInstruction[1] == "D" then direction = "Down"
        elseif walkInstruction[1] == "L" then direction = "Left"
        elseif walkInstruction[1] == "R" then direction = "Right"
        end
      else
            if walkInstruction[1] == "D" then direction = "Up"
        elseif walkInstruction[1] == "U" then direction = "Down"
        elseif walkInstruction[1] == "R" then direction = "Left"
        elseif walkInstruction[1] == "L" then direction = "Right"
        end
      end

      walking(direction, walkInstruction[2], running)

		-- Interaction
		elseif walkInstruction[1] == "Interact" then
			print("Interacting.")
			Trainer.TalkToNPC();
      checkInterruption()

    outDatedMovement = {"Door","Speak","Talk","Ledge","Press","Wait","Cut","Surf","Strength","RockSmash","RockClimb","Waterfall","Dive"}
    elseif arrayContains(outDatedMovement, walkInstruction[1]) then
      print(walkInstruction[1] .. " is outdated movement. Use Interact to pick an item, talk and use HMs.")
		else
      print("Unknown command: " .. walkInstruction[1] .. ".")
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
		print("Walking to destination. Using Route #".. choice)
    leavePokeCenter()
		CheckPosition(startX,stratY)
		pathFinder(chosenRoute)
		CheckPosition(endX,endY)
	else
    if array_Activities_Routes_ShortcutBackToPokecenter[1] == "Walk" then
      print("Walking back. Using Route #".. choice)
			CheckPosition(endX,endY)
			pathFinder(reverseTable(chosenRoute), true, true)
			CheckPosition(startX,stratY)
			goToNurse()
    else
      print("Using a shortcut")
      if array_Activities_Routes_ShortcutBackToPokecenter[1] == "Dig and Teleport" and int_Setting_HotkeyFM_Dig > 0 and int_Setting_HotkeyFM_Teleport > 0 then
        KeyTyped("H"..int_Setting_HotkeyFM_Dig)
        checkInterruption()
        KeyTyped("H"..int_Setting_HotkeyFM_Teleport)
        checkInterruption()
      elseif array_Activities_Routes_ShortcutBackToPokecenter[1] == "Dive up and Teleport" and int_Setting_HotkeyFM_Dive > 0 and int_Setting_HotkeyFM_Teleport > 0 then
        KeyTyped("H"..int_Setting_HotkeyFM_Dive)
        checkInterruption()
        KeyTyped("H"..int_Setting_HotkeyFM_Teleport)
        checkInterruption()
      elseif array_Activities_Routes_ShortcutBackToPokecenter[1] == "Teleport" and int_Setting_HotkeyFM_Teleport > 0 then
        KeyTyped("H"..int_Setting_HotkeyFM_Teleport)
        checkInterruption()
      end
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
