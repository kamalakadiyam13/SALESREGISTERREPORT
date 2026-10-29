@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Sum Of GST'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSales_SUM_of_gst as select from I_JournalEntryItem as jei
left outer join I_Withholdingtaxitem as wht on jei.AccountingDocument = wht.AccountingDocument
    and jei.CompanyCode = wht.CompanyCode
    left outer join I_GLAccountText as gt on jei.GLAccount = gt.GLAccount and gt.Language = 'E'
{
    key jei.AccountingDocument,
    jei.CompanyCode,
    jei.AccountingDocumentType,
    sum(cast(jei.AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as taxable_amt,
    
    sum( cast(
    case
        when jei.TaxCode = 'GE' or jei.TaxCode = 'NE' or jei.TaxCode = 'FD'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 2.5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'GF' or jei.TaxCode = 'ND' or jei.TaxCode = 'FC'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 9 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'NF'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 20 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'GG' or jei.TaxCode = 'GH' or jei.TaxCode = 'GD'
          or jei.TaxCode = 'FE' or jei.TaxCode = 'FF' or jei.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )

end 
as abap.dec(23,2)) )  as CGST_Amount,

 
sum(cast(
    case
        when jei.TaxCode = 'GE' or jei.TaxCode = 'NE' or jei.TaxCode = 'FD'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 2.5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'GF' or jei.TaxCode = 'ND' or jei.TaxCode = 'FC'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 9 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'NF'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 20 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'GG' or jei.TaxCode = 'GH' or jei.TaxCode = 'GD'
          or jei.TaxCode = 'FE' or jei.TaxCode = 'FF' or jei.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )

end 
as abap.dec(23,2)) ) as SGST_Amount,
sum(
    cast(
        case
            when jei.TaxCode = 'GB' or jei.TaxCode = 'NB' or jei.TaxCode = 'FA'
            then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
                 * cast( 5 as abap.dec(5,2) )
                 / cast( 100 as abap.dec(5,2) )

            when jei.TaxCode = 'GC' or jei.TaxCode = 'NA' or jei.TaxCode = 'FB'
            then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
                 * cast( 18 as abap.dec(5,2) )
                 / cast( 100 as abap.dec(5,2) )

            when jei.TaxCode = 'NC'
            then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
                 * cast( 40 as abap.dec(5,2) )
                 / cast( 100 as abap.dec(5,2) )

            when jei.TaxCode = 'GH' or jei.TaxCode = 'GA'
              or jei.TaxCode = 'FE' or jei.TaxCode = 'FF' or jei.TaxCode = 'FG'
            then cast( 0 as abap.dec(15,2) )

            else cast( 0 as abap.dec(15,2) )
        end
    as abap.dec(23,2) )
) as IGST_Amount,
cast(wht.WhldgTaxAmtInCoCodeCrcy as abap.dec(23,2)) as TDS_Amt,
jei.ReferenceDocument,
jei.CompanyCodeCurrency
}
where
jei.Ledger ='0L'
and
(( jei.AccountingDocumentType = 'DR' and (jei.TransactionTypeDetermination <> 'EGK' or jei.TransactionTypeDetermination = '') and jei.PostingKey <> '31') 
or ( jei.AccountingDocumentType = 'DG' and (jei.TransactionTypeDetermination <> 'EGK' or jei.TransactionTypeDetermination = '') and jei.PostingKey <> '31'))
//or ( (jei.AccountingDocumentType = 'AB' and jei.IsReversal = 'X' ) and (jei.TransactionTypeDetermination <> 'EGK' or jei.TransactionTypeDetermination = '') and ( jei.PostingKey <> '31' or jei.Supplier = '' ))
and jei.Supplier = ''
and gt.GLAccountName not like '%TDS%' and gt.GLAccountName not like '%Rounded%'
and jei.TransactionTypeDetermination <> 'JIC'
and jei.TransactionTypeDetermination <> 'JIS'
and jei.TransactionTypeDetermination <> 'JII'
and jei.TransactionTypeDetermination <> 'JOC'
and jei.TransactionTypeDetermination <> 'JOS'
and jei.TransactionTypeDetermination <> 'JOI'
and jei.TransactionTypeDetermination <> 'JCI' 
and jei.TransactionTypeDetermination <> 'JRC'
and jei.TransactionTypeDetermination <> 'JRS'

