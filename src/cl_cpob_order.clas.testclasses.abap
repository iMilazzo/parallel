
CLASS lth_base DEFINITION ABSTRACT
INHERITING FROM th_cpob_order_base
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PROTECTED SECTION.
    DATA mo_cut TYPE REF TO th_cpob_order.
ENDCLASS.

**********************************************************************

CLASS ltc_get_processing_time DEFINITION
INHERITING FROM lth_base FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS order_pt_is_item_list_pt FOR TESTING RAISING cx_cpob_parallel.

    METHODS assert_order_process_time_is
      IMPORTING iv_exp_process_time TYPE cpob_process_time
      RAISING cx_cpob_parallel.
ENDCLASS.


CLASS ltc_get_processing_time IMPLEMENTATION.
  METHOD order_pt_is_item_list_pt.
    DATA(lo_item_list_double) =
      td_cpob_item_list=>create_double( iv_process_time = 20 ).
    mo_int_factory_double->inject_item_list( lo_item_list_double ).

    mo_cut = th_cpob_order=>create( ).

    assert_order_process_time_is( 20 ).
  ENDMETHOD.

  METHOD assert_order_process_time_is.
    cl_abap_unit_assert=>assert_equals(
      exp = iv_exp_process_time
      act = mo_cut->if_cpob_order~get_processing_time( )
    ).
  ENDMETHOD.
ENDCLASS.

**********************************************************************
