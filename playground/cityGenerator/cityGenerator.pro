/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement cityGenerator
    open core, math

constants
    className = "playground/cityGenerator/cityGenerator".
    classVersion = "".

class facts
    cell : (integer I, integer J, integer Type) nondeterm.

class predicates
   addCell : (integer I,integer J,integer Type).
   fillMap:(integer,integer) procedure (i, i).
   fillRoad: (integer,integer) procedure (i, i).
   prtDataBase:(integer, integer) procedure (i,i).
   canBeRoad:(integer,integer,integer) procedure (i,i,o).
clauses
    classInfo(className, classVersion).

    create() :- 
        fillMap(maxCol,maxRow),!,
        !,
        fillRoad(maxCol,maxRow),
        prtDataBase(0,0).
                
    fillRoad(I,_):-
        I<0,!.
    fillRoad(I,J):-
        J<0,!,
        fillRoad(I-1,maxCol).
    fillRoad(I,J):-
        I<1,!,
        fillRoad(I,J-1),
        IsRoad = random(2),
        addCell(I,J,IsRoad).
    fillRoad(I,J):-
        J<1,!,
        fillRoad(I,J-1),
        IsRoad = random(2),
        addCell(I,J,IsRoad).
    fillRoad(I,J):-
        fillRoad(I,J-1),
        getCellType(I,J-1,Up),
        getCellType(I-1,J,Left),
        getCellType(I-1,J-1,Corner),
        Up = cellEmpty,
        Left = cellEmpty,
        Corner = cellEmpty,
        addCell(I,J,cellRoad),
        !.
    fillRoad(I,J):-
        getCellType(I,J-1,Up),
        getCellType(I-1,J,Left),
        getCellType(I-1,J-1,Corner),
        Up = cellEmpty,
        Left = cellEmpty,
        Corner = cellRoad,
        addCell(I,J,cellEmpty),
        canBeRoad(I,J-1, CanUp),
        canBeRoad(I-1,J, CanLeft),
        UpOrLeft = random(2),
        if UpOrLeft = 0, CanUp = 1, ! then
            addCell(I,J-1,cellRoad)
        else
            if CanLeft = 1, ! then
                addCell(I-1,J,cellRoad)
            end if
        end if,
        !.
    fillRoad(I,J):-
        getCellType(I,J-1,Up),
        getCellType(I-1,J,Left),
        getCellType(I-1,J-1,Corner),
        Up = cellRoad,
        Left = cellRoad,
        Corner = cellEmpty,
        canBeRoad(I-1,J-1,CanCorner),
        CanCorner = 1,  
        addCell(I,J,cellRoad),
        !.
    fillRoad(I,J):-
        getCellType(I,J-1,Up),
        getCellType(I-1,J,Left),
        getCellType(I-1,J-1,Corner),
        Up = cellEmpty,
        Left = cellRoad,
        Corner = cellRoad,
        addCell(I,J,cellRoad),
        !.        
    fillRoad(I,J):-
        addCell(I,J,cellEmpty),
        !.

    canBeRoad(I,J,0):-
        getCellType(I,J-1,Up),
        getCellType(I-1,J,Left),
        getCellType(I-1,J-1,Corner),
        Up = cellRoad,
        Left = cellRoad,
        Corner = cellRoad,!.
    canBeRoad(_I,_J,1).          
    
    fillMap(I,_):-
        I<0,!.
    fillMap(I,J):-
        J<0,!,
        fillMap(I-1,maxCol).
    fillMap(I,J) :-
        addCell(I,J,cellEmpty),
        fillMap(I,J-1).

    addCell(I,J,Type) :-
        retract(cell(I,J,_)),
        assert(cell(I,J, Type)),!.
    addCell(I,J,Type) :-
        assert(cell(I,J, Type)),!.
    
    getCellType(I,_J,cellEmpty) :-
        I < 0, !.
    getCellType(_I,J,cellEmpty) :-
        J < 0, !.
    getCellType(I,J,Type) :-
        cell(I,J, Type).

    prtDataBase(I,J):-
        I>maxCol,!,
        stdio::nl,
        prtDataBase(0,J+1).
    prtDataBase(_,J):-
        J>maxRow,!.
    prtDataBase(I,J) :- 
        cell(I,J,Type),!,
        stdio::write(Type, " "),
        prtDataBase(I+1,J).
    prtDataBase(_I,_J).
  
end implement cityGenerator
