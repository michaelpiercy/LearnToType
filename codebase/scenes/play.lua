--======================================================================--
--== Play Words Scene - a Composer Scene
--== Shows gameplay for Word and Letter game types
--== A word or letter appears on screen with a countdown bar.
--== Player must type the corresponding letter before the bar
--== runs out. Get a word or letter correct ad the bar resets.
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

local Child = require("classes.childClass")
local Text = require("classes.textClass")
local Countdown = require("classes.countdownClass")
local mainLetter
local mainWord
local mainCountDown

--======================================================================--
--== Scene functions
--======================================================================--

--== Composer Scene create()
function scene:create( event )
   local sceneGroup = self.view

   -- Assign scene name
   self.name = "Play"

   --Draw Background Image
   local bg = display.newImageRect( "assets/img-boardBg.png", 1920, 1080 )
   bg.x = display.contentWidth/2
   bg.y = display.contentHeight/2
   sceneGroup:insert(bg)
   self.bg = bg

   --Draw Score Text Object
   local mainScore = Text:new()
   self.mainScore = mainScore
   sceneGroup:insert(mainScore.score)

   --Draw Score Text Object
   local mainChild = Child:new({timeUnit = gd.timeUnit})
   sceneGroup:insert(mainChild.image)
   self.mainChild = mainChild

   --Set up Countdown Timer Object
   mainCountDown = Countdown:new{parentScene = sceneGroup, xPos = 70, yPos = 880, height = 800}
   gd.sessionDetails.mainCountDown = mainCountDown
end

--== Composer Scene show()
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then

      --Assign the scene
      gd.sessionDetails.currentScene = self

      --Trigger Reset Score event
      local event = { name="resetScore", target=self.mainScore.score }
      self.mainScore.score:dispatchEvent( event )
      gd.sessionDetails.score = self.mainScore.score.text


   elseif ( phase == "did" ) then
      --Ready to play
      --Add a new letter and start countdown.
      self:reset()
      mainCountDown:start()

      --Add a key touch listener to Runtime
      --This function is triggered when a key is touched
      --Event Listener is removed when the scene is hidden
      Runtime:addEventListener( "key", gfm.onKeyEvent )

   end
end

--== Composer Scene hide()
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "did" ) then
      print(self.name .. " scene was hidden")

      --Remove key touch event listener
      Runtime:removeEventListener( "key", gfm.onKeyEvent )

      if gd.sessionDetails.mode == "Word" then
         --Destroy the left over word
         mainWord:destroy()
         mainWord = nil
      else
         mainLetter:destroy()
         mainLetter = nil
      end
   end
end

--== Composer Scene destroy()
function scene:destroy( event )
   local sceneGroup = self.view
   print(self.name .. " scene got destroyed")
end

--== ready()
--== Parameters: event object
--== This function is called by an event listener
--== Purpose: Define what to do when the scene is ready to move on
function scene:ready( event )

   local sceneGroup = self.view
   gd.sessionDetails.score = self.mainScore.score
   gfm.changeScene("scenes."..event.changeTo)
end

--== reset()
--== Parameters: event object
--== This function is after the scene shows
--== Purpose: Reset timer, word or letter objects depending on session mode
function scene:reset()

   if gd.sessionDetails.mode == "Word" then

      --Create a new word to start
      local event = { name="addNewWord", target = self  }
      mainWord = scene:dispatchEvent( event )
      gd.sessionDetails.mainWord = mainWord

      --Set the letter from the new word as mainLetter
      mainLetter = mainWord.letters[mainWord.currentLetterIndex]
      gd.sessionDetails.mainLetter = mainLetter
   else

      --Create a new letter and set as mainLetter
      local event = { name="addNewLetter", target = self  }
      mainLetter = scene:dispatchEvent( event )
      gd.sessionDetails.mainLetter = mainLetter
   end

   --Reset and start the timer
   local event = { name="reset" }
   mainCountDown.box:dispatchEvent( event )
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
scene:addEventListener( "correctAnswer", gfm.correctAnswer)
scene:addEventListener( "gameOver", gfm.gameOver)

--======================================================================--

return scene
