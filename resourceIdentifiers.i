/************************************************************************
      This file is handled by the Visual Development Environment       
************************************************************************/

interface resourceIdentifiers
constants
    id_taskmenu = 10000.
    id_file = 10001.
    id_file_new = 10002.
    idi_errorpresentation_info = 10003.
    idi_errorpresentation_warning = 10004.
    idi_errorpresentation_error = 10005.
    idb_pastebitmap = 10006.
    idb_copybitmap = 10007.
    idb_cutbitmap = 10008.
    idb_redobitmap = 10009.
    idb_undobitmap = 10010.
    idb_helpbitmap = 10011.
    idb_savefilebitmap = 10012.
    idb_openfilebitmap = 10013.
    idb_newfilebitmap = 10014.
    idt_help_line = 10015.

    acceleratorList : vpiDomains::accel_List =
        [
        vpiDomains::a(vpiDomains::k_f7, vpiDomains::c_Nothing, id_file_new)
        ].
end interface resourceIdentifiers
