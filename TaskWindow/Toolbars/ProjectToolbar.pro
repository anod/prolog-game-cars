/*****************************************************************************

                        Copyright © 

******************************************************************************/

implement projectToolbar
    open core, vpiDomains, vpiToolbar, resourceIdentifiers

constants
    className = "TaskWindow/Toolbars/projectToolbar".
    classVersion = "".

clauses
    classInfo(className, classVersion).

clauses
    create(Parent):-
        _ = vpiToolbar::create(style, Parent, controlList).

% This code is maintained automatically, do not update it manually. 07:19:09-30.10.2011
constants
    style : vpiToolbar::style = tb_top().
    controlList : vpiToolbar::control_list =
        [
        ].
% end of automatic code
end implement projectToolbar
