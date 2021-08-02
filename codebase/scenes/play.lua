--======================================================================--
--== Play Scene - a Composer Scene
--== Shows gameplay for Word and Letter game types
--== A word or letter and a countdown bar appear on screen.
--== Player must type the corresponding letters before the bar
--== runs out. Get a word or letter correct and the bar resets.
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

local PopupChild = require("classes.childClass")
local Score = require("classes.scoreClass")
local Countdown = require("classes.countdownClass")

--======================================================================--
--== Scene functions
--======================================================================--

--== Composer Scene create()
function scene:create( event )

   local sceneGroup = self.view

   -- Assign scene name
   self.name = "Play"

   --Draw Background Image
   self.bg = gfm.drawImage("assets/img-boardBg.png", 1920, 1080, sceneGroup, gd.w/2, gd.h/2)

   --Draw Score Text Object
   self.mainScore = Score:new()
   sceneGroup:insert(self.mainScore.score)

   --Draw Popup Child Object
   self.mainChild = PopupChild:new({timeUnit = gd.timeUnit})
   sceneGroup:insert(self.mainChild.image)

   --Set up Countdown Timer Object
   self.mainCountDown = Countdown:new{parentScene = sceneGroup, xPos = 70, yPos = 880, height = 800}
   gd.sessionDetails.mainCountDown = self.mainCountDown

end

--== Composer Scene show()
function scene:show( event )

   local phase = event.phase

   if ( phase == "will" ) then

      --Assign the scene
      gd.sessionDetails.currentScene = self
      gd.isGameOver = false
      gd.isGameRunning = true

      --Trigger Reset Score event
      local event = { name="resetScore", target=self.mainScore.score }
      self.mainScore.score:dispatchEvent( event )
      gd.sessionDetails.score = self.mainScore.score.text

   elseif ( phase == "did" ) then

      --Ready to play
      --Add a new letter/word and start countdown.
      self:reset()
      self.mainCountDown:start()

      --Add a key touch listener to Runtime
      --This event is triggered when a key is touched
      --Event Listener is removed when the scene is hidden
      Runtime:addEventListener( "key", gfm.onKeyEvent )

   end

end

--== Composer Scene hide()
function scene:hide( event )

   local phase = event.phase

   if ( phase == "did" ) then

      print(self.name .. " scene was hidden")

      --Remove key touch event listener
      Runtime:removeEventListener( "key", gfm.onKeyEvent )

      if gd.sessionDetails.mode == "Word" then

         --Destroy the left over word
         self.mainWord:destroy()
         self.mainWord = nil

      else

         self.mainLetter:destroy()
         self.mainLetter = nil

      end

   end

end

--== Composer Scene destroy()
function scene:destroy( event )

   print(self.name .. " scene got destroyed")

end

--== ready()
--== Parameters: event object
--== This function is called by an event listener
--== Purpose: Define what to do when the scene is ready to move on
function scene:ready( event )

   gd.sessionDetails.score = self.mainScore.score
   gfm.changeScene("scenes."..event.changeTo)

end

--== reset()
--== Parameters: optional
--== This function is after the scene shows
--== Purpose: Reset timer, word or letter objects depending on session mode
function scene:reset()

   if gd.sessionDetails.mode == "Word" then

      --Create a new word to start and set as mainWord
      local event = { name="addNewWord", target = self  }
      self.mainWord = self:dispatchEvent( event )
      gd.sessionDetails.mainWord = self.mainWord

      --Set the letter from the new word as mainLetter
      self.mainLetter = self.mainWord.letters[self.mainWord.currentLetterIndex]
      gd.sessionDetails.mainLetter = self.mainLetter

   else

      --Create a new letter and set as mainLetter
      local event = { name="addNewLetter", target = self  }
      self.mainLetter = self:dispatchEvent( event )
      gd.sessionDetails.mainLetter = self.mainLetter

   end

   --Reset and start the timer
   local event = { name="reset" }
   self.mainCountDown.box:dispatchEvent( event )

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
