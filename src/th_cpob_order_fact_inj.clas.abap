
CLASS th_cpob_order_fact_inj DEFINITION PUBLIC ABSTRACT FOR TESTING FINAL.
  PUBLIC SECTION.
    CLASS-METHODS inject_factory
      IMPORTING io_factory TYPE REF TO if_cpob_order_factory.
ENDCLASS.


CLASS th_cpob_order_fact_inj IMPLEMENTATION.
  METHOD inject_factory.
    cl_cpob_order_factory=>so_factory = io_factory.
  ENDMETHOD.
ENDCLASS.
