--======================================================================--
--== Countdown Class - a class
--== Returns an rectangle box with border that shrinks as a determined
--== time counts down. 
--======================================================================--

local Countdown = {counterUnit = 10, caseType="vertical"}
local gd = require( "globalData" )


function Countdown:new (o)
      local o = o or {}
      setmetatable( o, self )
      self.__index = self
      o.alive = true
      o.frame = o:getFrame({o.caseType})
      o.box = o:getBox({o.caseType})
      o.counterUnit = o.counterUnit
      o.timeUnit = o.box.height*(self.counterUnit/2000)
      --o.timeUnit = 100
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
      self.timer = timer.performWithDelay( self.timeUnit*self.counterUnit, function()
            self:reduce()
       end, 0 )
end

function Countdown:reduce()

      self.box.height = self.box.height-self.timeUnit
      print(self.timeUnit)
      if self.box.height <= self.timeUnit then
            timer.cancel( self.timer )
            --dispatch lose life event
            print("LOSE LIFE")
            local scene = gd.sessionDetails.currentScene
            local event = { name="loseLife", target=scene}
            local timedClosure = function() scene:dispatchEvent( event ) end
            local tm = timer.performWithDelay( 1000, timedClosure, 1 )
      end
end

function Countdown:reset()
      self.box.height = display.actualContentHeight*0.8
end

function Countdown:getBox (params)
      local myRectangle = display.newRect( 0, 0, 100, self.frame.height )
      myRectangle.anchorX, myRectangle.anchorY = 0.5, myRectangle.height
      myRectangle:setFillColor( 0.7 )
      myRectangle.x, myRectangle.y = self.frame.x, self.frame.y

      return myRectangle
end

function Countdown:getFrame (params)
      local myRectangle = display.newRect( 0, 0, 100, display.actualContentHeight*0.8 )
      myRectangle.anchorX, myRectangle.anchorY = 0.5, myRectangle.height
      myRectangle.strokeWidth = 6
      myRectangle:setFillColor( 0, 0, 0, 0 )
      myRectangle:setStrokeColor( 1, 0, 0 )
      myRectangle.x, myRectangle.y = display.actualContentWidth*0.075, display.actualContentHeight/2+myRectangle.height/2
      return myRectangle
end


return Countdown
