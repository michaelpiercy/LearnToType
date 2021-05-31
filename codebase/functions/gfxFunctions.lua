-- Pseudo-global space
-- Require into other files as such:
-- local gfx = require( "functions.gfxFunctions" )
-- Graphics Functions table is used to store functions that are useful in multiple files across the game.
-- These functions are mapped in the globalFunctionsMap file.
-- Useful for porting to other systems.

local gd = require( "globalData" )

local gfxFunctions = {
   drawImage = function(imageFile, width, height, sceneGroup, posX, posY)

      local newImage = display.newImageRect( imageFile, width, height )
      newImage.anchorX, newImage.anchorY = 0.5, 0.5
      newImage.x = posX
      newImage.y = posY
      sceneGroup:insert(newImage)
      return newImage

   end,

   drawText = function(args)
      local newText = display.newText( args.copy or "", 0, 0, "assets/Winter Snow.ttf", args.fontsize or 19 )
      --local color = {r = args.color.r or 1, g = args.color.g or 0, b = args.color.b or 0}
      local color = args.color or {r = 1, g = 0, b = 0}
      newText:setFillColor(color.r, color.g, color.b)
      newText.x, newText.y = args.xPos or gd.w * 0.5, args.yPos or gd.h * 0.5
      args.parentScene:insert( newText )

      return newText

   end
}

return gfxFunctions
