/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement gameController
    open core, vpiDomains, carDomains, topTenDomains
    
constants
    cTIMER_MILLIS:positive = 20.
        
    cCARS_AI_NUMBER:positive = 3.
    
    cSCREEN_GAME:positive = 0.
    cSCREEN_MAINMENU:positive = 1.
    cSCREEN_TOP:positive = 2.
    cSCREEN_FINISH:positive = 3.
    
    cMENU_ITEM_START:positive = 0.
    cMENU_ITEM_TOP10:positive = 1.
          
    cVIOLATION_TIME:positive = 10.
            
class facts
    tm:vpiDomains::timerId := nullHandle.
    win:window := erroneous.
    timeCounter:positive := 0.
    currentScreen:integer := 1.
    menuItemSelected:integer := 0.
    gamePaused:integer := 0.
    showViolation:integer := 0.
    
clauses
%
% Public predicates
%
    init(W) :-
        win:=W,
        draw::load(),
        topTenManager::init(),
        tm := win:timerSet(cTIMER_MILLIS).
       
    start() :-
        currentScreen = cSCREEN_GAME,
        cityGenerator::create(), 
        mapBFS::build(),
        carManager::createCars(cCARS_AI_NUMBER),
        timeCounter:=0,
        showViolation:=0,
        gamePaused:=0,!.
    start() :-
        cityGenerator::create(),
        gamePaused:=0.

    stop() :-
        vpi::timerKill(tm),!.
        
    timer(W):-
        currentScreen = cSCREEN_GAME,
        timeCounter:=timeCounter+cTIMER_MILLIS,
        cityTrafficLights::updateTimers(),
        carManager::moveCars(),
        if carManager::getUserCar():redeemViolation() = 1,! then
            showViolation:=cVIOLATION_TIME,
            timeCounter:=timeCounter+(cVIOLATION_TIME*1000)
        end if,
        checkFinish(),
        W:invalidate(),!.
    timer(W):-
        W:invalidate(),!.
        
    draw(GDIObject, Rect):-
        currentScreen = cSCREEN_GAME,
        draw::drawGame(GDIObject, Rect, timeCounter, showViolation),
        showViolation:=0,!.
    draw(GDIObject, _Rect):-
        currentScreen = cSCREEN_MAINMENU,
        draw::drawMainMenu(GDIObject, menuItemSelected),!.
    draw(GDIObject, _Rect):-
        currentScreen = cSCREEN_TOP,
        draw::drawTopTen(GDIObject),!.
    draw(GDIObject, _Rect):-
        currentScreen = cSCREEN_FINISH,
        Score = topTenManager::calcScore(timeCounter),
        draw::drawFinish(GDIObject,Score),!.       
    draw(_GDIObject, _Rect).
         
    keyDown(Key):-
        currentScreen = cSCREEN_GAME,
        keyDownGame(Key),!.
    keyDown(_Key).
    
    keyUp(k_esc):-
        currentScreen = cSCREEN_GAME,
        gamePaused:=1,
        currentScreen := cSCREEN_MAINMENU,!.
    keyUp(_Key):-
        currentScreen = cSCREEN_GAME,
        carManager::getUserCar():stop(),!.       
    keyUp(Key):-
        currentScreen = cSCREEN_MAINMENU,
        keyUpMenu(Key),!.
    keyUp(_Key):-
        currentScreen = cSCREEN_TOP,
        currentScreen := cSCREEN_MAINMENU,!.
    keyUp(k_esc):-
        currentScreen = cSCREEN_FINISH,
        currentScreen := cSCREEN_MAINMENU,!.        
    keyUp(k_space):-
        currentScreen = cSCREEN_FINISH,
        currentScreen := cSCREEN_MAINMENU,!.        
    keyUp(k_enter):-
        currentScreen = cSCREEN_FINISH,
        currentScreen := cSCREEN_MAINMENU,!.        
    keyUp(_Key).
        
    
%
% Inner class predicates
%
class predicates
    checkFinish:().
clauses
    checkFinish():-
        carManager::getUserCar():getCell() = carManager::getUserCar():getDestCell(),
        Score = topTenManager::calcScore(timeCounter),
        topTenManager::addScore(Score),
        currentScreen:=cSCREEN_FINISH,!.
    checkFinish().

class predicates
    keyUpMenu:(integer Key).
clauses
    keyUpMenu(k_up):-
        menuItemSelected = cMENU_ITEM_START,
        menuItemSelected:=cMENU_ITEM_TOP10,!.
    keyUpMenu(k_up):-
        menuItemSelected = cMENU_ITEM_TOP10,
        menuItemSelected:=cMENU_ITEM_START,!.
    keyUpMenu(k_down):-
        menuItemSelected = cMENU_ITEM_START,
        menuItemSelected:=cMENU_ITEM_TOP10,!.
    keyUpMenu(k_down):-
        menuItemSelected = cMENU_ITEM_TOP10,
        menuItemSelected:=cMENU_ITEM_START,!.
    keyUpMenu(k_enter):-
        menuItemSelected = cMENU_ITEM_TOP10,
        currentScreen:=cSCREEN_TOP,!.
    keyUpMenu(k_enter):-
        menuItemSelected = cMENU_ITEM_TOP10,
        currentScreen:=cSCREEN_TOP,!.
    keyUpMenu(k_enter):-
        menuItemSelected = cMENU_ITEM_START,
        currentScreen:=cSCREEN_GAME,
        start(),!.
    keyUpMenu(k_esc):-
        gamePaused = 1,
        gamePaused:=0,
        currentScreen:=cSCREEN_GAME,!.       
    keyUpMenu(_Key).

class predicates
    keyDownGame:(integer Key).
clauses
    keyDownGame(Key):-
        Key = 65, % - A
        carManager::getUserCar():driveLeft(),
        fail.
    keyDownGame(Key):-
        Key = 68, % - D
        carManager::getUserCar():driveRight(),
        fail.
    keyDownGame(Key):-
        Key = 87, % - W
        carManager::getUserCar():driveForward(),
        fail.
    keyDownGame(Key):-
        Key = 83, % - S
        carManager::getUserCar():driveBackward(),
        fail.
    keyDownGame(_Key).
    
        
end implement gameController
