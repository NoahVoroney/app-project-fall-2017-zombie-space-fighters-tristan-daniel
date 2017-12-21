-----------------------------------------------------------------------------------------
--
-- level1_screen.lua
-- Created by: Daniel Finger
-- Date: Nov. 22nd, 2014
-- Description: This is the level 1 screen of the game.
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------

-- Use Composer Libraries
local composer = require( "composer" )
local widget = require( "widget" )

-- load physics
local physics = require("physics")

-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "level1_screen"

-----------------------------------------------------------------------------------------

-- Creating Scene Object
local scene = composer.newScene( sceneName )

-----------------------------------------------------------------------------------------
-- GLOBAL VARIABLES
-----------------------------------------------------------------------------------------

numLives = 3

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

-- The local variables for this scene
local bkg_image

local platform1
local platform2
local platform3
local platform4
local platform5
local platform6
local platform7

--local door
--local door2
local character

local heart1
local heart2
local heart3

local rArrow
local lArrow
local uArrow

local motionx = 0
local SPEED = 3
local LINEAR_VELOCITY = -350
local GRAVITY =24

local leftW
local rightW
local topW
local floor

local YouLose
local YouWin

local zombie2
local zombie3

local questionsAnswered = 0

local popSound = audio.loadSound( "Sounds/Pop.mp3")
local popSoundChannel

local L1Music = audio.loadSound( "Sounds/L1Music.mp3")
local L1SoundChannel

local youWinSound = audio.loadSound("Sounds/Cheer.m4a")
local youWinSoundChannel

local backButton


-----------------------------------------------------------------------------------------
-- LOCAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

local function WinTransition( )
    composer.gotoScene( "you_win", {effect = "fromBottom", time = 500})
end


-- When left arrow is touched, move character left
local function left (touch)
  motionx = -SPEED
  character.xScale = -1
end


-- When right arrow is touched, move character right
local function right (touch)
    --if (character ~= nil) then
        motionx = SPEED
        character.xScale = 1
    --end
end

-- When up arrow is touched, add vertical so it can jump
local function up (touch)
    if (character ~= nil) then
        character:setLinearVelocity( 0, LINEAR_VELOCITY )
    end
end

-- Move character horizontally
local function movePlayer (event)
    if (character ~= nil) then
        character.x = character.x + motionx
    end
end

-- Stop character movement when no arrow is pushed
local function stop (event)
    if (event.phase =="ended") then
        motionx = 0
    end
end
-- Runtime:addEventListener("touch", stop )

local function AddArrowEventListeners()
    rArrow:addEventListener("touch", right)
    uArrow:addEventListener("touch", up)
    lArrow:addEventListener("touch", left)
end

local function RemoveArrowEventListeners()
    rArrow:removeEventListener("touch", right)
    uArrow:removeEventListener("touch", up)
    lArrow:removeEventListener("touch", left)
end

local function AddRuntimeListeners()
    Runtime:addEventListener("enterFrame", movePlayer)
    Runtime:addEventListener("touch", stop )
end

local function RemoveRuntimeListeners()
    Runtime:removeEventListener("enterFrame", movePlayer)
    Runtime:removeEventListener("touch", stop )
end


local function ReplaceCharacter()
    character = display.newImageRect("Images/KickyKatRight.png", 100, 150)
    character.x = display.contentWidth * 0.5 / 8
    character.y = display.contentHeight  * 0.1 / 3
    character.width = 75
    character.height = 100
    character.myName = "KickyKat"

    -- intialize horizontal movement of character
    motionx = 0

    -- add physics body
    physics.addBody( character, "dynamic", { density=0, friction=0.5, bounce=0, rotation=0 } )

    -- prevent character from being able to tip over
    character.isFixedRotation = true

    -- add back arrow listeners
    AddArrowEventListeners()

    -- add back runtime listeners
    AddRuntimeListeners()
end

local function MakeZombiesVisible()
    zombie2.isVisible = true
    zombie3.isVisible = true

end

local function MakeHeartsVisible()
    heart1.isVisible = true
    heart2.isVisible = true
    heart3.isVisible = true
end

local function YouLoseTransition()
    composer.gotoScene( "you_lose" )
end

local function Level2Transition( )
    composer.gotoScene( "you_win" )

    --audio.stop ( mmMusicChannel)


    --play you win audio
    --youWinSoundChannel = audio.play(youWinSound)

    --go to the main menu for now
    composer.gotoScene( "main_menu" )
end

local function onCollision( self, event )

    if  (event.target.myName == "zombie2") or
        (event.target.myName == "zombie3") then

        theZombie = event.target

        -- stop the character from moving
        motionx = 0

        -- make the character invisible
        character.isVisible = false

        -- show overlay with math question
        composer.showOverlay( "level1_question", { isModal = true, effect = "fade", time = 100})

        -- Increment questions answered
        questionsAnswered = questionsAnswered + 1



        if (questionsAnswered == 2) then
            backButton.isVisible = true

        end

    end

end


