
INTERFACE if_cpob_item PUBLIC.
  TYPES tab TYPE STANDARD TABLE OF REF TO if_cpob_item WITH EMPTY KEY.

  INTERFACES if_abap_parallel.
  METHODS prepare_parallel_processing.
  METHODS take_over_result_from
    IMPORTING io_item TYPE REF TO if_abap_parallel.

  METHODS get_key
    RETURNING VALUE(rs_key) TYPE cpob_s_item_key.
  METHODS get_processing_time
    RETURNING VALUE(rv_time) TYPE cpob_process_time.
ENDINTERFACE.
