CLASS zcaa361_gen_data_cg1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcaa361_gen_data_cg1 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DELETE FROM zcaa361_tra_CG1.
    INSERT zcaa361_tra_CG1 FROM ( SELECT FROM /dmo/travel FIELDS * ).
    out->write( 'ZCAA361_TRA_CG1'  ).

    DELETE FROM zcaa361_book_CG1.
    INSERT zcaa361_book_CG1 FROM ( SELECT FROM /dmo/booking FIELDS * ).
    out->write( 'ZCAA361_BOOK_CG1'  ).

  ENDMETHOD.

ENDCLASS.
