function get(file)
shell.run("rm", file..".lua")
shell.run("wget", "https://github.com/itomwav/Test/raw/main/"..file)
end

get(miner)