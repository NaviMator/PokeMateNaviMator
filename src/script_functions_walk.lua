--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~W~A~L~K~I~N~G~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]

-- Credits to Fiereu for position correction and much more


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
			MessageBox("Player has wrong Position\nPlease got back to start and Run the Bot again")
			Stop()
		end
	end
end


-- Levelchange (doors or caves)
function levelChange()
	sleep(1000)
	while(Trainer.IsMovementBlocked()) do
		sleep(1000)
	end
	sleep(1000)
	randomWaitingTime()
end


-- Leave PokeCenter from Nurse
function leavePokeCenter()
	Trainer.MoveDown(bool_Setting_Steps_AlwaysRun, 6)
	levelChange()
end


-- Enter PokeCenter to Nurse
function goToNurse()
	print("Heading to nurse")
	Trainer.MoveUp(false, 1)
	levelChange()
	Trainer.MoveUp(bool_Setting_Steps_AlwaysRun, 4)
end

-- Reset values after healing
function healed()
	readDatabase()
	int_PP_Current_SweetScent = int_PP_Base_SweetScent
	goHeal = false
	writeDatabase()
end

-- Go To Nurse and talk to her
function regenerate()
	print("Regernerating")
	CheckPosition(7,4)
	Trainer.TalkToNPC()
	for i=1, 7 do
		sleep(1200)
		randomWaitingTime()
		KeyTyped("A")
	end
	healed()
	randomWaitingTime()
	print("Regenerated")
end


-- How to walk and use HM
function pathFinder(walkRouteWay)
	for i,walkLine in ipairs(walkRouteWay) do
		randomWaitingTime()
		walkInstruction = splitString(walkLine,"-")

		-- Dont run long ways because steps get skipped sometimes
		if walkInstruction[2] then
			if tonumber(walkInstruction[2]) >= 10 then
				running = false
			else
				running = bool_Setting_Steps_AlwaysRun
			end
		end

		-- Walking has to be split up to single steps because of possible interruption
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

		elseif walkInstruction[1] == "Door" then
			print("Walking through door")
			levelChange()
		elseif walkInstruction[1] == "Ledge" then
			print("Jumping down ledge")
			sleep(1000)
			randomWaitingTime()
			checkInterruption()
		elseif walkInstruction[1] == "Cut" then
			print("Trimming tree")
			KeyTyped("H"..int_Setting_HotkeyFM_Cut)
			levelChange()
		elseif walkInstruction[1] == "Surf" then
			print("Going for a swim")
			KeyTyped("H"..int_Setting_HotkeyFM_Surf)
			sleep(3000)
			levelChange()
		elseif walkInstruction[1] == "Strength" then
			print("Pushing boulders")
			KeyTyped("H"..int_Setting_HotkeyFM_Strength)
			sleep(3000)
			levelChange()
		elseif walkInstruction[1] == "RockSmash" then
			print("Smashing boulders")
			KeyTyped("H"..int_Setting_HotkeyFM_RockSmash)
			levelChange()
			checkInterruption()
		elseif walkInstruction[1] == "RockClimb" then
			print("Walking up walls")
			KeyTyped("H"..int_Setting_HotkeyFM_RockClimb)
			levelChange()
		elseif walkInstruction[1] == "Waterfall" then
			print("Swimming up walls")
			KeyTyped("H"..int_Setting_HotkeyFM_Waterfall)
			levelChange()
		elseif walkInstruction[1] == "Whirlpool" then
			print("Entering hot tub")
			KeyTyped("H"..int_Setting_HotkeyFM_Whirlpool)
			levelChange()
		elseif walkInstruction[1] == "Dive" then
			print("Taking a deep breath")
			KeyTyped("H"..int_Setting_HotkeyFM_Dive)
			levelChange()
		end
	end
end


-- Walking to and back from route logic
function walkRoute(startX, stratY, endX, endY, availableRoutes, walkingBack)

	choice = random(1,tableLength(availableRoutes))
	chosenRoute = (availableRoutes[choice])

	if walkingBack ~= true then
		print("Using Route #".. choice)
		CheckPosition(startX,stratY)
		pathFinder(chosenRoute)
		CheckPosition(endX,endY)
	else
		if bool_Activities_Routes_DigAndTeleportBack == true then
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
