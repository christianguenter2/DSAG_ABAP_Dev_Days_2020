CLASS zcl_caa361_eml_cg1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS:
      read_and_log
        IMPORTING
          iv_travel_id TYPE ZCAA361_C_Travel_CG1-TravelID
          ii_out       TYPE REF TO if_oo_adt_classrun_out,

      log_if_not_initial
        IMPORTING
          data   TYPE any
          ii_out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_caa361_eml_cg1 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    CONSTANTS: co_travel_id TYPE zcaa361_c_travel_cg1-travelid VALUE '00001338'.

    read_and_log( iv_travel_id = co_travel_id ii_out = out ).

    MODIFY ENTITIES OF ZCAA361_i_Travel_CG1
      ENTITY travel
      UPDATE FROM VALUE
        #( ( Travel_ID            = co_travel_id
             Description          = 'I am king'
             %control-Description = if_abap_behv=>mk-on ) )
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

    log_if_Not_initial( data = ls_failed ii_out = out ).
    log_if_Not_initial( data = ls_reported ii_out = out ).

    COMMIT ENTITIES RESPONSE OF ZCAA361_i_Travel_CG1
      FAILED DATA(ls_failed_commit)
      REPORTED DATA(ls_reported_commit).

    log_if_Not_initial( data = ls_failed_commit ii_out = out ).
    log_if_Not_initial( data = ls_reported_commit ii_out = out ).

    read_and_log( iv_travel_id = co_travel_id ii_out = out ).

  ENDMETHOD.


  METHOD read_and_log.

    READ ENTITIES OF ZCAA361_C_Travel_CG1
      ENTITY Travel
      FROM VALUE #( ( TravelID = iv_travel_id ) )
      RESULT DATA(lt_travels).

    ii_out->write( lt_travels ).

  ENDMETHOD.


  METHOD log_if_not_initial.

    IF data IS NOT INITIAL.
      ii_out->write( data ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
