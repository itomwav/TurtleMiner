function save(table,name)
    local file = fs.open(name,"w")
    file.write(textutils.serialize(table))
    file.close()
    print("File saved as "..name..".")
end

function load(name)
    local file = fs.open(name,"r")
    local data = file.readAll()
    file.close()
    print("File loaded as "..tostring(textutils.unserialize(data))..".")
    return textutils.unserialize(data)
end

-------------------------------------

function request()
    rednet.broadcast((x-1).." "..y,"miner")
    print("requested "..x.." "..y)
end

function mining()
    print("mining "..x.." "..y)
end

function mined()
    print("mined "..x.." "..y)
end

map = {}

rednet.open("left")
term.clear()
term.setCursorPos(1,1)

while true do
local id,message,protocol = rednet.receive()
if protocol == "req" then
    x = tonumber(string.sub(message,0,string.find(message," ")-1))
    y = tonumber(string.sub(message,string.find(message," ")+1,string.len(message)))

    if y == 0 then
        if string.find(tostring(map[x-1]),"table") then
            request()
        end
    elseif math.abs(y) == 1 then --wegen unsauberer Programmierung
        if string.find(tostring(map[x]),"table") then
            request()
        end
    elseif y < 0 then
        if x <= #map then
        if map[x][y+1] == "mined" and map[x][y] ~= "mining" then
            request()
        end
        end
    elseif y > 0 then
        if x <= #map then
        if map[x][y-1] == "mined" and map[x][y] ~= "mining" then
            request()
        end
        end
    end
    save(map,"saving")

elseif protocol == "mining" then
    x = tonumber(string.sub(message,0,string.find(message," ")-1))
    y = tonumber(string.sub(message,string.find(message," ")+1,string.len(message)))
    if y == 0 then 
        if x <= (#map+1) then
        map[x] = "mining"
        mining()
        end
    else
        if x <= #map then
        map[x][y] = "mining"
        mining()
        end
    end
    save(map,"saving")

elseif protocol == "mined" then
    x = tonumber(string.sub(message,0,string.find(message," ")-1))
    y = tonumber(string.sub(message,string.find(message," ")+1,string.len(message)))
    
    if y == 0 then 
        map[x] = {}
        mined()
    else
        if x <= #map then
        map[x][y] = "mined"
        mined()
        end
    end
    save(map,"saving")

elseif protocol == "info" then
    if message == "complete" then
        rednet.send(id,map,"infoBack")
    else
    x = tonumber(string.sub(message,0,string.find(message," ")-1))
    y = tonumber(string.sub(message,string.find(message," ")+1,string.len(message)))
    if x > #map then
    print(nil)
    rednet.send(id,"nil","infoBack")
    else -- wenn es im möglichen Bereich ist:
    if y == 0 then
        if string.find(tostring(map[x]),"table") then
        rednet.send(id,"mined","infoBack")
        else
        rednet.send(id,map[x],"infoBack")
        end
    else
        print(map[x][y])
        rednet.send(id,tostring(map[x][y]),"infoBack")
    end
    end
    end

elseif protocol == "table" then
if fs.exists(message) then
    saving = message
    map = load(message)
    rednet.send(id,"loaded","table")
else
    rednet.send(id,"create","table")
end

elseif protocol == "createTable" then
    saving = message
map = {}

else
    rednet.send(tonumber(protocol),message,tostring(id))
    term.clear()
    term.setCursorPos(1,1)
    print("NewMessage:")
    print("Text: "..tostring(message))
    print("From: "..tostring(id))
    print("To: "..tostring(protocol))
end

end