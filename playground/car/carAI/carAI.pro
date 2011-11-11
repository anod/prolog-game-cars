/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement carAI inherits car
    open core, vpiDomains

constants
    className = "playground/car/carAI/carAI".
    classVersion = "".

domains
    dir_list = integer*.

facts
    hasWay:positive := 1.
    
predicates
   findDirections:(integer CellI, integer CellJ, dir_list , dir_list) determ (i,i,i,o).
   getNewCell:(integer,integer,integer,integer,integer) procedure (i,i,i,o,o).
   checkNewCell:(integer,integer) -> integer.

clauses
    classInfo(className, classVersion).

    move():-
        hasWay = 1,
        drive(),
        draw::carToCell(This,CellI,CellJ),
        Dir = getDirection(),
        getNewCell(CellI,CellJ,Dir,NewI,NewJ),
        checkNewCell(NewI,NewJ) = 1,!.
    move():-
        hasWay = 1,

        DirList = list::remove([dirTop,dirLeft,dirRight,dirBottom],getDirection()),
        draw::carToCell(This,CellI,CellJ),
        findDirections(CellI,CellJ,DirList,PosDirList),
        
        if list::length(PosDirList) = 0,! then
            hasWay:=0,
            stop()
        else
            Idx = math::random(list::length(DirList)), % dirTop,dirLeft,dirRight,dirBottom
            NewDir = list::tryGetNth(Idx,DirList),
            setDirection(NewDir)
        end if,!.
    move().


    findDirections(_CellI, _CellJ, [] , []).
    findDirections(CellI, CellJ, [DirHead|Tail] , NewList):-
        findDirections(CellI, CellJ, Tail , ANewList),
        getNewCell(CellI,CellJ,DirHead,NewI,NewJ),
        if checkNewCell(NewI,NewJ) = 0,! then
            NewList = ANewList
        else
            NewList = list::append(ANewList,[DirHead])
        end if.
            
    getNewCell(CurI,CurJ,NewDir,CurI,CurJ-1):-
       NewDir = dirTop,!.
    getNewCell(CurI,CurJ,NewDir,CurI-1,CurJ):-
       NewDir = dirLeft,!.
    getNewCell(CurI,CurJ,NewDir,CurI+1,CurJ):-
       NewDir = dirRight,!.
    getNewCell(CurI,CurJ,NewDir,CurI,CurJ+1):-
       NewDir = dirBottom,!.
    getNewCell(CurI,CurJ,_,CurI,CurJ).
    
    checkNewCell(I,_)=0:-
        I < 0,!.
    checkNewCell(_,J)=0:-
        J < 0,!.
    checkNewCell(I,_)=0:-
        I > cityGenerator::maxCol,!.
    checkNewCell(_,J)=0:-
        J > cityGenerator::maxRow,!.
    checkNewCell(I,J)=1:-
        cityGenerator::getCellType(I,J,Type),
        Type = cityGenerator::cellRoad,!.
    checkNewCell(_,_)=0.

end implement carAI
