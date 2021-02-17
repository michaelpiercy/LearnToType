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


--== create()
function scene:create( event )
  -- Code here runs when the scene is first created but has not yet appeared on screen

  local sceneGroup = self.view


  -- Draw background and logo
  --local backgroundImage = gfm.drawImage("assets/img-boyResults.png", gd.w, gd.h, sceneGroup, gd.w/2, gd.h/2)
  local splashLogo = gfm.drawImage("assets/img-boyResults.png", 1000*0.5, 820*0.5, sceneGroup, gd.w/2, gd.h/2)

  --TODO: Add loading bar. When everything is loaded, then move to main menu screen scene...what though, are we loading, exactly? Sprites, scripts etc.

  self.statusText = gfm.drawText{
      copy = "Caleb and Michael's Game",
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
  gfm.changeScene("scenes.play")

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
