
INTERFACE if_cpob_process_step_list PUBLIC.
  INTERFACES if_serializable_object.

  METHODS add_process_step_data
    IMPORTING it_data TYPE cpob_t_process_step_data.
  METHODS update_process_step_data
    IMPORTING is_data TYPE cpob_s_process_step_data.
  METHODS remove_process_step_data
    IMPORTING is_data TYPE cpob_s_process_step_data.

  METHODS get_processing_time
    RETURNING VALUE(rv_time) TYPE cpob_process_time.
ENDINTERFACE.
