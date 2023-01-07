
CLASS cl_cpob_process_step_list DEFINITION PUBLIC CREATE PROTECTED
GLOBAL FRIENDS cl_cpob_int_order_factory.
  PUBLIC SECTION.
    INTERFACES if_cpob_process_step_list.

  PROTECTED SECTION.
    METHODS get_process_step_data
      RETURNING VALUE(rt_data) TYPE cpob_t_process_step_data.

    DATA mt_data TYPE cpob_t_process_step_data.

  PRIVATE SECTION.
    CLASS-METHODS create
      RETURNING VALUE(ro_list) TYPE REF TO cl_cpob_process_step_list ##RELAX.
ENDCLASS.


CLASS cl_cpob_process_step_list IMPLEMENTATION.
  METHOD create.
    ro_list = NEW cl_cpob_process_step_list( ).
  ENDMETHOD.

  METHOD if_cpob_process_step_list~add_process_step_data.
    INSERT LINES OF it_data INTO TABLE mt_data.
  ENDMETHOD.

  METHOD if_cpob_process_step_list~update_process_step_data.
    if_cpob_process_step_list~remove_process_step_data( is_data ).
    if_cpob_process_step_list~add_process_step_data( VALUE #( ( is_data ) ) ).
  ENDMETHOD.

  METHOD if_cpob_process_step_list~remove_process_step_data.
    DELETE TABLE mt_data FROM is_data.
  ENDMETHOD.

  METHOD if_cpob_process_step_list~get_processing_time.
    DATA(lt_data) = get_process_step_data( ).
    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<s_data>).
      rv_time += <s_data>-process_step_time.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_process_step_data.
    rt_data = mt_data.
  ENDMETHOD.
ENDCLASS.
