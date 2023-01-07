
CLASS cl_cpob_item_th DEFINITION PUBLIC ABSTRACT
INHERITING FROM cl_cpob_item.
  PUBLIC SECTION.
    METHODS if_cpob_item~prepare_parallel_processing REDEFINITION.
    METHODS if_abap_parallel~do REDEFINITION.

    METHODS get_api_process_time ABSTRACT
      RETURNING VALUE(rv_time) TYPE cpob_api_process_time.

  PROTECTED SECTION.
    DATA mo_dao_factory_double TYPE REF TO cl_cpob_dao_factory_td.
ENDCLASS.


CLASS cl_cpob_item_th IMPLEMENTATION.
  METHOD if_cpob_item~prepare_parallel_processing.
    mo_dao_factory_double = CAST cl_cpob_dao_factory_td(
      cl_cpob_dao_factory=>get( ) ).
  ENDMETHOD.

  METHOD if_abap_parallel~do.
    IF mo_dao_factory_double IS BOUND.
      "parallel processing
      mo_dao_factory_double->inject_itself( ).

      DATA(lo_api_factory_double) = cl_cpob_api_factory_td=>create( ).
      lo_api_factory_double->inject_itself( ).
      DATA(lo_api_double) = cl_cpob_api_td=>create( ).
      lo_api_factory_double->inject_api( lo_api_double ).
    ENDIF.

    super->if_abap_parallel~do( ).
  ENDMETHOD.
ENDCLASS.
