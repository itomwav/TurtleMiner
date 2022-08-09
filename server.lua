function request()
    rednet.send(2,"miner "..x.." "..y)
    print("requested "..x.." "..y)
end

function mining()
    print("mining "..x.." "..y)
end

function mined()
    print("mined "..x.." "..y)
end

rednet.open("left")
term.clear()
term.setCursorPos(1,1)

map = {}
map[1] = {}

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
        if map[x][y+1] == "mined" and map[x][y] ~= "mining" then
            request()
        end
    elseif y > 0 then
        if map[x][y-1] == "mined" and map[x][y] ~= "mining" then
            request()
        end
    end

elseif protocol == "mining" then
    x = tonumber(string.sub(message,0,string.find(message," ")-1))
    y = tonumber(string.sub(message,string.find(message," ")+1,string.len(message)))
    if y == 0 then 
        map[x] = "mining"
        mining()
    else
        map[x][y] = "mining"
        mining()
    end

elseif protocol == "change" then
    x = tonumber(string.sub(message,0,string.find(message," ")-1))
    y = tonumber(string.sub(message,string.find(message," ")+1,string.len(message)))
    if y == 0 then 
        map[x] = {}
        mined()
    else
        map[x][y] = "mined"
        mined()
    end

elseif protocol == "info" then
    x = tonumber(string.sub(message,0,string.find(message," ")-1))
    y = tonumber(string.sub(message,string.find(message," ")+1,string.len(message)))
    if x > #map then
    print(nil)
    else
    print(map[x][y])
    end

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