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
local gd = require( "globalData" )
local gfm = require( "globalFunctionsMap" )
local scene = composer.newScene()

local Letter = require("classes.letterClass")
local Child = require("classes.childClass")
local Text = require("classes.textClass")
local Countdown = require("classes.countdownClass")

local mainLetter = "" --Should do to GlobalData
local mainChild = "" --Should do to GlobalData
local mainScore = "" --Should do to GlobalData
local mainCountDown = "" --Should do to GlobalData
local timeUnit = 500 --Should do to GlobalData

--======================================================================--
--== Scene functions
--======================================================================--


--== create()
function scene:create( event )
  -- Code here runs when the scene is first created but has not yet appeared on screen
  local sceneGroup = self.view
  local bg = display.newImageRect( "assets/img-boardBg.png", 3377, 1462 )
  bg.x = display.contentWidth/2
  bg.y = display.contentHeight/2
  bg:scale(0.5, 0.5)
  sceneGroup:insert(bg)

  mainScore = Text:new(params)
  mainChild = Child:new({timeUnit = timeUnit})
  mainCountDown = Countdown:new(params)

end

--== ready()
function scene:ready( event )
  local sceneGroup = self.view

end



--== show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    local event = { name="addNewLetter" }
    scene:dispatchEvent( event )

    mainCountDown:start()
  end
end


--== hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)

  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen

  end
end


--== destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view

end


-- Called when a key event has been received
local function onKeyEvent( event )
      local answer = ""
      if event.phase == "up" then
            if mainChild.animating == false then
                  if event.keyName == (mainLetter.letter.text) then
                        answer = "correct"
                  else
                        answer = "incorrect"
                  end

                  local event = { name="answer", target=mainLetter.letter, params={answer=answer, scene=scene} }
                  mainLetter.letter:dispatchEvent( event )

                  local event = { name="answer", target=mainChild.image, params={answer=answer, scene=scene} }
                  mainChild.image:dispatchEvent( event )

            end
      end

      return false
end

function scene:addNewLetter()
      print("adding new letter")

      --This creates a new class object
      local thisLetter = Letter:new({timeUnit = timeUnit, --[[letters = {"a","s","d","f","j","k","l"}]]})
      thisLetter:updateLocation({xPos= display.contentWidth/2, yPos= display.contentHeight/2})
      mainLetter = thisLetter

      local event = { name="reset" }
      mainCountDown.box:dispatchEvent( event )
end

function scene:correctAnswer()
      print("correct answer!")
      timer.pause(mainCountDown.timer)

      local timer = timer.performWithDelay( timeUnit*3, function()
            local event = { name="addNewLetter" }
            self:dispatchEvent( event )
            timer.resume(mainCountDown.timer)
      end )

      local event = { name="increaseScore", target=mainScore.score }
      mainScore.score:dispatchEvent( event )
end

--======================================================================--
--== Scene event function listeners
--======================================================================--
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )
scene:addEventListener( "addNewLetter", self)
scene:addEventListener( "correctAnswer", self)
--
--======================================================================--

return scene
