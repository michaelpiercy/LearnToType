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

letterFunctions.onKeyEvent = function(event)

   -- Called when a key event has been received
   local scene = gd.sessionDetails.currentScene
   local answer = ""
   local mainLetter = gd.sessionDetails.mainLetter
   local mainWord = gd.sessionDetails.mainWord

   if event.phase == "up" then
      print("The current letter is:", mainLetter.letter)
      print("Letter pressed was:", event.keyName)
      if event.keyName == (mainLetter.letter.text) then
         answer = "correct"
      else
         answer = "incorrect"
      end

      if gd.sessionDetails.mode == "Word" then
         print("here")
         local event = { name="answer", target=mainWord.word, params={answer=answer, scene=scene, mainletter=mainLetter} }
         mainWord:answer( event )
         print("and")
         mainLetter = mainWord.letters[mainWord.currentLetterIndex]
         print("again")
      else
         local event = { name="answer", target=mainLetter.letter, params={answer=answer, scene=scene} }
         mainLetter.letter:dispatchEvent( event )
      end

      if scene.mainChild.animating == false then
         local event = { name="answer", target=scene.mainChild.image, params={answer=answer, scene=scene} }
         scene.mainChild.image:dispatchEvent( event )
      end
   end

   return false
end

letterFunctions.correctAnswer = function(event)

   local self = gd.sessionDetails.currentScene
   local mainCountDown = gd.sessionDetails.mainCountDown
   print("correct Word answer!")

   timer.pause(mainCountDown.timer)

   local timer = timer.performWithDelay( gd.timeUnit*3, function()
      self:reset()
      timer.resume(mainCountDown.timer)
   end )

   local event = { name="increaseScore", target=self.mainScore.score }
   self.mainScore.score:dispatchEvent( event )
end

letterFunctions.gameOver = function(event)
   local scene = event.target
   print("gameOver")
   local event = { name="ready", target=scene, changeTo="score" }
   local timedClosure = function() scene:dispatchEvent( event ) end
   local tm = timer.performWithDelay( 1000, timedClosure, 1 )
end

return letterFunctions
