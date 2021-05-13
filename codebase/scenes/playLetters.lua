--======================================================================--
--== Play Scene - a Composer Scene
--== Shows gameplay
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
local Child = require("classes.childClass")
local Text = require("classes.textClass")
local Countdown = require("classes.countdownClass")

local mainLetter = ""
local mainChild = ""
local mainCountDown = ""

--======================================================================--
--== Scene functions
--======================================================================--
-- Called when a key event has been received
local function onKeyEvent( event )
      local answer = ""

      --What happens when a key is pressed
      if event.phase == "up" then
            print("The current letter is:", mainLetter)
            print("Letter pressed was:", event.keyName)
            if event.keyName == (mainLetter.letter.text) then
                  answer = "correct"
            else
                  answer = "incorrect"
            end

            --Trigger letter objects event and give answer
            local event = { name="answer", target=mainLetter.letter, params={answer=answer, scene=scene} }
            mainLetter.letter:dispatchEvent( event )

            --Trigger Pop up child objects event and give answer
            local event = { name="answer", target=scene.mainChild.image, params={answer=answer, scene=scene} }
            scene.mainChild.image:dispatchEvent( event )

      end

      return false
end


--== create()
function scene:create( event )
      local sceneGroup = self.view
      self.name = "Play Letters"

      --Draw Background
      local bg = display.newImageRect( "assets/img-boardBg.png", 1920, 1080 )
      bg.x = display.contentWidth/2
      bg.y = display.contentHeight/2
      sceneGroup:insert(bg)
      self.bg = bg

      --Draw Score Text Object
      local mainScore = Text:new()
      self.mainScore = mainScore
      sceneGroup:insert(mainScore.score)

      --Draw Pop Up Child Image Object
      local mainChild = Child:new({timeUnit = gd.timeUnit})
      sceneGroup:insert(mainChild.image)
      self.mainChild = mainChild

      --Set up Countdown Timer
      self.countDown = Countdown:new{parentScene = sceneGroup, xPos = 70, yPos = 880, height = 800, time=5}
      mainCountDown = self.countDown
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
      local event = { name="addNewLetter", target = self  }
      mainLetter = scene:dispatchEvent( event )

      --Reset and start the timer
      local event = { name="reset" }
      mainCountDown.box:dispatchEvent( event )
end


--== show()
function scene:show( event )

      local sceneGroup = self.view
      local phase = event.phase

      if ( phase == "will" ) then
            gd.sessionDetails.currentScene = self

            --Reset score for a new game
            local event = { name="resetScore", target=self.mainScore.score }
            self.mainScore.score:dispatchEvent( event )
            gd.sessionDetails.score = self.mainScore.score.text

      elseif ( phase == "did" ) then
            --Ready - Add a new letter and start countdown.
            self:reset()
            mainCountDown:start()
            Runtime:addEventListener( "key", onKeyEvent )

      end
end

--TODO: This should be an event triggered to a listener attached to a global session object instead of to the scene.
function scene:gameOver(event)
      print("gameOver")
      --Stop the game and move to the score screen.
      local event = { name="ready", target=scene, changeTo="score" }
      local timedClosure = function() scene:dispatchEvent( event ) end
      local tm = timer.performWithDelay( 1000, timedClosure, 1 )
end


--== hide()
function scene:hide( event )

      local sceneGroup = self.view
      local phase = event.phase

      if ( phase == "will" ) then

      elseif ( phase == "did" ) then
            print(self.name .. " scene was hidden")

            --Destroy the left over letter
            mainLetter:destroy()
            Runtime:removeEventListener( "key", onKeyEvent )

      end
end


--== destroy()
function scene:destroy( event )

      local sceneGroup = self.view
      print(self.name .. " scene got destroyed")

end


--TODO: This should be an event triggered to a listener attached to a global session object instead of to the scene.
function scene:correctAnswer()
      print("correct answer!")
      --Pause the countdown timer
      timer.pause(mainCountDown.timer)

      --Reset Timer and trigger the Add New Letter event.
      local timer = timer.performWithDelay( gd.timeUnit*3, function()
            self:reset()
            timer.resume(mainCountDown.timer)
      end )

      --Add some score for getting it right!
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
scene:addEventListener( "correctAnswer", self)
scene:addEventListener( "gameOver", self)

--======================================================================--

return scene
