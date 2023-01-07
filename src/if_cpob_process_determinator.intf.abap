
INTERFACE if_cpob_process_determinator PUBLIC.
  METHODS use_serial_processing_for
    IMPORTING it_item TYPE if_cpob_item=>tab
    RETURNING VALUE(rv_use_serial) TYPE abap_bool.
ENDINTERFACE.
