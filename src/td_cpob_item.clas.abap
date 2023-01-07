
CLASS td_cpob_item DEFINITION PUBLIC CREATE PRIVATE FOR TESTING
INHERITING FROM th_cpob_item FINAL.
  PUBLIC SECTION.
    CLASS-METHODS create_double
      IMPORTING iv_process_time TYPE cpob_process_time OPTIONAL
      RETURNING VALUE(ro_item) TYPE REF TO td_cpob_item.

    METHODS if_cpob_item~take_over_result_from REDEFINITION.
    METHODS if_abap_parallel~do REDEFINITION.

    METHODS assert_called_once.

  PROTECTED SECTION.
    METHODS constructor
      IMPORTING is_data TYPE cpob_s_item_data OPTIONAL.

  PRIVATE SECTION.
    DATA mv_num_call TYPE i.
ENDCLASS.


CLASS td_cpob_item IMPLEMENTATION.
  METHOD create_double.
    ro_item = NEW td_cpob_item(
      CORRESPONDING cpob_s_item_data( get_next_key( ) ) ).
    ro_item->mv_process_time = iv_process_time.
  ENDMETHOD.

  METHOD constructor.
    super->constructor( is_data ).
  ENDMETHOD.

  METHOD if_cpob_item~take_over_result_from.
    DATA(lo_item) = CAST td_cpob_item( io_item ).
    mv_num_call = lo_item->mv_num_call.
  ENDMETHOD.

  METHOD if_abap_parallel~do.
    mv_num_call += 1.
  ENDMETHOD.

  METHOD assert_called_once.
    cl_abap_unit_assert=>assert_equals( exp = 1 act = mv_num_call ).
  ENDMETHOD.
ENDCLASS.
