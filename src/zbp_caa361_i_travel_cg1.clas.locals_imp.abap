CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES: ty_helper_type   TYPE TABLE FOR ACTION IMPORT zcaa361_i_travel_cg1~booktravel,
           ty_helper_type_1 TYPE RESPONSE FOR FAILED zcaa361_i_travel_cg1,
           ty_helper_type_2 TYPE RESPONSE FOR REPORTED zcaa361_i_travel_cg1,
           ty_helper_type_3 TYPE TABLE FOR ACTION RESULT zcaa361_i_travel_cg1\\travel~canceltravel.

    METHODS set_status
      IMPORTING
        keys      TYPE ty_helper_type
        new_staus TYPE /dmo/if_flight_legacy=>travel_status_enum
      CHANGING
        failed    TYPE ty_helper_type_1
        reported  TYPE ty_helper_type_2.
    METHODS read_travel
      IMPORTING
        keys          TYPE ty_helper_type
      RETURNING
        VALUE(result) TYPE ty_helper_type_3.

    METHODS validateDates FOR VALIDATION travel~validateDates
      IMPORTING keys FOR travel.
    METHODS setinitialstatus FOR DETERMINATION travel~setinitialstatus
      IMPORTING keys FOR travel.
    METHODS booktravel FOR MODIFY
      IMPORTING keys FOR ACTION travel~booktravel RESULT result.
    METHODS canceltravel FOR MODIFY
      IMPORTING keys FOR ACTION travel~canceltravel RESULT result.

ENDCLASS.

CLASS lhc_travel IMPLEMENTATION.

  METHOD validateDates.

    READ ENTITY zcaa361_i_travel_CG1\\travel FROM VALUE #(
      FOR <root_key> IN keys
        ( %key     = <root_key>
          %control = VALUE #(
                        begin_date = if_abap_behv=>mk-on
                        end_date   = if_abap_behv=>mk-on ) ) )
      RESULT DATA(lt_travel_result).

    LOOP AT lt_travel_result ASSIGNING FIELD-SYMBOL(<ls_travel>).

      IF <ls_travel>-End_Date < <ls_travel>-Begin_Date.
        INSERT VALUE #( %key = <ls_travel>-%key  ) INTO TABLE failed.

        INSERT VALUE #(
          %key     = <ls_travel>-%key
          %msg     = new_message(
                       id       = /dmo/cx_flight_legacy=>end_date_before_begin_date-msgid
                       number   = /dmo/cx_flight_legacy=>end_date_before_begin_date-msgno
                       v1       = |{ <ls_travel>-begin_date DATE = USER }|
                       v2       = |{ <ls_travel>-end_date DATE = USER }|
                       v3       = |{ <ls_travel>-travel_id ALPHA = OUT }|
                       severity = if_abap_behv_message=>severity-error )
          %element-begin_date = if_abap_behv=>mk-on
          %element-end_date   = if_abap_behv=>mk-on
        ) INTO TABLE reported.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD setinitialstatus.


    MODIFY ENTITIES OF ZCAA361_I_Travel_CG1 IN LOCAL MODE
      ENTITY travel
        UPDATE FROM VALUE #( FOR travel IN keys (
          %key            = travel-%key
          status          = /dmo/if_flight_legacy=>travel_status-new
          %control-Status = if_abap_behv=>mk-on
        ) )
      REPORTED reported.

  ENDMETHOD.


  METHOD booktravel.

    set_status(
      EXPORTING
        keys      = keys
        new_staus = /dmo/if_flight_legacy=>travel_status-booked
      CHANGING
        failed    = failed
        reported  = reported ).

    result = CORRESPONDING #( read_travel( CORRESPONDING #( keys ) ) ).

  ENDMETHOD.


  METHOD canceltravel.

    set_status(
      EXPORTING
        keys      = CORRESPONDING #( keys )
        new_staus = /dmo/if_flight_legacy=>travel_status-cancelled
      CHANGING
        failed    = failed
        reported  = reported ).

    result = read_travel( CORRESPONDING #( keys ) ).

  ENDMETHOD.


  METHOD set_status.

    MODIFY ENTITIES OF ZCAA361_I_Travel_CG1 IN LOCAL MODE
      ENTITY travel
        UPDATE FROM VALUE #( FOR key IN keys (
          Travel_ID       = key-Travel_ID
          status          = new_staus
          %control-status = if_abap_behv=>mk-on
        ) )
      FAILED failed
      REPORTED reported.

  ENDMETHOD.


  METHOD read_travel.

    READ ENTITIES OF zcaa361_i_travel_CG1 IN LOCAL MODE
          ENTITY Travel
             FROM VALUE #( FOR key IN keys
               ( travel_id = key-travel_id
                 %control-Travel_ID       = if_abap_behv=>mk-on
                 %control-agency_id       = if_abap_behv=>mk-on
                 %control-customer_id     = if_abap_behv=>mk-on
                 %control-begin_date      = if_abap_behv=>mk-on
                 %control-end_date        = if_abap_behv=>mk-on
                 %control-booking_fee     = if_abap_behv=>mk-on
                 %control-total_price     = if_abap_behv=>mk-on
                 %control-currency_code   = if_abap_behv=>mk-on
                 %control-status          = if_abap_behv=>mk-on
                 %control-description     = if_abap_behv=>mk-on
                 %control-created_by      = if_abap_behv=>mk-on
                 %control-created_at      = if_abap_behv=>mk-on
                 %control-last_changed_by = if_abap_behv=>mk-on
                 %control-last_changed_at = if_abap_behv=>mk-on
                 ) )
           RESULT DATA(lt_travel_result).

    result = VALUE #( FOR ls_travel IN lt_travel_result
                  ( travel_id = ls_travel-Travel_ID
                    %param = CORRESPONDING #( ls_travel )
                 ) ).

  ENDMETHOD.

ENDCLASS.
