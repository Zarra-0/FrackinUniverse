require "/scripts/pathutil.lua"

function init()
	if world.type() ~= "unknown" then

	else
		local spawn = vec2.add(object.position(), {1,-3})
		world.setPlayerStart(spawn, true)
		world.setProperty("fu_byos.spawn", spawn)
	end
end
