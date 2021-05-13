local Word = require("classes.wordClass")
local Letter = require("classes.letterClass")
local gd = require( "globalData" )

local letterFunctions = {}

letterFunctions.addNewLetter = function(event)
      print("adding new letter")
      local self = event.target
      local sceneGroup = self.view

      --This creates a new letter object
      local thisLetter = Letter:new({timeUnit = gd.timeUnit, parentScene = sceneGroup--[[letters = {"a","s","d","f","j","k","l"}]]})
      thisLetter:updateLocation({xPos= display.contentWidth/2, yPos= display.contentHeight/2})

      return thisLetter

end

letterFunctions.addNewWord = function(event)
      print("adding new word")
      local self = event.target
      local sceneGroup = self.view

      --This creates a new word object
      local thisWord = Word:new({timeUnit = gd.timeUnit, parentScene = sceneGroup})
      thisWord:updateLocation({xPos= #thisWord.letters*75+75, yPos= display.contentHeight/2})

      print(#thisWord.letters*125)
      return thisWord
end

return letterFunctions
