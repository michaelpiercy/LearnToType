--======================================================================--
--== Splash Scene - a Composer Scene
--== Shows loading info/animation
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

--======================================================================--
--== Scene functions
--======================================================================--

--== Composer Scene create()
function scene:create( event )
   local sceneGroup = self.view

   -- Assign scene name
   self.name = "Splash"

   -- Draw Logo image
   self.splashLogo = gfm.drawImage("assets/img-boyResults.png", 1000*0.5, 820*0.5, sceneGroup, gd.w/2, gd.h/2)

   --Draw Text for game name
   self.statusText = gfm.drawText{
      copy = "Caleb and Michael's Learn to Type Game",
      parentScene = sceneGroup,
      xPos = gd.w/2,
      yPos = gd.h/6,
      fontsize = 50,
      color = {r=1,  g=1, b=1}
   }
end

--== Composer Scene show()
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "did" ) then

      --Trigger the ready event to move to next scene
      local event = { name="ready", target=scene }
      local timedClosure = function() scene:dispatchEvent( event ) end
      local tm = timer.performWithDelay( 2000, timedClosure, 1 )
   end
end

--== Composer Scene hide()
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "did" ) then
      print(self.name .. " scene was hidden")
   end
end

--== Composer Scene destroy
function scene:destroy( event )

   local sceneGroup = self.view
   print(self.name .. " scene got destroyed")
end

--== ready()
--== Parameters: event object
--== This function is called by an event listener
--== Purpose: Define what to do when the scene is ready to move on
function scene:ready( event )
   gfm.changeScene("scenes.title")
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
