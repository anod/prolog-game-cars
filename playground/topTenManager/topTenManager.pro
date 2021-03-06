/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement topTenManager
    open core, topTenDomains

constants
    className = "playground/topTenManager/topTenManager".
    classVersion = "".

    cFILE_NAME = "top.fac".
    
class facts - top
    top10 : (integer ID, integer Value) nondeterm.
    currentList:top10_list := [].
    
clauses
    classInfo(className, classVersion).

    init():-
        file::consult(cFILE_NAME, top),!.

    calcScore(TimeMillis)=math::floor(100000/(TimeMillis/1000)).

    addScore(Value) :-
        top10(ID,Value),
        assert(top10(ID+1,Value)),
        file::save(cFILE_NAME, top),!.
    addScore(Value) :-
        assert(top10(0,Value)),
        file::save(cFILE_NAME, top),!.

    getTopTen()=Result:-
        currentList:=[],
        loadList(),
        ListSorted = list::sort(currentList),
        ListRev = list::reverse(ListSorted),
        List10 = list::take(10,ListRev),
        if list::length(List10) < 10 then
            Need = 10 - list::length(List10),
            Result = fillEmpty(Need, List10)
        else 
            Result = List10
        end if,!.

class predicates
    fillEmpty:(integer, top10_list) -> top10_list.
clauses
    fillEmpty(0,List) = List:-!.
    fillEmpty(Count,List) = Result :-
        Temp = list::append(List,[0]),
        Result = fillEmpty(Count-1,Temp),!.
    
class predicates
    loadList:() procedure.
clauses
    loadList():-
        top10(_ID,Value),
        currentList := list::append([Value],currentList),fail.
    loadList().

    
end implement topTenManager
