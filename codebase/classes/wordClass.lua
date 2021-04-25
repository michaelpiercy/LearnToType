local Letter = require("classes.letterClass")

local Word = {timeUnit = 150, caseType="upper",
words={
      "hello",
      "there",
      "caleb",
      "pencil",
      "mammy",
      "daddy",
      "phone",
      "sellotape",
      "keyboard"
}}


function Word:new (o)
      local o = o or {}
      setmetatable( o, self )
      self.__index = self
      o.alive = true
      o.parentScene = o.parentScene
      o.timeUnit = o.timeUnit
      o.letters = {}
      o.currentLetter = ""
      o.word = o.word or o:getWord{caseType = o.caseType, words = o.words}
      --o.word:addEventListener( "answer", o )
      return o
end

function Word:updateLocation (params)
      print("how many", #self.letters)
      for i = 1, #self.letters do
            self.letters[i].letter.x, self.letters[i].letter.y = self.letters[i].letter.x - params.xPos, params.yPos
      end
end


function Word:destroy()
      print("destroying")
      local destroyTimer = timer.performWithDelay( self.timeUnit, function()
            self.alive = false
            for i = 1, #self.letters do
                  self.letters[i]:destroy()
            end
            display.remove(self.word)
            self = nil
      end)
end

function Word:shake()

      print("WRONG!¬!!!!")
end

function Word:answer(event)
      print("you rang?")
      local params = event.params
      if params.answer == "correct" then

            print("details:", self.currentLetterIndex, #self.letters)
            self.letters[self.currentLetterIndex].letter.alpha = 1

            if self.currentLetterIndex == #self.letters then
                  print("that's the lot!")
                  self:destroy()
                  local event = { name="correctAnswer" }
                  params.scene:dispatchEvent( event )
            else
                  print("correctAnswer - what's the next letter?")
                  self.currentLetterIndex = self.currentLetterIndex + 1
            end

      else
            self:shake(self.word)
      end

end

function Word:getLetters(params)

      for i = 1, #params.str do
          local c = params.str:sub(i,i)
          print("added ", c, "to word's letter list")
          local thisLetter = Letter:new({letters = {c},parentScene = self.parentScene})
          thisLetter:updateLocation({xPos= display.contentWidth/2+i*150, yPos= display.contentHeight/2})
          print("width:", thisLetter.width)
          table.insert(params.table, thisLetter)
      end
      return true

end
function Word:getWord (params)

      --TODO: this word object should not be made up of a string, but rather, made up of a collection of letter objects
      --local word = display.newText( "_", 100, 100, native.systemFont, 200 )
      --word:setFillColor( 1, 1, 1 )
      --word.alpha = 0.4
      local word = {}
      print("num of words to choose from:", #params.words)
      local rand = math.random(1, #params.words)

      word.text = params.words[rand]
      print("the word is ", word.text, #word.text)

      -- add individual letters
      self:getLetters{table = self.letters, str=word.text}
      self.currentLetterIndex= 1

      return word
end

return Word
