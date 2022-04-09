require "/scripts/util.lua"
require "/quests/scripts/questutil.lua"

function init()
end

function questInteract(entityId)
end

function questStart()
end

function update(dt)
  quest.setCanTurnIn(true)
end

function questComplete()
  questutil.questCompleteActions()

	player.startQuest("fu_outpost")
	player.startQuest("fu_scienceoutpost")

	player.startQuest("combatmaneuvering1")
	player.startQuest("longjump0")
	player.startQuest("fudistortionsphere")

	player.giveItem("craftingfarm")
	player.giveItem("craftingfurnace")
	player.giveItem("prototyper")
	player.giveItem("fu_stldrive")
	player.addCurrency("fuscienceresource", 1200)

  player.addTeleportBookmark(config.getParameter("outpostBookmark"))--outpost bookmark
  player.addTeleportBookmark(config.getParameter("outpostBookmark2"))--science outpost bookmark

  player.upgradeShip(config.getParameter("shipUpgrade"))
  player.setUniverseFlag("outpost_mission1")
end
