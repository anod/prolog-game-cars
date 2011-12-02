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
    hasRoad:positive := 1.
    way:pntlist := [].
    
predicates
   findDirections:(integer CellI, integer CellJ, dir_list , dir_list) determ (i,i,i,o).
   getNewCell:(integer,integer,integer,integer,integer) procedure (i,i,i,o,o).
   checkNewCell:(integer,integer) -> integer.
   
clauses
    classInfo(className, classVersion).

    initWay():-
        if checkDirection() = 0,! then
            hasRoad:=0,
            stop()
        else
            pnt(CellI,CellJ) = getCell(),
            utils::findRoadCell(DestI,DestJ),
            stdio::writef("CarAI: New direction [%d,%d] -> [%d,%d]\n",CellI,CellJ,DestI,DestJ),
            Way=mapBFS::calcWay(pnt(CellI,CellJ),pnt(DestI,DestJ)),
            stdio::write("Way: ",Way),stdio::nl,
            [_ThisCell | Tail] = Way,
            way:=Tail,
            moveNextCell(),
            drive()
        end if,!.
    initWay():-
        hasRoad = 1,
        stop(),!.
    initWay().
            
    update():-
        hasRoad = 1,
        moveNextCell(),
        !.
    update():-
        hasRoad = 1,
        way = [],
        initWay(),
        moveNextCell(),!.
    update():-
        hasRoad = 1,
        stop(),!.
    update().

predicates
    moveNextCell:() determ.
clauses
    moveNextCell():-
       [NextCell | Tail ] = way,
       detectDirection(getCell(),NextCell,NewDir),
       setNextCell(NewDir,NextCell),
       way:=Tail.
    
    
predicates
   checkDirection:() -> integer.
clauses
   checkDirection()=Success:-
        DirList = [dirTop,dirLeft,dirRight,dirBottom],
        pnt(CellI,CellJ) = getCell(),
        findDirections(CellI,CellJ,DirList,PosDirList),
        if list::length(PosDirList) > 0,! then
            Success = 1
        else
            Success = 0
        end if,!.
   checkDirection()=0.

predicates
    detectDirection:(pnt,pnt,integer) determ (i,i,o).
clauses
    detectDirection(pnt(I,J),pnt(I1,J1),dirRight):-
        I+1 = I1, J = J1, !.
    detectDirection(pnt(I,J),pnt(I1,J1),dirLeft):-
        I-1 = I1, J = J1, !.
    detectDirection(pnt(I,J),pnt(I1,J1),dirBottom):-
        I = I1, J+1 = J1, !.
    detectDirection(pnt(I,J),pnt(I1,J1),dirTop):-
        I = I1, J-1 = J1, !.
    
clauses

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
