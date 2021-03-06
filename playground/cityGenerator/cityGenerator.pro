/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement cityGenerator
    open core, vpiDomains, math

constants
    className = "playground/cityGenerator/cityGenerator".
    classVersion = "".

class facts
    cell : (integer I, integer J, integer Type) nondeterm.

clauses
    classInfo(className, classVersion).

    create() :-
        purge(),
        fillMap(maxCol,maxRow),
        fillRoad(),
        cityTrafficLights::place(),
        fillBuildings(maxCol,maxRow),
        prtDataBase(0,0).

    getCellType(I,_J,cellEmpty) :-
        I < 0, !.
    getCellType(_I,J,cellEmpty) :-
        J < 0, !.
    getCellType(I,J,Type) :-
        cell(I,J, Type).
    
class predicates
    fillBuildings: (integer,integer) procedure (i, i).
    % @short fill random empty cells with buildings
clauses
    fillBuildings(I,_):-
        I<0,!.
    fillBuildings(I,J):-
        J<0,!,
        fillBuildings(I-1,maxCol).
    fillBuildings(I,J):-
        getCellType(I,J,Type),
        Type = cellEmpty,
        IsBuilding = math::random(2),
        IsBuilding = 1,
        addCell(I,J,cellBuilding),
        fillBuildings(I,J-1),!.
    fillBuildings(I,J):-
        fillBuildings(I,J-1),!.

domains
    primWall = primWall (pnt, pnt).
    primWallList = primWall*.

class facts
    emptyList:primWallList := [].
class predicates
    fillRoad:().
    % @short create roads on map using randomized prim's algorithm
clauses
    fillRoad():-
        % Pick a cell, mark it as part of the maze.
        addCell(0,0,cellRoad),
        % Add the empty cells around of the cell to the empty list.
        emptyList:=[primWall(pnt(0,0),pnt(1,0)),primWall(pnt(0,0),pnt(0,1))],
        % Start prime
        prim(),!.

class predicates
    prim:().
    % @short randomized prim algorithm
clauses
    prim():-
        % stop if list is empty
        emptyList = [],!.
    prim():-
       not(emptyList = []),
       Len = list::length(emptyList),
       % Pick a random empty cell from the list.
       Idx = math::random(Len),
       Space = list::tryGetNth(Idx,emptyList),
       primWall(pnt(I,J),pnt(I1,J1)) = Space,
       getOppositeCell(Space,OpCell),
       OpCell = pnt(A,B),
       % If the cell on the opposite side isn't road yet
       if utils::checkRoadCell(A,B) = 0,! then
            % Make empty cell as road  
            addCell(I1,J1,cellRoad),
            % mark the cell on the opposite side as part of the maze.
            addCell(A,B,cellRoad),
            % Add the neighboring cell of the cell to the empty list.
            addToEmptyListSafe(OpCell,pnt(A+1,B)),
            addToEmptyListSafe(OpCell,pnt(A-1,B)),
            addToEmptyListSafe(OpCell,pnt(A,B+1)),
            addToEmptyListSafe(OpCell,pnt(A,B-1))
       end if, 
       emptyList := list::remove(emptyList,primWall(pnt(I,J),pnt(I1,J1))),
       prim(),!.
    prim().
    
class predicates
    addToEmptyListSafe:(pnt From, pnt To).
clauses
    addToEmptyListSafe(_From, pnt(I,_J)):-
        I<0,!.        
    addToEmptyListSafe(_From, pnt(I,_J)):-
        I>maxCol,!.   
    addToEmptyListSafe(_From, pnt(_I,J)):-
        J<0,!.
    addToEmptyListSafe(_From, pnt(_I,J)):-
        J>maxRow,!.
    addToEmptyListSafe(From, pnt(I,J)):-
        utils::checkRoadCell(I,J) = 0,
        emptyList:=list::append([primWall(From,pnt(I,J))],emptyList),!.
    addToEmptyListSafe(_From, _To).

class predicates
    getOppositeCell:(primWall,pnt) procedure (i,o).
clauses
    getOppositeCell(primWall(pnt(I,J),pnt(I1,J1)),pnt(A,B)):-
        I = I1, J1 = J+1, A = I1, B = J1+1, !. %down
    getOppositeCell(primWall(pnt(I,J),pnt(I1,J1)),pnt(A,B)):-
        I = I1, J1 = J-1, A = I1, B = J1-1, !. %up
    getOppositeCell(primWall(pnt(I,J),pnt(I1,J1)),pnt(A,B)):-
        I1 = I+1, J1 = J, A = I1+1, B = J1, !. %right
    getOppositeCell(primWall(pnt(I,J),pnt(I1,J1)),pnt(A,B)):-
        I1 = I-1, J1 = J, A = I1-1, B = J1, !. %left
    getOppositeCell(primWall(_,_),pnt(0,0)):-
        stdio::write("ERROR -  Cannot be\n"),!.

class predicates
   fillMap:(integer,integer) procedure (i, i).
clauses       
    fillMap(I,_):-
        I<0,!.
    fillMap(I,J):-
        J<0,!,
        fillMap(I-1,maxCol).
    fillMap(I,J) :-
        addCell(I,J,cellEmpty),
        fillMap(I,J-1).

class predicates
   addCell : (integer I,integer J,integer Type).
clauses
    addCell(I,J,Type) :-
        retract(cell(I,J,_)),
        assert(cell(I,J, Type)),!.
    addCell(I,J,Type) :-
        assert(cell(I,J, Type)),!.

class predicates
   prtDataBase:(integer, integer) procedure (i,i).
clauses
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

    
class predicates
    purge:().
clauses
    purge():-
        retractall(cell(_,_,_)),!.
  
end implement cityGenerator
