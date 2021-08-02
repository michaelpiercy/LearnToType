local Word = require("classes.wordClass")
local Letter = require("classes.letterClass")
local gd = require( "globalData" )

local letterFunctions = {}

--All functions are called by event listeners.
--Note the assignment format so that they can be mapped in the globalFunctionsMap

--Returns a new letter object
letterFunctions.addNewLetter = function(event)

   local self = event.target
   local sceneGroup = self.view

   --This creates a new letter object
   --Include a letters table to serve custom letters. Eg: letters = {"a","s","d","f","j","k","l"}
   local thisLetter = Letter:new{ timeUnit = gd.timeUnit, parentScene = sceneGroup  }
   thisLetter:updateLocation{ xPos= display.contentWidth/2, yPos= display.contentHeight/2 }

   return thisLetter

end

--Returns a new word object
letterFunctions.addNewWord = function(event)

   local self = event.target
   local sceneGroup = self.view

   --This creates a new word object
   local thisWord = Word:new{ timeUnit = gd.timeUnit, parentScene = sceneGroup }
   thisWord:updateLocation{ xPos= #thisWord.letters*75+75, yPos= display.contentHeight/2 }

   return thisWord

end

-- Called when a key event has been received
letterFunctions.onKeyEvent = function(event)

   local scene = gd.sessionDetails.currentScene
   local mainLetter = gd.sessionDetails.mainLetter
   local mainWord = gd.sessionDetails.mainWord
   local answer = ""

   --Only interested if the key press is finished
   if event.phase == "up" then

      if event.keyName == (mainLetter.letter.text) then
         answer = "correct"
      else
         answer = "incorrect"
      end

      --Pass the answer through an event call depending on game mode.
      if gd.sessionDetails.mode == "Word" then
         local event = { name="answer", target=mainWord.word, params={answer=answer, scene=scene, mainletter=mainLetter} }
         mainWord:answer( event )
         mainLetter = mainWord.letters[mainWord.currentLetterIndex]
      else
         local event = { name="answer", target=mainLetter.letter, params={answer=answer, scene=scene} }
         mainLetter.letter:dispatchEvent( event )
      end

      --Animate the popup child image - only if it's not already animating
      if scene.mainChild.animating == false then
         local event = { name="answer", target=scene.mainChild.image, params={answer=answer, scene=scene} }
         scene.mainChild.image:dispatchEvent( event )
      end

   end

   return false

end

--Called when the correct answer event has been triggered
letterFunctions.correctAnswer = function(event)

   local self = gd.sessionDetails.currentScene
   local mainCountDown = gd.sessionDetails.mainCountDown

   timer.pause(mainCountDown.timer)

   -- Hold a beat before calling reset on the countdown timer
   local resetTimer = timer.performWithDelay( gd.timeUnit*3, function()
      self:reset()
      timer.resume(mainCountDown.timer)
   end )

   --Increase the score and update global data
   local event = { name="increaseScore", target=self.mainScore.score }
   self.mainScore.score:dispatchEvent( event )

   return true

end

--Called When the Game Over event has been triggered
letterFunctions.gameOver = function(event)

   local scene = event.target
   gd.isGameOver = true

   local event = { name="ready", target=scene, changeTo="score" }
   local timedClosure = function() scene:dispatchEvent( event ) end
   local tm = timer.performWithDelay( 1000, timedClosure, 1 )

   return true

end

return letterFunctions
