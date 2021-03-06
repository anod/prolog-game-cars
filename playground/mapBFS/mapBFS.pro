/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement mapBFS
    open core, vpiDomains

constants
    className = "playground/mapBFS/mapBFS".
    classVersion = "".

domains
    node=pnt.
    path=node*.
    queue=path*.
    
class facts
    arcs : (pnt A, pnt B).

clauses
    classInfo(className, classVersion).

    build() :-
       purge(),
       fillArcs(cityGenerator::maxCol,cityGenerator::maxRow),!.

    calcWay(Start, Goal)=Path :-
        fgoal:=Goal,
        bSearch([[Start]], L),
        Path = list::reverse(L),!.

class facts
    fgoal:pnt := pnt(0,0).

class predicates
     solved:(path) determ.
clauses    
    solved(L) :-
        L = [ fgoal | _].
class predicates
    bSearch:(queue, path) determ (i,o).
clauses    
    bSearch([T|Queue],Solution):-
        if solved(T) then
           Solution = T
        else
            Extention = [Daughter || nextLevel(T,Daughter)],
            ExtendedQueue = list::append(Queue, Extention),
            bSearch(ExtendedQueue, Solution)
         end if.
         
class predicates
    nextLevel:(path,path) nondeterm (i,o).
clauses   
    nextLevel([Point|Path], [Daughter,Point|Path]):-
        arcs(Point,Daughter),
        not(list::isMember(Daughter,Path)).

class predicates    
    fillArcs:(integer I,integer J).
clauses
    fillArcs(I,_):-
        I<0,!.
    fillArcs(I,J):-
        J<0,!,
        fillArcs(I-1,cityGenerator::maxCol).
    fillArcs(I,J) :-
        cityGenerator::getCellType(I,J,Type),
        Type = cityGenerator::cellRoad,!, 
        fillArc(I,J,I-1,J),
        fillArc(I,J,I+1,J),
        fillArc(I,J,I,J-1),
        fillArc(I,J,I,J+1),

        fillArcs(I,J-1).   
    fillArcs(I,J) :-
        fillArcs(I,J-1).   

class predicates       
    fillArc:(integer I,integer J, integer I1, integer J1).
clauses   
    fillArc(I,J,I1,J1) :-
        arcs(pnt(I,J),pnt(I1,J1)),!.
    fillArc(I,J,I1,J1) :-
        cityGenerator::getCellType(I1,J1,Type),
        Type = cityGenerator::cellRoad,!, 
        assert(arcs(pnt(I,J),pnt(I1,J1))).
    fillArc(_I,_J,_I1,_J1).
        
class predicates
    purge:().
clauses
    purge():-
        retractall(arcs(_,_)),!.
end implement mapBFS
