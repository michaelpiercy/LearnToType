--======================================================================--
--== Action Class - a class
--== Returns an object with boy/girl type imagesheet
--======================================================================--

local Child = {
   timeUnit = 250
}

function Child:new (o)
   local o = o or {}
   setmetatable( o, self )
   self.__index = self
   o.animating = false
   o.type = o.type or "boy"
   o.direction = o.direction or 1
   o.image = o:getImage{o.type}
   o.xPos = o.xPos or 0
   o.yPos = o.yPos or 0
   o.timeUnit = o.timeUnit
   o.parentScene = o.parentScene
   o.image:addEventListener( "selected", o )

   return o
end

function Child:destroy()
   print("destroying child")
   self.alive = false
   display.remove(self.image)
   self = nil
end

function Child:move(event)

   local function returnFunction()
      local closure = function()
         self.animating = false
      end
      self.childTimer = timer.performWithDelay( self.timeUnit, function()
         transition.moveBy( self.image, { x=0, y=self.image.height*1.35, time=self.timeUnit, transition=easing.outExpo, onComplete=closure } )
      end)
   end

   if self.animating~=true then
      self.animating = true
      self.childTransition = transition.moveBy( self.image, { x=0, y=-self.image.height*1.35, time=self.timeUnit, transition=easing.outExpo, onComplete=returnFunction } )
   end
end

function Child:selected(event)

   --change sprint
   self.image:setSequence(event.params.selected)
   self.image:play()

end

function Child:getImage (params)
   local options =
   {
      width = 384,
      height = 384,
      numFrames = 6,
      sheetContentWidth = 1152,  -- width of original 1x size of entire sheet
      sheetContentHeight = 768  -- height of original 1x size of entire sheet
   }

   local data = {
      {   name="excellent",   start=1,    count=1,    loopCount = 1},
      {   name="shock",       start=2,    count=1,    loopCount = 1},
      {   name="sparkle",     start=3,    count=1,    loopCount = 1},
      {   name="reject",      start=4,    count=1,    loopCount = 1},
      {   name="question",    start=5,    count=1,    loopCount = 1},
      {   name="idea",        start=6,    count=1,    loopCount = 1}
   }

   local imageSheet = graphics.newImageSheet( "assets/img-"..self.type.."-actions.png", options )

   local image = display.newSprite( imageSheet, data  )
   image.x = self.xPos
   image.y = self.yPos
   image:scale(self.direction, 1)
   self.parentScene:insert(image)

   return image
end

return Child
