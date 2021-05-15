--======================================================================--
--== Countdown Class - a class
--== Returns a rectangle box with border that shrinks as a determined
--== time counts down.
--======================================================================--

local Countdown = {caseType="vertical", time=15}
local gd = require( "globalData" )

function Countdown:new (o)
   local o = o or {}
   setmetatable( o, self )
   self.__index = self
   o.alive = true
   o.parentScene = o.parentScene
   o.xPos = o.xPos or 0
   o.yPos = o.yPos or 0
   o.height = o.height or 1
   o.frame = o:getFrame({o.caseType})
   o.box = o:getBox({o.caseType})
   o.counterUnits = o.box.height/o.time
   o.box:addEventListener("reset", o)
   o.box:addEventListener("reduce", o)
   return o
end

function Countdown:destroy()
   local destroyTimer = timer.performWithDelay( 1500, function()
      self.alive = false
      display.remove(self.box)
      self = nil
   end)
end

function Countdown:start()
   self.timer = timer.performWithDelay( 100, function()
      self:reduce()
   end, 0 )
end

function Countdown:reduce()

   self.box.height = self.box.height-self.counterUnits/10
   if self.box.height <= self.counterUnits/10 then
      timer.cancel( self.timer )
      --dispatch lose life event
      print("GameOver")
      local scene = gd.sessionDetails.currentScene
      local event = { name="gameOver", target=scene}
      local timedClosure = function() scene:dispatchEvent( event ) end
      local tm = timer.performWithDelay( 10, timedClosure, 1 )
   end
end

function Countdown:reset()
   self.box.height = self.frame.height - 8
end

function Countdown:getBox (params)
   local myRectangle = display.newRect( 0, 0, 100, self.frame.height - 8 )
   myRectangle.anchorX, myRectangle.anchorY = 0.5, myRectangle.height
   myRectangle:setFillColor( 0.7 )
   myRectangle.x, myRectangle.y = self.frame.x, self.frame.y - 2
   self.parentScene:insert(myRectangle)

   return myRectangle
end

function Countdown:getFrame (params)
   local myRectangle = display.newRect( 0, 0, 104, self.height )
   myRectangle.anchorX, myRectangle.anchorY = 0.5, myRectangle.height
   myRectangle.strokeWidth = 4
   myRectangle:setFillColor( 0, 0, 0, 0 )
   myRectangle:setStrokeColor( (91/255), (58/255), (15/255) )
   myRectangle.x, myRectangle.y = self.xPos, self.yPos
   self.parentScene:insert(myRectangle)

   return myRectangle
end


return Countdown
