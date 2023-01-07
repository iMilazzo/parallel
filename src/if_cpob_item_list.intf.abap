
INTERFACE if_cpob_item_list PUBLIC.
  METHODS get_item
    IMPORTING is_item_key TYPE cpob_s_item_key
    RETURNING VALUE(ro_item) TYPE REF TO if_cpob_item.
  METHODS add_item
    IMPORTING io_item TYPE REF TO if_cpob_item.
  METHODS remove_item
    IMPORTING io_item TYPE REF TO if_cpob_item.

  METHODS get_processing_time
    RETURNING VALUE(rv_time) TYPE cpob_process_time
    RAISING cx_cpob_parallel.
ENDINTERFACE.
