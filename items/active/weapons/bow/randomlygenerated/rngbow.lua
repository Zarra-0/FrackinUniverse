require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/items/active/weapons/weapon.lua"
require "/scripts/FRHelper.lua"

function init()
  animator.setGlobalTag("paletteSwaps", config.getParameter("paletteSwaps", ""))
  activeItem.setCursor("/cursors/reticle0.cursor")

  self.weapon = Weapon:new()

  self.weapon:addTransformationGroup("weapon", {0,0}, 0)

  local primaryAbility = getPrimaryAbility()
  self.weapon:addAbility(primaryAbility)

  local secondaryAttack = getAltAbility(self.weapon.elementalType)
  if secondaryAttack then
    self.weapon:addAbility(secondaryAttack)
  end

  self.bowMastery = 1 + status.stat("bowMastery")

  self.weapon:init()
end

function update(dt, fireMode, shiftHeld)
  --*************************************
  -- FU/FR ADDONS
  if not self.species or not self.species:succeeded() then
    self.species = world.sendEntityMessage(activeItem.ownerEntityId(), "FR_getSpecies")
  end
  if not self.helper and self.species:succeeded() then
    self.helper = FRHelper:new(self.species:result())
    self.helper:loadWeaponScripts("bow-update")
  end

  if self.helper then
    self.helper:clearPersistent()
    self.helper:runScripts("bow-update", self, dt, fireMode, shiftHeld)
  end

  if self.bowMastery > 1 then
    self.bowMasteryHalved = ((self.bowMastery -1) / 2) + 1
        status.setPersistentEffects("bowbonus", {
          {stat = "critChance", amount = 2 * self.bowMastery},
          {stat = "critDamage", amount = 7 * self.bowMastery},
          {stat = "bowDrawTimeBonus", amount = 0.01 * self.bowMasteryHalved},
          {stat = "bowEnergyBonus", amount = 1 * self.bowMasteryHalved},
          {stat = "powerMultiplier", effectiveMultiplier = 1 * self.bowMasteryHalved}
        })
        mcontroller.controlModifiers({speedModifier = 1 + (self.bowMastery / 16)})
  end

  --**************************************
  self.weapon:update(dt, fireMode, shiftHeld)
  --*************************************
  -- FU/FR ADDONS
  --if not self.species or not self.species:succeeded() then
  --  self.species = world.sendEntityMessage(activeItem.ownerEntityId(), "FR_getSpecies")
  --end

  --setupHelper(self, "bow-update")
  --if self.helper then
  --  self.helper:loadWeaponScripts("bow-update")
  --end
  --**************************************

end

function uninit()
  cancelEffects(true)
  self.weapon:uninit()
end

function cancelEffects(fullClear)
  status.clearPersistentEffects("bowbonus")
end