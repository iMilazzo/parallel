
INTERFACE if_cpob_order PUBLIC.
  METHODS get_processing_time
    RETURNING VALUE(rv_time) TYPE cpob_process_time
    RAISING cx_cpob_parallel.
ENDINTERFACE.
