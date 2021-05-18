function init()
  self.recipes = config.getParameter("recipes")
  self.swingTime = config.getParameter("swingTime")
  activeItem.setArmAngle(-math.pi / 2)
end

function update(dt, fireMode, shiftHeld)
  updateAim()

  if not self.swingTimer and fireMode == "primary" and player then
    checkRecipes()
    self.swingTimer = self.swingTime
  end

  if self.recipePass then
    if self.swingTimer then
      self.swingTimer = math.max(0, self.swingTimer - dt)

      activeItem.setArmAngle((-math.pi / 2) * (self.swingTimer / self.swingTime))

      if self.swingTimer == 0 then
        learnBlueprint()
      end
    end
  end
end

function learnBlueprint()
  if checkRecipes() then
    for _,recipe in pairs(self.recipes) do
      player.giveBlueprint(recipe)
    end
    animator.playSound("learnBlueprint")
    item.consume(1)
  else
    return
  end
end

function checkRecipes()
  for _,itemName in pairs(self.recipes) do
    if not player.blueprintKnown(itemName) then
      self.recipePass = true
      return true
    end
  end
  self.recipePass = false
  return false
end

function updateAim()
  self.aimAngle, self.aimDirection = activeItem.aimAngleAndDirection(0, activeItem.ownerAimPosition())
  activeItem.setFacingDirection(self.aimDirection)
end
