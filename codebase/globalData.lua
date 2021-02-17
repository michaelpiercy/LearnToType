-- Pseudo-global space
-- Require into other files as such:
-- local gd = require( "globalData" )
-- Global Data table is convenient place to store key value pairs that are useful to ave access to from various files across the game.
-- These variables can be altered for the current gaming session and will return to their hard-coded values when the game is restarted.

local globalData = {
    gameTitle               = "Learn to Type",
    gameVersion             = "0.1.0",
    gameDetails             = {},
    isGameRunning           = false,
    isGameOver              = false,
    sessionDetails          = {},
    w                       = display.actualContentWidth,
    h                       = display.actualContentHeight
}

return globalData
