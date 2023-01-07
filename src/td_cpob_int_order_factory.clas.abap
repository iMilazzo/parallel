
CLASS td_cpob_int_order_factory DEFINITION PUBLIC CREATE PRIVATE FOR TESTING
INHERITING FROM cl_cpob_int_order_factory FINAL.
  PUBLIC SECTION.
    CLASS-METHODS create
      RETURNING VALUE(ro_factory) TYPE REF TO td_cpob_int_order_factory.

    METHODS if_cpob_int_order_factory~create_item_list REDEFINITION.
    METHODS if_cpob_int_order_factory~create_item REDEFINITION.
    METHODS if_cpob_int_order_factory~create_process_step_list REDEFINITION.

    METHODS inject_item_list
      IMPORTING io_item_list TYPE REF TO th_cpob_item_list.
    METHODS inject_item
      IMPORTING io_item TYPE REF TO th_cpob_item.

    METHODS inject_process_determinator
      IMPORTING io_determinator TYPE REF TO td_cpob_process_determinator.
    METHODS inject_parallel_processor
      IMPORTING io_parallel TYPE REF TO td_cpob_parallel.

  PRIVATE SECTION.
    DATA mt_item_list TYPE th_cpob_item_list=>tab.
    DATA mt_item TYPE th_cpob_item=>tab.
ENDCLASS.


CLASS td_cpob_int_order_factory IMPLEMENTATION.
  METHOD create.
    ro_factory = NEW td_cpob_int_order_factory( ).
  ENDMETHOD.

  METHOD if_cpob_int_order_factory~create_item_list.
    LOOP AT mt_item_list INTO DATA(lo_item_list).
      DELETE mt_item INDEX sy-tabix.
      ro_list = lo_item_list.
      RETURN.
    ENDLOOP.
    ro_list = th_cpob_item_list=>create( ).
  ENDMETHOD.

  METHOD if_cpob_int_order_factory~create_item.
    DATA(ls_data) = CORRESPONDING th_cpob_item=>s_data( is_data ).

    LOOP AT mt_item INTO DATA(lo_item).
      IF lo_item->get_key( ) = ls_data-key.
        DELETE mt_item INDEX sy-tabix.
        ro_item = lo_item.
        RETURN.
      ENDIF.
    ENDLOOP.

    ro_item = th_cpob_item=>create_with_data( ls_data ).
    ro_item->prepare_parallel_processing( ).
  ENDMETHOD.

  METHOD if_cpob_int_order_factory~create_process_step_list.
    ro_list = th_cpob_pstep_list=>create( ).
  ENDMETHOD.

  METHOD inject_item_list.
    INSERT io_item_list INTO TABLE mt_item_list.
  ENDMETHOD.

  METHOD inject_item.
    INSERT io_item INTO TABLE mt_item.
  ENDMETHOD.

  METHOD inject_process_determinator.
    cl_abap_unit_assert=>assert_not_bound( mo_determinator ).
    mo_determinator = io_determinator.
  ENDMETHOD.

  METHOD inject_parallel_processor.
    cl_abap_unit_assert=>assert_not_bound( mo_parallel ).
    mo_parallel = io_parallel.
  ENDMETHOD.
ENDCLASS.
