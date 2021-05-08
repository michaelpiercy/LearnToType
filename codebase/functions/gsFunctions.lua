-- Pseudo-global space
-- Require into other files as such:
-- local gsf = require( "gsFunctions" )
-- Game State Functions table is used to store key-value pairs that are useful in multiple files across the game.
-- These functions are referenced in the globalFunctions file.

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
        print("RESETTING DATA")
        --TODO: List keys and their values that need to be reset. These should be housed in Global Data table.
    end
}

return gsFunctions
