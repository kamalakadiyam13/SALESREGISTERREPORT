@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'desc for Sales Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel: {
modelingPattern: #ANALYTICAL_DIMENSION,
    supportedCapabilities: [#ANALYTICAL_DIMENSION, #CDS_MODELING_ASSOCIATION_TARGET, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE]
    }
define view entity Z_SALES_REG_REP_VER1_MAIN as select from Z_SALES_REGISTER_REPORT_VER1 as sr 
left outer join ZSalesPaymentMain as pay on sr.AccountingDocument = pay.AccountingDocument and sr.AccountingDocumentType = pay.AccountingDocumentType

{
 key sr.AccountingDocument,
sr.BillingDocument,
sr.BillingDocumentType,
sr.AccountingDocumentType,
sr.DocumentReferenceID,
sr.BillingDocumentItem,
sr.PayerParty,
sr.BusinessPartnerFullName,
sr.CityName,
sr.TaxNumber3,
sr.BillingDocumentDate,
sr.ProfitCenter,
sr.AdditionalCustomerGroup1,
sr.AdditionalCustomerGroup1Name,
sr.AdditionalCustomerGroup2,
sr.AdditionalCustomerGroup2Name,
sr.AdditionalCustomerGroup3,
sr.AdditionalCustomerGroup3Name,
sr.AdditionalCustomerGroup4,
sr.AdditionalCustomerGroup4Name,
sr.AdditionalCustomerGroup5,
sr.AdditionalCustomerGroup5Name,
sr.SalesDocument,
sr.pannumber,
sr.AccountingDocumentHeaderText,
sr.AssignmentReference,
sr.Gstr1_section,
sr.CompanyCode,
sr.BusinessPlace,
sr.FiscalYear,
sr.TaxCode,
sr.JOCAccount,
sr.JOSAccount,
sr.JOIAccount,
sr.CreationDate,
sr.AccountingDocCreatedByUser,
sr.PostingDate,
sr.FiscalPeriod,
sr.GLAccount,
sr.GLAccountLongName,
sr.AcctYear,
sr.ExternalProductGroup,
sr.ExternalProductGroupName,
sr.CGSTTrasactionKey,
sr.SGSTTrasactionKey,
sr.IGSTTrasactionKey,
sr.ProductGroup,
sr.ProductGroupName,
sr.Product,
sr.BillingDocumentItemText,
case when sr.AccountingDocumentType = 'AB' then -abs(sr.CreditRelatedPrice) else abs(sr.CreditRelatedPrice) end as CreditRelatedPrice,
sr.TransactionCurrency,
cast(sr.BillingQuantity as abap.dec(15,3))  as BillingQuantity,
sr.BillingQuantityUnit,
cast(
    (sr.BillingQuantityInBaseUnit) 
    as abap.dec(15,3)
) as BillingQuantityInBaseUnit,

sr.BaseUnit,

sr.CompanyCodeCurrency,

sr.DocumentCurrency,
sr.TaxRate,
pay.payment_type,
sr.StatisticsCurrency,
sr.ConsumptionTaxCtrlCode,
sr.CustomerConditionGroup1,
sr.CustomerConditionGroup2,
sr.CustomerConditionGroup3,
sr.CustomerConditionGroup4,
sr.CustomerConditionGroup5,
sr.Plant,
sr.PlantName,
sr.BillToPartyRegion,
sr.statecode,

sr.OverallBillingStatusDesc,
sr.CustomerAccountGroup,
sr.YY1_EMAIL_REFERENCE_SDH,
sr.OriginalreferenceNo,
sr.ApInvoiceDate,
sr.DueDate,
sr.BillDate,
sr.WBSElement,
sr.PO_NO,
sr.PODAte,
sr.shipAdd,
sr.BillAdd,
sr.InvoiceReference,
sr.SalesOrganization,
sr.AccountingDocumentTypeName,
sr.ReferenceDocument,
case 
    when sr.AccountingDocumentType = 'AB' 
    then cast( -abs(sr.GrossValue1) as abap.dec(15,2) )
    else cast( abs(sr.GrossValue1) as abap.dec(15,2) )
end as GrossValue1,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.GrossValue) as abap.dec(15,2) )
    else cast( abs(sr.GrossValue) as abap.dec(15,2) )
end as GrossValue,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.NetAmount1) as abap.dec(15,2) )
    else cast( abs(sr.NetAmount1) as abap.dec(15,2) )
end as NetAmount1,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.NetAmount) as abap.dec(15,2) )
    else cast( abs(sr.NetAmount) as abap.dec(15,2) )
end as NetAmount,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.DiscountAmount) as abap.dec(15,2) )
    else cast( abs(sr.DiscountAmount) as abap.dec(15,2) )
end as DiscountAmount,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.DiscountAmount1) as abap.dec(15,2) )
    else cast( abs(sr.DiscountAmount1) as abap.dec(15,2) )
end as DiscountAmount1,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.DebitAmountinCompCurrency) as abap.dec(15,2) )
    else cast( abs(sr.DebitAmountinCompCurrency) as abap.dec(15,2) )
end as DebitAmountinCompCurrency,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.DebitAmountinCompCurrency1) as abap.dec(15,2) )
    else cast( abs(sr.DebitAmountinCompCurrency1) as abap.dec(15,2) )
end as DebitAmountinCompCurrency1,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.DebitAmountinTransCurrency) as abap.dec(15,2) )
    else cast( abs(sr.DebitAmountinTransCurrency) as abap.dec(15,2) )
end as DebitAmountinTransCurrency,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.DebitAmountinTransCurrency1) as abap.dec(15,2) )
    else cast( abs(sr.DebitAmountinTransCurrency1) as abap.dec(15,2) )
end as DebitAmountinTransCurrency1,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.JOCGValue) as abap.dec(15,2) )
    else cast( abs(sr.JOCGValue) as abap.dec(15,2) )
end as JOCGValue,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.JOSGValue) as abap.dec(15,2) )
    else cast( abs(sr.JOSGValue) as abap.dec(15,2) )
end as JOSGValue,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.JOIGValue) as abap.dec(15,2) )
    else cast( abs(sr.JOIGValue) as abap.dec(15,2) )
end as JOIGValue,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.RoundJOCGValue) as abap.dec(15,2) )
    else cast( abs(sr.RoundJOCGValue) as abap.dec(15,2) )
end as RoundJOCGValue,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.RoundJOSGValue) as abap.dec(15,2) )
    else cast( abs(sr.RoundJOSGValue) as abap.dec(15,2) )
end as RoundJOSGValue,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.RoundJOIGValue) as abap.dec(15,2) )
    else cast( abs(sr.RoundJOIGValue) as abap.dec(15,2) )
end as RoundJOIGValue,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.Listprice) as abap.dec(15,2) )
    else cast( abs(sr.Listprice) as abap.dec(15,2) )
end as Listprice,

case 
    when sr.AccountingDocumentType = 'AB'
    then cast( -abs(sr.GrossValue_1) as abap.dec(15,2) )
    else cast( abs(sr.GrossValue_1) as abap.dec(15,2) )
end as GrossValue_1
} 
