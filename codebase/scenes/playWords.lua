--======================================================================--
--== Play Words Scene - a Composer Scene
--== Shows gameplay for Word-play game type
--======================================================================--

--======================================================================--
--== Scene Setup
--== Load Composer settings and local forward references
--======================================================================--

---- Local forward references and require files
local composer = require( "composer" )
local scene = composer.newScene()

local gd = require( "globalData" )
local gfm = require( "globalFunctionsMap" )

local Letter = require("classes.letterClass")
local Word = require("classes.wordClass")
local Child = require("classes.childClass")
local Text = require("classes.textClass")
local Countdown = require("classes.countdownClass")

local mainLetter = ""
local mainWord = ""
local mainCountDown = ""

--======================================================================--
--== Scene functions
--======================================================================--

--== create()
function scene:create( event )
      local sceneGroup = self.view
      self.name = "Play Words"

      local bg = display.newImageRect( "assets/img-boardBg.png", 1920, 1080 )
      bg.x = display.contentWidth/2
      bg.y = display.contentHeight/2
      sceneGroup:insert(bg)
      self.bg = bg

      local mainScore = Text:new()
      self.mainScore = mainScore
      sceneGroup:insert(mainScore.score)

      local mainChild = Child:new({timeUnit = gd.timeUnit})
      sceneGroup:insert(mainChild.image)
      self.mainChild = mainChild

      mainCountDown = Countdown:new{parentScene = sceneGroup, xPos = 70, yPos = 880, height = 800}
end

--TODO: This should be an event triggered to a listener attached to a global session object instead of to the scene.
--== ready()
function scene:ready( event )
      local sceneGroup = self.view
      gd.sessionDetails.score = self.mainScore.score
      gfm.changeScene("scenes."..event.changeTo)
end



--== show()
function scene:show( event )

      local sceneGroup = self.view
      local phase = event.phase

      if ( phase == "will" ) then
            -- Code here runs when the scene is still off screen (but is about to come on screen)
            gd.sessionDetails.currentScene = self

            local event = { name="resetScore", target=self.mainScore.score }
            self.mainScore.score:dispatchEvent( event )
            gd.sessionDetails.score = self.mainScore.score.text


      elseif ( phase == "did" ) then
            -- Code here runs when the scene is entirely on screen
            local event = { name="addNewWord" }
            scene:dispatchEvent( event )

            mainCountDown:start()
      end
end

--TODO: This should be an event triggered to a listener attached to a global session object instead of to the scene.
function scene:loseLife(event)
      print("a life has been lost")
      local event = { name="ready", target=scene, changeTo="score" }
      local timedClosure = function() scene:dispatchEvent( event ) end
      local tm = timer.performWithDelay( 1000, timedClosure, 1 )

end

--== hide()
function scene:hide( event )

      local sceneGroup = self.view
      local phase = event.phase

      if ( phase == "will" ) then
            -- Code here runs when the scene is on screen (but is about to go off screen)

      elseif ( phase == "did" ) then
            -- Code here runs immediately after the scene goes entirely off screen
            print(self.name .. " scene was hidden")

            --Destroy the left over word
            mainWord:destroy()
            mainWord = nil
      end
end


--== destroy()
function scene:destroy( event )

      local sceneGroup = self.view
      -- Code here runs prior to the removal of scene's view
      print(self.name .. " scene got destroyed")

end


--TODO: This should be an event triggered to a listener attached to a global session object instead of to the scene.
-- Called when a key event has been received
local function onKeyEvent( event )
      local answer = ""

      if event.phase == "up" then
            print("The current letter is:", mainLetter)
            print("Letter pressed was:", event.keyName)
            if event.keyName == (mainLetter) then
                  answer = "correct"
            else
                  answer = "incorrect"
            end

            local event = { name="answer", target=mainWord.word, params={answer=answer, scene=scene, mainletter=mainletter} }
            mainWord:answer( event )

            mainLetter = mainWord.letters[mainWord.currentLetterIndex].letter.text

            if scene.mainChild.animating == false then
                  local event = { name="answer", target=scene.mainChild.image, params={answer=answer, scene=scene} }
                  scene.mainChild.image:dispatchEvent( event )
            end
      end

      return false
end

--TODO: This should be an event triggered to a listener attached to a global session object instead of to the scene.
function scene:addNewWord()
      print("adding new word")
      local sceneGroup = self.view

      --This creates a new class object
      local thisWord = Word:new({timeUnit = gd.timeUnit, parentScene = sceneGroup})
      thisWord:updateLocation({xPos= #thisWord.letters*75+75, yPos= display.contentHeight/2})
      mainLetter = thisWord.letters[thisWord.currentLetterIndex].letter.text
      mainWord = thisWord
      print(#thisWord.letters*125)

      local event = { name="reset" }
      mainCountDown.box:dispatchEvent( event )
end

--TODO: This should be an event triggered to a listener attached to a global session object instead of to the scene.
function scene:addNewLetter()
      print("adding new letter")
      local sceneGroup = self.view

      --This creates a new class object
      local thisLetter = Letter:new({timeUnit = gd.timeUnit, parentScene = sceneGroup--[[letters = {"a","s","d","f","j","k","l"}]]})
      thisLetter:updateLocation({xPos= display.contentWidth/2, yPos= display.contentHeight/2})
      mainLetter = thisLetter

      local event = { name="reset" }
      mainCountDown.box:dispatchEvent( event )
end

--TODO: This should be an event triggered to a listener attached to a global session object instead of to the scene.
function scene:correctAnswer()
      print("correct answer!")
      timer.pause(mainCountDown.timer)

      local timer = timer.performWithDelay( gd.timeUnit*3, function()
            local event = { name="addNewWord" }
            self:dispatchEvent( event )
            timer.resume(mainCountDown.timer)
      end )

      local event = { name="increaseScore", target=self.mainScore.score }
      self.mainScore.score:dispatchEvent( event )
end

--======================================================================--
--== Scene event function listeners
--======================================================================--
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "ready", scene )

-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )
scene:addEventListener( "addNewLetter", self)
scene:addEventListener( "addNewWord", self)
scene:addEventListener( "correctAnswer", self)
scene:addEventListener( "loseLife", self)

--======================================================================--

return scene
