rednet.open("back")

function drawPixel(xx,yy)
	rednet.send(4,(xx-1).." "..(yy-11),"info")
id,status,protocol = rednet.receive("infoBack")
		
if status == "nil" then
	paintutils.drawPixel(xx,yy,colors.gray)
end
if status == "mining" then
	paintutils.drawPixel(xx,yy,colors.orange)
end
if status == "mined" then
	paintutils.drawPixel(xx,yy,colors.green)
end	
end

function drawMap()

mode = "map"
	
term.clear()
for i=2,25 do
for j=3,19 do
drawPixel(i,j)		
os.sleep(0.05)
end
end

end

drawMap()


while true do 

	local event,button,x,y = os.pullEvent("mouse_click")
	
	if mode == "map" then 
		
		if x>=2 and x<=25 and y>=3 and y<=19 then
			
			if button == 1 then
			    rednet.send(4,(x-1).." "..(y-11),"req")
			    os.sleep(0.5)
			    drawPixel(x,y)
			elseif button == 2 then
			    rednet.send(4,(x-1).." "..(y-11),"mined")
			    os.sleep(0.5)
			    drawPixel(x,y)
			end
				
		end
			
	end
	
end

os.sleep(20)