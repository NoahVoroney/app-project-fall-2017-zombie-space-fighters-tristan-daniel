-----------------------------------------------------------------------------------------
--
-- level1_screen.lua
-- Created by: Allison
-- Date: May 16, 2017
-- Description: This is the level 1 screen of the game. the charater can be dragged to move
--If character goes off a certain araea they go back to the start. When a user interactes
--with piant a trivia question will come up. they will have a limided time to click on the answer
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------

-- Use Composer Libraries
local composer = require( "composer" )
local widget = require( "widget" )
local physics = require( "physics")


-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "level2_question"

-----------------------------------------------------------------------------------------

-- Creating Scene Object
local scene = composer.newScene( sceneName )

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

-- The local variables for this scene
local questionText

local firstNumber
local secondNumber

local answer
local wrongAnswer1
local wrongAnswer2
local wrongAnswer3

local answerText 
local wrongText1
local wrongText2
local wrongText3

local answerPosition = 1
local bkg
local cover

local X1 = display.contentWidth*2/7
local X2 = display.contentWidth*4/7
local Y1 = display.contentHeight*1/2
local Y2 = display.contentHeight*5.5/7

local textTouched = false

-----------------------------------------------------------------------------------------
--LOCAL FUNCTIONS
-----------------------------------------------------------------------------------------
--making transition to next scene
local function BackToLevel1() 
    composer.hideOverlay("crossFade", 400 )
  
    ResumeGame()
end 




local function TouchListenerAnswer(touch)

    userAnswer = answerText.text

    if (touch.phase == "ended") then

       BackToLevel1( )
   end
end

--checking to see if the user pressed the right answer and bring them back to level 1
local function TouchListenerWrongAnswer(touch)

    if (touch.phase == "ended") then

        numLives = numLives - 1

        BackToLevel1( )
        
        
    end 
end

--checking to see if the user pressed the right answer and bring them back to level 1
local function TouchListenerWrongAnswer2(touch)

    
    if (touch.phase == "ended") then
        numLives = numLives - 1

        BackToLevel1( )
        
    end 
end

local function TouchListenerWrongAnswer3(touch)

    
    if (touch.phase == "ended") then
        numLives = numLives - 1

        BackToLevel1( )
        
    end 
end



--adding the event listeners 
local function AddTextListeners()
    answerText:addEventListener("touch", TouchListenerAnswer)
    wrongAnswerText1:addEventListener("touch", TouchListenerWrongAnswer)
    wrongAnswerText2:addEventListener("touch", TouchListenerWrongAnswer2)
    wrongAnswerText3:addEventListener("touch", TouchListenerWrongAnswer3)
end

--removing the event listeners
local function RemoveTextListeners()
    answerText:removeEventListener( "touch", TouchListenerAnswer)
    wrongAnswerText1:removeEventListener( "touch", TouchListenerWrongAnswer)
    wrongAnswerText2:removeEventListener( "touch", TouchListenerWrongAnswer2)
    wrongAnswerText3:removeEventListener( "touch", TouchListenerWrongAnswer3)

    answerText:removeEventListener("touch", TouchListenerAnswer)
    wrongText1:removeEventListener("touch", TouchListenerWrongAnswer)
    wrongText2:removeEventListener("touch", TouchListenerWrongAnswer2)
    wrongText3:removeEventListener("touch", TouchListenerWrongAnswer3)
end

local function DisplayQuestion()
    --creating random numbers
    firstNumber = math.random (9,15)
    secondNumber = math.random (5,7)

    -- calculate answer
    answer = firstNumber - secondNumber

    -- calculate wrong answers
    wrongAnswer1 = answer - math.random(1, 2)
    wrongAnswer2 = answer + math.random(3, 4)
    wrongAnswer3 = answer + math.random(8, 8)


    --creating the question depending on the selcetion number
    questionText.text = firstNumber .. " - " .. secondNumber .. " ="

    --creating answer text from list it corispondes with the animals list
    answerText.text = answer
    
    --creating wrong answers
    wrongAnswerText1.text = wrongAnswer1
    wrongAnswerText2.text = wrongAnswer2
    wrongAnswerText3.text = wrongAnswer3

end

