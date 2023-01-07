
CLASS cl_cpob_int_order_factory DEFINITION PUBLIC CREATE PROTECTED
GLOBAL FRIENDS th_cpob_int_order_fact_inj.
  PUBLIC SECTION.
    INTERFACES if_cpob_int_order_factory.

    CLASS-METHODS get
      RETURNING VALUE(ro_factory) TYPE REF TO if_cpob_int_order_factory.

  PROTECTED SECTION.
    DATA mo_determinator TYPE REF TO if_cpob_process_determinator.
    DATA mo_parallel TYPE REF TO cl_abap_parallel.

  PRIVATE SECTION.
    CLASS-DATA so_factory TYPE REF TO if_cpob_int_order_factory.
ENDCLASS.


CLASS cl_cpob_int_order_factory IMPLEMENTATION.
  METHOD get.
    IF so_factory IS NOT BOUND.
      so_factory = NEW cl_cpob_int_order_factory( ).
    ENDIF.
    ro_factory = so_factory.
  ENDMETHOD.

  METHOD if_cpob_int_order_factory~create_item_list.
    ro_list = cl_cpob_item_list=>create( ).
  ENDMETHOD.

  METHOD if_cpob_int_order_factory~create_item.
    ro_item = cl_cpob_item=>create( is_data ).
  ENDMETHOD.

  METHOD if_cpob_int_order_factory~create_process_step_list.
    ro_list = cl_cpob_process_step_list=>create( ).
  ENDMETHOD.

  METHOD if_cpob_int_order_factory~create_process_determinator.
    IF mo_determinator IS NOT BOUND.
      mo_determinator = cl_cpob_process_determinator=>create( ).
    ENDIF.
    ro_determinator = mo_determinator.
  ENDMETHOD.

  METHOD if_cpob_int_order_factory~create_parallel_processor.
    IF mo_parallel IS NOT BOUND.
      mo_parallel = NEW cl_abap_parallel( ).
    ENDIF.
    ro_parallel = mo_parallel.
  ENDMETHOD.
ENDCLASS.
