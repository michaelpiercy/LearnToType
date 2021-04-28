--======================================================================--
--== Play ~Words Scene - a Composer Scene
--== Shows gameplay for Words game type
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
local Word = require("classes.wordClass")
local Child = require("classes.childClass")
local Text = require("classes.textClass")
local Countdown = require("classes.countdownClass")

local mainLetter = "" --Should do to GlobalData
local mainWord = ""
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
  local bg = display.newImageRect( "assets/img-boardBg.png", 1920, 1080 )
  bg.x = display.contentWidth/2
  bg.y = display.contentHeight/2
  sceneGroup:insert(bg)

  mainScore = Text:new()
  sceneGroup:insert(mainScore.score)

  mainChild = Child:new({timeUnit = gd.timeUnit})
  sceneGroup:insert(mainChild.image)

  mainCountDown = Countdown:new(params)
  sceneGroup:insert(mainCountDown.frame)
end

--== ready()
function scene:ready( event )
  local sceneGroup = self.view
  gd.sessionDetails.score = mainScore.score
  gfm.changeScene("scenes."..event.changeTo)
end



--== show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    gd.sessionDetails.currentScene = self
    composer.removeHidden()

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    local event = { name="addNewWord" }
    scene:dispatchEvent( event )

    mainCountDown:start()
  end
end

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

            if mainChild.animating == false then
                  local event = { name="answer", target=mainChild.image, params={answer=answer, scene=scene} }
                  mainChild.image:dispatchEvent( event )
            end
      end

      return false
end

function scene:addNewWord()
      print("adding new word")
      local sceneGroup = self.view


      --This creates a new class object
      local thisWord = Word:new({timeUnit = gd.timeUnit, parentScene = sceneGroup --[[words = {"a","s","d","f","j","k","l"}]]})
      print(#thisWord.letters*125)
      thisWord:updateLocation({xPos= #thisWord.letters*75+75, yPos= display.contentHeight/2})
      mainLetter = thisWord.letters[thisWord.currentLetterIndex].letter.text
      mainWord = thisWord
      --sceneGroup:insert(thisWord)

      print("mainleter", mainLetter)
      local event = { name="reset" }
      mainCountDown.box:dispatchEvent( event )
end

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

function scene:correctAnswer()
      print("correct answer!")
      timer.pause(mainCountDown.timer)

      local timer = timer.performWithDelay( gd.timeUnit*3, function()
            local event = { name="addNewWord" }
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
scene:addEventListener( "ready", scene )

-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )
scene:addEventListener( "addNewLetter", self)
scene:addEventListener( "addNewWord", self)
scene:addEventListener( "correctAnswer", self)
scene:addEventListener( "loseLife", self)

--======================================================================--

return scene