local function lifeTaker()
    if (numLives == 3) then
        -- update hearts
        heart1.isVisible = true
        heart2.isVisible = true
        heart3.isVisible = true

        elseif (numLives == 2) then
                -- update hearts
            heart1.isVisible = true
            heart2.isVisible = true
            heart3.isVisible = false
            --timer.performWithDelay(200, ReplaceCharacter)

         elseif (numLives == 1) then
                -- update hearts
            heart1.isVisible = true
            heart2.isVisible = false
            heart3.isVisible = false
            --timer.performWithDelay(200, ReplaceCharacter)

        elseif (numLives == 0) then
                -- update hearts
            heart1.isVisible = false
            heart2.isVisible = false
            heart3.isVisible = false
            timer.performWithDelay(200, YouLoseTransition)
    end
end

local function AddCollisionListeners()

     --when character collides with zombie, onCollision will be called
        zombie2.collision = onCollision
        zombie2:addEventListener( "collision" )
        zombie3.collision = onCollision
        zombie3:addEventListener( "collision" )

end

local function RemoveCollisionListeners()

    zombie2:removeEventListener( "collision" )
    zombie3:removeEventListener( "collision" )

end

local function AddPhysicsBodies()


    --add to the physics engine
    physics.addBody( platform1, "static", { density=1.0, friction=0.3, bounce=0.2 } )
    physics.addBody( platform2, "static", { density=1.0, friction=0.3, bounce=0.2 } )
    physics.addBody( platform3, "static", { density=1.0, friction=0.3, bounce=0.2 } )
--    physics.addBody( platform4, "static", { density=1.0, friction=0.3, bounce=0.2 } )
    physics.addBody( platform5, "static", { density=1.0, friction=0.3, bounce=0.2 } )
    physics.addBody( platform6, "static", { density=1.0, friction=0.3, bounce=0.2 } )
