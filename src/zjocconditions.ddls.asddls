@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For JOC Conditions'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZJOCConditions as select from I_OperationalAcctgDocItem as oa
{
   key oa.AccountingDocument,
   oa.AccountingDocumentType,
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
   oa.AmountInCompanyCodeCurrency,
   oa.CompanyCode,
   oa.CompanyCodeCurrency,
   @Semantics.amount.currencyCode: 'TransactionCurrency' 
   oa.AmountInTransactionCurrency,
   oa.TransactionCurrency,
   @Semantics.amount.currencyCode: 'FunctionalCurrency' 
   oa.AmountInFunctionalCurrency,
   oa.FunctionalCurrency, 
   oa.FiscalYear,
   oa.GLAccount
    
}
where oa.TransactionTypeDetermination = 'JOC' or oa.TransactionTypeDetermination ='JIC'
//and oa.AccountingDocumentType = 'DR'
