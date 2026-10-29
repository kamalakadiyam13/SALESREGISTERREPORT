@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'desc for final condition value v1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZFINALCONDITIONVALUE_V1 as select from ZCONDITIONVALUE_V1 as t0
{
     key t0.BillingDocument,  
    key t0.BillingDocumentItem,  
    t0.TransactionCurrency, 
    sum(JOCGRate) as JOCGRate,
    sum(JOSGRate) as JOSGRate,
    sum(JOIGRate) as JOIGRate,
    @Semantics.amount.currencyCode: 'TransactionCurrency' 
    sum(JOCGValue) as JOCGValue,
    @Semantics.amount.currencyCode: 'TransactionCurrency' 
    sum(JOSGValue) as JOSGValue,
     @Semantics.amount.currencyCode: 'TransactionCurrency' 
    sum(JOIGValue) as JOIGValue
}
group by t0.BillingDocument,BillingDocumentItem, t0.TransactionCurrency
