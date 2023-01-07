
CLASS ltc_factory DEFINITION FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS setup.
    METHODS get_factory_as_singleton_ok FOR TESTING.

    "! @testing cl_cpob_item_list
    METHODS create_item_list_ok FOR TESTING.
    "! @testing cl_cpob_item
    METHODS create_item_ok FOR TESTING.
    "! @testing cl_cpob_process_step_list
    METHODS create_process_step_list_ok FOR TESTING.

    METHODS create_process_determinator_ok FOR TESTING.
    METHODS create_parallel_processor_ok FOR TESTING.

    DATA mo_cut TYPE REF TO if_cpob_int_order_factory.
ENDCLASS.


CLASS ltc_factory IMPLEMENTATION.
  METHOD setup.
    mo_cut = cl_cpob_int_order_factory=>get( ).
  ENDMETHOD.

  METHOD get_factory_as_singleton_ok.
    cl_abap_unit_assert=>assert_bound( mo_cut ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_cpob_int_order_factory=>get( )
      exp = mo_cut
    ).
  ENDMETHOD.

  METHOD create_item_list_ok.
    cl_abap_unit_assert=>assert_bound( mo_cut->create_item_list( ) ).
  ENDMETHOD.

  METHOD create_item_ok.
    cl_abap_unit_assert=>assert_bound( mo_cut->create_item( VALUE #( ) ) ).
  ENDMETHOD.

  METHOD create_process_step_list_ok.
    cl_abap_unit_assert=>assert_bound( mo_cut->create_process_step_list( ) ).
  ENDMETHOD.

  METHOD create_process_determinator_ok.
    DATA(lo_determinator) = mo_cut->create_process_determinator( ).
    cl_abap_unit_assert=>assert_bound( lo_determinator ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->create_process_determinator( )
      exp = lo_determinator
    ).
  ENDMETHOD.

  METHOD create_parallel_processor_ok.
    DATA(lo_parallel) = mo_cut->create_parallel_processor( ).
    cl_abap_unit_assert=>assert_bound( lo_parallel ).
    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->create_parallel_processor( )
      exp = lo_parallel
    ).
  ENDMETHOD.
ENDCLASS.
