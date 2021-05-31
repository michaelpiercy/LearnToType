-- Pseudo-global space
-- Require into other files as such:
-- local gd = require( "globalData" )
-- Global Data table is convenient place to store key value pairs that are useful to ave access to from various files across the game.
-- These variables can be altered for the current gaming session and will return to their hard-coded values when the game is restarted.

local globalData = {

   gameDetails             = {
      title               = "Learn to Type",
      version             = "1.0.0",
   },
   isGameRunning           = false,
   isGameOver              = false,
   sessionDetails          = {
      currentScene={},
      score="0",
      mode="None Yet",
      mainLetter={},
      mainWord={},
      mainCountDown={}
   },
   w                       = display.actualContentWidth,
   h                       = display.actualContentHeight,
   timeUnit                = 500
}

return globalData
