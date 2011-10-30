/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement click
    open core, vpiDomains
    
constants
    timeRedraw:positive = 20.
    
class facts
    tm:vpiDomains::timerId := nullHandle.
    carUser:car := erroneous.
    city:cityGenerator := cityGenerator::new().  
predicates
    
clauses

    bip(W) :- 
        draw::load(),
        city := cityGenerator::new(),
        city:create(), 
        carUser := car::new(),
        tm := W:timerSet(timeRedraw).
    kill() :- vpi::timerKill(tm).

    timer(W):-
        carUser:update(),
        pnt(X,Y) = carUser:getPosition(),
        W:invalidate(rct(X+10,Y+10,X+32+10,Y+32+10)).
        
    draw(GDIObject, Rect):-
        draw::draw(GDIObject, Rect, city, carUser).
        
    keyDown(Key):-
        Key = 65, % a
        carUser:turnRight(),
        fail.
    keyDown(Key):-
        Key = 68, % d
        carUser:turnLeft(),
        fail.
    keyDown(Key):-
        Key = 87, % w
        carUser:drive(),
        fail.
    keyDown(Key):-
        Key = 83, % s
        carUser:stop(),
        fail.
    keyDown(_Key).
    

end implement click
