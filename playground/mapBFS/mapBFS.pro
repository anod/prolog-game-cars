/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement mapBFS
    open core, vpiDomains

constants
    className = "playground/mapBFS/mapBFS".
    classVersion = "".

class facts
    arcs : (pnt A, pnt B).
    visited : (pnt A).
	way:pntlist := [].

class predicates
     fillArcs:(integer I,integer J).
     fillArc:(integer I,integer J, integer I1, integer J1).
     addToRoute:(pnt A).
     calcWay:(pntlist List,pnt Dest) nondeterm.
     resetWay:().
     resetMap:().
     printWay:().
clauses
    classInfo(className, classVersion).

    build() :- 
        fillArcs(cityGenerator::maxCol,cityGenerator::maxRow),
        utils::findRoadCell(I,J),
        utils::findRoadCell(I1,J1),
        resetWay(),
        stdio::write("Calc way [", I, ", ", J, "] -> [", I1, ", ", J1, "]\n"),
        
        List = [pnt(I,J)],
        way := [pnt(I,J)],
        calcWay(List,pnt(I1,J1)),
        printWay(),
        !.
    build().
    
	resetWay() :-
        resetMap(),
		way:=[],!.
    %resetWay().

    resetMap():-
       retract(visited(_)),!.
    resetMap().
    
    printWay() :-
		stdio::write("route is : ", way),stdio::nl,!.
	%printWay().
    
    
    %%
 %%   public List search(Node startNode, Node goalNode) {
 %%	// list of visited nodes
%%	LinkedList closedList = new LinkedList();
%%  
%%	// list of nodes to visit (sorted)
%%	LinkedList openList = new LinkedList();
%%	openList.add(startNode);
%%	startNode.pathParent = null;
%%  
%%	while (!openList.isEmpty()) {
%%		Node node = (Node)openList.removeFirst();
%%		if (node == goalNode) {
%%			// path found!
%%			return constructPath(goalNode);
%%		}
%%		
%%		closedList.add(node);
%%
%%		// add neighbors to the open list
%%
%%		Iterator i = node.neighbors.iterator();
%%		while (i.hasNext()) {
%%			Node neighborNode = (Node)i.next();
%%			if (!closedList.contains(neighborNode) &&
%%				!openList.contains(neighborNode)) 
%%			{
%%				neighborNode.pathParent = node;
%%				openList.add(neighborNode);
%%			}
%%		}
%%	}
%%  
%%  // no path found
%% return null;
%%}
5%
%%protected List constructPath(Node node) {
%%	LinkedList path = new LinkedList();
%%	while (node.pathParent != null) {
%%		path.addFirst(node);
%%		node = node.pathParent;
%%	}
%%	return path;
%%}
    
    calcWay([],_).
    calcWay([Head|_Tail],_):-
        visited(Head),!.
    calcWay([Head|_Tail],Dest):-
        Head = Dest,!.
    calcWay([Head|Tail],Dest):-
        assert(visited(Head)),
        arcs(Head,Next),
		addToRoute(Next),
		calcWay([Next|Tail],Dest),!.
       
	addToRoute(A) :-
         not(list::isMember(A,way)),
		 way:=list::append(way,[A]),!.
	addToRoute(_).
       
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
