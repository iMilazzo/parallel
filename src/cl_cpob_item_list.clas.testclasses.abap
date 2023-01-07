
CLASS lth_base DEFINITION ABSTRACT
INHERITING FROM th_cpob_order_base
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PROTECTED SECTION.
    DATA mo_cut TYPE REF TO th_cpob_item_list.
    DATA mo_any_order TYPE REF TO th_cpob_order.

  PRIVATE SECTION.
    METHODS setup.
ENDCLASS.


CLASS lth_base IMPLEMENTATION.
  METHOD setup.
    mo_cut = th_cpob_item_list=>create( ).
    mo_any_order = th_cpob_order=>create_any( ).
  ENDMETHOD.
ENDCLASS.

**********************************************************************

CLASS lth_operation_base DEFINITION ABSTRACT
INHERITING FROM lth_base
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PROTECTED SECTION.
    DATA mo_any_item TYPE REF TO th_cpob_item.
    DATA mo_other_item TYPE REF TO th_cpob_item.

  PRIVATE SECTION.
    METHODS setup.
ENDCLASS.


CLASS lth_operation_base IMPLEMENTATION.
  METHOD setup.
    mo_any_item = th_cpob_item=>create_any( ).
    mo_any_order->add_item( mo_any_item ).
    mo_other_item = th_cpob_item=>create( ).
    mo_any_order->add_item( mo_other_item ).
  ENDMETHOD.
ENDCLASS.

**********************************************************************

CLASS ltc_add_get DEFINITION
INHERITING FROM lth_operation_base FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS empty_list_add_new_item_ok FOR TESTING.
    METHODS full_list_add_old_item_no FOR TESTING.

    METHODS assert_add_succeeded_for
      IMPORTING io_item TYPE REF TO th_cpob_item.
    METHODS assert_add_ignored_for
      IMPORTING io_item TYPE REF TO th_cpob_item.
ENDCLASS.


CLASS ltc_add_get IMPLEMENTATION.
  METHOD empty_list_add_new_item_ok.
    assert_add_succeeded_for( mo_any_item ).
  ENDMETHOD.

  METHOD full_list_add_old_item_no.
    mo_cut->add_item( mo_any_item ).
    assert_add_ignored_for( mo_any_item ).
  ENDMETHOD.

  METHOD assert_add_succeeded_for.
    mo_cut->assert_has_not( io_item ).
    DATA(lv_size_before) = mo_cut->get_size( ).

    mo_cut->if_cpob_item_list~add_item( io_item ).

    mo_cut->assert_size_is( lv_size_before + 1 ).
    mo_cut->assert_has( io_item ).
  ENDMETHOD.

  METHOD assert_add_ignored_for.
    mo_cut->assert_has( io_item ).
    DATA(lv_size_before) = mo_cut->get_size( ).

    mo_cut->if_cpob_item_list~add_item( io_item ).

    mo_cut->assert_size_is( lv_size_before ).
    mo_cut->assert_has( io_item ).
  ENDMETHOD.
ENDCLASS.

**********************************************************************

CLASS ltc_remove_get DEFINITION
INHERITING FROM lth_operation_base FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS empty_list_remove_item_no FOR TESTING.
    METHODS full_list_remove_old_item_ok FOR TESTING.
    METHODS full_list_remove_new_item_no FOR TESTING.

    METHODS assert_remove_succeeded_for
      IMPORTING io_item TYPE REF TO th_cpob_item.
    METHODS assert_remove_ignored_for
      IMPORTING io_item TYPE REF TO th_cpob_item.
ENDCLASS.


CLASS ltc_remove_get IMPLEMENTATION.
  METHOD empty_list_remove_item_no.
    assert_remove_ignored_for( mo_any_item ).
  ENDMETHOD.

  METHOD full_list_remove_old_item_ok.
    mo_cut->add_item( mo_any_item ).
    mo_cut->add_item( mo_other_item ).
    assert_remove_succeeded_for( mo_any_item ).
    mo_cut->assert_has( mo_other_item ).
  ENDMETHOD.

  METHOD full_list_remove_new_item_no.
    mo_cut->add_item( mo_any_item ).
    assert_remove_ignored_for( mo_other_item ).
    mo_cut->assert_has( mo_any_item ).
  ENDMETHOD.

  METHOD assert_remove_succeeded_for.
    mo_cut->assert_has( io_item ).
    DATA(lv_size_before) = mo_cut->get_size( ).

    mo_cut->if_cpob_item_list~remove_item( io_item ).

    mo_cut->assert_size_is( lv_size_before - 1 ).
    mo_cut->assert_has_not( io_item ).
  ENDMETHOD.

  METHOD assert_remove_ignored_for.
    mo_cut->assert_has_not( io_item ).
    DATA(lv_size_before) = mo_cut->get_size( ).

    mo_cut->if_cpob_item_list~remove_item( io_item ).

    mo_cut->assert_size_is( lv_size_before ).
    mo_cut->assert_has_not( io_item ).
  ENDMETHOD.
ENDCLASS.

**********************************************************************

CLASS lth_get_process_time_base DEFINITION ABSTRACT
INHERITING FROM lth_base
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PROTECTED SECTION.
    DATA mo_item_7s TYPE REF TO td_cpob_item.
    DATA mo_item_70s TYPE REF TO td_cpob_item.
    DATA mo_item_17s TYPE REF TO td_cpob_item.

  PRIVATE SECTION.
    METHODS setup.
ENDCLASS.


