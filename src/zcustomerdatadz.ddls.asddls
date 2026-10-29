@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For DZ Customer'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCustomerdataDZ  as select from I_OperationalAcctgDocItem as oa 
{
    key oa.AccountingDocument,
    oa.CompanyCode,
    oa.FiscalYear,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     oa.AmountInCompanyCodeCurrency,
     oa.CompanyCodeCurrency,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    oa.AmountInTransactionCurrency,
    oa.TransactionCurrency,
    oa.Customer,
    oa.OffsettingAccount,
    oa.Plant
}
where oa.TransactionTypeDetermination = '' and oa.Customer <> ''  
