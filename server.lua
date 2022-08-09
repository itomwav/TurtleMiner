rednet.open("left")
term.clear()
term.setCursorPos(1,1)

map = {}
map[1] = {}
--table.insert(map,1,{})

while true do
local id,message,protocol = rednet.receive()
if protocol == "req" then
    x = tonumber(string.sub(message,0,string.find(message," ")-1))
    y = tonumber(string.sub(message,string.find(message," ")+1,string.len(message)))

    if y == 0 then
        if string.find(tostring(map[x-1]),"table") then
            rednet.send(2,"miner "..x.." "..y)
            print("requested "..x.." "..y)
        end
    elseif math.abs(y) == 1 then --wegen unsauberer Programmierung
        if string.find(tostring(map[x]),"table") then
            rednet.send(2,"miner "..x.." "..y)
            print("requested "..x.." "..y)
        end
    elseif y < 0 then
        if map[x][y+1] == "mined" and map[x][y] ~= "mining" then
            rednet.send(2,"miner "..x.." "..y)
            print("requested "..x.." "..y)
        end
    elseif y > 0 then
        if map[x][y-1] == "mined" and map[x][y] ~= "mining" then
            rednet.send(2,"miner "..x.." "..y)
            print("requested "..x.." "..y)
        end
    end

elseif protocol == "mining" then
    x = tonumber(string.sub(message,0,string.find(message," ")-1))
    y = tonumber(string.sub(message,string.find(message," ")+1,string.len(message)))
    if y == 0 then 
        map[x] = "mining"
        --table.insert(map,x,"mining")
        print("mining "..x.." "..y)
    else
        map[x][y] = "mining"
        --table.insert(map[x],y,"mining")
        print("mining "..x.." "..y)
    end

elseif protocol == "change" then
    x = tonumber(string.sub(message,0,string.find(message," ")-1))
    y = tonumber(string.sub(message,string.find(message," ")+1,string.len(message)))
    if y == 0 then 
        map[x] = {}
        --table.insert(map,x,{})
        print("mined "..x.." "..y)
    else
        table[x][y] = "mined"
        --table.insert(map[x],y,"mined")
        print("mined "..x.." "..y)
    end

elseif protocol == "info" then
    x = tonumber(string.sub(message,0,string.find(message," ")-1))
    y = tonumber(string.sub(message,string.find(message," ")+1,string.len(message)))
    print(map[x][y])

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