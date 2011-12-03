/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement car
    open core, vpiDomains

constants
    className = "playground/car/car".
    classVersion = "".

    stateStop:integer = 0.
    stateDrive:integer = 1.
    stateWait:integer = 2.
    
facts
    direction:integer := 3.
    dX:integer := 0.
    dY:integer := 1.
    state:integer := 0.

    currentPosition:pnt := pnt(0,0).
    nextPosition:pnt := pnt(0,0).
    
    cell:pnt := pnt(0,0).
    nextCell:pnt := pnt(0,0).

clauses
    classInfo(className, classVersion).

    init(Cell) :-
        cell:=Cell,
        pnt(CellI,CellJ) = Cell,
        currentPosition:=pnt(CellI*draw::cellImgSize,CellJ*draw::cellImgSize),
        This:initWay().

    move():-
        state = stateDrive,
        pnt(X,Y) = currentPosition,
        currentPosition:=pnt(X+dX,Y+dY),
        if nextPosition = currentPosition,! then
            cell:=nextCell,
            This:onBeforeNextCell()
        end if,!.
    move():-
        state = stateWait,
        This:onWait(),!.
    move().
    
    initWay().
    
    onBeforeNextCell().
    onWait().

    getCell()=cell.
    
    getNextCell()=nextCell.
   
    getDirection()=direction.

    getPosition()=currentPosition.
    
    setNextCell(Dir,pnt(I,J)):-
        setDirection(Dir),
        CarX = I*draw::cellImgSize,
        CarY = J*draw::cellImgSize,
        nextCell:=pnt(I,J),
        nextPosition:=pnt(CarX,CarY).
    
    stop():-
        stdio::write("Car - Stop.\n"),
        state:=stateStop.

    drive():-
        stdio::write("Car - Drive.\n"),
        state:=stateDrive.

    wait():-
        stdio::write("Car - Wait.\n"),
        state:=stateWait.

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

predicates
    setDirection:(integer).
clauses
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

end implement car
