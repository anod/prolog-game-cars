/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement carAI inherits car
    open core, vpiDomains, utils

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
   filterDirection:(dir_list,integer,dir_list) procedure (i,i,o).
clauses
    classInfo(className, classVersion).

    initDirection():-
        DirList = [dirTop,dirLeft,dirRight,dirBottom],
        utils::carToCell(This,CellI,CellJ),
        findDirections(CellI,CellJ,DirList,PosDirList),
        
        if list::length(PosDirList) = 0,! then
            hasWay:=0,
            stop()
        else
            Idx = math::random(list::length(PosDirList)), % dirTop,dirLeft,dirRight,dirBottom
            NewDir = list::tryGetNth(Idx,PosDirList),
            setDirection(NewDir),
            drive()
        end if,!.
    initDirection().
    
    move():-
        hasWay = 1,
        utils::carToCell(This,CellI,CellJ),
        Dir = getDirection(),
        getNewCell(CellI,CellJ,Dir,NewI,NewJ),
        checkNewCell(NewI,NewJ) = 1,!.
    move():-
        hasWay = 1,

        Dir = getDirection(),
        DirList = list::remove([dirTop,dirLeft,dirRight,dirBottom],Dir),
        utils::carToCell(This,CellI,CellJ),
        findDirections(CellI,CellJ,DirList,PosDirList),
        
        if list::length(PosDirList) = 0,! then
            hasWay:=0,
            stop()
        else
            filterDirection(PosDirList,Dir,FPosDirList),
            Idx = math::random(list::length(FPosDirList)), % dirTop,dirLeft,dirRight,dirBottom
            NewDir = list::tryGetNth(Idx,FPosDirList),
            setDirection(NewDir)
        end if,!.
    move().

    filterDirection(PosDirList,_,PosDirList):-
        list::length(PosDirList) = 1,!.
    filterDirection(PosDirList,OldDir,NewDirList):-
        OldDir = dirTop,
        NewDirList = list::remove(PosDirList,dirBottom),!.
    filterDirection(PosDirList,OldDir,NewDirList):-
        OldDir = dirBottom,
        NewDirList = list::remove(PosDirList,dirTop),!.
    filterDirection(PosDirList,OldDir,NewDirList):-
        OldDir = dirLeft,
        NewDirList = list::remove(PosDirList,dirRight),!.
    filterDirection(PosDirList,OldDir,NewDirList):-
        OldDir = dirRight,
        NewDirList = list::remove(PosDirList,dirLeft),!.
    filterDirection(PosDirList,_,PosDirList).
        

    findDirections(_CellI, _CellJ, [] , []).
    findDirections(CellI, CellJ, [DirHead|Tail] , NewList):-
        findDirections(CellI, CellJ, Tail , ANewList),
        getNewCell(CellI,CellJ,DirHead,NewI,NewJ),
        if checkNewCell(NewI,NewJ) = 0,! then
            NewList = ANewList
        else
            NewList = list::append(ANewList,[DirHead])
        end if.
            
    getNewCell(CurI,CurJ,Dir,CurI,CurJ-1):-
       Dir = dirTop,!.
    getNewCell(CurI,CurJ,Dir,CurI-1,CurJ):-
       Dir = dirLeft,!.
    getNewCell(CurI,CurJ,Dir,CurI+1,CurJ):-
       Dir = dirRight,!.
    getNewCell(CurI,CurJ,Dir,CurI,CurJ+1):-
       Dir = dirBottom,!.
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
