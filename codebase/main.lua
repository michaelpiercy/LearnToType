--This sets Potato as a reference to the class file
--local background = require("classes.background")

local Letter = require("classes.letterClass")
local Child = require("classes.childClass")
local Text = require("classes.textClass")
local Countdown = require("classes.countdownClass")

local mainLetter = ""
local mainChild = ""
local mainScore = ""
local mainCountDown = ""
local timeUnit = 500
--space background
local bg = display.newImageRect( "assets/img-boardBg.png", 3377, 1462 )
bg.x = display.contentWidth/2
bg.y = display.contentHeight/2
bg:scale(0.5, 0.5)


mainScore = Text:new(params)
mainChild = Child:new({timeUnit = timeUnit})
mainCountDown = Countdown:new(params)


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

                  local event = { name="answer", target=mainLetter.letter, params={answer=answer} }
                  mainLetter.letter:dispatchEvent( event )

                  local event = { name="answer", target=mainChild.image, params={answer=answer} }
                  mainChild.image:dispatchEvent( event )

            end
      end

      return false
end

local function addNewLetter()
      print("adding new letter")

      --This creates a new class object
      local thisLetter = Letter:new({timeUnit = timeUnit, --[[letters = {"a","s","d","f","j","k","l"}]]})
      thisLetter:updateLocation({xPos= display.contentWidth/2, yPos= display.contentHeight/2})
      mainLetter = thisLetter

      local event = { name="reset" }
      mainCountDown.box:dispatchEvent( event )
end

local function correctAnswer()
      print("correct answer!")
      timer.pause(mainCountDown.timer)

      local timer = timer.performWithDelay( timeUnit*3, function()
            local event = { name="newLetter" }
            Runtime:dispatchEvent( event )
            timer.resume(mainCountDown.timer)
      end )

      local event = { name="increaseScore", target=mainScore.score }
      mainScore.score:dispatchEvent( event )
end


-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )
Runtime:addEventListener( "correctAnswer", correctAnswer)
Runtime:addEventListener( "newLetter", addNewLetter)
local event = { name="newLetter" }
Runtime:dispatchEvent( event )
mainCountDown:start()
