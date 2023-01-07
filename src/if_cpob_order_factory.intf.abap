
INTERFACE if_cpob_order_factory PUBLIC.
  METHODS create_order
    IMPORTING is_data TYPE cpob_s_order_data
    RETURNING VALUE(ro_order) TYPE REF TO if_cpob_order.
ENDINTERFACE.
