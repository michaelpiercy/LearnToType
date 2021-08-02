-- Pseudo-global space
-- Require into other files as such:
-- local gf = require( "globalFunctions" )
-- Global Functions table provides convenient access to functions across multiple files.
-- Functions files should be stored in relevant directories and this table should in turn map/govern their access.

local gd = require( "globalData" )
local gsf = require("functions.gsFunctions")
local gfx = require("functions.gfxFunctions")
local glf = require("functions.letterFunctions")

local globalFunctionsMap = {

    resetGlobalData     = gsf.resetGlobalData,
    drawImage           = gfx.drawImage,
    drawText            = gfx.drawText,
    changeScene         = gsf.changeScene, -- Change Composer Scene
    addNewLetter        = glf.addNewLetter,
    addNewWord          = glf.addNewWord,
    onKeyEvent          = glf.onKeyEvent,
    correctAnswer       = glf.correctAnswer,
    gameOver            = glf.gameOver
}
return globalFunctionsMap
