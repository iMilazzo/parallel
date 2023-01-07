
CLASS cl_cpob_item DEFINITION PUBLIC CREATE PROTECTED
GLOBAL FRIENDS cl_cpob_int_order_factory.
  PUBLIC SECTION.
    INTERFACES if_cpob_item.
    INTERFACES if_cpob_api_object.

  PROTECTED SECTION.
    METHODS constructor
      IMPORTING is_data TYPE cpob_s_item_data OPTIONAL.

    DATA ms_data TYPE cpob_s_item_data.
    DATA mo_pstep_list TYPE REF TO if_cpob_process_step_list.
    DATA mv_process_time TYPE cpob_process_time.

  PRIVATE SECTION.
    CLASS-METHODS create
      IMPORTING is_data TYPE cpob_s_item_data
      RETURNING VALUE(ro_item) TYPE REF TO cl_cpob_item ##RELAX.
ENDCLASS.


CLASS cl_cpob_item IMPLEMENTATION.
  METHOD create.
    ro_item = NEW cl_cpob_item( is_data ).
  ENDMETHOD.

  METHOD constructor.
    ms_data = is_data.

    DATA(lo_factory) = cl_cpob_int_order_factory=>get( ).
    mo_pstep_list = lo_factory->create_process_step_list( ).
  ENDMETHOD.

  METHOD if_abap_parallel~do.
    DATA(lo_dao) = cl_cpob_dao_factory=>get( )->get_dao( ).
    DATA(lo_api) = cl_cpob_api_factory=>get( )->get_api( ).

    mv_process_time = lo_dao->read_item_setup_time( ms_data-item_type ).
    mv_process_time += lo_api->get_processing_time_of( me ).
    mv_process_time += mo_pstep_list->get_processing_time( ).
  ENDMETHOD.

  METHOD if_cpob_item~prepare_parallel_processing.
    RETURN. "for testing only
  ENDMETHOD.

  METHOD if_cpob_item~take_over_result_from.
    DATA(lo_item) = CAST if_cpob_item( io_item ).
    mv_process_time = lo_item->get_processing_time( ).
  ENDMETHOD.

  METHOD if_cpob_item~get_key.
    rs_key = ms_data-key.
  ENDMETHOD.

  METHOD if_cpob_item~get_processing_time.
    rv_time = mv_process_time.
  ENDMETHOD.

  METHOD if_cpob_api_object~get_api_data.
    rs_data-api_type = ms_data-item_type.
  ENDMETHOD.
ENDCLASS.
