
CLASS cl_cpob_c DEFINITION PUBLIC ABSTRACT FINAL.
  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF item_type,
        standard TYPE cpob_item_type VALUE 'S',
        express TYPE cpob_item_type VALUE 'E',
      END OF item_type.
ENDCLASS.


CLASS cl_cpob_c IMPLEMENTATION.
ENDCLASS.
