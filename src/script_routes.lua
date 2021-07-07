--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~R~O~U~T~E~S~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]


-- Script to get current position
-- print("X= " .. Trainer.GetX() .. " | Y= " .. Trainer.GetY())


-- Copy and define a new "if" below to call your route
-- Set start and end coordinates to check your position
-- D-4 means to walk down 4 steps. R-2 means to walk right 2 steps. And so on. Door means to wait until a level (house, route, cave...) is loaded.
-- Define a walkReset as an instruction to walk to your end point before walking back


function routes(route, reverse)
	if route == "Hoenn route 117" then -- Hoenn, route 117 (start Verdanturf Town at nurse)
		startX = 16
		stratY = 4
		endX = 19
		endY = 14

		routesTowards = {
			{'D-5', 'R-23', 'D-7'},
			{'D-7', 'R-23', 'D-5'},
			{'D-4', 'R-23', 'D-8'}
		}

		routesBack = {
			{'D-3', 'R-3', 'U-8', 'R-24', 'U-6'},
			{'D-3', 'R-3', 'U-6', 'R-24', 'U-8'}
		}
	elseif route == "Kanto route 10" then -- Kanto, route 10 (start Lavender Town at nurse)
		startX = 6
		stratY = 6
		endX = 18
		endY = 37

		routesTowards = {
			{'R-6', 'U-11', 'R-4', 'U-5', 'R-9', 'U-9', 'L-4', 'U-5', 'L-11', 'U-4','Door'}
		}
	elseif route == "Hoenn victory road" then -- Hoenn, victory road (start Ever Grande City at nurse)
		startX = 27
		stratY = 49
		endX = 17
		endY = 39

		routesTowards = {
			{'D-3', 'L-9', 'U-8', 'L-2', 'U-5', 'Door', 'U-1', 'R-3'},
			{'D-4', 'L-9', 'U-10', 'L-2', 'U-4', 'Door', 'U-1', 'R-3'}
		}
		routesBack = {
			{'R-10', 'U-4', 'L-4', 'D-3', 'Door', 'D-7', 'R-3', 'D-4', 'R-8', 'U-4'}
		}
	elseif route == "Hoenn route 113" then -- Hoenn, route 113 (start Fallarbor Town at nurse)
		startX = 14
		stratY = 8
		endX = 28
		endY = 9

		routesTowards = {
			{'D-4','R-6','D-3','R-16','U-2','R-15','U-5'}
		}
		routesBack = {
			{'L-10','D-8','L-10','U-2','L-4','D-2','L-14','U-6','L-8','U-2'}
		}
	elseif route == "Hoenn route 113 (Collect Ash)" then -- Hoenn, route 113 (start Fallarbor Town at nurse)
		startX = 14
		stratY = 8
		endX = 19
		endY = 9

		routesTowards = {
			{'D-4','R-6','D-3','R-16','U-2','R-24','U-7','R-6','U-2','R-3','U-2','R-4','U-3','R-6','D-3','R-4','Ledge','D-2','R-9','U-2','R-5','Ledge','D-2','R-7','D-2','Ledge','R-7','U-4','R-4','D-4','L-2','D-2','L-13','D-2','R-11','D-2','L-20','U-3','L-16','U-6','L-11','D-4','L-3','D-5','L-14','U-2','R-7','U-2','L-10'}
		}
		routesBack = {
			{'D-5','L-8','D-2','L-12','U-6','L-8','U-2'}
		}
	end

	if reverse == true then
		print("Walking back from " .. route)
		walkRoute(startX, stratY, endX, endY, routesBack, true)
	else
		print("Walking towards " .. route)
		walkRoute(startX, stratY, endX, endY, routesTowards, false)
	end
end