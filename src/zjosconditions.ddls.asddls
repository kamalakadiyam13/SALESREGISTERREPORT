@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For JOS Conditions'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZJOSConditions as select from  I_OperationalAcctgDocItem as oa
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
where oa.TransactionTypeDetermination = 'JOS' or oa.TransactionTypeDetermination ='JIS'
//and oa.AccountingDocumentType = 'DR'
