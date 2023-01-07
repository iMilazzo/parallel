
CLASS ltc_factory DEFINITION FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS setup.
    METHODS get_factory_as_singleton_ok FOR TESTING.

    "! @testing cl_cpob_order
    METHODS create_order_ok FOR TESTING.

    DATA mo_cut TYPE REF TO if_cpob_order_factory.
ENDCLASS.


CLASS ltc_factory IMPLEMENTATION.
  METHOD setup.
    mo_cut = cl_cpob_order_factory=>get( ).
  ENDMETHOD.

  METHOD get_factory_as_singleton_ok.
    cl_abap_unit_assert=>assert_bound( mo_cut ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_cpob_order_factory=>get( )
      exp = mo_cut
    ).
  ENDMETHOD.

  METHOD create_order_ok.
    cl_abap_unit_assert=>assert_bound(
      mo_cut->create_order( VALUE #( ) ) ).
  ENDMETHOD.
ENDCLASS.
