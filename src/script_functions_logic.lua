--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~LUA~~~F~U~N~C~T~I~O~N~S~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]

-- Check if table contains value
function arrayContains(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

-- Split string
function splitString(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- Reverse table
function reverseTable(tbl)
  for i=1, math.floor(#tbl / 2) do
    local tmp = tbl[i]
    tbl[i] = tbl[#tbl - i + 1]
    tbl[#tbl - i + 1] = tmp
  end
end

-- Convert table to string
function table_to_string(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
        end
        -- Check the value type
        if type(v) == "table" then
            result = result..table_to_string(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        elseif type(v) == "number" then
            result = result..tonumber(v)
        else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    -- Remove leading commas from the result
    if result ~= "" then
        result = result:sub(1, result:len()-1)
    end
    return result.."}"
end

-- Count items in table
function tableLength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~AWESOME~~DATABASE~~COMMUNICATION~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--]]


function readDatabase()
    file = assert(io.open(dataBaseFile, "r+"))
    io.output(file);
    lines = file:read("*a")
    io.close(file)
    dofile(dataBaseFile)
end

function writeDatabase()
    line = splitString(lines, "\n");
    dataBase = "";

    for init, thisVariable in ipairs(line) do
        thisVariablePart = splitString(thisVariable, " = ");

        thisVariableName = thisVariablePart[1];
        thisVariableValue = _G[thisVariablePart[1]];

        if type(thisVariableValue) == "table" then
            thisVariableValue = table_to_string(thisVariableValue);
        elseif type(thisVariableValue) == "boolean" then
            thisVariableValue = tostring(thisVariableValue);
        end

        --print(thisVariableName)
        --print(thisVariableValue)

        if init > 1 then
            dataBase = dataBase .. "\n"
        end

        dataBase = dataBase .. thisVariableName .. " = " .. thisVariableValue
    end

    file = assert(io.open(dataBaseFile, "w+"))
    io.output(file);
    io.write(dataBase)
    io.close(file)

    dofile(dataBaseFile)
end



readDatabase() -- Further scripts will depend on this data

