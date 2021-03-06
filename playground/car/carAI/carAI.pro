/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement carAI inherits car
    open core, vpiDomains, utils

domains
    dir_list = integer*.

facts
    hasRoad:positive := 1.
    way:pntlist := [].

clauses
    classInfo(className, classVersion).

    getClassName()=className.

    initWay():-
        if checkDirection() = 0,! then
            hasRoad:=0,
            stop()
        else
            newWay(),
            drive()
        end if,!.
    initWay():-
        hasRoad = 1,
        initWay(),!.
    initWay().

    onBeforeNextCell():-
        way = [],
        initWay(),!.          
    onBeforeNextCell():-
        moveNextCell(),
        !.
    onBeforeNextCell():-
        stop(),!.

    onWait():-
        NextCell = getNextCell(),
        carManager::checkCarInCell(getDirection(),NextCell) = 0,
        checkTrafficLight(NextCell) = 1,
        drive(),!.
    onWait().
            
predicates 
    newWay:() determ.
clauses
    newWay():-
        pnt(CellI,CellJ) = getCell(),
        utils::findRoadCellDist(CellI,CellJ,DestI,DestJ),
        DestCell = pnt(DestI,DestJ),
        setDestCell(DestCell),
        Dist = utils::calcDistance(pnt(CellI,CellJ),DestCell),
        stdio::writef("CarAI: New destination [%d,%d] -> [%d,%d], Distance: %d\n",CellI,CellJ,DestI,DestJ, Dist),
        Way=mapBFS::calcWay(pnt(CellI,CellJ),DestCell),
        stdio::write("Way: ",Way),stdio::nl,
        [_ThisCell | Tail] = Way,
        way:=Tail,
        moveNextCell().
           
predicates
    moveNextCell:() determ.
clauses
    moveNextCell():-
       [NextCell | Tail ] = way,
       detectDirection(getCell(),NextCell,NewDir),
       setNextCell(NewDir,NextCell),
       way:=Tail,
       if utils::checkTrafficLight(NextCell) = 0,! then
           wait()
       else
           if carManager::checkCarInCell(NewDir,NextCell) = 1,! then
               wait()
           end if
       end if.
        
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
    
predicates
   findDirections:(integer CellI, integer CellJ, dir_list , dir_list) determ (i,i,i,o).
clauses
    findDirections(_CellI, _CellJ, [] , []).
    findDirections(CellI, CellJ, [DirHead|Tail] , NewList):-
        findDirections(CellI, CellJ, Tail , ANewList),
        utils::getDirectionCell(DirHead,pnt(CellI,CellJ),NewCell),
        pnt(NewI,NewJ) = NewCell,
        if utils::checkRoadCell(NewI,NewJ) = 0,! then
            NewList = ANewList
        else
            NewList = list::append(ANewList,[DirHead])
        end if.

end implement carAI
