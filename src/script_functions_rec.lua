--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~R~E~C~O~R~D~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]
	
function record()
	print("Recording.")
	if tonumber(array_Hidden_Record_LastOutput[1]) ~= 0 then
		lastRecTimestamp = array_Hidden_Record_LastOutput[1]
		print("Output was not empty. Will ignore, but please clear.")
	end
	while true do
		readDatabase()
		if tonumber(array_Hidden_Record_LastOutput[1]) > 0 then
			if array_Hidden_Record_LastOutput[1] ~= lastRecTimestamp then
				if bool_Hidden_Setting_Debug then print("Got new record-input: " .. array_Hidden_Record_LastOutput[2]) end
				if array_Hidden_Record_LastOutput[2] == "Wait-1" then
          array_Hidden_Record_CurrentState[1] = "Waiting for input"
          writeDatabase()
          print("Just a note")
				elseif array_Hidden_Record_LastOutput[2] == "GetCoordinates" then
          array_Hidden_Record_CurrentState[1] = "Waiting for input"
          writeDatabase()
          print("X: " .. Trainer.GetX() .. " || Y: " .. Trainer.GetY())
        else
          array_Hidden_Record_CurrentState[1] = "Processing Input"
          writeDatabase()
          pathFinder({array_Hidden_Record_LastOutput[2]})
				end
				lastRecTimestamp = array_Hidden_Record_LastOutput[1]
			end
		end
		sleep(100)
	end
end