group by
jei.AccountingDocument,
    jei.CompanyCode,
    jei.CompanyCodeCurrency,
    jei.ReferenceDocument,
    wht.WhldgTaxAmtInCoCodeCrcy,
    jei.AccountingDocumentType

union all

select from I_JournalEntryItem as jei
 left outer join I_GLAccountText as gl on jei.GLAccount = gl.GLAccount and gl.Language = 'E'
 inner join I_JournalEntryItem as jei1 on jei.ReversalReferenceDocument = jei1.AccountingDocument and jei.AccountingDocumentItem = jei1.AccountingDocumentItem
and (jei1.AccountingDocumentType = 'DG' or  jei1.AccountingDocumentType = 'DR' or  jei1.AccountingDocumentType = 'RV' or  jei1.AccountingDocumentType = 'DI' or  jei1.AccountingDocumentType = 'DC'   )
and jei1.Ledger = '0L'
left outer join I_Withholdingtaxitem as wht on jei.AccountingDocument = wht.AccountingDocument
    and jei.CompanyCode = wht.CompanyCode

{
 key jei.AccountingDocument,
    jei.CompanyCode,
    jei.AccountingDocumentType,
    sum(cast(jei.AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as taxable_amt,
    
        sum( cast(
    case
        when jei.TaxCode = 'GE' or jei.TaxCode = 'NE' or jei.TaxCode = 'FD'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 2.5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'GF' or jei.TaxCode = 'ND' or jei.TaxCode = 'FC'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 9 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'NF'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 20 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'GG' or jei.TaxCode = 'GH' or jei.TaxCode = 'GD'
          or jei.TaxCode = 'FE' or jei.TaxCode = 'FF' or jei.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )

end 
as abap.dec(23,2)) )  as CGST_Amount,

 
sum(cast(
    case
        when jei.TaxCode = 'GE' or jei.TaxCode = 'NE' or jei.TaxCode = 'FD'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 2.5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'GF' or jei.TaxCode = 'ND' or jei.TaxCode = 'FC'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 9 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'NF'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 20 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'GG' or jei.TaxCode = 'GH' or jei.TaxCode = 'GD'
          or jei.TaxCode = 'FE' or jei.TaxCode = 'FF' or jei.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )

end 
as abap.dec(23,2)) ) as SGST_Amount,


sum(
cast(
    case
        when jei.TaxCode = 'GB' or jei.TaxCode = 'NB' or jei.TaxCode = 'FA'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'GC' or jei.TaxCode = 'NA' or jei.TaxCode = 'FB'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 18 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'NC'
        then cast( jei.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 40 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when jei.TaxCode = 'GH' or jei.TaxCode = 'GA'
          or jei.TaxCode = 'FE' or jei.TaxCode = 'FF' or jei.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )
    end
as abap.dec(23,2) ) ) as IGST_Amount,
cast(wht.WhldgTaxAmtInCoCodeCrcy as abap.dec(23,2)) as TDS_Amt,
jei.ReferenceDocument,
jei.CompanyCodeCurrency
}
where 

 jei.Ledger = '0L'
and 
 gl.GLAccountName not like '%TDS%' and gl.GLAccountName not like '%Rounded%'

and jei.AccountingDocumentType='AB' and jei.IsReversal = 'X'
and ( jei.TransactionTypeDetermination <> 'AGD' or jei.TransactionTypeDetermination <> 'EGK' )
and jei.Supplier = ''
and jei.TaxCode <> ''
and ( jei.TransactionTypeDetermination <> 'JIC' and jei.TransactionTypeDetermination <> 'JIS' and jei.TransactionTypeDetermination <> 'JII'  
and jei.TransactionTypeDetermination <> 'JOC' and jei.TransactionTypeDetermination <> 'JOS' and jei.TransactionTypeDetermination <> 'JOI' and  jei.TransactionTypeDetermination <> 'JCI' 
and jei.TransactionTypeDetermination <> 'JRC' and jei.TransactionTypeDetermination <> 'JRS' and jei.TransactionTypeDetermination <> 'JRI')

group by
jei.AccountingDocument,
    jei.CompanyCode,
    jei.CompanyCodeCurrency,
    jei.ReferenceDocument,
    wht.WhldgTaxAmtInCoCodeCrcy,
    jei.AccountingDocumentType
