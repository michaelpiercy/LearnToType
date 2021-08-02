--======================================================================--
--== Score Scene - a Composer Scene
--== Shows score and option to return to title scene
--======================================================================--

--======================================================================--
--== Scene Setup
--== Load Composer settings and local forward references
--======================================================================--

---- Local forward references, require files and classes
local composer = require( "composer" )
local scene = composer.newScene()

local gd = require( "globalData" )
local gfm = require( "globalFunctionsMap" )

local Child = require("classes.actionClass")

--======================================================================--
--== Scene functions
--======================================================================--

--== Composer Scene create()
function scene:create( event )

   local sceneGroup = self.view

   -- Assign scene name
   self.name = "Score"

   --Draw Background Image
   self.bg = gfm.drawImage("assets/img-boardBg.png", 1920, 1080, sceneGroup, gd.w/2, gd.h/2)


   --Draw Scene Instruction Text
   self.score = gfm.drawText{
      copy = "Your Score: " .. gd.sessionDetails.score.text,
      parentScene = sceneGroup,
      xPos = gd.w/2,
      yPos = gd.h/3,
      fontsize = 100,
      color = {r=1,  g=1, b=1}
   }

   --Draw Girl Image
   self.girl = Child:new({parentScene = sceneGroup, type="boy", direction=1})
   self.girl.image.x = gd.w/2
   self.girl.image.y = gd.h/1.75

   --Add a touch function to the Girl image
   --This function is triggered when the image is touched
   --Event Listener is added when the scene is shown
   function self.girl:touch(event)

      if event.phase == "ended" then

         --Trigger ready event to move scene to Play Words game
         local event = { name="ready", target=scene, changeTo="title" }
         local timedClosure = function() scene:dispatchEvent( event ) end
         local tm = timer.performWithDelay( 1000, timedClosure, 1 )

         --Set Image Sequence
         local event = { name="selected", params={selected = "excellent"} }
         self.image:dispatchEvent( event )

      end

   end

   --Draw Girl Text
   self.wordGameText = gfm.drawText{
      copy = "Play again",
      parentScene = sceneGroup,
      xPos = self.girl.image.x,
      yPos = self.girl.image.y+self.girl.image.height/1.75,
      fontsize = 30,
      color = {r=1,  g=1, b=1}
   }

end

--== Composer Scene show()
function scene:show( event )

   local phase = event.phase

   if ( phase == "will" ) then

      --Assign the scene
      gd.sessionDetails.currentScene = self
      gd.isGameOver = true
      gd.isGameRunning = false

      --Set Girl Image Sequence
      local event = { name="selected", params={selected = "question"} }
      self.girl.image:dispatchEvent( event )

      --Set score text to session score
      self.score.text = "Your Score: " .. gd.sessionDetails.score.text

   elseif ( phase == "did" ) then

      --Add Event Listener to Image
      --Event Listener is removed when the scene is hidden
      self.girl.image:addEventListener("touch", self.girl)

   end
end

--== Composer Scene hide()
function scene:hide( event )

   local phase = event.phase

   if ( phase == "will" ) then

      --Remove Event Listeners
      self.girl.image:removeEventListener("touch", self.girl)

   elseif ( phase == "did" ) then

      print(self.name .. " scene was hidden")

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

   gfm.changeScene("scenes."..event.changeTo)

end

--======================================================================--
--== Scene event function listeners
--======================================================================--
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "ready", scene )

--======================================================================--

return scene
