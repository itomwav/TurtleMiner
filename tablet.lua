rednet.open("back")

function printHeading()
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.setCursorPos(2,2)
term.clearLine()
paintutils.drawLine(2,2,23,2,colors.white)
term.setCursorPos(3,2)
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
print(" "..mode.." ")
term.setCursorPos(25,2)
term.setBackgroundColor(colors.red)
term.setTextColor(colors.white)
print("X")

end

function customButton(content,y)
term.setCursorPos(2,y)
term.setBackgroundColor(colors.gray)
term.setTextColor(colors.white)
term.clearLine()
term.setCursorPos(2,y)
print(content)
buttons[y] = content
end

function drawPixel(xx,yy)


if xx-1 > #map then
	status = nil
else -- wenn es im möglichen Bereich ist:
	if yy-11 == 0 then
		if string.find(tostring(map[xx-1]),"table") then
		status = "mined"
		else
		status = map[xx-1]
		end
	else
		status = map[xx-1][yy-11]
	end
end
		
if status == nil then
	paintutils.drawPixel(xx,yy,colors.gray)
end
if status == "mining" then
	paintutils.drawPixel(xx,yy,colors.orange)
end
if status == "mined" then
	paintutils.drawPixel(xx,yy,colors.green)
end	
end

function updateScreen()

	rednet.send(4,"complete","info")
	id,map,protocol = rednet.receive("infoBack")
	
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.white)
	for i=2,25 do
	for j=4,19 do
	
		drawPixel(i,j)
		
	end
	end

end

mode = "menu"
loop = true
buttons = {}

while true do
loop = true
output = ""
while loop do 

	keyinput = false
	inputNeeded = true

	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.white)
	term.clear()
	term.setCursorBlink(false)
	keyinput = false
	buttons = {}
	printHeading()

	if mode == "menu" then
		customButton("map",4)
		customButton("table",6)
		customButton("reactor",8)
	end

	if mode == "reactor" then
		rednet.send(4,"getReactorStats","5")
		local id,message,protocol = rednet.receive("5")
		energyProduced = tonumber(string.sub(message,0,string.find(message," ")-1))
		energyChanged = tonumber(string.sub(message,string.find(message," ")+1,string.find(message," ",string.find(message," ")+1)))
		energyOutputted = tonumber(string.sub(message,string.find(message," ",string.find(message," ")+1)+1,string.len(message)))
		paintutils.drawBox(2,4,10,6,colors.lightGray)    -- reactor
		paintutils.drawBox(2,16,10,18,colors.lightGray)  -- battery
		paintutils.drawBox(15,10,20,12,colors.lightGray) -- output
		term.setBackgroundColor(colors.lightGray)
		term.setTextColor(colors.black)
		term.setCursorPos(3,5)
		print("reactor")
		term.setCursorPos(3,17)
		print("battery")
		term.setCursorPos(16,11)
		print("grid")

		paintutils.drawLine(6,8,6,14,colors.gray)
		paintutils.drawLine(6,11,13,11,colors.gray)

		reactorX1 = {}
		reactorY1 = {}
		reactorX2 = {}
		reactorY2 = {}

		if energyProduced > 10 then --reactor
		for i=1,4 do
			reactorX1[i] = 6
			reactorY1[i] = i+7
		end
		end
		if energyOutputted > 10 then --grid
			for i=5,11 do
				reactorX1[i] = i+2
				reactorY1[i] = 11
			end
		end
		if energyChanged < 10 then --from battery
			for i=1,4 do
				reactorX2[i] = 6
				reactorY2[i] = 15-i
			end
		end
		if energyChanged > 10 then --to battery
			for i=5,7 do
				reactorX2[i] = 6
				reactorY2[i] = i+7
			end
		end
	while true do
	for i=1,16 do
		if reactorX1[i] then paintutils.drawPixel(reactorX1[i],reactorY1[i],colors.blue) end
		if reactorX2[i] then paintutils.drawPixel(reactorX2[i],reactorY2[i],colors.blue) end
		if reactorX1[i-3] then paintutils.drawPixel(reactorX1[i-3],reactorY1[i-3],colors.gray) end
		if reactorX2[i-3] then paintutils.drawPixel(reactorX2[i-3],reactorY2[i-3],colors.gray) end
	os.sleep(0.01)
	end
end
end

	if mode == "map" then
		updateScreen()
	end

	if mode == "create" then
		term.setCursorPos(2,4)
		term.setBackgroundColor(colors.red)
		term.setTextColor(colors.white)
		print("discard")
		term.setCursorPos(2,6)
		term.setBackgroundColor(colors.green)
		term.setTextColor(colors.white)
		print("create")
	end

	if mode == "loaded" then
		inputNeeded = false
		mode = "map"
	end

	if mode == "table" then
		keyinput = true
		term.setCursorPos(2,4)
		term.setBackgroundColor(colors.black)
		term.setTextColor(colors.white)
		term.clearLine()
		paintutils.drawLine(2,4,12,4,colors.gray)
		term.setBackgroundColor(colors.blue)
		term.setCursorPos(14,4)
		print("Send")
		term.setCursorPos(2,4)
		term.setBackgroundColor(colors.gray)
		print(output)
		term.setCursorPos(2+string.len(output),4)
		term.setCursorBlink(true)
	end

	if inputNeeded then
		if keyinput then
		event,button,x,y = os.pullEvent()
		else
		event,button,x,y = os.pullEvent("mouse_click")
		end
	end

	-- Allgemeine Drücker:
	if x==25 and y==2 then
		mode = "menu"
		loop = false
	end

	if buttons[y] then
		mode = buttons[y]
	end

	-- Bestimmte Drücker:

	if mode == "create" then
	if y == 4 then
		mode = "menu"
	end
	if y == 6 then
		rednet.send(4,tableName,"createTable")
		mode = "map"
	end
	end

	if mode == "table" then
		if event == "mouse_click" then
			if y == 4 and x > 13 then
			rednet.send(4,output,"table")
			tableName = output
			local id,message,protocol = rednet.receive("table")
			mode = message
			end
		end
		if event == "key" then
			if button > 1 and button < 12 then
				if button == 11 then
					output = output.."0"
				else
					output = output..(button-1)
				end
			end
			if button > 15 and button < 51 then
				if button == 42 then
				elseif button == 28 then
					typing = 0
				else
				output = output..tostring(keys.getName(button))
				end
			end
			if button == 57 then 
				output = output.." "
			end
			if button == 14 then
				output = string.sub(output,1,string.len(output)-1)
			end
		end

	end

	if mode == "map" then 
		
		if x>=2 and x<=25 and y>=4 and y<=19 then
			
			if button == 1 then
			    rednet.send(4,(x-1).." "..(y-11),"req")
			    os.sleep(0.5)
			    updateScreen()
			elseif button == 2 then
			    rednet.send(4,(x-1).." "..(y-11),"mined")
			    os.sleep(0.5)
			    updateScreen()
			end
				
		end
			
	end
	
end

end

os.sleep(20)