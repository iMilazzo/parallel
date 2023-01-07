
CLASS cl_cpob_api_factory_td DEFINITION PUBLIC CREATE PRIVATE
INHERITING FROM cl_cpob_api_factory FINAL.
  PUBLIC SECTION.
    CLASS-METHODS create
      RETURNING VALUE(ro_factory) TYPE REF TO cl_cpob_api_factory_td.

    METHODS inject_itself.
    METHODS inject_api
      IMPORTING io_api TYPE REF TO if_cpob_api.
ENDCLASS.


CLASS cl_cpob_api_factory_td IMPLEMENTATION.
  METHOD create.
    ro_factory = NEW cl_cpob_api_factory_td( ).
  ENDMETHOD.

  METHOD inject_itself.
    set_factory( me ).
  ENDMETHOD.

  METHOD inject_api.
    mo_api = io_api.
  ENDMETHOD.
ENDCLASS.
