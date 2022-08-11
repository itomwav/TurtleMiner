function get(file)
shell.run("rm", file)
shell.run("wget", "https://github.com/itomwav/TurtleMiner/raw/main/"..file)
end

if turtle == nil then --Turtle
get("miner.lua")
elseif pocket then --Tablet
get("tablet.lua")
else --Computer -> Server
get("server.lua")
end