@EndUserText.label: 'Booking projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity ZCAA361_C_Booking_CG1
  as projection on ZCAA361_I_Booking_CG1
{
      @Search.defaultSearchElement: true
  key Travel_ID       as TravelID,
      @Search.defaultSearchElement: true
  key Booking_ID      as BookingID,
      Booking_Date    as BookingDate,
      @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Customer', element: 'CustomerID' }}]
      @Search.defaultSearchElement: true
      Customer_ID     as CustomerID,
      @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Carrier', element: 'AirlineID' }}]
      @ObjectModel.text.element: ['CarrierName']
      Carrier_ID      as CarrierID,
      _Carrier.Name   as CarrierName,
      @Consumption.valueHelpDefinition: [ {entity: {name: '/DMO/I_Flight', element: 'ConnectionID'},
                                            additionalBinding: [ { localElement: 'FlightDate',   element: 'FlightDate'},
                                                                 { localElement: 'CurrencyCode', element: 'CurrencyCode' } ] } ]
      Connection_ID   as ConnectionID,
      @Consumption.valueHelpDefinition: [ {entity: {name: '/DMO/I_Flight', element: 'FlightDate' },
                                            additionalBinding: [ { localElement: 'ConnectionID', element: 'ConnectionID'},
                                                             { localElement: 'CarrierID',    element: 'AirlineID'},
                                                                { localElement: 'CurrencyCode', element: 'CurrencyCode' }]}]
      Flight_Date     as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Flight_Price    as FlightPrice,
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_Currency', element: 'Currency' }}]
      Currency_Code   as CurrencyCode,
      @UI.hidden: true
      Last_Changed_At as LastChangedAt, -- Take over from parent
      /* Associations */
      _Travel : redirected to parent ZCAA361_C_Travel_CG1,
      _Customer,
      _Carrier
}
