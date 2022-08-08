rednet.open("left")
term.clear()

map = {}
table.insert(map,1,{})

while true do
local id,message,protocol = rednet.receive()
if protocol == "req" then
    x = tonumber(string.sub(message,0,string.find(message," ")-1))
    y = tonumber(string.sub(message,string.find(message," ")+1,string.len(message)))

    if y == 0 then
        if map[x-1] ~= nil then
        print("mining "..x.." "..y)
        end
    elseif math.abs(y) = 1 then --wegen unsauberer Programmierung
        if map[x] ~= "mining" and map[x] ~= nil then
        print("mining "..x.." "..y)
        end
    elseif y < 0 then
        if map[x][y+1] == "mined" and map[x][y] ~= "mining" then
        print("mining "..x.." "..y)
        end
    elseif y > 0 then
        if map[x][y-1] == "mined" and map[x][y] ~= "mining" then
        print("mining "..x.." "..y)
        end
    end

elseif protocol == "change" then
    x = string.sub(message,0,string.find(message," ")-1)
    y = string.sub(message,string.find(message," ")+1,string.len(message))
    if y == 0 then 
        table.insert(map,x,{})
    else
        table.insert(map[x],y,"mined")
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