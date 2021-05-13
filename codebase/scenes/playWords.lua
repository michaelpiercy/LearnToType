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

function scene:reset()
      --Create a new word to start
      local event = { name="addNewWord", target = self  }
      mainWord = scene:dispatchEvent( event )

      --Set the letter from the new word
      mainLetter = mainWord.letters[mainWord.currentLetterIndex].letter.text

      --Reset and start the timer
      local event = { name="reset" }
      mainCountDown.box:dispatchEvent( event )
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
            self:reset()
            mainCountDown:start()
            Runtime:addEventListener( "key", onKeyEvent )

      end
end

--TODO: This should be an event triggered to a listener attached to a global session object instead of to the scene.
function scene:gameOver(event)
      print("gameOver")
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
            print(Runtime:removeEventListener( "key", onKeyEvent ))

      end
end

--== destroy()
function scene:destroy( event )

      local sceneGroup = self.view
      -- Code here runs prior to the removal of scene's view
      print(self.name .. " scene got destroyed")

end

--TODO: This should be an event triggered to a listener attached to a global session object instead of to the scene.
function scene:correctAnswer()
      print("correct answer!")
      timer.pause(mainCountDown.timer)

      local timer = timer.performWithDelay( gd.timeUnit*3, function()
            self:reset()
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
scene:addEventListener( "addNewLetter", gfm.addNewLetter)
scene:addEventListener( "addNewWord", gfm.addNewWord)
scene:addEventListener( "correctAnswer", self)
scene:addEventListener( "gameOver", self)

--======================================================================--

return scene
