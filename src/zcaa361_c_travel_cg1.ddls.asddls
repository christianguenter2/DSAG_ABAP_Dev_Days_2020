@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel'
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZCAA361_C_Travel_CG1
  as projection on ZCAA361_I_Travel_CG1 as Travel
{
      @Search.defaultSearchElement: true
  key Travel_ID          as TravelID,
      @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Agency', element: 'AgencyID'  } }]
      @ObjectModel.text.element: ['AgencyName']
      @Search.defaultSearchElement: true
      Agency_ID          as AgencyID,
      _Agency.Name       as AgencyName,
      @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Customer', element: 'CustomerID'  } }]
      @ObjectModel.text.element: ['CustomerName']
      @Search.defaultSearchElement: true
      Customer_ID        as CustomerID,
      _Customer.LastName as CustomerName,
      Begin_Date         as BeginDate,
      End_Date           as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Booking_Fee        as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Total_Price        as TotalPrice,
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_Currency', element: 'Currency' }}]
      Currency_Code      as CurrencyCode,
      Status             as TravelStatus,
      Description        as Description,
      Last_Changed_At    as LastChangedAt,
  /* Associations */
      _Booking : redirected to composition child ZCAA361_C_Booking_CG1,
      _Agency,
      _Customer
}
