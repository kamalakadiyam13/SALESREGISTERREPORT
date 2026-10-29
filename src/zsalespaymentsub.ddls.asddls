@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Sales Sub Payments'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSalesPaymentSub 
as select distinct from ZSalesPartial as pay

{
    key pay.InvoiceDocument as AccountingDocument,
    pay.AccountingDocumentType,
    pay.FiscalYear,
    pay.rev_type as payment_type,
    pay.CompanyCodeCurrency,
    abs(pay.invamt) as Invoiceamount,
    pay.Payment1_Doc,
    pay.Payment1_Date,
    abs(pay.Payment1_Amt) as Payment1_Amt,
    pay.Payment2_Doc,
    pay.Payment2_Date,
    abs(pay.Payment2_Amt) as Payment2_Amt,
    pay.Payment3_Doc,
    pay.Payment3_Date,
    abs(pay.Payment3_Amt) as Payment3_Amt,
    pay.Payment4_Doc,
    pay.Payment4_Date,
    abs(pay.Payment4_Amt) as Payment4_Amt,
    pay.Payment5_Doc,
    pay.Payment5_Date,
    abs(pay.Payment5_Amt) as Payment5_Amt,
    pay.IsReversal,
    pay.IsReversed

    
}

union all

select distinct from ZClearingSalesDataMAIN as cl
{
 key cl.AccountingDocument,

 cl.AccountingDocumentType,
  cl.FiscalYear,
 cl.clear_type as payment_type,
 cl.CompanyCodeCurrency,
 abs(cl.Orginal_Amt) as Invoiceamount,
 
  cl.CLEARING_DOC as Payment1_Doc, 
 cl.PostingDate as Payment1_Date,
 case 
 when cl.kr_cle_doc <> '' then abs(cl.Orginal_Amt) else cl.Clearing_Amt end as Payment1_Amt,
 
 cast('' as abap.char(10)) as Payment2_Doc,
 cast('00000000' as abap.dats(8)) as Payment2_Date,
cast( 0 as abap.dec(23,2) ) as Payment2_Amt,

cast('' as abap.char(10)) as Payment3_Doc,
 cast('00000000' as abap.dats(8)) as Payment3_Date,
cast( 0 as abap.dec(23,2) ) as Payment3_Amt,

cast('' as abap.char(10)) as Payment4_Doc,
 cast('00000000' as abap.dats(8)) as Payment4_Date,
cast( 0 as abap.dec(23,2) ) as Payment4_Amt,

cast('' as abap.char(10)) as Payment5_Doc,
 cast('00000000' as abap.dats(8)) as Payment5_Date,
cast( 0 as abap.dec(23,2) ) as Payment5_Amt,
cl.IsReversal,
cl.IsReversed
}

union all
select distinct from  ZClearingSalesDataMAIN as cl
inner join ZSalesClearingAB as ac on cl.AccountingDocument = ac.rev_doc and cl.CompanyCode = ac.CompanyCode
{
 key ac.AccountingDocument,

 ac.AccountingDocumentType,
 cl.FiscalYear,
 ac.rev_type as payment_type,
 cl.CompanyCodeCurrency,
 abs(cl.Orginal_Amt) as Invoiceamount,
 
  ac.rev_doc as Payment1_Doc, 
 ac.PostingDate as Payment1_Date,
 //case 
 //when cl.kr_cle_doc <> '' then -abs(cl.Orginal_Amt) else cl.Clearing_Amt end as Payment1_Amt,
 cast(
 case
   when cl.kr_cle_doc <> '' then abs(cast(cl.Orginal_Amt as abap.dec(23,2)))
   else cast(cl.Clearing_Amt as abap.dec(23,2))
 end
as abap.dec(23,2)) as Payment1_Amt,
 cast('' as abap.char(10)) as Payment2_Doc,
 cast('00000000' as abap.dats(8)) as Payment2_Date,
cast( 0 as abap.dec(23,2) ) as Payment2_Amt,

cast('' as abap.char(10)) as Payment3_Doc,
 cast('00000000' as abap.dats(8)) as Payment3_Date,
cast( 0 as abap.dec(23,2) ) as Payment3_Amt,

cast('' as abap.char(10)) as Payment4_Doc,
 cast('00000000' as abap.dats(8)) as Payment4_Date,
cast( 0 as abap.dec(23,2) ) as Payment4_Amt,

cast('' as abap.char(10)) as Payment5_Doc,
 cast('00000000' as abap.dats(8)) as Payment5_Date,
cast( 0 as abap.dec(23,2) ) as Payment5_Amt,
ac.IsReversal,
ac.IsReversed

}
