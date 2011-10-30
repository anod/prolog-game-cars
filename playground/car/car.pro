/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement car
    open core, vpiDomains

constants
    className = "playground/car/car".
    classVersion = "".
    
facts
    direction:integer := 3.
    dX:integer := 0.
    dY:integer := 1.
    speed:integer := 0.
    position:pnt := pnt(0,0).

predicates
    setDirection:(integer).
  
clauses
    classInfo(className, classVersion).

    setDirection(Dir):-
        Dir = dirTop,
        direction := Dir,
        dX := 0, dY := -1,!.
    setDirection(Dir):-
        Dir = dirLeft,!,
        direction := Dir,
        dX := -1, dY := 0,!.
    setDirection(Dir):-
        Dir = dirRight,!,
        direction := Dir,
        dX := 1, dY := 0,!.
    setDirection(Dir):-
        Dir = dirBottom,!,!,
        direction := Dir,
        dX := 0, dY := 1.
    setDirection(_Dir).

    update():-
        if speed = 1, ! then
           pnt(X,Y) = position,
%           stdio::writef("dX - %d, dY - %d, NewX - %d, NewY - %d\n",dX,dY,X+dX,Y+dY),
           position:=pnt(X+dX,Y+dY)
        end if.

    getDirection()=direction.
    
    getPosition()=position.
    setPosition(Pos):-position:=Pos.
    
    stop():-
       stdio::write("User Car - Stop.\n"),
       speed:=0.

    drive():-
       stdio::write("User Car - Drive.\n"),
       speed:=1.

    turnLeft():-
        direction = dirTop,!,
        setDirection(dirLeft).
    turnLeft():-
        direction = dirBottom,!,
        setDirection(dirRight).
    turnLeft():-
        direction = dirLeft,!,
        setDirection(dirBottom).
    turnLeft():-
        direction = dirRight,!,
        setDirection(dirTop).
    turnLeft().
    
    turnRight():-
        direction = dirTop,!,
        setDirection(dirRight). 
    turnRight():-
        direction = dirBottom,!,
        setDirection(dirLeft).
    turnRight():-
        direction = dirLeft,!,
        setDirection(dirTop).
    turnRight():-
        direction = dirRight,!,
        setDirection(dirBottom).
    turnRight().
    
end implement car
