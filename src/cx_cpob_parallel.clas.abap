
CLASS cx_cpob_parallel DEFINITION PUBLIC CREATE PUBLIC
INHERITING FROM cx_static_check FINAL.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF s_error.
        INCLUDE TYPE cpob_s_item_key AS item_key. TYPES:
        message TYPE string,
      END OF s_error.
    TYPES:
      t_error TYPE STANDARD TABLE OF s_error WITH EMPTY KEY.

    CLASS-METHODS create
      IMPORTING it_error TYPE t_error
      RETURNING VALUE(ro_check) TYPE REF TO cx_cpob_parallel.

    METHODS get_errors
      RETURNING VALUE(rt_error) TYPE t_error.

  PRIVATE SECTION.
    DATA mt_error TYPE t_error.
ENDCLASS.


CLASS cx_cpob_parallel IMPLEMENTATION.
  METHOD create.
    ro_check = NEW cx_cpob_parallel( ).
    ro_check->mt_error = it_error.
  ENDMETHOD.

  METHOD get_errors.
    rt_error = mt_error.
  ENDMETHOD.
ENDCLASS.
