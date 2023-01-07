
CLASS tc_cpob_ct_order DEFINITION PUBLIC ABSTRACT
INHERITING FROM th_cpob_order_base
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PROTECTED SECTION.
    METHODS order_1_items_0 FOR TESTING
      RAISING cx_cpob_parallel.
    METHODS order_1_decr_items_2_psteps_0 FOR TESTING
      RAISING cx_cpob_parallel.
    METHODS order_1_incr_items_2_psteps_2 FOR TESTING
      RAISING cx_cpob_parallel.

  PRIVATE SECTION.
    METHODS setup.

    METHODS configure_setup_time
      IMPORTING io_item TYPE REF TO th_cpob_item.
    METHODS assert_order_process_time_is
      IMPORTING iv_exp_process_time TYPE cpob_process_time
      RAISING cx_cpob_parallel.

    DATA mo_any_order TYPE REF TO th_cpob_order.
    DATA mo_xpr_item_setup_1s_api_4s TYPE REF TO th_cpob_item.
    DATA mo_std_item_setup_10s_api_40s TYPE REF TO th_cpob_item.
ENDCLASS.


CLASS tc_cpob_ct_order IMPLEMENTATION.
  METHOD setup.
    mo_any_order = th_cpob_order=>create_any( ).
    mo_xpr_item_setup_1s_api_4s = th_cpob_item=>create_express( ).
    mo_xpr_item_setup_1s_api_4s->set(
      iv_setup_time = 1
      iv_api_process_time = 4
    ).
    mo_std_item_setup_10s_api_40s = th_cpob_item=>create_standard( ).
    mo_std_item_setup_10s_api_40s->set(
      iv_setup_time = 10
      iv_api_process_time = 40
    ).

    configure_setup_time( mo_xpr_item_setup_1s_api_4s ).
    configure_setup_time( mo_std_item_setup_10s_api_40s ).
  ENDMETHOD.

  METHOD order_1_items_0.
    assert_order_process_time_is( 0 ).
  ENDMETHOD.

  METHOD order_1_decr_items_2_psteps_0.
    mo_any_order->add_item( mo_std_item_setup_10s_api_40s ).
    mo_any_order->add_item( mo_xpr_item_setup_1s_api_4s ).

    assert_order_process_time_is( 50 ).
  ENDMETHOD.

  METHOD order_1_incr_items_2_psteps_2.
    mo_any_order->add_item( mo_xpr_item_setup_1s_api_4s ).
    mo_any_order->add_item( mo_std_item_setup_10s_api_40s ).
    mo_xpr_item_setup_1s_api_4s->add_process_step(
      th_cpob_pstep=>create( iv_process_time = 2 ) ).
    mo_std_item_setup_10s_api_40s->add_process_step(
      th_cpob_pstep=>create( iv_process_time = 20 ) ).

    assert_order_process_time_is( 70 ).
  ENDMETHOD.

  METHOD configure_setup_time.
    mo_dao_double->configure_setup_time_of( io_item ).
  ENDMETHOD.

  METHOD assert_order_process_time_is.
    cl_abap_unit_assert=>assert_equals(
      exp = iv_exp_process_time
      act = mo_any_order->if_cpob_order~get_processing_time( )
    ).
  ENDMETHOD.
ENDCLASS.
