
INTERFACE if_cpob_int_order_factory PUBLIC.
  METHODS create_item_list
    RETURNING VALUE(ro_list) TYPE REF TO if_cpob_item_list.
  METHODS create_item
    IMPORTING is_data TYPE cpob_s_item_data
    RETURNING VALUE(ro_item) TYPE REF TO if_cpob_item.
  METHODS create_process_step_list
    RETURNING VALUE(ro_list) TYPE REF TO if_cpob_process_step_list.

  METHODS create_process_determinator
    RETURNING VALUE(ro_determinator) TYPE REF TO if_cpob_process_determinator.
  METHODS create_parallel_processor
    RETURNING VALUE(ro_parallel) TYPE REF TO cl_abap_parallel.
ENDINTERFACE.
