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

--== create()
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
      local girl = Child:new({parentScene = sceneGroup, type="girl", direction=-1})
      girl.image.x = gd.w/2-girl.image.width/2
      girl.image.y = gd.h/2

      --Add a touch function to the Girl image
      --This function is triggered when the image is touched
      --Event Listener is added when the scene is shown
      function girl:touch(event)
            if event.phase == "ended" then
                  --Set Image Sequence
                  local event = { name="selected", params={selected = "sparkle"} }
                  self.image:dispatchEvent( event )

                  --Trigger ready event to move scene to Play Words game
                  local event = { name="ready", target=scene, changeTo="playWords" }
                  local timedClosure = function() scene:dispatchEvent( event ) end
                  local tm = timer.performWithDelay( 1000, timedClosure, 1 )
            end
      end

      --Assign girl object to scene
      self.girl = girl

      --Draw Girl Text
      self.wordGameText = gfm.drawText{
            copy = "WORDS",
            parentScene = sceneGroup,
            xPos = girl.image.x,
            yPos = girl.image.y+girl.image.height/1.75,
            fontsize = 30,
            color = {r=1,  g=1, b=1}
      }

      --Draw Boy Image
      local boy = Child:new({parentScene = sceneGroup, type="boy"})
      boy.image.x = gd.w/2+boy.image.width/2
      boy.image.y = gd.h/2

      --Assign boy object to scene
      self.boy = boy

      --Add a touch function to the Boy image
      --This function is triggered when the image is touched
      --Event Listener is added when the scene is shown
      function boy:touch(event)
            if event.phase == "ended" then
                  --Set Image Sequence
                  local event = { name="selected", params={selected = "sparkle"} }
                  self.image:dispatchEvent( event )

                  --Trigger ready event to move scene to Play Letters game
                  local event = { name="ready", target=scene, changeTo="playLetters" }
                  local timedClosure = function() scene:dispatchEvent( event ) end
                  local tm = timer.performWithDelay( 1000, timedClosure, 1 )
            end
      end

      --Draw Boy Text
      self.lettersGameText = gfm.drawText{
            copy = "LETTERS",
            parentScene = sceneGroup,
            xPos = boy.image.x,
            yPos = boy.image.y+boy.image.height/1.75,
            fontsize = 30,
            color = {r=1,  g=1, b=1}
      }
end

--== ready()
--== Parameters: event object
--== This function is called by an event listener
--== Purpose: Define what to do when the scene is ready to move on
function scene:ready( event )
      gfm.changeScene("scenes."..event.changeTo)

end

--== Composer Scene shown
function scene:show( event )

      local sceneGroup = self.view
      local phase = event.phase

      if ( phase == "will" ) then

            --Set Boy and Girl Image Sequences
            local event = { name="selected", params={selected = "idea"} }
            self.girl.image:dispatchEvent( event )

            local event = { name="selected", params={selected = "question"} }
            self.boy.image:dispatchEvent( event )

      elseif ( phase == "did" ) then

            --Add Event Listeners to Images
            self.boy.image:addEventListener("touch", self.boy)
            self.girl.image:addEventListener("touch", self.girl)
      end

      --Reset scores
      gd.sessionDetails.score="0"
end


--== Composer Scene hidden
function scene:hide( event )

      local sceneGroup = self.view
      local phase = event.phase

      if ( phase == "will" ) then
            --Remove Event Listeners
            self.boy.image:removeEventListener("touch", self.boy)
            self.girl.image:removeEventListener("touch", self.girl)

      elseif ( phase == "did" ) then
            print(self.name .. " scene was hidden")

      end
end


--== Composer Scene destroy
function scene:destroy( event )

      local sceneGroup = self.view
      print(self.name .. " scene got destroyed")

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
