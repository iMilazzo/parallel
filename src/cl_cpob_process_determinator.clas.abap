
CLASS cl_cpob_process_determinator DEFINITION PUBLIC CREATE PRIVATE FINAL
GLOBAL FRIENDS cl_cpob_int_order_factory.
  PUBLIC SECTION.
    INTERFACES if_cpob_process_determinator.

  PRIVATE SECTION.
    CLASS-METHODS create
      RETURNING VALUE(ro_determinator) TYPE REF TO cl_cpob_process_determinator.
ENDCLASS.


CLASS cl_cpob_process_determinator IMPLEMENTATION.
  METHOD create.
    ro_determinator = NEW cl_cpob_process_determinator( ).
  ENDMETHOD.

  METHOD if_cpob_process_determinator~use_serial_processing_for.
    IF lines( it_item ) < 5.
      rv_use_serial = abap_true.
    ELSE.
      rv_use_serial = abap_false.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
