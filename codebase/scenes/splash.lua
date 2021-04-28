--======================================================================--
--== Splash Scene - a Composer Scene
--== Shows loading info/animation
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

--======================================================================--
--== Scene functions
--======================================================================--

--== Scene is created
function scene:create( event )
  local sceneGroup = self.view

  -- Draw background and logo
  sceneGroup.splashLogo = gfm.drawImage("assets/img-boyResults.png", 1000*0.5, 820*0.5, sceneGroup, gd.w/2, gd.h/2)

  sceneGroup.statusText = gfm.drawText{
      copy = "Caleb and Michael's Learn to Type Game",
      parentScene = sceneGroup,
      xPos = gd.w/2,
      yPos = gd.h/6,
      fontsize = 30,
      color = {r=0,  g=0, b=0}
  }
end

--== ready()
function scene:ready( event )
  gfm.changeScene("scenes.title")

end

--== show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen

    sceneGroup.statusText.alpha = 0.4

    local event = { name="ready", target=scene }
    local timedClosure = function() scene:dispatchEvent( event ) end
    local tm = timer.performWithDelay( 2000, timedClosure, 1 )
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
  print("this scene got destroyed")

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
