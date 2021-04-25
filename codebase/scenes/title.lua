--======================================================================--
--== Title Scene - a Composer Scene
--== Shows gameplay options
--== Two options, Letter-play and Word-play.
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

local Child = require("classes.actionClass")

local mainChild = "" --Should do to GlobalData

--======================================================================--
--== Scene functions
--======================================================================--

--== create()
function scene:create( event )
  local sceneGroup = self.view

  -- Draw background and logo
  --local backgroundImage = gfm.drawImage("assets/img-boyResults.png", gd.w, gd.h, sceneGroup, gd.w/2, gd.h/2)
  --local splashLogo = gfm.drawImage("assets/img-boyResults.png", 1000*0.5, 820*0.5, sceneGroup, gd.w/2, gd.h/2)


  girl = Child:new({parentScene = sceneGroup, type="girl", direction=-1})
  girl.image.x = gd.w/2-girl.image.width/2
  girl.image.y = gd.h/2
  local event = { name="selected", params={selected = "idea"} }
  girl.image:dispatchEvent( event )

  self.wordGameText = gfm.drawText{
      copy = "WORDS",
      parentScene = sceneGroup,
      xPos = girl.image.x,
      yPos = girl.image.y+girl.image.height/1.75,
      fontsize = 30,
      color = {r=0,  g=0, b=0}
  }


  boy = Child:new({parentScene = sceneGroup, type="boy"})
  boy.image.x = gd.w/2+boy.image.width/2
  boy.image.y = gd.h/2
  local event = { name="selected", params={selected = "question"} }
  boy.image:dispatchEvent( event )

  self.lettersGameText = gfm.drawText{
      copy = "LETTERS",
      parentScene = sceneGroup,
      xPos = boy.image.x,
      yPos = boy.image.y+boy.image.height/1.75,
      fontsize = 30,
      color = {r=0,  g=0, b=0}
  }

  --Add a touch function to the new images
  function boy:touch(event)
        if event.phase == "ended" then
              print("you clicked me!")
              local event = { name="selected", params={selected = "sparkle"} }
              self.image:dispatchEvent( event )

              local event = { name="ready", target=scene, changeTo="play" }
              local timedClosure = function() scene:dispatchEvent( event ) end
              local tm = timer.performWithDelay( 1000, timedClosure, 1 )
        end
  end

  --Add a touch function to the new images
  function girl:touch(event)
        if event.phase == "ended" then
             print("you clicked me!")
             local event = { name="selected", params={selected = "sparkle"} }
             self.image:dispatchEvent( event )

             local event = { name="ready", target=scene, changeTo="playWords" }
             local timedClosure = function() scene:dispatchEvent( event ) end
             local tm = timer.performWithDelay( 1000, timedClosure, 1 )
        end
  end



  self.statusText = gfm.drawText{
      copy = "Choose an option to play",
      parentScene = sceneGroup,
      xPos = gd.w/2,
      yPos = gd.h/6,
      fontsize = 30,
      color = {r=0,  g=0, b=0}
  }
end

--== ready()
function scene:ready( event )
  scene:removeEventListener( "ready", scene )
  gfm.changeScene("scenes."..event.changeTo)

end

--== show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    local event = { name="ready", target=scene }
    local timedClosure = function() scene:dispatchEvent( event ) end
    --local tm = timer.performWithDelay( 2000, timedClosure, 1 )

    boy.image:addEventListener("touch", boy)
    girl.image:addEventListener("touch", girl)
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
  --display:remove(splashLogo)
  --splashLogo = nil

  display:remove(backgroundImage)
  backgroundImage = nil


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
