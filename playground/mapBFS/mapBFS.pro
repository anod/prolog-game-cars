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
    fgoal:pnt := pnt(0,0).

class predicates
     fillArcs:(integer I,integer J).
     fillArc:(integer I,integer J, integer I1, integer J1).
     bSearch:(queue, path) determ (i,o).
     nextLevel:(path,path) nondeterm (i,o).
     solved:(path) determ.
     purge:().
clauses
    classInfo(className, classVersion).

    build() :-
       purge(),
       fillArcs(cityGenerator::maxCol,cityGenerator::maxRow),!.

    purge():-
        retract(arcs(_A,_B)),!.
    purge().

    calcWay(Start, Goal)=Path :-
        fgoal:=Goal,
        bSearch([[Start]], L),
        Path = list::reverse(L),!.
    
    solved(L) :-
        L = [ fgoal | _].
    
    bSearch([T|Queue],Solution):-
        if solved(T) then
           Solution = T
        else
            Extention = [Daughter || nextLevel(T,Daughter)],
            ExtendedQueue = list::append(Queue, Extention),
            bSearch(ExtendedQueue, Solution)
         end if.
   
    nextLevel([Point|Path], [Daughter,Point|Path]):-
        arcs(Point,Daughter),
        not(list::isMember(Daughter,Path)).
    
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
          
    fillArc(I,J,I1,J1) :-
        arcs(pnt(I,J),pnt(I1,J1)),!.
    fillArc(I,J,I1,J1) :-
        cityGenerator::getCellType(I1,J1,Type),
        Type = cityGenerator::cellRoad,!, 
        assert(arcs(pnt(I,J),pnt(I1,J1))).
    fillArc(_I,_J,_I1,_J1).
        

end implement mapBFS