CLASS lth_get_process_time_base IMPLEMENTATION.
  METHOD setup.
    mo_item_7s = td_cpob_item=>create_double( iv_process_time = 7 ).
    mo_item_70s = td_cpob_item=>create_double( iv_process_time = 70 ).
    mo_item_17s = td_cpob_item=>create_double( iv_process_time = 17 ).

    mo_any_order->add_items(
      VALUE #( ( mo_item_7s ) ( mo_item_70s ) ( mo_item_17s ) ) ).
  ENDMETHOD.
ENDCLASS.

**********************************************************************

CLASS ltc_get_process_time_serial DEFINITION
INHERITING FROM lth_get_process_time_base FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS setup.
    METHODS empty_list_get_process_time_no FOR TESTING
      RAISING cx_cpob_parallel.
    METHODS full_list_get_process_time_ok FOR TESTING
      RAISING cx_cpob_parallel.

    METHODS assert_process_time_is
      IMPORTING iv_exp_process_time TYPE cpob_process_time
      RAISING cx_cpob_parallel.
ENDCLASS.


CLASS ltc_get_process_time_serial IMPLEMENTATION.
  METHOD setup.
    set_serial_processing( ).
  ENDMETHOD.

  METHOD empty_list_get_process_time_no.
    assert_process_time_is( 0 ).
  ENDMETHOD.

  METHOD full_list_get_process_time_ok.
    mo_cut->add_item( mo_item_7s ).
    mo_cut->add_item( mo_item_70s ).
    mo_cut->add_item( mo_item_17s ).

    assert_process_time_is( 70 ).

    mo_item_7s->assert_called_once( ).
    mo_item_70s->assert_called_once( ).
    mo_item_17s->assert_called_once( ).
  ENDMETHOD.

  METHOD assert_process_time_is.
    cl_abap_unit_assert=>assert_equals(
      exp = iv_exp_process_time
      act = mo_cut->if_cpob_item_list~get_processing_time( )
    ).
  ENDMETHOD.
ENDCLASS.

**********************************************************************

CLASS ltc_get_process_time_parallel DEFINITION
INHERITING FROM lth_get_process_time_base FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS setup.
    METHODS empty_list_get_process_time_no FOR TESTING.
    METHODS full_list_get_process_time_ok FOR TESTING.
    METHODS full_list_get_process_time_ko FOR TESTING.

    METHODS configure_success_for
      IMPORTING io_item TYPE REF TO td_cpob_item.
    METHODS configure_failure_for
      IMPORTING io_item TYPE REF TO td_cpob_item.

    METHODS assert_process_time_is
      IMPORTING iv_exp_process_time TYPE cpob_process_time.
    METHODS assert_process_time_error_for
      IMPORTING io_item TYPE REF TO th_cpob_item.

    DATA mo_parallel_double TYPE REF TO td_cpob_parallel.
    DATA mt_exp_error TYPE cx_cpob_parallel=>t_error.
ENDCLASS.


CLASS ltc_get_process_time_parallel IMPLEMENTATION.
  METHOD setup.
    set_parallel_processing( ).

    mo_parallel_double = td_cpob_parallel=>create_double( ).
    mo_int_factory_double->inject_parallel_processor( mo_parallel_double ).
  ENDMETHOD.

  METHOD empty_list_get_process_time_no.
    assert_process_time_is( 0 ).
  ENDMETHOD.

  METHOD full_list_get_process_time_ok.
    configure_success_for( mo_item_7s ).
    configure_success_for( mo_item_70s ).
    configure_success_for( mo_item_17s ).

    assert_process_time_is( 70 ).
  ENDMETHOD.

  METHOD full_list_get_process_time_ko.
    configure_failure_for( mo_item_7s ).
    configure_success_for( mo_item_70s ).
    configure_failure_for( mo_item_17s ).

    assert_process_time_error_for( mo_item_70s ).
  ENDMETHOD.

  METHOD configure_success_for.
    mo_cut->add_item( io_item ).
    mo_parallel_double->configure_success_for( io_item ).
  ENDMETHOD.

  METHOD configure_failure_for.
    DATA ls_error LIKE LINE OF mt_exp_error.

    ls_error-item_key = io_item->get_key( ).
    ls_error-message = |Item | && ls_error-item_id &&
      | of order | && ls_error-order_id && | failed|.
    INSERT ls_error INTO TABLE mt_exp_error.

    mo_cut->add_item( io_item ).
    mo_parallel_double->configure_failure_with( ls_error-message ).
  ENDMETHOD.

  METHOD assert_process_time_is.
    FIELD-SYMBOLS <s_error> TYPE cx_cpob_parallel=>s_error.

    TRY.
        DATA(lv_act_process_time) =
          mo_cut->if_cpob_item_list~get_processing_time( ).
      CATCH cx_cpob_parallel INTO DATA(lx_parallel).
        LOOP AT lx_parallel->get_errors( ) ASSIGNING <s_error>.
          cl_abap_unit_assert=>fail(
            msg = <s_error>-message
            quit = if_abap_unit_constant=>quit-no
          ).
        ENDLOOP.
        RETURN.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals(
      exp = iv_exp_process_time
      act = lv_act_process_time
    ).
  ENDMETHOD.

  METHOD assert_process_time_error_for.
    TRY.
        DATA(lv_act_process_time) =
          mo_cut->if_cpob_item_list~get_processing_time( ).
      CATCH cx_cpob_parallel INTO DATA(lx_parallel).
        cl_abap_unit_assert=>assert_equals(
          exp = mt_exp_error
          act = lx_parallel->get_errors( )
        ).
    ENDTRY.

    cl_abap_unit_assert=>assert_equals(
      exp = 0
      act = lv_act_process_time
    ).
  ENDMETHOD.
ENDCLASS.

**********************************************************************
