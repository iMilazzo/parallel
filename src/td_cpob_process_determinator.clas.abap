
CLASS td_cpob_process_determinator DEFINITION PUBLIC CREATE PRIVATE
FOR TESTING FINAL.
  PUBLIC SECTION.
    INTERFACES if_cpob_process_determinator.

    CLASS-METHODS create_serial
      RETURNING VALUE(ro_determinator) TYPE REF TO td_cpob_process_determinator.
    CLASS-METHODS create_parallel
      RETURNING VALUE(ro_determinator) TYPE REF TO td_cpob_process_determinator.

  PRIVATE SECTION.
    DATA mv_use_serial TYPE abap_bool.
ENDCLASS.


CLASS td_cpob_process_determinator IMPLEMENTATION.
  METHOD create_serial.
    ro_determinator = NEW td_cpob_process_determinator( ).
    ro_determinator->mv_use_serial = abap_true.
  ENDMETHOD.

  METHOD create_parallel.
    ro_determinator = NEW td_cpob_process_determinator( ).
    ro_determinator->mv_use_serial = abap_false.
  ENDMETHOD.

  METHOD if_cpob_process_determinator~use_serial_processing_for.
    rv_use_serial = mv_use_serial.
  ENDMETHOD.
ENDCLASS.
