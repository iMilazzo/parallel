
CLASS ltc_parallel DEFINITION FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS create_with_errors_ok FOR TESTING.

    DATA mo_cut TYPE REF TO cx_cpob_parallel.
ENDCLASS.


CLASS ltc_parallel IMPLEMENTATION.
  METHOD create_with_errors_ok.
    DATA(lt_error) = VALUE cx_cpob_parallel=>t_error( (
      item_key = th_cpar_item=>create_any( )->get_key( )
      message = 'PARALLELIZATION FAILED' )
    ).
    mo_cut = cx_cpob_parallel=>create( lt_error ).

    cl_abap_unit_assert=>assert_equals(
      exp = lt_error
      act = mo_cut->get_errors( )
    ).
  ENDMETHOD.
ENDCLASS.
