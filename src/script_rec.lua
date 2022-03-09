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
				if bool_Hidden_Setting_Debug == true then print("Got new record-input: " .. array_Hidden_Record_LastOutput[2]) end
				if array_Hidden_Record_LastOutput[2] ~= "Door" and array_Hidden_Record_LastOutput[2] ~= "Ledge" and array_Hidden_Record_LastOutput[2] ~= "Wait-1" then
					if array_Hidden_Record_LastOutput[2] == "GetCoordinates" then
						print("X= " .. Trainer.GetX() .. " | Y= " .. Trainer.GetY())
					else
						pathfinderWrapper = {array_Hidden_Record_LastOutput[2]}
						pathFinder(pathfinderWrapper)
					end
				else
					print("Input is just a note.")
				end
				lastRecTimestamp = array_Hidden_Record_LastOutput[1]
			end
		end
		sleep(150)
		checkInterruption()
	end
end
