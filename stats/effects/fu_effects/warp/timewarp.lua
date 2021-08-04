function init()
	if not world.entityType(entity.id()) then delayInit=true return end
	script.setUpdateDelta(1)
	self.worldData=self.worldData or {}
	self.worldData[world.type()]=true
	self.rescuePosition = mcontroller.position()
	self.resources={}
	self.lockedResources={}
	local configuredResources=root.assetJson("/player.config:statusControllerSettings.resources")
	for k,v in pairs(configuredResources) do
		self.resources[k]=status.resource(k)
		if status.resourceLocked(k) then self.lockedResources[k]=true end
	end
	self.facing=mcontroller.rotation()
	self.velocity={mcontroller.xVelocity(),mcontroller.yVelocity()}
end

function update(dt)
	if delayInit then
		teleported=true
		delayInit=false
		effect.expire()
	end
end

function uninit()
	if teleported then return end
	for k,v in pairs(self.resources) do
		status.setResource(k,v)
		if self.lockedResources[k] then status.setResourceLocked(k,true) end
	end
	mcontroller.setPosition(self.rescuePosition)
	mcontroller.setRotation(self.facing)
	mcontroller.setVelocity(self.velocity)
end