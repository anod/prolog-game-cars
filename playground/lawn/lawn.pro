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
    onDestroy(_Source) :- click::kill().

predicates
    onShow : window::showListener.
clauses
    onShow(Parent, _Data) :-
        click::bip(Parent).

predicates
    onTimer : window::timerListener.
clauses
    onTimer(_Source, _TimerId) :- 
        click::timer(This).

predicates
    onPaint : drawWindow::paintResponder.
clauses
    onPaint(_Source, Rectangle, GDIObject) :-
        click::draw(GDIObject, Rectangle).

predicates
    onPushButtonClick : button::clickResponder.
clauses
    onPushButtonClick(_Source) = button::defaultAction.

predicates
    onKeyDown : drawWindow::keyDownResponder.
clauses
    onKeyDown(_Source, Key, _ShiftControlAlt) = drawWindow::defaultKeyDownHandling:-
        click::keyDown(Key),
        fail.
    onKeyDown(_Source, _Key, _ShiftControlAlt) = drawWindow::defaultKeyDownHandling.


predicates
    onEraseBackground : drawWindow::eraseBackgroundResponder.
clauses
    onEraseBackground(_Source, _GDI) = drawWindow::noEraseBackground.

% This code is maintained automatically, do not update it manually. 19:09:46-29.10.2011
facts

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setFont(vpi::fontCreateByName("Tahoma", 8)),
        setText("lawn"),
        setRect(rct(50,40,498,354)),
        setDecoration(titlebar([closebutton(),maximizebutton(),minimizebutton()])),
        setBorder(sizeBorder()),
        setState([wsf_ClipSiblings,wsf_ClipChildren]),
        menuSet(noMenu),
        addDestroyListener(onDestroy),
        addShowListener(onShow),
        addTimerListener(onTimer),
        setEraseBackgroundResponder(onEraseBackground),
        setKeyDownResponder(onKeyDown),
        setPaintResponder(onPaint).
% end of automatic code
end implement lawn
