@AbapCatalog.sqlViewName: 'ZCAA361IBOOKCG1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations:true
@EndUserText.label: 'Booking view'
define view ZCAA361_I_Booking_CG1
  as select from zcaa361_book_CG1 as Booking
  association        to parent ZCAA361_I_Travel_CG1 as _Travel     on  $projection.Travel_ID = _Travel.Travel_ID
  association [1..1] to /DMO/I_Customer             as _Customer   on  $projection.Customer_ID = _Customer.CustomerID
  association [1..1] to /DMO/I_Carrier              as _Carrier    on  $projection.Carrier_ID = _Carrier.AirlineID
  association [1..1] to /DMO/I_Connection           as _Connection on  $projection.Carrier_ID    = _Connection.AirlineID
                                                                   and $projection.Connection_ID = _Connection.ConnectionID
{
  key travel_id               as Travel_ID,
  key booking_id              as Booking_ID,
      booking_date            as Booking_Date,
      customer_id             as Customer_ID,
      carrier_id              as Carrier_ID,
      connection_id           as Connection_ID,
      flight_date             as Flight_Date,
      @Semantics.amount.currencyCode: 'currency_code'
      flight_price            as Flight_Price,
      @Semantics.currencyCode: true
      currency_code           as Currency_Code,
      @UI.hidden: true
      _Travel.Last_Changed_At as Last_Changed_At,
      /* Associations */
      _Travel,
      _Customer,
      _Carrier,
      _Connection
}
