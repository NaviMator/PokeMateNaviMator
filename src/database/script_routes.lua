--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~R~O~U~T~E~S~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]


-- Script to get current position
-- print('X= ' .. Trainer.GetX() .. ' | Y= ' .. Trainer.GetY())


-- Copy and define a new 'if' below to call your route
-- Set start and end coordinates to check your position
-- D-4 means to walk down 4 steps. R-2 means to walk right 2 steps. And so on. Door means to wait until a level (house, route, cave...) is loaded.
-- Define a walkReset as an instruction to walk to your end point before walking back


function routes(route, reverse)
	if route == 'Hoenn route 117' then -- Hoenn, route 117 (start Verdanturf Town at nurse)
		startX = 16
		stratY = 4
		endX = 19
		endY = 14

		availableRoutes = {
			{'D-5', 'R-22', 'D-6'},
			{'D-7', 'R-22', 'D-4'},
			{'D-4', 'R-22', 'D-7'}
		}
  
	elseif route == 'Hoenn route 104 (Fishing)' then -- Hoenn route 104, (start Petalburg City at nurse)
		startX = 20
		stratY = 17
		endX = 27
		endY = 75

		availableRoutes = {
			{'L-4','U-4','L-26','D-5','L-1','D-4','L-2','D-3'},
			{'L-2','U-2','L-4','U-1','L-4','U-1','L-22','D-9','L-1','D-3'},
		}

	elseif route == 'Kanto route 10' then -- Kanto, route 10 (start Lavender Town at nurse)
		startX = 6
		stratY = 6
		endX = 18
		endY = 36

		availableRoutes = {
			{'R-5', 'U-10', 'R-3', 'U-4', 'R-8', 'U-8', 'L-3', 'U-4', 'L-10', 'U-3'}
		}

	elseif route == 'Hoenn victory road' then -- Hoenn, victory road (start Ever Grande City at nurse)
		startX = 27
		stratY = 49
		endX = 17
		endY = 39

		availableRoutes = {
			{'D-3', 'L-8', 'U-7', 'L-1', 'U-4',   'R-2'},
			{'D-4', 'L-8', 'U-9', 'L-1', 'U-3',   'R-2'}
		}

	elseif route == 'Hoenn route 113' then -- Hoenn, route 113 (start Fallarbor Town at nurse)
		startX = 14
		stratY = 8
		endX = 28
		endY = 9

		availableRoutes = {
			{'D-4','R-5','D-2','R-15','U-1','R-14','U-4'}
		}

	elseif route == 'Hoenn route 102' then -- Hoenn, route 102 (start Petalburg City at nurse)
		startX = 20
		stratY = 17
		endX = 7
		endY = 12

		availableRoutes = {
			{'R-18','D-4','L-1'},
			{'D-2','R-19','D-3','L-2'},
		}

	elseif route == 'Hoenn route 113 (Collect Ash)' then -- Hoenn, route 113 (start Fallarbor Town at nurse)
		startX = 14
		stratY = 8
		endX = 19
		endY = 9

		availableRoutes = {
			{'D-4','R-5','D-2','R-15','U-1','R-23','U-6','R-5','U-1','R-2','U-1','R-3','U-2','R-5','D-2','R-3','D-1','R-8','U-1','R-4','D-1','R-6','D-1','R-6','U-3','R-3','D-3','L-1','D-1','L-12','D-1','R-10','D-1','L-19','U-2','L-15','U-5','L-10','D-3','L-2','D-4','L-13','U-1','R-6','U-1','L-9'}
		}

	elseif route == 'Hoenn route 121' then -- Hoenn, route 121 (start Lilycove City at nurse)
		startX = 24
		stratY = 15
		endX = 71
		endY = 9

		availableRoutes = {
			{'L-39','D-4','L-3','U-1'}
		}

	elseif route == 'Dragonspiral (Fishing)' then -- Unova, Dragonspiral (start Icirrus City at nurse)
		startX = 184
		stratY = 196
		endX = 22
		endY = 41

		availableRoutes = {
			{'L-4','U-39','R-1','U-14','L-1','U-10'}
		}

	elseif route == 'Kanto route 15' then -- Kanto, route 15 (start Fuchsia City at nurse)
		startX = 25
		stratY = 32
		endX = 20
		endY = 11

		availableRoutes = {
			{'R-3','U-11','R-42'}
		}

	elseif route == 'Cinnabar Island' then -- Kanto, route 15 (start Cinnabar Island at nurse)
		startX = 14
		stratY = 12
		endX = 13
		endY = 17

		availableRoutes = {
			{'D-2','Interact','L-1','D-2'}
		}

	end

	walkRoute(startX, stratY, endX, endY, availableRoutes, reverse)

end