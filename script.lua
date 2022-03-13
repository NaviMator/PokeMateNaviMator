baseFolder = "scripts/"
-- change this to the folder the script.lua, NaviMator.exe and src-folder is placed

-- Add this Script to PokeMate by this command
-- require "scripts/script"

dataBaseFile = baseFolder.."src/database/settingsDB.lua"
require (baseFolder.."src/database/script_mechanics")   -- List of hardcoded mechanics to make decisions in fights
require (baseFolder.."src/database/script_routes")      -- Scripts of available routes
require (baseFolder.."src/database/script_playthrough") -- Scripts of available playthroughts
require (baseFolder.."src/script_functions_logic")      -- Basic LUA functions and database connection (do not touch if you don't know what you are doing)
require (baseFolder.."src/script_functions_walk")       -- Functions to walk around
require (baseFolder.."src/script_functions_interact")   -- Functions to interact
require (baseFolder.."src/script_functions_fight")      -- Functions to fight and catch
require (baseFolder.."src/script_functions_rec")        -- Functions to record routes
require (baseFolder.."src/script_main")                 -- Main logic that puts everything together

print("Setup successful")



--Login()
startTask()