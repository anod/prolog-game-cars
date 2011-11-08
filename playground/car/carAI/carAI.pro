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
   newDirection:(dir_list,integer) procedure (i,o).
   getNewCell:(integer,integer,integer,integer,integer) procedure (i,i,i,o,o).
   checkNewCell:(integer,integer) -> integer.

clauses
    classInfo(className, classVersion).

    move():-
        hasWay = 1,
        drive(),
        pnt(CarX,CarY) = getPosition(),
        draw::pntToCell(CarX,CarY,CellI,CellJ),
        Dir = getDirection(),
        getNewCell(CellI,CellJ,Dir,NewI,NewJ),
        checkNewCell(NewI,NewJ) = 1,!.
    move():-
        hasWay = 1,

        DirList = list::remove([dirTop,dirLeft,dirRight,dirBottom],getDirection()),
        newDirection(DirList,NewDir),

        if NewDir > -1,! then
            setDirection(NewDir)
        else
            hasWay:=0,
            stop()
        end if,!.
    move().

    newDirection([],-1):-!.
    newDirection(DirList,NewDir):-
        pnt(CarX,CarY) = getPosition(),
        draw::pntToCell(CarX,CarY,CellI,CellJ),
        Idx = math::random(list::length(DirList)), % dirTop,dirLeft,dirRight,dirBottomN)
        NewDir = list::tryGetNth(Idx,DirList),
        NewDirList = list::remove(DirList,NewDir),
        getNewCell(CellI,CellJ,NewDir,NewI,NewJ),
        if checkNewCell(NewI,NewJ) = 0,! then
            newDirection(NewDirList,ANewDir),
            NewDir = ANewDir
        end if,!.
    newDirection(_DirList,-1).
    
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
    checkNewCell(_,_)=1.
    
end implement carAI
