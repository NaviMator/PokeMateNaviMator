--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~P~L~A~Y~T~H~R~O~U~G~H~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]


-- Copy and define a new "if" below to call your route
-- Set start and end coordinates to check your position
-- D-4 means to walk down 4 steps. R-2 means to walk right 2 steps. And so on. Door means to wait until a level (house, route, cave...) is loaded.
-- Define a walkReset as an instruction to walk to your end point before walking back

if array_Activities_Playthrough_Starter[1] == "Grass" then
	choseStarter = {'Press-A'}
elseif array_Activities_Playthrough_Starter[1] == "Fire" then
	choseStarter = {'Press-Down','Press-A'}
elseif array_Activities_Playthrough_Starter[1] == "Water" then
	choseStarter = {'Press-Down','Press-Down','Press-A'}
end


function playthrough(chapter)
	-- Some tests you can run from pokecenter in Littleoot Town (hoenn)
	if chapter == "Test Chapter 1: Just a little Dance" then
		startX = 6
		stratY = 17
		endX = 6
		endY = 17
		fastShoesAvailable = false

		interactions = {
			-- Dance (a little)
			{'D-2','R-1','U-1','L-1','D-1','R-1','U-3'}
		}

	elseif chapter == "Test Chapter 2: Into the forest" then
		startX = 6
		stratY = 17
		endX = 6
		endY = 17
		fastShoesAvailable = false

		interactions = {
			-- Down and Up
			{'D-2','R-3','U-2','R-7','D-2','L-5','U-5'},
			-- Left and Dwn
			{'D-10','R-6','D-4','R-2','U-4','L-9','U-7','L-3','U-2'}
		}
		
	elseif chapter == "Test Chapter 3: Around the Center" then
		startX = 6
		stratY = 17
		endX = 6
		endY = 17
		fastShoesAvailable = false

		interactions = {
			-- Arount the Center
			{'D-1','R-4','U-7','L-6','D-7','R-3','U-2'},
			-- Back arount the Center
			{'D-2','L-3','U-6','R-6','D-7','L-4','U-2'}
		}

	elseif chapter == "Test Chapter 4: Talk inside the other House" then
		startX = 6
		stratY = 17
		endX = 6
		endY = 17
		fastShoesAvailable = false

		interactions = {
			-- To the other house
			{'D-2','R-8','U-3','R-3','U-2','Door'},
			-- Go to woman
			{'U-3','R-1','Talk-3'},
			-- Go to man
			{'U-2','R-6','D-2','L-1','Talk-3'},
			-- Leave to PC
			{'D-4','L-6','D-2','Door','L-6','D-2','L-5','U-2'}
		}

	end

	print("Starting playthrough")
	playChapter(chapter, startX, stratY, endX, endY, interactions, fastShoesAvailable, startFromPokeCenter)

end