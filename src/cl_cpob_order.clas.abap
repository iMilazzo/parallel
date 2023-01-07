
CLASS cl_cpob_order DEFINITION PUBLIC CREATE PROTECTED
GLOBAL FRIENDS cl_cpob_order_factory.
  PUBLIC SECTION.
    INTERFACES if_cpob_order.

  PROTECTED SECTION.
    METHODS constructor
      IMPORTING is_data TYPE cpob_s_order_data OPTIONAL.

    DATA ms_data TYPE cpob_s_order_data.
    DATA mo_item_list TYPE REF TO if_cpob_item_list.

  PRIVATE SECTION.
    CLASS-METHODS create
      IMPORTING is_data TYPE cpob_s_order_data
      RETURNING VALUE(ro_order) TYPE REF TO cl_cpob_order ##RELAX.
ENDCLASS.


CLASS cl_cpob_order IMPLEMENTATION.
  METHOD create.
    ro_order = NEW cl_cpob_order( is_data ).
  ENDMETHOD.

  METHOD constructor.
    ms_data = is_data.
    mo_item_list = cl_cpob_int_order_factory=>get( )->create_item_list( ).
  ENDMETHOD.

  METHOD if_cpob_order~get_processing_time.
    rv_time = mo_item_list->get_processing_time( ).
  ENDMETHOD.
ENDCLASS.
