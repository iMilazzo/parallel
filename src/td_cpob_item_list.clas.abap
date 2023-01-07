
CLASS td_cpob_item_list DEFINITION PUBLIC CREATE PRIVATE FOR TESTING
INHERITING FROM th_cpob_item_list FINAL.
  PUBLIC SECTION.
    CLASS-METHODS create_double
      IMPORTING iv_process_time TYPE cpob_process_time
      RETURNING VALUE(ro_list) TYPE REF TO td_cpob_item_list.

    METHODS if_cpob_item_list~get_processing_time REDEFINITION.

  PRIVATE SECTION.
    DATA mv_process_time TYPE cpob_process_time.
ENDCLASS.


CLASS td_cpob_item_list IMPLEMENTATION.
  METHOD create_double.
    ro_list = NEW td_cpob_item_list( ).
    ro_list->mv_process_time = iv_process_time.
  ENDMETHOD.

  METHOD if_cpob_item_list~get_processing_time.
    rv_time = mv_process_time.
  ENDMETHOD.
ENDCLASS.
