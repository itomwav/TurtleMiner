local params = {...}

if params[1] then
    branch = params[1]
else
    branch = "main"
end

function get(file)
shell.run("rm", file)
shell.run("wget", "https://github.com/itomwav/TurtleMiner/raw/"..branch.."/"..file)
end

if turtle then 
    get("miner.lua") --Turtle 
elseif pocket then
    get("tablet.lua") --Tablet
else 
    get("server.lua") --Server
end

os.reboot()