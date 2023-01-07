
CLASS th_cpob_order_base DEFINITION PUBLIC ABSTRACT
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PROTECTED SECTION.
    METHODS set_serial_processing.
    METHODS set_parallel_processing.

    DATA mo_int_factory_double TYPE REF TO td_cpob_int_order_factory.
    DATA mo_dao_factory_double TYPE REF TO cl_cpob_dao_factory_td.
    DATA mo_api_factory_double TYPE REF TO cl_cpob_api_factory_td.

    DATA mo_dao_double TYPE REF TO cl_cpob_dao_td.

  PRIVATE SECTION.
    METHODS setup.

    DATA mo_api_double TYPE REF TO cl_cpob_api_td.
ENDCLASS.


CLASS th_cpob_order_base IMPLEMENTATION.
  METHOD setup.
    mo_int_factory_double = td_cpob_int_order_factory=>create( ).
    th_cpob_int_order_fact_inj=>inject_factory( mo_int_factory_double ).

    mo_api_factory_double = cl_cpob_api_factory_td=>create( ).
    th_cpob_api_fact_inj=>inject_factory( mo_api_factory_double ).
    mo_api_double = cl_cpob_api_td=>create( ).
    mo_api_factory_double->inject_api( mo_api_double ).

    mo_dao_factory_double = cl_cpob_dao_factory_td=>create( ).
    th_cpob_dao_fact_inj=>inject_factory( mo_dao_factory_double ).
    mo_dao_double = cl_cpob_dao_td=>create( ).
    mo_dao_factory_double->inject_dao( mo_dao_double ).
  ENDMETHOD.

  METHOD set_serial_processing.
    DATA(lo_determinator_double) =
      td_cpob_process_determinator=>create_serial( ).
    mo_int_factory_double->inject_process_determinator(
      lo_determinator_double ).
  ENDMETHOD.

  METHOD set_parallel_processing.
    DATA(lo_determinator_double) =
      td_cpob_process_determinator=>create_parallel( ).
    mo_int_factory_double->inject_process_determinator(
      lo_determinator_double ).
  ENDMETHOD.
ENDCLASS.
