local params = {...}

if params[1] then
    if params[1] == "update" then
    shell.run("rm", "update.lua")
    shell.run("wget", "https://github.com/itomwav/TurtleMiner/raw/main/update")
    os.reboot()
    else
    branch = params[1]
    end
else
    branch = "main"
end

function get(file)
shell.run("rm", file)
shell.run("wget", "https://github.com/itomwav/TurtleMiner/raw/"..branch.."/"..file)
end

if turtle then 
    get("turtle/miner.lua") --Turtle 
elseif pocket then
    get("tablet/tablet.lua") --Tablet
else 
    get("computer/server.lua") --Server
end

os.reboot()