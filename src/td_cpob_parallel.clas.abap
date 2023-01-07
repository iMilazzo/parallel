
CLASS td_cpob_parallel DEFINITION PUBLIC CREATE PRIVATE FOR TESTING
INHERITING FROM cl_abap_parallel FINAL.
  PUBLIC SECTION.
    CLASS-METHODS create_double
      RETURNING VALUE(ro_parallel) TYPE REF TO td_cpob_parallel.

    METHODS run_inst REDEFINITION.

    METHODS configure_success_for
      IMPORTING io_instance TYPE REF TO if_abap_parallel.
    METHODS configure_failure_with
      IMPORTING iv_message TYPE string.

  PRIVATE SECTION.
    DATA mt_item_out TYPE cl_abap_parallel=>t_out_inst_tab.
ENDCLASS.


CLASS td_cpob_parallel IMPLEMENTATION.
  METHOD create_double.
    ro_parallel = NEW td_cpob_parallel( ).
  ENDMETHOD.

  METHOD run_inst.
    p_out_tab = mt_item_out.
  ENDMETHOD.

  METHOD configure_success_for.
    DATA ls_item_out LIKE LINE OF mt_item_out.

    ls_item_out-inst = io_instance.
    ls_item_out-index = lines( mt_item_out ) + 1.
    INSERT ls_item_out INTO TABLE mt_item_out.
  ENDMETHOD.

  METHOD configure_failure_with.
    DATA ls_item_out LIKE LINE OF mt_item_out.

    ls_item_out-index = lines( mt_item_out ) + 1.
    ls_item_out-message = iv_message.
    INSERT ls_item_out INTO TABLE mt_item_out.
  ENDMETHOD.
ENDCLASS.