local function PositionAnswers()

    --creating random start position in a cretain area
    answerPosition = math.random(1,4)

    if (answerPosition == 1) then

        answerText.x = X1
        answerText.y = Y1
        
        wrongAnswerText1.x = X2
        wrongAnswerText1.y = Y1
        
        wrongAnswerText2.x = X1
        wrongAnswerText2.y = Y2

        wrongAnswerText3.x = X2
        wrongAnswerText3.y = Y2

        
    elseif (answerPosition == 2) then

        answerText.x = X2
        answerText.y = Y2
            
        wrongAnswerText1.x = X1
        wrongAnswerText1.y = Y1
            
        wrongAnswerText2.x = X2
        wrongAnswerText2.y = Y1

        wrongAnswerText3.x = X1
        wrongAnswerText3.y = Y2


    elseif (answerPosition == 3) then

        answerText.x = X1
        answerText.y = Y2
            
        wrongAnswerText1.x = X2
        wrongAnswerText1.y = Y2
            
        wrongAnswerText2.x = X1
        wrongAnswerText2.y = Y1

        wrongAnswerText3.x = X2
        wrongAnswerText3.y = Y1
            
    elseif (answerPosition == 4) then

        answerText.x = X2
        answerText.y = Y1
            
        wrongAnswerText1.x = X1
        wrongAnswerText1.y = Y2
            
        wrongAnswerText2.x = X2
        wrongAnswerText2.y = Y2

        wrongAnswerText3.x = X1
        wrongAnswerText3.y = Y1
            
    end
end



-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view  

    -----------------------------------------------------------------------------------------
    --covering the other scene with a rectangle so it looks faded and stops touch from going through
    bkg = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    --setting to a semi black colour
    bkg:setFillColor(0,0,0,0.5)

    -----------------------------------------------------------------------------------------
    --making a cover rectangle to have the background fully bolcked where the question is
    cover = display.newRoundedRect(display.contentCenterX, display.contentCenterY, display.contentWidth*0.8, display.contentHeight*0.95, 50 )
    --setting its colour
    cover:setFillColor(96/255, 96/255, 96/255)

    -- create the question text object
    questionText = display.newText("", display.contentCenterX, display.contentCenterY*3/8, Arial, 75)

    -- create the answer text object & wrong answer text objects
    answerText = display.newText("", X1, Y2, Arial, 75)
    answerText.anchorX = 0

    wrongAnswerText1 = display.newText("", X2, Y2, Arial, 75)
    wrongAnswerText1.anchorX = 0
    wrongAnswerText2 = display.newText("", X1, Y1, Arial, 75)
    wrongAnswerText2.anchorX = 0
    wrongAnswerText3 = display.newText("", X1, Y1, Arial, 75)
    wrongAnswerText3.anchorX = 0

    wrongText1 = display.newText("", X2, Y2, Arial, 75)
    wrongText1.anchorX = 0
    wrongText2 = display.newText("", X1, Y1, Arial, 75)
    wrongText2.anchorX = 0
    wrongText3 = display.newText("", X2, Y1, Arial, 75)
    wrongText3.anchorX = 0


    -----------------------------------------------------------------------------------------

    -- insert all objects for this scene into the scene group
    sceneGroup:insert(bkg)
    sceneGroup:insert(cover)
    sceneGroup:insert(questionText)
    sceneGroup:insert(answerText)
    sceneGroup:insert(wrongAnswerText1)
    sceneGroup:insert(wrongAnswerText2)
    sceneGroup:insert(wrongAnswerText3)

end --function scene:create( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then

        -- Called when the scene is still off screen (but is about to come on screen).
    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        DisplayQuestion()
        PositionAnswers()
        AddTextListeners()
    end

end --function scene:show( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to leave the screen
function scene:hide( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
        --parent:resumeGame()
    -----------------------------------------------------------------------------------------

        RemoveTextListeners()

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
    end

end --function scene:hide( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to be destroyed
function scene:destroy( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    -- Called prior to the removal of scene's view ("sceneGroup"). 
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.

end -- function scene:destroy( event )

-----------------------------------------------------------------------------------------
-- EVENT LISTENERS
-----------------------------------------------------------------------------------------

-- Adding Event Listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )



-----------------------------------------------------------------------------------------

return scene