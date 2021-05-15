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

   --Draw Background Image
   local bg = display.newImageRect( "assets/img-boardBg.png", 1920, 1080 )
   bg.x = display.contentWidth/2
   bg.y = display.contentHeight/2
   sceneGroup:insert(bg)
   self.bg = bg

   --Draw Scene Instruction Text
   local score = gfm.drawText{
      copy = "Your Score: " .. gd.sessionDetails.score.text,
      parentScene = sceneGroup,
      xPos = gd.w/2,
      yPos = gd.h/3,
      fontsize = 100,
      color = {r=1,  g=1, b=1}
   }
   self.score = score

   --Draw Girl Image
   local girl = Child:new({parentScene = sceneGroup, type="boy", direction=1})
   girl.image.x = gd.w/2
   girl.image.y = gd.h/1.75

   --Add a touch function to the Girl image
   --This function is triggered when the image is touched
   --Event Listener is added when the scene is shown
   function girl:touch(event)
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

   --Assign girl object to scene
   self.girl = girl

   --Draw Girl Text
   self.wordGameText = gfm.drawText{
      copy = "Play again",
      parentScene = sceneGroup,
      xPos = girl.image.x,
      yPos = girl.image.y+girl.image.height/1.75,
      fontsize = 30,
      color = {r=1,  g=1, b=1}
   }

end

--== Composer Scene show()
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then

      --Set Boy and Girl Image Sequences
      local event = { name="selected", params={selected = "question"} }
      self.girl.image:dispatchEvent( event )

      --Set score text to session score
      self.score.text = "Your Score: " .. gd.sessionDetails.score.text
   elseif ( phase == "did" ) then

      --Add Event Listener to Image
      self.girl.image:addEventListener("touch", self.girl)
   end
end

--== Composer Scene hide()
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then

      --Remove Event Listeners
      self.girl.image:removeEventListener("touch", self.girl)

   end
end

--== Composer Scene destroy()
function scene:destroy( event )

   local sceneGroup = self.view

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
