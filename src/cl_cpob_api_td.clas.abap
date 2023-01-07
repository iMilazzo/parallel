
CLASS cl_cpob_api_td DEFINITION PUBLIC CREATE PRIVATE FINAL.
  PUBLIC SECTION.
    INTERFACES if_cpob_api.

    CLASS-METHODS create
      RETURNING VALUE(ro_api) TYPE REF TO cl_cpob_api_td ##RELAX.
ENDCLASS.


CLASS cl_cpob_api_td IMPLEMENTATION.
  METHOD create.
    ro_api = NEW cl_cpob_api_td( ).
  ENDMETHOD.

  METHOD if_cpob_api~get_processing_time_of.
    DATA(lo_item) = CAST cl_cpob_item_th( io_api_object ).
    rv_time = lo_item->get_api_process_time( ).
  ENDMETHOD.
ENDCLASS.
