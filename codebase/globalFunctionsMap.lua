-- Pseudo-global space
-- Require into other files as such:
-- local gf = require( "globalFunctions" )
-- Global Functions table provides convenient access to functions across multiple files.
-- Functions files should be stored in relevant directories and this table should in turn map/govern their access.

local gd = require( "globalData" )
local gsf = require("functions.gsFunctions")
local gfx = require("functions.gfxFunctions")


local globalFunctionsMap = {

    resetGlobalData     = gsf.resetGlobalData,
    initRequest         = gsf.initRequest, -- Send request details to GameSparks to register this players details in session.
    handleFinishGame    = gsf.handleFinishGame, -- Handler function to determin game outcomes and what to do when one is reached.
    drawImage           = gfx.drawImage,
    drawText            = gfx.drawText,
    changeScene         = gsf.changeScene, -- Change Composer Scene
    matchData           = gsf.getMatchResults

}
return globalFunctionsMap
