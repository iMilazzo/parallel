
CLASS cl_cpob_order_factory DEFINITION PUBLIC CREATE PROTECTED
GLOBAL FRIENDS th_cpob_order_fact_inj.
  PUBLIC SECTION.
    INTERFACES if_cpob_order_factory.

    CLASS-METHODS get
      RETURNING VALUE(ro_factory) TYPE REF TO if_cpob_order_factory.

  PRIVATE SECTION.
    CLASS-DATA so_factory TYPE REF TO if_cpob_order_factory.
ENDCLASS.


CLASS cl_cpob_order_factory IMPLEMENTATION.
  METHOD get.
    IF so_factory IS NOT BOUND.
      so_factory = NEW cl_cpob_order_factory( ).
    ENDIF.
    ro_factory = so_factory.
  ENDMETHOD.

  METHOD if_cpob_order_factory~create_order.
    ro_order = cl_cpob_order=>create( is_data ).
  ENDMETHOD.
ENDCLASS.
