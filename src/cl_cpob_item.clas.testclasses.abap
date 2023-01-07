
CLASS ltc_get_processing_time DEFINITION
INHERITING FROM th_cpob_order_base FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    METHODS setup.
    METHODS setup10_api40_time_50 FOR TESTING.
    METHODS setup10_api40_psteps20_time_70 FOR TESTING.

    METHODS configure
      IMPORTING io_item TYPE REF TO th_cpob_item.

    METHODS create_item_like
      IMPORTING io_item TYPE REF TO th_cpob_item.
    METHODS add_process_steps
      IMPORTING it_pstep TYPE th_cpob_pstep=>tab.

    METHODS assert_item_process_time_is
      IMPORTING iv_exp_process_time TYPE cpob_process_time.

    CLASS-DATA so_item_setup_10_api_40 TYPE REF TO th_cpob_item.
    CLASS-DATA so_pstep_5s TYPE REF TO th_cpob_pstep.
    CLASS-DATA so_pstep_15s TYPE REF TO th_cpob_pstep.
    DATA mo_cut TYPE REF TO th_cpob_item.
ENDCLASS.


CLASS ltc_get_processing_time IMPLEMENTATION.
  METHOD class_setup.
    so_item_setup_10_api_40 = th_cpob_item=>create(
      iv_setup_time = 10
      iv_api_process_time = 40
    ).
    so_pstep_5s = th_cpob_pstep=>create( iv_process_time = 5 ).
    so_pstep_15s = th_cpob_pstep=>create( iv_process_time = 15 ).
  ENDMETHOD.

  METHOD setup.
    configure( so_item_setup_10_api_40 ).
  ENDMETHOD.

  METHOD setup10_api40_time_50.
    create_item_like( so_item_setup_10_api_40 ).
    assert_item_process_time_is( 50 ).
  ENDMETHOD.

  METHOD setup10_api40_psteps20_time_70.
    create_item_like( so_item_setup_10_api_40 ).
    add_process_steps( VALUE #( ( so_pstep_5s ) ( so_pstep_15s ) ) ).
    assert_item_process_time_is( 70 ).
  ENDMETHOD.

  METHOD configure.
    mo_dao_double->configure_setup_time_of( io_item ).
  ENDMETHOD.

  METHOD create_item_like.
    DATA(lo_factory) = cl_cpob_int_order_factory=>get( ).
    mo_cut = CAST th_cpob_item(
      lo_factory->create_item( io_item->get_data( )-super ) ).
    mo_cut->set( iv_api_process_time = io_item->get_api_process_time( ) ).
  ENDMETHOD.

  METHOD add_process_steps.
    mo_cut->add_process_steps( it_pstep ).
  ENDMETHOD.

  METHOD assert_item_process_time_is.
    mo_cut->if_abap_parallel~do( ).

    cl_abap_unit_assert=>assert_equals(
      exp = iv_exp_process_time
      act = mo_cut->if_cpob_item~get_processing_time( )
    ).
  ENDMETHOD.
ENDCLASS.

**********************************************************************

CLASS ltc_prepare_parallel_process DEFINITION FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS setup.
    METHODS prepare_parallel_process_ok FOR TESTING.

    DATA mo_cut TYPE REF TO if_cpob_item.
ENDCLASS.


CLASS ltc_prepare_parallel_process IMPLEMENTATION.
  METHOD setup.
    DATA(lo_factory) = cl_cpob_int_order_factory=>get( ).
    mo_cut = lo_factory->create_item( is_data = VALUE #( ) ).
  ENDMETHOD.

  METHOD prepare_parallel_process_ok.
    mo_cut->prepare_parallel_processing( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 0
      act = mo_cut->get_processing_time( )
    ).
  ENDMETHOD.
ENDCLASS.

**********************************************************************

CLASS lth_base DEFINITION ABSTRACT
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PROTECTED SECTION.
    DATA mo_cut TYPE REF TO th_cpob_item.

  PRIVATE SECTION.
    METHODS setup.
ENDCLASS.


CLASS lth_base IMPLEMENTATION.
  METHOD setup.
    mo_cut = th_cpob_item=>create_any( ).
  ENDMETHOD.
ENDCLASS.

**********************************************************************

CLASS ltc_take_over_result_from DEFINITION
INHERITING FROM lth_base FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS take_over_result_from_ok FOR TESTING.

    METHODS assert_process_time_is
      IMPORTING iv_exp_process_time TYPE cpob_process_time.

    CONSTANTS c_any_process_time TYPE cpob_process_time VALUE 3.
ENDCLASS.


CLASS ltc_take_over_result_from IMPLEMENTATION.
  METHOD take_over_result_from_ok.
    DATA(lo_item) = td_cpob_item=>create_double( c_any_process_time ).
    mo_cut->if_cpob_item~take_over_result_from( lo_item ).
    assert_process_time_is( c_any_process_time ).
  ENDMETHOD.

  METHOD assert_process_time_is.
    cl_abap_unit_assert=>assert_equals(
      exp = iv_exp_process_time
      act = mo_cut->if_cpob_item~get_processing_time( )
    ).
  ENDMETHOD.
ENDCLASS.

**********************************************************************

CLASS ltc_get_api_data DEFINITION
INHERITING FROM lth_base FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS get_api_data_ok FOR TESTING.
    METHODS get_key_ok FOR TESTING.

    METHODS get_api_data_from
      IMPORTING is_item_data TYPE th_cpob_item=>s_data
      RETURNING VALUE(rs_api_data) TYPE cpob_s_api_data.
ENDCLASS.


CLASS ltc_get_api_data IMPLEMENTATION.
  METHOD get_api_data_ok.
    cl_abap_unit_assert=>assert_equals(
      exp = get_api_data_from( mo_cut->get_data( ) )
      act = mo_cut->if_cpob_api_object~get_api_data( )
    ).
  ENDMETHOD.

  METHOD get_key_ok.
    cl_abap_unit_assert=>assert_equals(
      exp = CORRESPONDING cpob_s_item_key( mo_cut->get_key( ) )
      act = mo_cut->if_cpob_item~get_key( )
    ).
  ENDMETHOD.

  METHOD get_api_data_from.
    rs_api_data-api_type = is_item_data-item_type.
  ENDMETHOD.
ENDCLASS.

**********************************************************************
