--======================================================================--
--== Title Scene - a Composer Scene
--== Shows gameplay options
--== Two options, Letter-play and Word-play.
--======================================================================--

--======================================================================--
--== Scene Setup
--== Load Composer settings and local forward references
--======================================================================--

---- Local forward references, require files and classes
local composer = require( "composer" )
local scene = composer.newScene( )

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
   self.name = "Title"

   --Draw Scene Instruction Text
   self.statusText = gfm.drawText{
      copy = "Choose an option to play",
      parentScene = sceneGroup,
      xPos = gd.w/2,
      yPos = gd.h/6,
      fontsize = 30,
      color = {r=1,  g=1, b=1}
   }

   --Draw Girl Image
   self.girl = Child:new({parentScene = sceneGroup, type="girl", direction=-1})
   self.girl.image.x = gd.w/2-self.girl.image.width/2
   self.girl.image.y = gd.h/2

   --Add a touch function to the Girl image
   --This function is triggered when the image is touched
   --Event Listener is added when the scene is shown
   function self.girl:touch(event)

      if event.phase == "ended" then
         --Set Image Sequence
         local event = { name="selected", params={selected = "sparkle"} }
         self.image:dispatchEvent( event )

         --Trigger ready event to move scene to Play Words game
         local event = { name="ready", target=scene, changeTo="play" }
         local timedClosure = function()
            gd.sessionDetails.mode = "Word"
            scene:dispatchEvent( event )
         end
         local tm = timer.performWithDelay( 1000, timedClosure, 1 )
      end

   end

   --Draw Girl Text
   self.wordGameText = gfm.drawText{
      copy = "WORDS",
      parentScene = sceneGroup,
      xPos = self.girl.image.x,
      yPos = self.girl.image.y+self.girl.image.height/1.5,
      fontsize = 30,
      color = {r=1,  g=1, b=1}
   }

   --Draw Boy Image
   self.boy = Child:new({parentScene = sceneGroup, type="boy"})
   self.boy.image.x = gd.w/2+self.boy.image.width/2
   self.boy.image.y = gd.h/2

   --Add a touch function to the Boy image
   --This function is triggered when the image is touched
   --Event Listener is added when the scene is shown
   function self.boy:touch(event)

      if event.phase == "ended" then

         --Set Image Sequence
         local event = { name="selected", params={selected = "sparkle"} }
         self.image:dispatchEvent( event )

         --Trigger ready event to move scene to Play Letters game
         local event = { name="ready", target=scene, changeTo="play" }
         local timedClosure = function()
            gd.sessionDetails.mode = "Letter"
            scene:dispatchEvent( event )
         end
         local tm = timer.performWithDelay( 1000, timedClosure, 1 )

      end

   end

   --Draw Boy Text
   self.lettersGameText = gfm.drawText{
      copy = "LETTERS",
      parentScene = sceneGroup,
      xPos = self.boy.image.x,
      yPos = self.boy.image.y+self.boy.image.height/1.5,
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
      gd.isGameRunning = false

      --Set Boy and Girl Image Sequences
      local event = { name="selected", params={selected = "idea"} }
      self.girl.image:dispatchEvent( event )

      local event = { name="selected", params={selected = "question"} }
      self.boy.image:dispatchEvent( event )

   elseif ( phase == "did" ) then

      --Add Event Listeners to images
      --Event Listeners are removed when the scene is hidden
      self.boy.image:addEventListener("touch", self.boy)
      self.girl.image:addEventListener("touch", self.girl)

   end

   --Reset scores
   gd.sessionDetails.score="0"

end

--== Composer Scene hide()
function scene:hide( event )

   local phase = event.phase

   if ( phase == "will" ) then

      --Remove Event Listeners
      self.boy.image:removeEventListener("touch", self.boy)
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