--    physics.addBody( platform7, "static", { density=1.0, friction=0.3, bounce=0.2 } )

    physics.addBody(leftW, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody(rightW, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody(topW, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody(floor, "static", {density=1, friction=0.3, bounce=0.2} )

    physics.addBody(zombie2, "static",  {density=0, friction=0, bounce=0} )
    physics.addBody(zombie3, "static",  {density=0, friction=0, bounce=0} )

end

local function RemovePhysicsBodies()
    physics.removeBody(platform1)
    physics.removeBody(platform2)
    physics.removeBody(platform3)
--    physics.removeBody(platform4)
    physics.removeBody(platform5)
    physics.removeBody(platform6)
--    physics.removeBody(platform7)

    physics.removeBody(leftW)
    physics.removeBody(rightW)
    physics.removeBody(topW)
    physics.removeBody(floor)

end


local function backvisible()
    if questionsAnswered == 2 then
        backButton.isVisible = true
    end
end
-----------------------------------------------------------------------------------------
-- GLOBAL FUNCTIONS
-----------------------------------------------------------------------------------------


function ResumeGame()

    --updates lives
    lifeTaker()

    -- make character visible again
    character.isVisible = true


    if (theZombie ~= nil) and (theZombie.isBodyActive == true) then
        print ("***Removed theZombie " .. theZombie.myName)
        theZombie.isVisible = false
        physics.removeBody(theZombie)
    end

        -- make character visible again
    character.isVisible = true

end



-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    -- Insert the background image
    bkg_image = display.newImageRect("Images/Level1Background.png", display.contentWidth, display.contentHeight)
    bkg_image.x = display.contentWidth / 2
    bkg_image.y = display.contentHeight / 2

    -- Insert background image into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( bkg_image )




    -- Creating Back Button
    backButton = widget.newButton(
    {
        -- Setting Position
        x = display.contentWidth*1/8,
        y = display.contentHeight*15/16,

        -- Setting Dimensions
        -- width = 1000,
        -- height = 106,

        -- Setting Visual Properties
        defaultFile = "Images/LevelFinishButton.png",
        overFile = "Images/LevelFinishButtonPressed.png",

        -- Setting Functional Properties
        onRelease = WinTransition

    } )

    backButton.isVisible = false



    -- Associating Buttons with this scene
    sceneGroup:insert( backButton )



    -- Insert the platforms
    platform1 = display.newImageRect("Images/Level-1Platform1.png", 250, 50)
    platform1.x = display.contentWidth * 1 / 8
    platform1.y = display.contentHeight * 1.6 / 4

    sceneGroup:insert( platform1 )

    platform2 = display.newImageRect("Images/Level-1Platform1.png", 150, 50)
    platform2.x = display.contentWidth /2.1
    platform2.y = display.contentHeight * 1.2 / 4

    sceneGroup:insert( platform2 )

    platform3 = display.newImageRect("Images/Level-1Platform1.png", 180, 50)
    platform3.x = display.contentWidth *3 / 5
    platform3.y = display.contentHeight * 3.5 / 5

    sceneGroup:insert( platform3 )



--    platform4 = display.newImageRect("Images/Level-1Platform1.png", 180, 50)
--    platform4.x = display.contentWidth *4.7 / 5
--    platform4.y = display.contentHeight * 1.3 / 5

--    sceneGroup:insert( platform4 )


    platform4 = display.newImageRect("Images/Level-1Platform1.png", 180, 50)
    platform4.x = display.contentWidth *4.7 / 5
    platform4.y = display.contentHeight * 1.3 / 5

    sceneGroup:insert( platform4 )



    platform5 = display.newImageRect("Images/Level-1Platform1.png", 250, 50)
    platform5.x = display.contentWidth * 3 / 8
    platform5.y = display.contentHeight * 2.8 / 5

    sceneGroup:insert( platform5)


    platform6 = display.newImageRect("Images/Level-1Platform1.png", 150, 50)
    platform6.x = display.contentWidth * 6 / 8
    platform6.y = display.contentHeight * 2.2 / 5

    sceneGroup:insert( platform6)




--    platform7 = display.newImageRect("Images/Level-1Platform2.png", 50, 150)
--    platform7.x = display.contentWidth * 5.8 / 8
--    platform7.y = display.contentHeight * 0.4 / 5

--    sceneGroup:insert( platform7)


    platform7 = display.newImageRect("Images/Level-1Platform2.png", 50, 150)
    platform7.x = display.contentWidth * 5.8 / 8
    platform7.y = display.contentHeight * 0.4 / 5

    sceneGroup:insert( platform7)




    -- Insert the Hearts
    heart1 = display.newImageRect("Images/Lives.png", 80, 80)
    heart1.x = 50
    heart1.y = 50
    heart1.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart1 )

    heart2 = display.newImageRect("Images/Lives.png", 80, 80)
    heart2.x = 130
    heart2.y = 50
    heart2.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart2 )

    heart3 = display.newImageRect("Images/Lives.png", 80, 80)
    heart3.x = 210
    heart3.y = 50
    heart3.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart3 )
    --Insert the right arrow
    rArrow = display.newImageRect("Images/RightArrowUnpressed.png", 100, 50)
    rArrow.x = display.contentWidth * 9.2 / 10
    rArrow.y = display.contentHeight * 9.5 / 10

    lArrow = display.newImageRect("Images/LeftArrowUnpressed.png", 100, 50)
    lArrow.x = display.contentWidth * 7.2 / 10
    lArrow.y = display.contentHeight * 9.5 / 10

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( rArrow)
    sceneGroup:insert( lArrow)

    --Insert the left arrow
    uArrow = display.newImageRect("Images/UpArrowUnpressed.png", 50, 100)
    uArrow.x = display.contentWidth * 8.2 / 10
    uArrow.y = display.contentHeight * 8.5 / 10

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( uArrow)

    --WALLS--
    leftW = display.newLine( 0, 0, 0, display.contentHeight)
    leftW.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( leftW )

    rightW = display.newLine( 0, 0, 0, display.contentHeight)
    rightW.x = display.contentCenterX * 2
    rightW.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( rightW )

    topW = display.newLine( 0, 0, display.contentWidth, 0)
    topW.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( topW )


    floor = display.newImageRect("Images/Level-1Floor.png", 1024, 100)
    floor.x = display.contentCenterX
    floor.y = display.contentHeight * 1.05


    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( floor )

    -- You Lose screen
    YouLose = display.newImageRect ("Images/YouLose.png", display.contentWidth, display.contentHeight)
    YouLose.isVisible = false
    YouLose.x = display.contentWidth / 2
    YouLose.y = display.contentHeight / 2

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( YouLose )

    -- You Win screen
    YouWin = display.newImageRect ("Images/YouWin.png", display.contentWidth, display.contentHeight)
    YouWin.isVisible = false
    YouWin.x = display.contentWidth / 2
    YouWin.y = display.contentHeight / 2

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( YouWin )

    --zombie2
    zombie2 = display.newImageRect ("Images/Zombie.png", 70, 70)
    zombie2.x = 610
    zombie2.y = 480
    zombie2.myName = "zombie2"

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( zombie2 )


    --zombie3
    zombie3 = display.newImageRect ("Images/Zombie.png", 70, 70)
    zombie3.x = 490
    zombie3.y = 170
    zombie3.myName = "zombie3"

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( zombie3 )


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
        -- start physics
        physics.start()

        -- set gravity
        physics.setGravity( 0, GRAVITY )

    elseif ( phase == "did" ) then

        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.

        L1SoundChannel = audio.play(L1Music )

        numLives = 3
        questionsAnswered = 0

        -- make all zombies visible
        MakeZombiesVisible()

        -- make all lives visible
        MakeHeartsVisible()

        -- add physics bodies to each object
        AddPhysicsBodies()

        -- add collision listeners to objects
        AddCollisionListeners()

        -- add arrow event listeners for buttons
        AddArrowEventListeners()

        -- create the character, add physics bodies and runtime listeners
        ReplaceCharacter()
        -- make the lives work
        lifeTaker()

        backvisible()

        backButton.isVisible = false


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

    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        RemoveCollisionListeners()
        RemovePhysicsBodies()
        audio.stop()
        physics.stop()
        RemoveArrowEventListeners()
        RemoveRuntimeListeners()
        display.remove(character)
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
