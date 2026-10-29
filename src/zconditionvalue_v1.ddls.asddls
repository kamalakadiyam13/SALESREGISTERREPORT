@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'desc for Codition Value V1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZCONDITIONVALUE_V1 as  
select from I_BillingDocumentItemPrcgElmnt as t0  
{  
    key t0.BillingDocument,  
    key t0.BillingDocumentItem,  
    t0.TransactionCurrency,  

    -- Condition Rate Values  
    max(case when t0.ConditionType = 'JOCG' then t0.ConditionRateValue else 0 end) as JOCGRate,  
    max(case when t0.ConditionType = 'JOSG' then t0.ConditionRateValue else 0 end) as JOSGRate,  
    max(case when t0.ConditionType = 'JOIG' then t0.ConditionRateValue else 0 end) as JOIGRate,  

    -- Condition Amounts with Currency  
    @Semantics.amount.currencyCode: 'TransactionCurrency'  
    max(case when t0.ConditionType = 'JOCG' then t0.ConditionAmount else cast(0 as abap.curr(13,2)) end) as JOCGValue,  

    @Semantics.amount.currencyCode: 'TransactionCurrency'  
    max(case when t0.ConditionType = 'JOSG' then t0.ConditionAmount else cast(0 as abap.curr(13,2)) end) as JOSGValue,  

    @Semantics.amount.currencyCode: 'TransactionCurrency'  
    max(case when t0.ConditionType = 'JOIG' then t0.ConditionAmount else cast(0 as abap.curr(13,2)) end) as JOIGValue  
}  
where (t0.ConditionType ='JOIG' or t0.ConditionType ='JOSG' or t0.ConditionType ='JOCG')
group by t0.BillingDocument,
    t0.BillingDocumentItem,t0.TransactionCurrency,t0.ConditionType
