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

    currentPosition:pnt := pnt(0,0).
    nextPosition:pnt := pnt(0,0).
    
    cell:pnt := pnt(0,0).
  
predicates
    setDirection:(integer).
    
clauses
    classInfo(className, classVersion).

    init(Cell) :-
      cell:=Cell,
      pnt(CellI,CellJ) = Cell,
      currentPosition:=pnt(CellI*draw::cellImgSize,CellJ*draw::cellImgSize),
      This:initWay().
        
    initWay().
    update().

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

    move():-
        if speed = 1, ! then
           pnt(X,Y) = currentPosition,
           currentPosition:=pnt(X+dX,Y+dY),
           if nextPosition = currentPosition,! then
                utils::pntToCell(currentPosition,Cell),
                cell:=Cell,
                This:update()
           end if
        end if.

   getCell()=cell.
        
   getDirection()=direction.

   getPosition()=currentPosition.
    
   setNextCell(Dir,pnt(I,J)):-
      setDirection(Dir),
      CarX = I*draw::cellImgSize,
      CarY = J*draw::cellImgSize,
      adjustCoords(Dir,pnt(CarX,CarY),NewPos),
      nextPosition:=NewPos.
    
predicates
    adjustCoords:(integer Dir,pnt, pnt) procedure (i,i,o). 
clauses
 %   adjustCoords(Dir, pnt(X, Y), pnt(X, Y+draw::cellImgSize - 1)):-
    adjustCoords(Dir, pnt(X, Y), pnt(X, Y+draw::cellImgSize)):-
        Dir = car::dirBottom,!.
%    adjustCoords(Dir, pnt(X, Y), pnt(X+draw::cellImgSize - 1, Y)):-
    adjustCoords(Dir, pnt(X, Y), pnt(X+draw::cellImgSize , Y)):-
        Dir = car::dirLeft,!.
%    adjustCoords(Dir, pnt(X, Y), pnt(X-1, Y)):-
    adjustCoords(Dir, pnt(X, Y), pnt(X, Y)):-
        Dir = car::dirRight,!.
    adjustCoords(Dir, pnt(X, Y), pnt(X, Y)):-
%    adjustCoords(Dir, pnt(X, Y), pnt(X, Y-1)):-
        Dir = car::dirTop,!.
    adjustCoords(_, pnt(X, Y), pnt(X, Y)).

clauses
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
