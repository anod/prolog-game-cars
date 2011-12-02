/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement lawn
    inherits formWindow
    open core, vpiDomains
   
constants
    className = "playground/lawn/lawn".
    classVersion = "".

class facts
    eraseBg:integer := 0.

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
    onDestroy(_Source) :- gameController::stop().

predicates
    onShow : window::showListener.
clauses
    onShow(Parent, _Data) :-
      gameController::init(Parent),
      gameController::start().

predicates
    onTimer : window::timerListener.
clauses
    onTimer(_Source, _TimerId) :- 
        gameController::timer(This).

predicates
    onPaint : drawWindow::paintResponder.
clauses
    onPaint(_Source, Rectangle, GDIObject) :-
        eraseBg:=0,
        gameController::draw(GDIObject, Rectangle).

predicates
    onKeyDown : drawWindow::keyDownResponder.
clauses
    onKeyDown(_Source, Key, _ShiftControlAlt) = drawWindow::defaultKeyDownHandling:-
        gameController::keyDown(Key),
        fail.
    onKeyDown(_Source, _Key, _ShiftControlAlt) = drawWindow::defaultKeyDownHandling.


predicates
    onEraseBackground : drawWindow::eraseBackgroundResponder.
clauses
    onEraseBackground(_Source, _GDI) = drawWindow::noEraseBackground :-
        eraseBg = 0,!.
    onEraseBackground(_Source, _GDI) = drawWindow::eraseBackground.

predicates
    onMove : window::moveListener.
clauses
    onMove(_Source):- eraseBg:=1 .

% This code is maintained automatically, do not update it manually. 17:34:14-2.12.2011
facts

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setFont(vpi::fontCreateByName("Tahoma", 8)),
        setText("lawn"),
        setRect(rct(150,15,662,365)),
        setDecoration(titlebar([closebutton()])),
        setBorder(thinBorder()),
        setState([wsf_ClipSiblings,wsf_ClipChildren]),
        menuSet(noMenu),
        addDestroyListener(onDestroy),
        addMoveListener(onMove),
        addShowListener(onShow),
        addTimerListener(onTimer),
        setEraseBackgroundResponder(onEraseBackground),
        setKeyDownResponder(onKeyDown),
        setPaintResponder(onPaint).
% end of automatic code
end implement lawn
