-- Pseudo-global space
-- Require into other files as such:
-- local gsf = require( "functions.gsFunctions" )
-- Game State Functions table is used to store functions that are useful in multiple files across the game.
-- These functions are mapped in the globalFunctionsMap file.
-- Useful for porting to other systems.

local gd = require( "globalData" )
local composer = require( "composer" )

local gsFunctions = {}
gsFunctions = {

   changeScene = function(scene, effect, time, params)
      local options = {
         effect = effect or "crossFade",
         time = time or 1000,
         params = params or {}
      }
      composer.gotoScene( scene, options )
   end,

   resetGlobalData = function()

      print("Resetting data back to defaults")
      package.loaded["globalData"] = nil
      return require( "globalData" )

   end
}

return gsFunctions
