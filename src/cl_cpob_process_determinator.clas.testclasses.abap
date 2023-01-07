
CLASS ltc_is_serial_processing DEFINITION FINAL
FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    METHODS setup.
    METHODS num_items_below_serial_proc FOR TESTING.
    METHODS num_items_above_parallel_proc FOR TESTING.

    CONSTANTS c_num_item_just_below TYPE i VALUE 4.

    CLASS-DATA st_item_just_below TYPE if_cpob_item=>tab.
    DATA mo_cut TYPE REF TO if_cpob_process_determinator.
ENDCLASS.


CLASS ltc_is_serial_processing IMPLEMENTATION.
  METHOD class_setup.
    DO c_num_item_just_below times.
      INSERT th_cpob_item=>create( ) INTO TABLE st_item_just_below.
    ENDDO.
  ENDMETHOD.

  METHOD setup.
    DATA(lo_factory) = cl_cpob_int_order_factory=>get( ).
    mo_cut = lo_factory->create_process_determinator( ).
  ENDMETHOD.

  METHOD num_items_below_serial_proc.
    cl_abap_unit_assert=>assert_true(
      mo_cut->use_serial_processing_for( st_item_just_below ) ).
  ENDMETHOD.

  METHOD num_items_above_parallel_proc.
    DATA(lt_item_just_above) = st_item_just_below.
    INSERT th_cpob_item=>create( ) INTO TABLE lt_item_just_above.

    cl_abap_unit_assert=>assert_false(
      mo_cut->use_serial_processing_for( lt_item_just_above ) ).
  ENDMETHOD.
ENDCLASS.
