/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement cityGenerator
    open core, math

constants
    className = "playground/cityGenerator/cityGenerator".
    classVersion = "".
  
    startTop    = 0.
    startLeft   = 1.
    startRight  = 2.
    startBottom = 3.
    
    dirTop      = 0.
    dirLeft     = 1.
    dirRight    = 2.
    dirBottom   = 3.
facts
    cell : (integer I, integer J, integer Type) nondeterm.

predicates
   addCell : (integer I,integer J,integer Type).
   addRoadCell:(integer,integer) procedure (i, i).
   placeRoads:(integer,integer,integer) procedure (i, i, i).
   placeRoad:(integer,integer,integer,integer,integer) procedure (i,i, i, i, i).
   fillMap:(integer,integer) procedure (i, i).
   fillRoad: (integer,integer) procedure (i, i).
   getRoardStartCoord:(integer,integer,integer) procedure (i,o,o).
   newDirection:(integer,integer,integer,integer) procedure (i,i,i,o).
   dirToText:(integer) -> string.
   startTypeToText:(integer) -> string.
   prtDataBase:(integer, integer) procedure (i,i).
   notCellType:(integer) -> integer.
   canBeRoad:(integer,integer,integer) procedure (i,i,o).
clauses
    classInfo(className, classVersion).

    create() :- 
        fillMap(maxRow,maxCol),!,
        !,
        %StartType = random(3),
        %getRoardStartCoord(StartType,StartI,StartJ),
        %stdio::writef("Start (Type: %s) [ %d , %d ]\n",startTypeToText(StartType),StartI,StartJ),
        %placeRoads(StartI,StartJ,StartType),
        fillRoad(maxRow,maxCol),
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
        CornerOrSelf = random(2),     
        if I > 0, J > 0, CanCorner = 1, CornerOrSelf = 0, ! then
        %    addCell(I-1,J-1,cellRoad)
        else 
            addCell(I,J,cellRoad)
        end if,
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
        
    notCellType(Type)=NewType:-
        Type = cellEmpty,
        NewType = cellRoad,!.
    notCellType(Type)=NewType:-
        Type = cellRoad,
        NewType = cellEmpty,!.
    notCellType(_Type)=0.
            
    
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
        
    addRoadCell(I,J) :-
        retract(cell(I,J,cellEmpty)),
        addCell(I,J,cellRoad),!.
    addRoadCell(_I,_J).
    
    getCellType(I,_J,cellEmpty) :-
        I < 0, !.
    getCellType(_I,J,cellEmpty) :-
        J < 0, !.
    getCellType(I,J,Type) :-
        cell(I,J, Type).

    getRoardStartCoord(Num,StartI,StartJ):-
        Num = startTop, !, % top
        StartI = random(maxCol-2)+1,
        StartJ = 0.
    getRoardStartCoord(Num,StartI,StartJ):-
        Num = startLeft, !, %
        StartI = 0,
        StartJ = random(maxRow-2)+1.
    getRoardStartCoord(Num,StartI,StartJ):-
        Num = startRight, !,
        StartI = maxCol,
        StartJ = random(maxRow-2)+1.
    getRoardStartCoord(Num,StartI,StartJ):-
        Num = startBottom, !,
        StartI = random(maxCol-2)+1,
        StartJ = maxRow.
    getRoardStartCoord(_Num,0,0).


    placeRoads(StartI,StartJ,StartType):-
        StartType = startTop, !,
        placeRoad(dirTop,StartI,StartJ,dirBottom,2).
    placeRoads(StartI,StartJ,StartType):-
        StartType = startBottom, !,
        placeRoad(dirBottom,StartI,StartJ,dirTop,2).
    placeRoads(StartI,StartJ,StartType):-
        StartType = startLeft, !,
        placeRoad(dirLeft,StartI,StartJ,dirRight,2).
    placeRoads(StartI,StartJ,StartType):-
        StartType = startRight, !,
        placeRoad(dirRight,StartI,StartJ,dirLeft,2).
    placeRoads(_StartI,_StartJ,_StartType).
   
    placeRoad(_,I,_,_,_):-
        I<0,!.
    placeRoad(_,_,J,_,_):-
        J<0,!.
    placeRoad(_,I,_,_,_):-
        I>maxRow,!.
    placeRoad(_,_,J,_,_):-
        J>maxCol,!.
    placeRoad(StartDir,I,J,Dir,StepLimit):-
        StepLimit < 0, !,
        newDirection(StartDir,Dir,-1,NewDir),
        NewStepLimit = random(2)+2,
