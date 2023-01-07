
CLASS cl_cpob_item_list DEFINITION PUBLIC CREATE PROTECTED
GLOBAL FRIENDS cl_cpob_int_order_factory.
  PUBLIC SECTION.
    INTERFACES if_cpob_item_list.

  PROTECTED SECTION.
    DATA mt_item TYPE if_cpob_item=>tab.

  PRIVATE SECTION.
    CLASS-METHODS create
      RETURNING VALUE(ro_list) TYPE REF TO cl_cpob_item_list ##RELAX.

    METHODS get_process_time_in_parallel
      RETURNING VALUE(rv_time) TYPE cpob_process_time
      RAISING cx_cpob_parallel.
ENDCLASS.


CLASS cl_cpob_item_list IMPLEMENTATION.
  METHOD create.
    ro_list = NEW cl_cpob_item_list( ).
  ENDMETHOD.

  METHOD if_cpob_item_list~get_item.
    LOOP AT mt_item INTO DATA(lo_item).
      IF lo_item->get_key( ) = is_item_key.
        ro_item = lo_item.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_cpob_item_list~add_item.
    IF if_cpob_item_list~get_item( io_item->get_key( ) ) IS NOT BOUND.
      INSERT io_item INTO TABLE mt_item.
    ENDIF.
  ENDMETHOD.

  METHOD if_cpob_item_list~remove_item.
    LOOP AT mt_item INTO DATA(lo_item).
      IF lo_item->get_key( ) = io_item->get_key( ).
        DELETE mt_item INDEX sy-tabix.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_cpob_item_list~get_processing_time.
    DATA(lo_factory) = cl_cpob_int_order_factory=>get( ).
    DATA(lo_determinator) = lo_factory->create_process_determinator( ).
    DATA(lv_serial_processing) =
      lo_determinator->use_serial_processing_for( mt_item ).

    IF lv_serial_processing = abap_true.
      LOOP AT mt_item INTO DATA(lo_item).
        lo_item->if_abap_parallel~do( ).
        DATA(lv_process_time) = lo_item->get_processing_time( ).
        IF lv_process_time > rv_time.
          rv_time = lv_process_time.
        ENDIF.
      ENDLOOP.
    ELSE.
      rv_time = get_process_time_in_parallel( ).
    ENDIF.
  ENDMETHOD.

  METHOD get_process_time_in_parallel.
    DATA lt_in_item TYPE cl_abap_parallel=>t_in_inst_tab.
    DATA lt_out_item TYPE cl_abap_parallel=>t_out_inst_tab.
    DATA lts_error TYPE cx_cpob_parallel=>t_error.
    DATA ls_error TYPE cx_cpob_parallel=>s_error.

    LOOP AT mt_item INTO DATA(lo_item).
      lo_item->prepare_parallel_processing( ).
      INSERT lo_item INTO TABLE lt_in_item.
    ENDLOOP.

    DATA(lo_factory) = cl_cpob_int_order_factory=>get( ).
    DATA(lo_parallel) = lo_factory->create_parallel_processor( ).
    lo_parallel->run_inst(
      EXPORTING
        p_in_tab = lt_in_item
      IMPORTING
        p_out_tab = lt_out_item
    ).

    LOOP AT lt_out_item ASSIGNING FIELD-SYMBOL(<s_out_item>).
      lo_item = mt_item[ <s_out_item>-index ].
      IF <s_out_item>-message IS NOT INITIAL.
        ASSERT <s_out_item>-inst IS NOT BOUND.
        ls_error-item_key = lo_item->get_key( ).
        ls_error-message = <s_out_item>-message.
        INSERT ls_error INTO TABLE lts_error.
      ELSEIF lts_error IS INITIAL.
        lo_item->take_over_result_from( <s_out_item>-inst ).
        DATA(lv_process_time) = lo_item->get_processing_time( ).
        IF lv_process_time > rv_time.
          rv_time = lv_process_time.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lts_error IS NOT INITIAL.
      RAISE EXCEPTION cx_cpob_parallel=>create( lts_error ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
