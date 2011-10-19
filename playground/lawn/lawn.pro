/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement lawn
    inherits formWindow
    open core, vpiDomains
   
constants
    className = "playground/lawn/lawn".
    classVersion = "".

clauses
    classInfo(className, classVersion).

clauses
    display(Parent) = Form :-
        Form = new(Parent),
        Form:show().

clauses
    new(Parent):-
        formWindow::new(Parent),
        generatedInitialize().

predicates
    onDestroy : window::destroyListener.
clauses
    onDestroy(_Source).% :- click::kill().

predicates
    onShow : window::showListener.
class facts
    city:cityGenerator := cityGenerator::new().  
clauses
    onShow(_Parent, _Data) :-
        city := cityGenerator::new(),
        city:create().%, click::bip(Parent).

predicates
    onTimer : window::timerListener.
clauses
    onTimer(_Source, _TimerId) :- 
        R=rct(0,0,800,600),
        invalidate(R).

predicates
    onPaint : drawWindow::paintResponder.
clauses
    onPaint(_Source, _Rectangle, GDIObject) :-
        draw::draw(GDIObject, city).

% This code is maintained automatically, do not update it manually. 23:27:29-17.10.2011
facts

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setFont(vpi::fontCreateByName("Tahoma", 8)),
        setText("lawn"),
        setRect(rct(50,40,650,440)),
        setDecoration(titlebar([closebutton(),maximizebutton(),minimizebutton()])),
        setBorder(sizeBorder()),
        setState([wsf_ClipSiblings,wsf_ClipChildren]),
        menuSet(noMenu),
        addDestroyListener(onDestroy),
        addShowListener(onShow),
        addTimerListener(onTimer),
        setPaintResponder(onPaint).
% end of automatic code
end implement lawn
