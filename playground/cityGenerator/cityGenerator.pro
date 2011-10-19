/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement cityGenerator
    open core, math

constants
    className = "playground/cityGenerator/cityGenerator".
    classVersion = "".
  
%facts - city
class facts
       cell : (integer I, integer J, integer Type) determ.
 
class predicates
   addCell : (integer I,integer J,integer Type).
   placeRoads:(integer I, integer J) procedure (i,i).
   fillMap:(integer,integer) procedure (i, i).
   
clauses
    classInfo(className, classVersion).

    create() :- 
        fillMap(maxRow,maxCol),!,
        placeRoads(maxRow,maxCol).
               
    fillMap(I,_):-
        I<0,!.
    fillMap(I,J):-
        J<0,!,
        fillMap(I-1,maxCol).
    fillMap(I,J) :-
        addCell(I,J,cellEmpty),
        fillMap(I,J-1).

    addCell(I,J,Type) :-
        assert(cell(I,J, Type)).

    addRoadCell():-

    getCellType(I,J,Type) :-
        cell(I,J, Type).

    placeRoads(I,_):-
        I<0,!.
    placeRoads(I,J):-
        J<0,!,
        placeRoads(I-1,maxCol).
    placeRoads(I,J):- % general case
        I mod 2 = 0,     % mostly spaces
        random(10)>0,!,  % 90% of spaces
        retract(cell(I,J,cellEmpty)),
        addCell(I,J,cellRoad),
        placeRoads(I,J-1).
    placeRoads(I,J):- % general case
        random(10)>1,!,  % 80% of walls        
        retract(cell(I,J,cellEmpty)),
        addCell(I,J,cellRoad),
        placeRoads(I,J-1).
    placeRoads(I,J):- !, % general case
        retract(cell(I,J,cellEmpty)),
        addCell(I,J,cellRoad),
        placeRoads(I,J-1).
                     
end implement cityGenerator
