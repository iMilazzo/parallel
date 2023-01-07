
CLASS lth_base DEFINITION ABSTRACT
INHERITING FROM th_cpob_order_base
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PROTECTED SECTION.
    METHODS get_pstep_data_of
      IMPORTING it_pstep TYPE th_cpob_pstep=>tab
      RETURNING VALUE(rt_data) TYPE cpob_t_process_step_data.
    METHODS add_pstep_data_of
      IMPORTING it_pstep TYPE th_cpob_pstep=>tab.
    METHODS update_pstep_data_of
      IMPORTING it_pstep TYPE th_cpob_pstep=>tab.
    METHODS remove_pstep_data_of
      IMPORTING it_pstep TYPE th_cpob_pstep=>tab.

    DATA mo_cut TYPE REF TO th_cpob_pstep_list.

    DATA mo_any_item TYPE REF TO th_cpob_item.
    DATA mo_pstep_2s TYPE REF TO th_cpob_pstep.
    DATA mo_pstep_3s TYPE REF TO th_cpob_pstep.

  PRIVATE SECTION.
    METHODS setup.
ENDCLASS.


CLASS lth_base IMPLEMENTATION.
  METHOD setup.
    mo_any_item = th_cpob_item=>create_any( ).
    mo_pstep_2s = th_cpob_pstep=>create( iv_process_time = 2 ).
    mo_pstep_3s = th_cpob_pstep=>create( iv_process_time = 3 ).

    mo_cut = th_cpob_pstep_list=>create( ).
  ENDMETHOD.

  METHOD get_pstep_data_of.
    LOOP AT it_pstep INTO DATA(lo_pstep).
      INSERT lo_pstep->get_data( )-super INTO TABLE rt_data.
    ENDLOOP.
  ENDMETHOD.

  METHOD add_pstep_data_of.
    mo_any_item->add_process_steps( it_pstep ).
    DATA(lt_data) = get_pstep_data_of( it_pstep ).
    mo_cut->if_cpob_process_step_list~add_process_step_data( lt_data ).
  ENDMETHOD.

  METHOD update_pstep_data_of.
    DATA(lt_data) = get_pstep_data_of( it_pstep ).
    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<s_data>).
      mo_cut->if_cpob_process_step_list~update_process_step_data( <s_data> ).
    ENDLOOP.
  ENDMETHOD.

  METHOD remove_pstep_data_of.
    mo_any_item->add_process_steps( it_pstep ).
    DATA(lt_data) = get_pstep_data_of( it_pstep ).
    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<s_data>).
      mo_cut->if_cpob_process_step_list~remove_process_step_data( <s_data> ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

**********************************************************************

CLASS ltc_process_step_data DEFINITION
INHERITING FROM lth_base FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS add_2_psteps_ok FOR TESTING.
    METHODS add_2_psteps_remove_1_pstep_ok FOR TESTING.
    METHODS update_pstep_ok FOR TESTING.

    METHODS assert_has_pstep_data_of
      IMPORTING it_exp_pstep TYPE th_cpob_pstep=>tab.
ENDCLASS.


CLASS ltc_process_step_data IMPLEMENTATION.
  METHOD add_2_psteps_ok.
    add_pstep_data_of( VALUE #( ( mo_pstep_2s ) ( mo_pstep_3s ) ) ).
    assert_has_pstep_data_of( VALUE #( ( mo_pstep_2s ) ( mo_pstep_3s ) ) ).
  ENDMETHOD.

  METHOD add_2_psteps_remove_1_pstep_ok.
    add_pstep_data_of( VALUE #( ( mo_pstep_2s ) ( mo_pstep_3s ) ) ).
    remove_pstep_data_of( VALUE #( ( mo_pstep_3s ) ) ).
    assert_has_pstep_data_of( VALUE #( ( mo_pstep_2s ) ) ).
  ENDMETHOD.

  METHOD update_pstep_ok.
    DATA(lo_pstep) = th_cpob_pstep=>create( iv_process_time = 3 ).
    add_pstep_data_of( VALUE #( ( mo_pstep_2s ) ( lo_pstep ) ) ).

    lo_pstep->set( iv_process_time = 4 ).
    update_pstep_data_of( VALUE #( ( lo_pstep ) ) ).

    assert_has_pstep_data_of( VALUE #( ( mo_pstep_2s ) ( lo_pstep ) ) ).
  ENDMETHOD.

  METHOD assert_has_pstep_data_of.
    DATA(lt_exp_data) = get_pstep_data_of( it_exp_pstep ).
    mo_cut->assert_process_step_data( lt_exp_data ).
  ENDMETHOD.
ENDCLASS.

**********************************************************************

CLASS ltc_get_processing_time DEFINITION
INHERITING FROM lth_base FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS no_pstep_get_ptime_0s FOR TESTING.
    METHODS pstep_2s_pstep_3s_get_ptime_5s FOR TESTING.

    METHODS assert_list_process_time_is
      IMPORTING iv_exp_process_time TYPE cpob_process_time.
ENDCLASS.


CLASS ltc_get_processing_time IMPLEMENTATION.
  METHOD no_pstep_get_ptime_0s.
    add_pstep_data_of( VALUE #( ) ).
    assert_list_process_time_is( 0 ).
  ENDMETHOD.

  METHOD pstep_2s_pstep_3s_get_ptime_5s.
    add_pstep_data_of( VALUE #( ( mo_pstep_2s ) ( mo_pstep_3s ) ) ).
    assert_list_process_time_is( 5 ).
  ENDMETHOD.

  METHOD assert_list_process_time_is.
    cl_abap_unit_assert=>assert_equals(
      exp = iv_exp_process_time
      act = mo_cut->if_cpob_process_step_list~get_processing_time( )
    ).
  ENDMETHOD.
ENDCLASS.