%        stdio::writef("Direction: %s, Steps: %d [ %d , %d ]\n",dirToText(NewDir),NewStepLimit,I,J),
        placeRoad(StartDir,I,J,NewDir,NewStepLimit).
    placeRoad(StartDir,I,J,Dir,StepLimit):-
        Dir = dirBottom,!,
        stdio::writef("Direction: %s, Steps: %d [ %d , %d ]\n",dirToText(Dir),StepLimit,I,J),
        addRoadCell(I,J),
        placeRoad(StartDir,I,J+1,Dir,StepLimit-1).
    placeRoad(StartDir,I,J,Dir,StepLimit):-
        Dir = dirTop,!,
        stdio::writef("Direction: %s, Steps: %d [ %d , %d ]\n",dirToText(Dir),StepLimit,I,J),
        addRoadCell(I,J),
        placeRoad(StartDir,I,J-1,Dir,StepLimit-1).
    placeRoad(StartDir,I,J,Dir,StepLimit):-
        Dir = dirLeft,!,
        stdio::writef("Direction: %s, Steps: %d [ %d , %d ]\n",dirToText(Dir),StepLimit,I,J),
        addRoadCell(I,J),
        placeRoad(StartDir,I-1,J,Dir,StepLimit-1).
    placeRoad(StartDir,I,J,Dir,StepLimit):-
        Dir = dirRight,!,
        stdio::writef("Direction: %s, Steps: %d [ %d , %d ]\n",dirToText(Dir),StepLimit,I,J),
        addRoadCell(I,J),
        placeRoad(StartDir,I+1,J,Dir,StepLimit-1).
    placeRoad(_StartDir,_I,_J,_Dir,_StepLimit).
    
    startTypeToText(StartType) = Txt :-
        StartType = startBottom,!,
        Txt = "StartBottom".
    startTypeToText(StartType) = Txt :-
        StartType = startTop,!,
        Txt = "StartTop".
    startTypeToText(StartType) = Txt :-
        StartType = startLeft,!,
        Txt = "StartLeft".
    startTypeToText(StartType) = Txt :-
        StartType = startRight,!,
        Txt = "StartRight".
    startTypeToText(_StartType) = "".
     
    dirToText(Dir) = Txt :-
        Dir = dirBottom,!,
        Txt = "Bottom".
    dirToText(Dir) = Txt :-
        Dir = dirTop,!,
        Txt = "Top".
    dirToText(Dir) = Txt :-
        Dir = dirLeft,!,
        Txt = "Left".
    dirToText(Dir) = Txt :-
        Dir = dirRight,!,
        Txt = "Right".
    dirToText(_Dir) = "".
 
 
    prtDataBase(I,J):-
        I>maxRow,!,
        stdio::nl,
        prtDataBase(0,J+1).
    prtDataBase(_,J):-
        J>maxCol,!.
    prtDataBase(I,J) :- 
        cell(I,J,Type),!,
        stdio::write(Type, " "),
        prtDataBase(I+1,J).
    prtDataBase(_I,_J).


    newDirection(StartDir,OldDir,Temp,NewDir) :-
        not(-1 = Temp),
        not(OldDir = Temp),
        not(StartDir = Temp),
        NewDir = Temp, !.
    newDirection(StartDir,OldDir,_,NewDir) :-
        Temp = random(3),
        newDirection(StartDir,OldDir,Temp,NewDir),!.
        
        
       
    
end implement cityGenerator
