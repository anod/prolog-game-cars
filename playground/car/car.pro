/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement car
    open core, vpiDomains

constants
    className = "playground/car/car".
    classVersion = "".

    cSTATE_STOP:integer = 0.
    cSTATE_DRIVE:integer = 1.
    cSTATE_WAIT:integer = 2.
    
facts
    direction:integer := 3.
    dX:integer := 0.
    dY:integer := 1.
    state:integer := 0.

    currentPosition:pnt := pnt(0,0).
    nextPosition:pnt := pnt(0,0).
    
    cell:pnt := pnt(0,0).
    nextCell:pnt := pnt(0,0).
    destCell:pnt := pnt(0,0).

clauses
    classInfo(className, classVersion).

    getClassName()=className.

    init(Cell) :-
        cell:=Cell,
        pnt(CellI,CellJ) = Cell,
        currentPosition:=pnt(CellI*draw::cellImgSize,CellJ*draw::cellImgSize),
        This:initWay().

    move():-
        state = cSTATE_DRIVE,
        pnt(X,Y) = currentPosition,
        currentPosition:=pnt(X+dX,Y+dY),
        if nextPosition = currentPosition,! then
            cell:=nextCell,
            This:onBeforeNextCell()
        end if,!.
    move():-
        state = cSTATE_WAIT,
        This:onWait(),!.
    move().
    
    initWay().
    
    onBeforeNextCell().
    onWait().

    getCell()=cell.
    
    getNextCell()=nextCell.
    setNextCell(Dir,pnt(I,J)):-
        setDirection(Dir),
        CarX = I*draw::cellImgSize,
        CarY = J*draw::cellImgSize,
        nextCell:=pnt(I,J),
        nextPosition:=pnt(CarX,CarY).
    
    getDestCell()=destCell.
    setDestCell(Cell):-
       destCell := Cell,!.

    getPosition()=currentPosition.
    setPosition(Pos):-
        currentPosition := Pos,!.
    
    getDirection()=direction.
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

    stop():-
        state:=cSTATE_STOP.

    drive():-
        state:=cSTATE_DRIVE.

    wait():-
        state:=cSTATE_WAIT.

end implement car
