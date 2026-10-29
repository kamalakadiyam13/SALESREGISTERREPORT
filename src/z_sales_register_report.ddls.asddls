@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'desc for Sales Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel: {
modelingPattern: #ANALYTICAL_DIMENSION,
    supportedCapabilities: [#ANALYTICAL_DIMENSION, #CDS_MODELING_ASSOCIATION_TARGET, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE]
    }
// RV and RV reversal case
define view entity Z_Sales_Register_Report as 
select distinct from I_BillingDocument as t0
left outer join I_BillingDocumentItem as t1 on t0.BillingDocument=t1.BillingDocument
left outer join I_OperationalAcctgDocItem as oad on oad.BillingDocument = t0.BillingDocument
and oad.CompanyCode = t0.CompanyCode
and oad.FiscalYear = t0.FiscalYear
//and oad.BillingDocument = t0.BillingDocument
and oad.AccountingDocumentItem = '001'
left outer join I_JournalEntryItem as oa on oa.ReferenceDocument = t0.BillingDocument
and oa.TransactionTypeDetermination = ''
and oa.CompanyCode = t0.CompanyCode
and oa.FiscalYear = t0.FiscalYear
and oa.ReferenceDocumentItem = t1.BillingDocumentItem
left outer join I_JournalEntry as je on oa.AccountingDocument = je.AccountingDocument and oa.FiscalYear = je.FiscalYear
and oa.CompanyCode = je.CompanyCode
//and oa.AccountingDocumentItem = '002'
//and oa.GLAccountType = 'P'
left outer join I_BusinessPlace as bplace on bplace.CompanyCode = oa.CompanyCode
and bplace.BusinessPlace = oad.BusinessPlace
left outer join I_StorageLocation as sto on sto.StorageLocation = t1.StorageLocation
left outer join I_BillingDocumentTypeText as text on text.BillingDocumentType = t0.BillingDocumentType
and text.Language ='E'
left outer join I_BillingDocumentItemPrcgElmnt as cgst
    on cgst.BillingDocument = t1.BillingDocument
    and cgst.BillingDocumentItem = t1.BillingDocumentItem
    and cgst.ConditionType = 'JOCG'
 
left outer join I_BillingDocumentItemPrcgElmnt as sgst
    on sgst.BillingDocument = t1.BillingDocument
    and sgst.BillingDocumentItem = t1.BillingDocumentItem
    and sgst.ConditionType = 'JOSG'
 
left outer join I_BillingDocumentItemPrcgElmnt as igst
    on igst.BillingDocument = t1.BillingDocument
    and igst.BillingDocumentItem = t1.BillingDocumentItem
    and igst.ConditionType = 'JOIG'
 
//left outer join I_BillingDocumentItemPrcgElmnt as t4 on t1.BillingDocument = t4.BillingDocument 
//and t1.BillingDocumentItem=t4.BillingDocumentItem and ( t4.ConditionType = 'JOSG' or t4.ConditionType = 'JOCG'
//or t4.ConditionType = 'JOIG' )
left outer join I_BillingDocumentItemPrcgElmnt as Listprice on t1.BillingDocument=Listprice.BillingDocument
and t1.BillingDocumentItem=Listprice.BillingDocumentItem and (Listprice.ConditionType = 'ZFR1' or Listprice.ConditionType = 'ZP' or Listprice.ConditionType = 'ZPR3')
left outer join ZFINALCONDITIONVALUE_V1 as t8 on t1.BillingDocument = t8.BillingDocument
and t1.BillingDocumentItem=t8.BillingDocumentItem
left outer join ZNETVALUE as t11 on t11.AccountingDocument=t0.AccountingDocument and t11.CompanyCode=t0.CompanyCode
and t11.FiscalYear = t0.FiscalYear 
left outer join I_BusinessPartner as t2 on t0.PayerParty=t2.BusinessPartner
left outer join I_Customer as t3 on t0.PayerParty=t3.Customer
left outer join I_ProductPlantIntlTrd as t5 on t1.Product=t5.Product and t1.Plant=t5.Plant
left outer join I_CnsldtnPlantT as t6 on t1.Plant=t6.Plant
left outer join I_Product as t9 on t9.Product=t1.Product
left outer join I_ExtProdGrpText as t10 on t9.ExternalProductGroup=t10.ExternalProductGroup
left outer join I_ProductGroupText_2 as t12 on t12.ProductGroup=t9.ProductGroup
left outer join I_AdditionalCustomerGroup1Text as add1 on add1.AdditionalCustomerGroup1=t1.AdditionalCustomerGroup1 and add1.Language = 'E'
left outer join I_AdditionalCustomerGroup2Text as add2 on add2.AdditionalCustomerGroup2=t1.AdditionalCustomerGroup2 and add2.Language = 'E'
left outer join I_AdditionalCustomerGroup3Text as add3 on add3.AdditionalCustomerGroup3=t1.AdditionalCustomerGroup3 and add3.Language = 'E'
left outer join I_AdditionalCustomerGroup4Text as add4 on add4.AdditionalCustomerGroup4=t1.AdditionalCustomerGroup4 and add4.Language = 'E'
left outer join I_AdditionalCustomerGroup5Text as add5 on add5.AdditionalCustomerGroup5=t1.AdditionalCustomerGroup5 and add5.Language = 'E'
left outer join I_BillingDocumentItemPrcgElmnt as Disc on t1.BillingDocument=Disc.BillingDocument
and t1.BillingDocumentItem=Disc.BillingDocumentItem and (Disc.ConditionType = 'YK07' or Disc.ConditionType = 'ZK07' or Disc.ConditionType = 'ZK08'
or Disc.ConditionType = 'DPG2')
left outer join I_OverallBillingStatusText as obs on t0.OverallBillingStatus = obs.OverallBillingStatus and obs.Language = 'E'
left outer join I_SalesOrder as so on t1.SalesDocument = so.SalesOrder
left outer join I_GLAccountText as gt on gt.GLAccount = oa.GLAccount
and gt.Language = 'E'
left outer join ZCustomerDatas as cd on cd.AccountingDocument = oa.AccountingDocument
and cd.CompanyCode = oa.CompanyCode
and cd.FiscalYear = oa.FiscalYear
left outer join I_AccountingDocumentTypeText as adt on adt.AccountingDocumentType = oa.AccountingDocumentType
and adt.Language = 'E'
left outer join ZdocumentStatus as clt on clt.AccountingDocument = oa.AccountingDocument
and clt.CompanyCode = oa.CompanyCode
and clt.FiscalYear = oa.FiscalYear
left outer join I_BusinessUserBasic as bu on oa.AccountingDocCreatedByUser = bu.UserID 
{
    key t0.AccountingDocument,
     cast('' as abap.char(20)) as grantid,
 cast('' as abap.char( 10 )) as Fund,
    cast('' as abap.char( 16 )) as original_DocumentReferenceID,
    //bu.PersonFullName as createdby,
    case when oa.AccountingDocCreatedByUser = 'CC0000000002' then 'INTEGRATION' 
    when oa.AccountingDocCreatedByUser = 'INTEGRATION' then 'INTEGRATION'
    else bu.PersonFullName end as createdby,
    case 
    when ( oa.DocumentItemText <> '' and oa.DocumentItemText is not null ) 
        then oa.DocumentItemText 
    
    when ( cd.DocumentItemText <> '' and cd.DocumentItemText is not null ) 
        then cd.DocumentItemText
    
    else null 
end as DocumentItemText,
    //oa.WBSElement as wbs_element,
    oa.WBSElementInternalID as wbs_elementinternalid,
    t0.BillingDocument,
    t0.BillingDocumentType,
    oa.AccountingDocumentType,
    t0.DocumentReferenceID,
    t1.BillingDocumentItem,
    t0.PayerParty,
    t2.BusinessPartnerFullName,
    t3.CityName,
    t3.TaxNumber3,
    t0.BillingDocumentDate,
    //t7.ProfitCenter,
    t1.ProfitCenter,
     t1.AdditionalCustomerGroup1,
     add1.AdditionalCustomerGroup1Name,
     t1.AdditionalCustomerGroup2,
     add2.AdditionalCustomerGroup2Name,
     t1.AdditionalCustomerGroup3,
     add3.AdditionalCustomerGroup3Name,
     t1.AdditionalCustomerGroup4,
     add4.AdditionalCustomerGroup4Name,
     t1.AdditionalCustomerGroup5,
     add5.AdditionalCustomerGroup5Name,
     t1.SalesDocument,
     substring( t3.TaxNumber3, 3, 10 ) as pannumber,
     je.AccountingDocumentHeaderText,
     oa.AssignmentReference,
    case 
    when t3.TaxNumber3 <> '' then 'B2B'
    else 'B2C'
end as Gstr1_section,
    t0.CompanyCode,
    oad.BusinessPlace,   
    t0.FiscalYear,
    t1.TaxCode,
    case
when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' 
    or oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' 
    or oa.TaxCode = 'NF'
    or oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG'
     then  '0020900910'
     else '0000000000' end as JOCAccount,
 case
when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' 
    or oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' 
    or oa.TaxCode = 'NF'
    or oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG'
     then  '0020900920'
     else '0000000000' end  as JOSAccount,
         case
when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA' 
    or oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB' 
    or oa.TaxCode = 'NC' 
    or oa.TaxCode = 'GA' or oa.TaxCode = 'GH' 
     or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
    then '0020900900' else '0000000000' end  as  JOIAccount,
    //t0.CreationDate,
    oa.DocumentDate as CreationDate,
    case when oa.AccountingDocCreatedByUser = 'INTEGRATION' then 'CC0000000002' else oa.AccountingDocCreatedByUser end as AccountingDocCreatedByUser,
    oa.PostingDate,
    oa.FiscalPeriod,
    oa.GLAccount,
    gt.GLAccountLongName,
    t11.FiscalYear as AcctYear,
    t10.ExternalProductGroup,
    t10.ExternalProductGroupName,
    case when cgst.ConditionType  = 'JOCG' then 
     'JOC'
     else
    ''
end as CGSTTrasactionKey,
     case when sgst.ConditionType  = 'JOSG' then 
     'JOS'
     else
    ''
end as SGSTTrasactionKey,
     case when igst.ConditionType  = 'JOIG' then 
     'JOI'
     else
    ''
end as IGSTTrasactionKey,
    t1.ProductGroup,
    t12.ProductGroupName,
    t1.Product,
    t1.BillingDocumentItemText,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    cast( oa.AmountInTransactionCurrency as abap.dec(15,2 ) ) as CreditRelatedPrice,
    t1.TransactionCurrency,
    @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
    t1.BillingQuantity,
    t1.BillingQuantityUnit,
     @Semantics.quantity.unitOfMeasure: 'BaseUnit'
     t1.BillingQuantityInBaseUnit,
     t1.BaseUnit,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case 
  when t0.BillingDocumentType = 'CBRE' 
    // or t0.BillingDocumentType = 'S1' 
     or t0.BillingDocumentType = 'G2' 
     or t0.BillingDocumentType = 'IVS' 
  then -1 * (cast(t1.CreditRelatedPrice as abap.dec(15,3)) *  cast(t1.BillingQuantity as abap.dec(15,3)))
  else (cast(t1.CreditRelatedPrice as abap.dec(15,3)) *  cast(t1.BillingQuantity as abap.dec(15,3)))
    end as GrossValue1,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    (cast(t1.CreditRelatedPrice as abap.dec(15,3)) *  cast(t1.BillingQuantity as abap.dec(15,3))) as  GrossValue,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case 
  when t0.BillingDocumentType = 'CBRE' 
    // or t0.BillingDocumentType = 'S1' 
     or t0.BillingDocumentType = 'G2' 
     or t0.BillingDocumentType = 'IVS' 
  then
     -t1.NetAmount
     else
     cast(oa.AmountInCompanyCodeCurrency as abap.curr(15,2) )  end as NetAmount1,
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      t1.NetAmount,
cast(0.00 as  abap.dec(15,3)) as NetAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     Disc.ConditionAmount as DiscountAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case 
  when t0.BillingDocumentType = 'CBRE' 
     //or t0.BillingDocumentType = 'S1' 
     or t0.BillingDocumentType = 'G2' 
     or t0.BillingDocumentType = 'IVS' 
  then -1 *  Disc.ConditionAmount
  else Disc.ConditionAmount
end as DiscountAmount1,
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     cast( oa.AmountInCompanyCodeCurrency as abap.curr(15,2 ) ) as DebitAmountinCompCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     case 
  when t0.BillingDocumentType = 'CBRE' 
     //or t0.BillingDocumentType = 'S1' 
     or t0.BillingDocumentType = 'G2' 
     or t0.BillingDocumentType = 'IVS' 
  then -1 * oa.AmountInCompanyCodeCurrency
  else oa.AmountInCompanyCodeCurrency
end as DebitAmountinCompCurrency1,
     t11.CompanyCodeCurrency,
        @Semantics.amount.currencyCode: 'TransactionCurrency'
   cast( oa.AmountInTransactionCurrency as abap.curr(15,2 ) ) as DebitAmountinTransCurrency,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case 
  when t0.BillingDocumentType = 'CBRE' 
     //or t0.BillingDocumentType = 'S1' 
     or t0.BillingDocumentType = 'G2' 
     or t0.BillingDocumentType = 'IVS' 
  then -1 * oa.AmountInTransactionCurrency
  else oa.AmountInTransactionCurrency
end as DebitAmountinTransCurrency1,
    t11.TransactionCurrency as DocumentCurrency,
     case when ( t8.JOCGRate <> 0 and t8.JOSGRate <> 0) then 
     ( t8.JOCGRate + t8.JOSGRate )
     else
    t8.JOIGRate
    end as TaxRate,
//       @Semantics.amount.currencyCode: 'TransactionCurrency'
//    t8.JOCGValue,
//       @Semantics.amount.currencyCode: 'TransactionCurrency'
//    t8.JOSGValue,
//       @Semantics.amount.currencyCode: 'TransactionCurrency'
//    t8.,
//    @Semantics.amount.currencyCode: 'TransactionCurrency'
//   case 
//  when t0.BillingDocumentType = 'CBRE' 
//     or t0.BillingDocumentType = 'S1' 
//     or t0.BillingDocumentType = 'G2' 
//     or t0.BillingDocumentType = 'IVS' 
//  then 1 * t8.JOCGValue
//  else t8.JOCGValue
//end as JOCGValue,
//@Semantics.amount.currencyCode: 'TransactionCurrency'
//case 
//  when t0.BillingDocumentType = 'CBRE' 
//     or t0.BillingDocumentType = 'S1' 
//     or t0.BillingDocumentType = 'G2' 
//     or t0.BillingDocumentType = 'IVS' 
//  then 1 * t8.JOSGValue
//  else t8.JOSGValue
//end as JOSGValue,
//
//@Semantics.amount.currencyCode: 'TransactionCurrency'
//case 
//  when t0.BillingDocumentType = 'CBRE' 
//     or t0.BillingDocumentType = 'S1' 
//     or t0.BillingDocumentType = 'G2' 
//     or t0.BillingDocumentType = 'IVS' 
//  then 1 * t8.JOIGValue
//  else t8.JOIGValue
//end as JOIGValue,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
    case
        when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 2.5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 9 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'NF'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 20 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
          or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )
    end
as abap.curr(15,2) )

as JOCGValue,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    cast(
    case
        when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 2.5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 9 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'NF'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 20 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
          or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )
    end
as abap.curr(15,2) )

as JOSGValue,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
cast(
    case
        when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 18 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'NC'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 40 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GH' or oa.TaxCode = 'GA'
          or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )
    end
as abap.curr(15,2) )

as JOIGValue,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
cast(
    round(
        case
            when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 2.5 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 9 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'NF'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 20 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
              or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
            then cast( 0 as abap.dec(15,4) )

            else cast( 0 as abap.dec(15,4) )
        end,
        4
    )
as abap.curr(15,2) )

as RoundJOCGValue,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
cast(
    round(
        case
            when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 2.5 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 9 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'NF'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 20 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
              or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
            then cast( 0 as abap.dec(15,4) )

            else cast( 0 as abap.dec(15,4) )
        end,
        4
    )
as abap.curr(15,2) )

as RoundJOSGValue,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
cast(
    round(
        case
            when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 5 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 18 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'NC'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 40 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GH' or oa.TaxCode = 'GA'
              or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
            then cast( 0 as abap.dec(15,4) )

            else cast( 0 as abap.dec(15,4) )
        end,
        4
    )
as abap.curr(15,2) )

as RoundJOIGValue,

     t0.StatisticsCurrency,
     t5.ConsumptionTaxCtrlCode,
     t1.CustomerConditionGroup1,
     t1.CustomerConditionGroup2,
     t1.CustomerConditionGroup3,
     t1.CustomerConditionGroup4,
     t1.CustomerConditionGroup5,
     t1.Plant,
     t6.PlantName,
     t3.Region as BillToPartyRegion,
     case
    when t3.Region = 'AN' then '35'
    when t3.Region = 'AP' then '28'
    when t3.Region = 'AR' then '12'
    when t3.Region = 'AS' then '18'
    when t3.Region = 'BR' then '10'
    when t3.Region = 'CG' then '22'
    when t3.Region = 'CH' then '04'
    when t3.Region = 'DH' then '25'
    when t3.Region = 'DL' then '07'
    when t3.Region = 'GA' then '30'
    when t3.Region = 'GJ' then '24'
    when t3.Region = 'HP' then '02'
    when t3.Region = 'HR' then '06'
    when t3.Region = 'JH' then '20'
    when t3.Region = 'JK' then '01'
    when t3.Region = 'KA' then '29'
    when t3.Region = 'KL' then '32'
    when t3.Region = 'LA' then '37'
    when t3.Region = 'MH' then '27'
    when t3.Region = 'ML' then '17'
    when t3.Region = 'MN' then '14'
    when t3.Region = 'MP' then '23'
    when t3.Region = 'MZ' then '15'
    when t3.Region = 'NL' then '13'
    when t3.Region = 'OD' then '21'
    when t3.Region = 'OT' then '97'
    when t3.Region = 'PB' then '03'
    when t3.Region = 'PY' then '34'
    when t3.Region = 'RJ' then '08'
    when t3.Region = 'SK' then '11'
    when t3.Region = 'TN' then '33'
    when t3.Region = 'TR' then '16'
    when t3.Region = 'TS' then '36'
    when t3.Region = 'UK' then '05'
    when t3.Region = 'UP' then '09'
    when t3.Region = 'WB' then '19'
end as statecode,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     Listprice.ConditionRateValue as Listprice,
//     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//     case 
//  when t0.BillingDocumentType = 'CBRE' 
//     //or t0.BillingDocumentType = 'S1' 
//     or t0.BillingDocumentType = 'G2' 
//     or t0.BillingDocumentType = 'IVS' 
//  then -1 * ((get_numeric_value(Listprice.ConditionRateValue)) * (t1.BillingQuantity))
//  else ((get_numeric_value(Listprice.ConditionRateValue)) * (t1.BillingQuantity))
//end as GrossValue_1,
cast(0.00 as  abap.dec(15,3)) as GrossValue_1,
//case when t0.BillingDocumentType = 'S1' then 'Canceled' else obs.OverallBillingStatusDesc end as OverallBillingStatusDesc,
case when oa.IsReversal <> '' or oa.IsReversed <> '' then 'Cancelled'
when clt.ClearingJournalEntry <> '' then 'Close'
//when JEI0.ClearingJournalEntry = '' then 'Open'
else 'Open' end as OverallBillingStatusDesc,
t3.CustomerAccountGroup,
so.YY1_EMAIL_REFERENCE_SDH,
case when (oa.IsReversal = 'X' or oa.IsReversed = 'X') then oa.ReversalReferenceDocument else cast('' as abap.char(10)) end as OriginalreferenceNo,
case when (oa.IsReversal = 'X' or oa.IsReversed = 'X') then oa.PostingDate else cast('00000000' as abap.dats) end as ApInvoiceDate,
cd.NetDueDate as DueDate,
t1.BillingDocumentDate as BillDate,
//cast('' as abap.numc( 8 )) as WBSElement,
oa.WBSElement as WBSElement,
so.PurchaseOrderByCustomer as PO_NO,
cast(so.CustomerPurchaseOrderDate as abap.char(20)) as PODAte,
concat(
  concat(
    concat(
      concat(coalesce(t3.StreetName,''), ', '),
      concat(coalesce(t3.CityName,''), ', ')
    ),
    concat(coalesce(t3.Region,''), ', ')
  ),
  concat(coalesce(t3.Country,''), concat(' - ', coalesce(t3.PostalCode,'')))
) as shipAdd,
concat(
  concat(
    concat(
      concat(coalesce(t3.StreetName,''), ', '),
      concat(coalesce(t3.CityName,''), ', ')
    ),
    concat(coalesce(t3.Region,''), ', ')
  ),
  concat(coalesce(t3.Country,''), concat(' - ', coalesce(t3.PostalCode,'')))
) as BillAdd,
oa.InvoiceReference,
so.SalesOrganization,
adt.AccountingDocumentTypeName,
oa.ReferenceDocument
  //((get_numeric_value(Listprice.ConditionRateValue)) * (t1.BillingQuantity)) as GrossValue_1
}
where oa.AccountingDocumentType = 'RV' and oa.TransactionTypeDetermination = '' 
and oa.Ledger = '0L'
group by t0.AccountingDocument,
bu.PersonFullName,
oa.DocumentItemText,
cd.DocumentItemText,
    t0.BillingDocument,
    oa.IsReversal,
    oa.IsReversed,
    so.SalesOrganization,
    cd.NetDueDate,
    oa.ReversalReferenceDocument,
    t1.CustomsPreference,
    t0.DocumentReferenceID,
    t1.BillingDocumentItem,
    t0.PayerParty,
     oad.BusinessPlace,
    t2.BusinessPartnerFullName,
    t3.CityName,
    t3.TaxNumber3,
    t0.BillingDocumentDate,
    t1.ProfitCenter,
    //t7.ProfitCenter,
    t0.CompanyCode,   
    t0.FiscalYear,
    t1.TaxCode,
//    t7.JOSAccount,
//    t7.JOCAccount,
//    t7.JOIAccount,
    t0.BillingDocumentType,
    //t0.CreationDate,
    oa.DocumentDate,
    oa.AccountingDocCreatedByUser,
    oa.PostingDate,
    oa.FiscalPeriod,
    t11.FiscalYear,
    t10.ExternalProductGroup,
    t10.ExternalProductGroupName,
    t1.ProductGroup,
     t12.ProductGroupName,
    t1.Product,
    t1.BillingDocumentItemText,
    t1.CreditRelatedPrice,
    t1.TransactionCurrency,
    t1.BillingQuantity,
    t1.BillingQuantityUnit,
     t1.BillingQuantityInBaseUnit,
     t1.BaseUnit,
     t1.NetAmount,
     t11.DebitAmountinCompCurrency,
     t11.CompanyCodeCurrency,
     t11.DebitAmountinTransCurrency,
    t11.TransactionCurrency,
    Listprice.ConditionRateValue,
     t0.StatisticsCurrency,
     t1.Plant,
     t5.ConsumptionTaxCtrlCode,
     t6.PlantName,
     t1.Region,
     obs.OverallBillingStatusDesc,
     t3.CustomerAccountGroup,
     so.YY1_EMAIL_REFERENCE_SDH,
     t1.ReferenceSDDocument,
     t1.BillingDocumentDate,
     oa.WBSElement,
     oa.WBSElementInternalID,
     so.PurchaseOrderByCustomer,
     so.CustomerPurchaseOrderDate,
     t3.CityName,
     t3.Country,
     t3.Region,
     t3.StreetName,
     t3.PostalCode,
     t1.CustomerConditionGroup1,
     t1.CustomerConditionGroup2,
     t1.CustomerConditionGroup3,
     t1.CustomerConditionGroup4,
     t1.CustomerConditionGroup5,
     t3.Region,t8.JOCGRate,t8.JOSGRate,t8.JOIGRate,t8.JOCGValue,t8.JOSGValue,t8.JOIGValue,oa.AccountingDocumentType,
     t1.AdditionalCustomerGroup1,
     add1.AdditionalCustomerGroup1Name,
     t1.AdditionalCustomerGroup2,
     add2.AdditionalCustomerGroup2Name,
     t1.AdditionalCustomerGroup3,
     add3.AdditionalCustomerGroup3Name,
     t1.AdditionalCustomerGroup4,
     add4.AdditionalCustomerGroup4Name,
     t1.AdditionalCustomerGroup5,
     oa.GLAccount,
     gt.GLAccountLongName,
     oa.InvoiceReference,
     oa.TaxCode,
     oa.ReferenceDocument,
     cgst.ConditionType ,
     sgst.ConditionType ,
     igst.ConditionType ,
     oa.AmountInCompanyCodeCurrency,
     oa.AmountInTransactionCurrency,
     adt.AccountingDocumentTypeName,
     cd.AmountInTransactionCurrency,
     clt.ClearingJournalEntry,
     je.AccountingDocumentHeaderText,
     oa.AssignmentReference,
     add5.AdditionalCustomerGroup5Name,t1.SalesDocument,t0.BillingDocumentDate,t1.TaxAmount,Listprice.ConditionRateValue,Disc.ConditionAmount

union all  
    
//DR and DZ case
select distinct from  I_JournalEntryItem as oa 
left outer join I_OperationalAcctgDocItem as oad on oad.AccountingDocument = oa.AccountingDocument
and oad.CompanyCode = oa.CompanyCode
and oad.FiscalYear = oa.FiscalYear
//and oad.LedgerGLLineItem = '000001'
and oad.AccountingDocumentItem = '001'
left outer join I_JournalEntry as je on je.AccountingDocument = oa.AccountingDocument
and je.CompanyCode = oa.CompanyCode and je.FiscalYear = oa.FiscalYear and je.AccountingDocumentType = oa.AccountingDocumentType
left outer join I_BusinessPlace as bplace on bplace.CompanyCode = oa.CompanyCode
and bplace.BusinessPlace = oad.BusinessPlace
left outer join ZNETVALUE as t11 on t11.AccountingDocument = oa.AccountingDocument and t11.CompanyCode=oa.CompanyCode 
and oa.FiscalYear = t11.FiscalYear
left outer join I_AccountingDocumentTypeText as tet on tet.AccountingDocumentType = oa.AccountingDocumentType and tet.Language = 'E'
left outer join ZCustomerDatas as cd on cd.AccountingDocument = oa.AccountingDocument
and cd.CompanyCode = oa.CompanyCode
and cd.FiscalYear = oa.FiscalYear
left outer join I_BusinessPartner as t2 on ( cd.Customer =t2.BusinessPartner  or oa.Customer = t2.BusinessPartner )
left outer join I_Customer as t3 on ( cd.Customer=t3.Customer or oa.Customer = t3.Customer )
left outer join I_CnsldtnPlantT as t6 on oa.Plant=t6.Plant
left outer join I_GLAccountText as gt on gt.GLAccount = oa.GLAccount
and gt.Language = 'E'
left outer join ZdocumentStatus as clt on clt.AccountingDocument = oa.AccountingDocument
and clt.CompanyCode = oa.CompanyCode
and clt.FiscalYear = oa.FiscalYear
left outer join I_BusinessUserBasic as bu on oa.AccountingDocCreatedByUser = bu.UserID 
left outer join Z_ref_invoice_entries as invref on 
( je.AccountingDocument = invref.DG_doc or je.AccountingDocument = invref.DR_DocumentNo )
and ( je.FiscalYear = invref.DG_year or je.FiscalYear = invref.DR_Fyear )
and ( je.CompanyCode = invref.DG_companycode or je.CompanyCode = invref.DR_companycode )

{
    key oa.AccountingDocument,
    oa.GrantID,
    oa.Fund,
    invref.DocumentReferenceID as original_DocumentReferenceID,
   //cast( '' as abap.char(16) ) as original_DocumentReferenceID,
    case when oa.AccountingDocCreatedByUser = 'CC0000000002' then 'INTEGRATION' 
    when oa.AccountingDocCreatedByUser = 'INTEGRATION' then 'INTEGRATION'
    else bu.PersonFullName end as createdby,
     //bu.PersonFullName as createdby,
    //case when cd.DocumentItemText = '' then oa.DocumentItemText else cd.DocumentItemText end as DocumentItemText,
     case 
    when ( oa.DocumentItemText <> '' and oa.DocumentItemText is not null ) 
        then oa.DocumentItemText 
    
    when ( cd.DocumentItemText <> '' and cd.DocumentItemText is not null ) 
        then cd.DocumentItemText
    
    else null 
end as DocumentItemText,
    //oa.WBSElement as wbs_element,
    oa.WBSElementInternalID as wbs_elementinternalid,
    '' as BillingDocument,
    '' as BillingDocumentType,
    oa.AccountingDocumentType as AccountingDocumentType,
    je.DocumentReferenceID as DocumentReferenceID,
    oa.LedgerGLLineItem as BillingDocumentItem,
    t2.BusinessPartner as PayerParty,
    t2.BusinessPartnerFullName,
    t3.CityName,
    t3.TaxNumber3,
    oa.PostingDate as BillingDocumentDate,
    //t7.ProfitCenter,
    oa.ProfitCenter,
     '' as AdditionalCustomerGroup1,
     '' as AdditionalCustomerGroup1Name,
     '' as AdditionalCustomerGroup2,
     '' as AdditionalCustomerGroup2Name,
     '' as AdditionalCustomerGroup3,
     '' as AdditionalCustomerGroup3Name,
     '' as AdditionalCustomerGroup4,
     '' as AdditionalCustomerGroup4Name,
     '' as AdditionalCustomerGroup5,
     '' as AdditionalCustomerGroup5Name,
     '' as SalesDocument,
          substring( t3.TaxNumber3, 3, 10 ) as pannumber,
     je.AccountingDocumentHeaderText,
     oa.AssignmentReference,
    case 
    when t3.TaxNumber3 <> '' then 'B2B'
    else 'B2C'
end as Gstr1_section,
    oa.CompanyCode,
    oad.BusinessPlace,   
    oa.FiscalYear,
    oa.TaxCode,
   case
when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' 
    or oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' 
    or oa.TaxCode = 'NF'
    or oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG'
     then  '0020900910'
     else '0000000000' end as JOCAccount,
 case
when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' 
    or oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' 
    or oa.TaxCode = 'NF'
    or oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG'
     then  '0020900920'
     else '0000000000' end  as JOSAccount,
         case
when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA' 
    or oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB' 
    or oa.TaxCode = 'NC' 
    or oa.TaxCode = 'GA' or oa.TaxCode = 'GH' 
     or oa.TaxCode = 'FE' or oa.TaxCode = 'FH' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
    then '0020900900' else '0000000000' end  as  JOIAccount,
    oa.DocumentDate as CreationDate,
     case when oa.AccountingDocCreatedByUser = 'INTEGRATION' then 'CC0000000002' else oa.AccountingDocCreatedByUser end as AccountingDocCreatedByUser,   oa.PostingDate,
    oa.FiscalPeriod,
    oa.GLAccount,
    gt.GLAccountLongName,
    oa.FiscalYear as AcctYear,
   '' as ExternalProductGroup,
    '' as ExternalProductGroupName,
'' as  CGSTTrasactionKey,
   '' as SGSTTrasactionKey,
'' as  IGSTTrasactionKey,
    oa.ProductGroup as ProductGroup,
    '' as ProductGroupName,
    oa.Product,
   '' as BillingDocumentItemText,
   //cast('0000' as abap.dec(15,2 )) as CreditRelatedPrice,
   cast(0.00 as abap.dec(15,2 )) as CreditRelatedPrice,
   oa.TransactionCurrency as TransactionCurrency,

   cast(oa.Quantity as abap.quan(13)) as BillingQuantity,
   
   //cast(oa.BaseUnit as abap.unit(3)) 
   
   oa.BaseUnit as BillingQuantityUnit,

 cast('00000' as abap.quan(13)) as BillingQuantityInBaseUnit,
     //cast(oa.BaseUnit as abap.unit(3)) 
     oa.BaseUnit as BaseUnit,
cast('00000' as  abap.dec(15,3)) as GrossValue1,
cast('0000' as  abap.dec(15,3)) as  GrossValue,

       cast(oa.AmountInCompanyCodeCurrency as abap.curr(15,2) ) as NetAmount1,

     // cast(cd.AmountInTransactionCurrency as abap.curr(15,2) ) as NetAmount,
       cast(0.00 as  abap.dec(15,3)) as NetAmount,  
    cast('0000' as  abap.curr(15,2)) as DiscountAmount,

 cast('0000' as  abap.curr(15,2)) as DiscountAmount1,

 case 
 when oa.AccountingDocumentType = 'DG' or oa.AccountingDocumentType = 'DC'
 then cast(oa.AmountInCompanyCodeCurrency as  abap.curr(15,2)) 
 else  
 cast(oa.AmountInCompanyCodeCurrency as  abap.curr(15,2)) 
 end  as DebitAmountinCompCurrency,
 case 
 when oa.AccountingDocumentType = 'DG' or oa.AccountingDocumentType = 'DC'
 then cast(oa.AmountInCompanyCodeCurrency as  abap.curr(15,2)) 
 else  
 cast(oa.AmountInCompanyCodeCurrency as  abap.curr(15,2)) 
 end  as   DebitAmountinCompCurrency1,
   oa.CompanyCodeCurrency  as CompanyCodeCurrency,
   case 
 when oa.AccountingDocumentType = 'DG' or oa.AccountingDocumentType = 'DC'
 then cast (oa.AmountInTransactionCurrency as  abap.curr(15,2)) 
 else 
 cast (oa.AmountInTransactionCurrency as  abap.curr(15,2)) 
 end  as DebitAmountinTransCurrency,
   case 
 when oa.AccountingDocumentType = 'DG' or oa.AccountingDocumentType = 'DC'
 then cast (oa.AmountInTransactionCurrency as  abap.curr(15,2)) 
 else 
 cast (oa.AmountInTransactionCurrency as  abap.curr(15,2))
 end  as  DebitAmountinTransCurrency1,
    oa.TransactionCurrency as DocumentCurrency,
      cast(
case
    when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' then 2.5
    when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' then 9
    when oa.TaxCode = 'NF' then 20
    when oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG' 
     or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
     then 0
    when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' then 2.5
    when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' then 9
    when oa.TaxCode = 'NF' then 20
    when oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG' 
     or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
     then 0
    when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA' then 5
    when oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB' then 18
    when oa.TaxCode = 'NC' then 40
    when oa.TaxCode = 'FH' then 18
    when oa.TaxCode = 'GA' or oa.TaxCode = 'GH' 
     or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
    then 0
    else 0
end as abap.dec(5,2) ) as TaxRate,
        cast(
    case
        when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 2.5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 9 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'NF'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 20 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
          or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )
    end
as abap.curr(15,2) )

as JOCGValue,
    cast(
    case
        when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 2.5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 9 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'NF'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 20 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
          or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )
    end
as abap.curr(15,2) )

as JOSGValue,
     
cast(
    case
        when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 18 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'NC'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 40 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )
             
         when oa.TaxCode = 'FH'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 18  as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GH' or oa.TaxCode = 'GA'
          or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )
    end
as abap.curr(15,2) )

as JOIGValue,
     
cast(
    round(
        case
            when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 2.5 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 9 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'NF'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 20 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
              or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
            then cast( 0 as abap.dec(15,4) )

            else cast( 0 as abap.dec(15,4) )
        end,
        4
    )
as abap.curr(15,2) )

as RoundJOCGValue,

cast(
    round(
        case
            when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 2.5 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 9 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'NF'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 20 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
              or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
            then cast( 0 as abap.dec(15,4) )

            else cast( 0 as abap.dec(15,4) )
        end,
        4
    )
as abap.curr(15,2) )

as RoundJOSGValue,

cast(
    round(
        case
            when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 5 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 18 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'NC'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 40 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GH' or oa.TaxCode = 'GA'
              or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
            then cast( 0 as abap.dec(15,4) )

            else cast( 0 as abap.dec(15,4) )
        end,
        4
    )
as abap.curr(15,2) )

as RoundJOIGValue,
     cast('' as abap.cuky( 5 )) as StatisticsCurrency,
     oa.YY1_HSN_Code_COB as ConsumptionTaxCtrlCode,
     ''as CustomerConditionGroup1,
    '' as CustomerConditionGroup2,
     '' as CustomerConditionGroup3,
     '' as CustomerConditionGroup4,
     '' as CustomerConditionGroup5,
     oa.Plant,
     t6.PlantName as PlantName,
     t3.Region as BillToPartyRegion,
     case
    when t3.Region = 'AN' then '35'
    when t3.Region = 'AP' then '28'
    when t3.Region = 'AR' then '12'
    when t3.Region = 'AS' then '18'
    when t3.Region = 'BR' then '10'
    when t3.Region = 'CG' then '22'
    when t3.Region = 'CH' then '04'
    when t3.Region = 'DH' then '25'
    when t3.Region = 'DL' then '07'
    when t3.Region = 'GA' then '30'
    when t3.Region = 'GJ' then '24'
    when t3.Region = 'HP' then '02'
    when t3.Region = 'HR' then '06'
    when t3.Region = 'JH' then '20'
    when t3.Region = 'JK' then '01'
    when t3.Region = 'KA' then '29'
    when t3.Region = 'KL' then '32'
    when t3.Region = 'LA' then '37'
    when t3.Region = 'MH' then '27'
    when t3.Region = 'ML' then '17'
    when t3.Region = 'MN' then '14'
    when t3.Region = 'MP' then '23'
    when t3.Region = 'MZ' then '15'
    when t3.Region = 'NL' then '13'
    when t3.Region = 'OD' then '21'
    when t3.Region = 'OT' then '97'
    when t3.Region = 'PB' then '03'
    when t3.Region = 'PY' then '34'
    when t3.Region = 'RJ' then '08'
    when t3.Region = 'SK' then '11'
    when t3.Region = 'TN' then '33'
    when t3.Region = 'TR' then '16'
    when t3.Region = 'TS' then '36'
    when t3.Region = 'UK' then '05'
    when t3.Region = 'UP' then '09'
    when t3.Region = 'WB' then '19'
end as statecode,
     cast('00000' as  abap.dec(15,3)) as Listprice,
 //cast(cd.AmountInTransactionCurrency as  abap.dec(15,3)) as GrossValue_1,
 cast(0.00 as  abap.dec(15,3)) as GrossValue_1,
case when oa.IsReversal <> '' or oa.IsReversed <> '' then 'Cancelled'
when clt.ClearingJournalEntry <> '' then 'Close'
//when JEI0.ClearingJournalEntry = '' then 'Open'
else 'Open' end as OverallBillingStatusDesc,
t3.CustomerAccountGroup,
'' as YY1_EMAIL_REFERENCE_SDH,
case 
when oa.AccountingDocumentType = 'DG' or oa.AccountingDocumentType = 'DI' or oa.AccountingDocumentType = 'DC' then invref.DR_DocumentNo
when (oa.IsReversal = 'X' or oa.IsReversed = 'X') then oa.ReversalReferenceDocument else cast('' as abap.char(10)) end as OriginalreferenceNo,
//cast('' as abap.char( 10 )) as OriginalreferenceNo,
case 
when oa.AccountingDocumentType = 'DG' or oa.AccountingDocumentType = 'DI' or oa.AccountingDocumentType = 'DC' then invref.DR_postingdate
when (oa.IsReversal = 'X' or oa.IsReversed = 'X') then oa.PostingDate else cast('00000000' as abap.dats) end as ApInvoiceDate,
//cast('00000000' as abap.dats) as ApInvoiceDate,

cd.NetDueDate as DueDate,
'' as BillDate,
oa.WBSElement as WBSElement, 
oad.Reference1IDByBusinessPartner as PO_NO,
oad.Reference3IDByBusinessPartner as PODAte,
concat(
  concat(
    concat(
      concat(coalesce(t3.StreetName,''), ', '),
      concat(coalesce(t3.CityName,''), ', ')
    ),
    concat(coalesce(t3.Region,''), ', ')
  ),
  concat(coalesce(t3.Country,''), concat(' - ', coalesce(t3.PostalCode,'')))
) as shipAdd,
concat(
  concat(
    concat(
      concat(coalesce(t3.StreetName,''), ', '),
      concat(coalesce(t3.CityName,''), ', ')
    ),
    concat(coalesce(t3.Region,''), ', ')
  ),
  concat(coalesce(t3.Country,''), concat(' - ', coalesce(t3.PostalCode,'')))
) as BillAdd,
oa.InvoiceReference,
cast('' as abap.char(4)) as SalesOrganization,
tet.AccountingDocumentTypeName,
oa.ReferenceDocument
}
where  
  (( oa.AccountingDocumentType = 'DR' and (oa.GLAccountType = 'P' or oa.GLAccountType = 'N' ) )
   or (oa.AccountingDocumentType = 'DG' and(oa.GLAccountType = 'P' or oa.GLAccountType = 'N' ) )
   or (oa.AccountingDocumentType = 'DI' and (oa.GLAccountType = 'P' or oa.GLAccountType = 'N' ))
   or (oa.AccountingDocumentType = 'DC' and (oa.GLAccountType = 'P' or oa.GLAccountType = 'N' )) )
  and ( oa.Customer = '' or oa.Customer <> '' ) and gt.GLAccountName not like '%TDS%'
  and oa.Ledger = '0L'
group by oa.AccountingDocument,
oa.GrantID,
oa.Fund,
bu.PersonFullName,
    t2.BusinessPartnerFullName,
    oa.DocumentItemText,
    cd.DocumentItemText,
    t3.CityName,
    t3.TaxNumber3,
    oa.WBSElement,
    t3.Customer,
    t3.CustomerFullName,
    oa.ReversalReferenceDocument,
    cd.NetDueDate,
    oa.IsReversal,
    oa.IsReversed,
    t3.Country,
    t3.StreetName,
    t3.Region,
    t3.PostalCode,
     oad.BusinessPlace,
    oa.LedgerGLLineItem,
    t3.Region,
    oa.IsReversal,
    clt.ClearingJournalEntry,
    oa.ProductGroup,
    //t7.ProfitCenter,
    oa.CompanyCode, 
    oa.Quantity,
    oa.BaseUnit,  
    oa.FiscalYear,
    oa.TaxCode,
    oa.PostingDate,
    oa.AccountingDocCreatedByUser,
     oa.YY1_HSN_Code_COB,
    oa.FiscalPeriod,
    oa.FiscalYear,
      oa.GLAccount,
      oad.BusinessPlace,
    bplace.BusinessPlaceDescription,
    oad.Reference1IDByBusinessPartner ,
oad.Reference3IDByBusinessPartner ,
     oa.Plant,
     oa.Product,
     oa.DocumentDate,
     oa.ProfitCenter,
     oa.AccountingDocumentType,
      t6.PlantName,
      oa.AmountInCompanyCodeCurrency,
      oa.CompanyCodeCurrency,
      oa.AmountInTransactionCurrency,
      cd.AmountInTransactionCurrency,
      oa.TransactionTypeDetermination,
      oa.TransactionCurrency,
        cd.AmountInCompanyCodeCurrency ,
        cd.AmountInTransactionCurrency,
        tet.AccountingDocumentTypeName,
        oa.AccountingDocumentType,
        t3.CustomerAccountGroup,
        oa.GLAccount,
        gt.GLAccountLongName,
        oa.InvoiceReference,
         t2.BusinessPartner,
         oa.TransactionCurrency,
         oa.WBSElementInternalID,
          je.DocumentReferenceID,
          oa.ReferenceDocument,
          je.AccountingDocumentHeaderText,
          oa.AssignmentReference,
          invref.DR_postingdate,
          invref.DR_DocumentNo,
          invref.DocumentReferenceID
          //cd.InvoiceReferenceFiscalYear,
          //cd.InvoiceReference
          

union all //DZ Payments

select distinct from  I_JournalEntryItem as oa 
left outer join I_OperationalAcctgDocItem as oad on oad.AccountingDocument = oa.AccountingDocument
and oad.CompanyCode = oa.CompanyCode
and oad.FiscalYear = oa.FiscalYear
and oad.AccountingDocumentItem = '001'
left outer join I_JournalEntry as je on je.AccountingDocument = oa.AccountingDocument
and je.CompanyCode = oa.CompanyCode and je.FiscalYear = oa.FiscalYear and je.AccountingDocumentType = oa.AccountingDocumentType
left outer join I_BusinessPlace as bplace on bplace.CompanyCode = oa.CompanyCode
and bplace.BusinessPlace = oad.BusinessPlace
left outer join ZNETVALUE as t11 on t11.AccountingDocument = oa.AccountingDocument and t11.CompanyCode=oa.CompanyCode 
and oa.FiscalYear = t11.FiscalYear
left outer join I_AccountingDocumentTypeText as tet on tet.AccountingDocumentType = oa.AccountingDocumentType and tet.Language = 'E'
//left outer join ZCustomerDatas as cd on cd.AccountingDocument = oa.AccountingDocument
//and cd.CompanyCode = oa.CompanyCode
//and cd.FiscalYear = oa.FiscalYear
left outer join I_BusinessPartner as t2 on oa.Customer =t2.BusinessPartner
left outer join I_Customer as t3 on oa.Customer=t3.Customer
left outer join I_CnsldtnPlantT as t6 on oa.Plant=t6.Plant
left outer join I_GLAccountText as gt on gt.GLAccount = oa.GLAccount
and gt.Language = 'E'
left outer join ZdocumentStatus as clt on clt.AccountingDocument = oa.AccountingDocument
and clt.CompanyCode = oa.CompanyCode
and clt.FiscalYear = oa.FiscalYear
left outer join I_BusinessUserBasic as bu on oa.AccountingDocCreatedByUser = bu.UserID 
{
    key oa.AccountingDocument,
    oa.GrantID,
    oa.Fund,
        cast('' as abap.char( 16 )) as original_DocumentReferenceID,
       // bu.PersonFullName as createdby,
   case when oa.AccountingDocCreatedByUser = 'CC0000000002' then 'INTEGRATION' 
    when oa.AccountingDocCreatedByUser = 'INTEGRATION' then 'INTEGRATION'
    else bu.PersonFullName end as createdby,
  //case when cd.DocumentItemText = '' then oa.DocumentItemText else cd.DocumentItemText end as DocumentItemText,
     case 
    when ( oa.DocumentItemText <> '' and oa.DocumentItemText is not null ) 
        then oa.DocumentItemText 
    
    else null 
end as DocumentItemText,
    //oa.WBSElement as wbs_element,
    oa.WBSElementInternalID as wbs_elementinternalid,
    '' as BillingDocument,
    '' as BillingDocumentType,
    oa.AccountingDocumentType as AccountingDocumentType,
    je.DocumentReferenceID as DocumentReferenceID,
     oa.LedgerGLLineItem as BillingDocumentItem,
    t2.BusinessPartner as PayerParty,
    t2.BusinessPartnerFullName,
    t3.CityName,
    t3.TaxNumber3,
    oa.PostingDate as BillingDocumentDate,
    //t7.ProfitCenter,
    oa.ProfitCenter,
     '' as AdditionalCustomerGroup1,
     '' as AdditionalCustomerGroup1Name,
     '' as AdditionalCustomerGroup2,
     '' as AdditionalCustomerGroup2Name,
     '' as AdditionalCustomerGroup3,
     '' as AdditionalCustomerGroup3Name,
     '' as AdditionalCustomerGroup4,
     '' as AdditionalCustomerGroup4Name,
     '' as AdditionalCustomerGroup5,
     '' as AdditionalCustomerGroup5Name,
     '' as SalesDocument,
          substring( t3.TaxNumber3, 3, 10 ) as pannumber,
     je.AccountingDocumentHeaderText,
     oa.AssignmentReference,
    case 
    when t3.TaxNumber3 <> '' then 'B2B'
    else 'B2C'
end as Gstr1_section,
    oa.CompanyCode,
     oad.BusinessPlace,   
    oa.FiscalYear,
    oa.TaxCode,
   case
when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' 
    or oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' 
    or oa.TaxCode = 'NF'
    or oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG'
     then  '0020900910'
     else '0000000000' end as JOCAccount,
 case
when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' 
    or oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' 
    or oa.TaxCode = 'NF'
    or oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG'
     then  '0020900920'
     else '0000000000' end  as JOSAccount,
         case
when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA' 
    or oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB' 
    or oa.TaxCode = 'NC' 
    or oa.TaxCode = 'GA' or oa.TaxCode = 'GH' 
     or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
    then '0020900900' else '0000000000' end  as  JOIAccount,
    oa.DocumentDate as CreationDate,
    //cast( '' as abap.char(12)) 
    case when oa.AccountingDocCreatedByUser = 'INTEGRATION' then 'CC0000000002' else oa.AccountingDocCreatedByUser end as AccountingDocCreatedByUser,
   oa.PostingDate,
    oa.FiscalPeriod,
    oa.GLAccount,
    gt.GLAccountLongName,
    oa.FiscalYear as AcctYear,
   '' as ExternalProductGroup,
    '' as ExternalProductGroupName,
'' as  CGSTTrasactionKey,
   '' as SGSTTrasactionKey,
'' as  IGSTTrasactionKey,
    oa.ProductGroup as ProductGroup,
    '' as ProductGroupName,
    oa.Product,
   '' as BillingDocumentItemText,
  // cast('0000' as abap.dec(15,2 )) as CreditRelatedPrice,
   cast(0.00 as abap.dec(15,2 )) as CreditRelatedPrice,
   oa.TransactionCurrency as TransactionCurrency,
   cast(oa.Quantity as abap.quan(13)) as BillingQuantity,
   //cast(oa.BaseUnit as abap.unit(3)) as 
   oa.BaseUnit as BillingQuantityUnit,
 cast('00000' as abap.quan(13)) as BillingQuantityInBaseUnit,
     //cast(oa.BaseUnit as abap.unit(3)) 
     oa.BaseUnit as BaseUnit,
cast('00000' as  abap.dec(15,3)) as GrossValue1,
cast('0000' as  abap.dec(15,3)) as  GrossValue,
       cast(oa.AmountInCompanyCodeCurrency as abap.curr(15,2) ) as NetAmount1,
     // cast(cd.AmountInTransactionCurrency as abap.curr(15,2) ) as NetAmount,
     // cast(oa.AmountInCompanyCodeCurrency as abap.curr(15,2) ) as NetAmount,
    cast(0.00 as  abap.dec(15,3)) as NetAmount,
    cast('0000' as  abap.curr(15,2)) as DiscountAmount,
 cast('0000' as  abap.curr(15,2)) as DiscountAmount1,
 cast(oa.AmountInCompanyCodeCurrency as  abap.curr(15,2)) as DebitAmountinCompCurrency,
cast(
    -1 * cast(oa.AmountInCompanyCodeCurrency as abap.dec(23,2))
as abap.curr(15,2)) as   DebitAmountinCompCurrency1,
   oa.CompanyCodeCurrency  as CompanyCodeCurrency,
    cast(oa.AmountInTransactionCurrency as  abap.curr(15,2)) as DebitAmountinTransCurrency,
 cast(
    -1 * cast(oa.AmountInTransactionCurrency as abap.dec(23,2))
as abap.curr(15,2)) as  DebitAmountinTransCurrency1,
    oa.TransactionCurrency as DocumentCurrency,
      cast(
case
//    when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' then 2.5
//    when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' then 9
//    when oa.TaxCode = 'NF' then 20
//    when oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG' 
//     or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
//     then 0
//    when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' then 2.5
//    when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' then 9
//    when oa.TaxCode = 'NF' then 20
//    when oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG' 
//     or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
//     then 0
//    when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA' then 5
//    when oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB' then 18
//    when oa.TaxCode = 'NC' then 40
//    when oa.TaxCode = 'GA' or oa.TaxCode = 'GH' 
//     or oa.TaxCode = 'FE' or
when  oa.TaxCode = 'A1' or oa.TaxCode = 'A2' then 18
    else 0
end as abap.dec(5,2) ) as TaxRate,
         cast(
case
    when oa.TaxCode = 'A2' 
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
        * cast( 9 as abap.dec(5,2) )
        / cast( 100 as abap.dec(5,2) )

//    when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
//        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
//        * cast( 9 as abap.dec(5,2) )
//        / cast( 100 as abap.dec(5,2) )
//
//    when oa.TaxCode = 'NF'
//        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
//        * cast( 20 as abap.dec(5,2) )
//        / cast( 100 as abap.dec(5,2) )
//        
//        when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
//        or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
//        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
//        * cast( 0 as abap.dec(5,2) )
//        / cast( 100 as abap.dec(5,2) )
        
        
        

    else cast(0 as abap.dec(13,2))
end
as abap.curr(15,2))  as JOCGValue,

 
cast(
case
    when oa.TaxCode = 'A2' 
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
        * cast( 9 as abap.dec(5,2) )
        / cast( 100 as abap.dec(5,2) )

    else cast(0 as abap.dec(13,2))
end
as abap.curr(15,2)) as JOSGValue,

// @Semantics.amount.currencyCode: 'DocumentCurrency'

cast(
case
    when oa.TaxCode = 'A1' 
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
        * cast( 18 as abap.dec(5,2) )
        / cast( 100 as abap.dec(5,2) )
      
    else cast(0 as abap.dec(13,2))
end
as abap.curr(15,2)) as JOIGValue,

cast('00000' as abap.curr(15,2) )

as RoundJOCGValue,

cast('00000'as abap.curr(15,2) )

as RoundJOSGValue,
// @Semantics.amount.currencyCode: 'TransactionCurrency'
//cast(
//    round(
//        case
//            when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA'
//            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
//                 * cast( 5 as abap.dec(7,4) )
//                 / cast( 100 as abap.dec(7,4) )
//
//            when oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB'
//            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
//                 * cast( 18 as abap.dec(7,4) )
//                 / cast( 100 as abap.dec(7,4) )
//
//            when oa.TaxCode = 'NC'
//            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
//                 * cast( 40 as abap.dec(7,4) )
//                 / cast( 100 as abap.dec(7,4) )
//
//            when oa.TaxCode = 'GH' or oa.TaxCode = 'GA'
//              or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
//            then cast( 0 as abap.dec(15,4) )
//
//            else cast( 0 as abap.dec(15,4) )
//        end,
//        4
//    )
 cast('00000' as abap.curr(15,2) ) 

as RoundJOIGValue,
     cast('' as abap.cuky( 5 )) as StatisticsCurrency,
      '' as ConsumptionTaxCtrlCode,
     ''as CustomerConditionGroup1,
    '' as CustomerConditionGroup2,
     '' as CustomerConditionGroup3,
     '' as CustomerConditionGroup4,
     '' as CustomerConditionGroup5,
     oa.Plant,
     t6.PlantName as PlantName,
     t3.Region as BillToPartyRegion,
     case
    when t3.Region = 'AN' then '35'
    when t3.Region = 'AP' then '28'
    when t3.Region = 'AR' then '12'
    when t3.Region = 'AS' then '18'
    when t3.Region = 'BR' then '10'
    when t3.Region = 'CG' then '22'
    when t3.Region = 'CH' then '04'
    when t3.Region = 'DH' then '25'
    when t3.Region = 'DL' then '07'
    when t3.Region = 'GA' then '30'
    when t3.Region = 'GJ' then '24'
    when t3.Region = 'HP' then '02'
    when t3.Region = 'HR' then '06'
    when t3.Region = 'JH' then '20'
    when t3.Region = 'JK' then '01'
    when t3.Region = 'KA' then '29'
    when t3.Region = 'KL' then '32'
    when t3.Region = 'LA' then '37'
    when t3.Region = 'MH' then '27'
    when t3.Region = 'ML' then '17'
    when t3.Region = 'MN' then '14'
    when t3.Region = 'MP' then '23'
    when t3.Region = 'MZ' then '15'
    when t3.Region = 'NL' then '13'
    when t3.Region = 'OD' then '21'
    when t3.Region = 'OT' then '97'
    when t3.Region = 'PB' then '03'
    when t3.Region = 'PY' then '34'
    when t3.Region = 'RJ' then '08'
    when t3.Region = 'SK' then '11'
    when t3.Region = 'TN' then '33'
    when t3.Region = 'TR' then '16'
    when t3.Region = 'TS' then '36'
    when t3.Region = 'UK' then '05'
    when t3.Region = 'UP' then '09'
    when t3.Region = 'WB' then '19'
end as statecode,
     cast('00000' as  abap.dec(15,3)) as Listprice,
// cast(cd.AmountInTransactionCurrency as  abap.dec(15,3)) as GrossValue_1,
 // cast(oa.AmountInCompanyCodeCurrency as  abap.dec(15,3)) as GrossValue_1,
cast(0.00 as  abap.dec(15,3)) as GrossValue_1,
case when oa.IsReversal <> '' or oa.IsReversed <> '' then 'Cancelled'
when clt.ClearingJournalEntry <> '' then 'Close'
//when JEI0.ClearingJournalEntry = '' then 'Open'
else 'Open' end as OverallBillingStatusDesc,
t3.CustomerAccountGroup,
'' as YY1_EMAIL_REFERENCE_SDH,
case when (oa.IsReversal = 'X' or oa.IsReversed = 'X') then oa.ReversalReferenceDocument else cast('' as abap.char(10)) end as OriginalreferenceNo,
case when (oa.IsReversal = 'X' or oa.IsReversed = 'X') then oa.PostingDate else cast('00000000' as abap.dats) end as ApInvoiceDate,
oa.NetDueDate as DueDate,
'' as BillDate,
oa.WBSElement as WBSElement,
oad.Reference1IDByBusinessPartner as PO_NO,
oad.Reference3IDByBusinessPartner  as PODAte,
concat(
  concat(
    concat(
      concat(coalesce(t3.StreetName,''), ', '),
      concat(coalesce(t3.CityName,''), ', ')
    ),
    concat(coalesce(t3.Region,''), ', ')
  ),
  concat(coalesce(t3.Country,''), concat(' - ', coalesce(t3.PostalCode,'')))
) as shipAdd,
concat(
  concat(
    concat(
      concat(coalesce(t3.StreetName,''), ', '),
      concat(coalesce(t3.CityName,''), ', ')
    ),
    concat(coalesce(t3.Region,''), ', ')
  ),
  concat(coalesce(t3.Country,''), concat(' - ', coalesce(t3.PostalCode,'')))
) as BillAdd,
oa.InvoiceReference,
cast('' as abap.char(4)) as SalesOrganization,
tet.AccountingDocumentTypeName,
oa.ReferenceDocument
}
where  
   oa.AccountingDocumentType = 'DZ' and oa.SpecialGLCode <> ''
   and oa.TaxCode <> ''
   and oa.Ledger = '0L'
group by oa.AccountingDocument,
oa.GrantID,
oa.Fund,
bu.PersonFullName,
    t2.BusinessPartnerFullName,
    oa.DocumentItemText,
    //cd.DocumentItemText,
    oa.WBSElement,
    t3.CityName,
    t3.TaxNumber3,
    t3.Customer,
    t3.CustomerFullName,
    t3.Country,
    t3.StreetName,
    oa.NetDueDate,
    oa.ReversalReferenceDocument,
    oa.IsReversal,
    oa.IsReversed,
    t3.Region,
    t3.PostalCode,
    oa.ProductGroup,
    //t7.ProfitCenter,
    oa.CompanyCode,
    oa.Quantity,
    oa.BaseUnit,   
    oa.FiscalYear,
    oa.IsReversal,
    oa.TaxCode,
    oa.PostingDate,
    oa.FiscalPeriod,
    oad.Reference1IDByBusinessPartner ,
oad.Reference3IDByBusinessPartner ,
    oa.FiscalYear,
      oa.GLAccount,
      oad.BusinessPlace,
      clt.ClearingJournalEntry,
    bplace.BusinessPlaceDescription,
     oa.Plant,
    t3.Region,
     oa.Product,
     oa.DocumentDate,
     oa.ProfitCenter,
     oa.ReferenceDocument,
     oa.AccountingDocumentType,
      t6.PlantName,
      oa.AmountInCompanyCodeCurrency,
      oa.CompanyCodeCurrency,
      oa.AmountInTransactionCurrency,oa.TransactionTypeDetermination,
      oa.TransactionCurrency,
        oa.AmountInCompanyCodeCurrency ,
      //  cd.AmountInTransactionCurrency,
        tet.AccountingDocumentTypeName,
        oa.AccountingDocumentType,
        t3.CustomerAccountGroup,
        oa.GLAccount,
        gt.GLAccountLongName,
        oa.InvoiceReference,
         t2.BusinessPartner,
         oa.TransactionCurrency,
         oa.WBSElementInternalID,
          je.DocumentReferenceID,
           oad.BusinessPlace,
           oa.AccountingDocCreatedByUser,
           je.AccountingDocumentHeaderText,
           oa.AssignmentReference,
           oa.LedgerGLLineItem


union all   // DR and DG rversals
    

select distinct from  I_JournalEntryItem as oa 
left outer join I_OperationalAcctgDocItem as oad on oad.AccountingDocument = oa.AccountingDocument
and oad.CompanyCode = oa.CompanyCode
and oad.FiscalYear = oa.FiscalYear
and oad.AccountingDocumentItem = '001'
left outer join I_JournalEntry as je on je.AccountingDocument = oa.AccountingDocument
and je.CompanyCode = oa.CompanyCode and je.FiscalYear = oa.FiscalYear and je.AccountingDocumentType = oa.AccountingDocumentType
left outer join I_BusinessPlace as bplace on bplace.CompanyCode = oa.CompanyCode
and bplace.BusinessPlace = oad.BusinessPlace
left outer join ZNETVALUE as t11 on t11.AccountingDocument = oa.AccountingDocument and t11.CompanyCode=oa.CompanyCode 
and oa.FiscalYear = t11.FiscalYear
left outer join I_AccountingDocumentTypeText as tet on tet.AccountingDocumentType = oa.AccountingDocumentType and tet.Language = 'E'
left outer join ZCustomerDatas as cd on cd.AccountingDocument = oa.AccountingDocument
and cd.CompanyCode = oa.CompanyCode
and cd.FiscalYear = oa.FiscalYear
left outer join I_BusinessPartner as t2 on cd.Customer =t2.BusinessPartner or oa.Customer = t2.BusinessPartner
left outer join I_Customer as t3 on cd.Customer=t3.Customer or oa.Customer = t3.Customer
left outer join I_CnsldtnPlantT as t6 on oa.Plant=t6.Plant
left outer join I_GLAccountText as gt on gt.GLAccount = oa.GLAccount
and gt.Language = 'E'
inner join ZABReversal as ab on ab.AccountingDocument = oa.AccountingDocument
and ab.AccountingDocumentItem = oa.AccountingDocumentItem
and ab.CompanyCode = oa.CompanyCode
and ab.FiscalYear = oa.FiscalYear
left outer join ZdocumentStatus as clt on clt.AccountingDocument = oa.AccountingDocument
and clt.CompanyCode = oa.CompanyCode
and clt.FiscalYear = oa.FiscalYear
left outer join I_BusinessUserBasic as bu on oa.AccountingDocCreatedByUser = bu.UserID 
{
    key oa.AccountingDocument,
    oa.GrantID,
    oa.Fund,
            cast('' as abap.char( 16 )) as original_DocumentReferenceID,
       // bu.PersonFullName as createdby,
   case when oa.AccountingDocCreatedByUser = 'CC0000000002' then 'INTEGRATION' 
    when oa.AccountingDocCreatedByUser = 'INTEGRATION' then 'INTEGRATION'
    else bu.PersonFullName end as createdby,
  // case when cd.DocumentItemText = '' then oa.DocumentItemText else cd.DocumentItemText end as DocumentItemText,
    case 
    when ( oa.DocumentItemText <> '' and oa.DocumentItemText is not null ) 
        then oa.DocumentItemText 
    
    when ( cd.DocumentItemText <> '' and cd.DocumentItemText is not null ) 
        then cd.DocumentItemText
    
    else null 
end as DocumentItemText,
   // oa.WBSElement as wbs_element,
    oa.WBSElementInternalID as wbs_elementinternalid,
    '' as BillingDocument,
    '' as BillingDocumentType,
    oa.AccountingDocumentType as AccountingDocumentType,
    je.DocumentReferenceID as DocumentReferenceID,
    oa.LedgerGLLineItem as BillingDocumentItem,
     t2.BusinessPartner as PayerParty,
    t2.BusinessPartnerFullName,
    t3.CityName,
    t3.TaxNumber3,
    oa.PostingDate as BillingDocumentDate,
    //t7.ProfitCenter,
    oa.ProfitCenter,
     '' as AdditionalCustomerGroup1,
     '' as AdditionalCustomerGroup1Name,
     '' as AdditionalCustomerGroup2,
     '' as AdditionalCustomerGroup2Name,
     '' as AdditionalCustomerGroup3,
     '' as AdditionalCustomerGroup3Name,
     '' as AdditionalCustomerGroup4,
     '' as AdditionalCustomerGroup4Name,
     '' as AdditionalCustomerGroup5,
     '' as AdditionalCustomerGroup5Name,
     '' as SalesDocument,
          substring( t3.TaxNumber3, 3, 10 ) as pannumber,
     je.AccountingDocumentHeaderText,
     oa.AssignmentReference,
    case 
    when t3.TaxNumber3 <> '' then 'B2B'
    else 'B2C'
end as Gstr1_section,
    oa.CompanyCode,  
     oad.BusinessPlace, 
    oa.FiscalYear,
    oa.TaxCode,
case
    when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' 
      or oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' 
      or oa.TaxCode = 'NF'
      or oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG'
    then '0020900910'
    else '0000000000'
end as JOCAccount,
case
    when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' 
      or oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' 
      or oa.TaxCode = 'NF'
      or oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG'
    then '0020900920'
    else '0000000000'
end  as JOSAccount,
         case
when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA' 
    or oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB' 
    or oa.TaxCode = 'NC' 
    or oa.TaxCode = 'GA' or oa.TaxCode = 'GH' 
     or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
    then '0020900900' else '0000000000' end  as  JOIAccount,
    oa.DocumentDate as CreationDate,
     case when oa.AccountingDocCreatedByUser = 'INTEGRATION' then 'CC0000000002' else oa.AccountingDocCreatedByUser end as AccountingDocCreatedByUser,
   oa.PostingDate,
    oa.FiscalPeriod,
    oa.GLAccount,
    gt.GLAccountLongName,
    oa.FiscalYear as AcctYear,
   '' as ExternalProductGroup,
    '' as ExternalProductGroupName,
'' as  CGSTTrasactionKey,
   '' as SGSTTrasactionKey,
'' as IGSTTrasactionKey,
    oa.ProductGroup as ProductGroup,
    '' as ProductGroupName,
    oa.Product,
   '' as BillingDocumentItemText,
   //cast('0000' as abap.dec(15,2 )) as CreditRelatedPrice,
   cast(0.00 as abap.dec(15,2 )) as CreditRelatedPrice,
   oa.TransactionCurrency as TransactionCurrency,
   cast(oa.Quantity as abap.quan(13)) as BillingQuantity,
  // cast(oa.BaseUnit as abap.unit(3)) as BillingQuantityUnit,
  oa.BaseUnit as BillingQuantityUnit,
 cast('00000' as abap.quan(13)) as BillingQuantityInBaseUnit,
     //cast(oa.BaseUnit as abap.unit(3)) 
     oa.BaseUnit as BaseUnit,
cast('00000' as  abap.dec(15,3)) as GrossValue1,
cast('0000' as  abap.dec(15,3)) as  GrossValue,
       cast(oa.AmountInCompanyCodeCurrency as abap.curr(15,2) ) as NetAmount1,
      //cast(oa.AmountInTransactionCurrency as abap.curr(15,2) ) as NetAmount,
    cast(0.00 as  abap.dec(15,3)) as NetAmount,
    cast('0000' as  abap.curr(15,2)) as DiscountAmount,
 cast('0000' as  abap.curr(15,2)) as DiscountAmount1,
cast(oa.AmountInCompanyCodeCurrency as  abap.curr(15,2)) as DebitAmountinCompCurrency,
cast(oa.AmountInCompanyCodeCurrency as  abap.curr(15,2)) as   DebitAmountinCompCurrency1,
   oa.CompanyCodeCurrency  as CompanyCodeCurrency,
 cast (oa.AmountInTransactionCurrency as  abap.curr(15,2))   as DebitAmountinTransCurrency, 
 cast (oa.AmountInTransactionCurrency as  abap.curr(15,2)) 
   as  DebitAmountinTransCurrency1,
    oa.TransactionCurrency as DocumentCurrency,
        cast(
case
    when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' then 2.5
    when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' then 9
    when oa.TaxCode = 'NF' then 20
    when oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG' 
     or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
     then 0
    when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' then 2.5
    when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' or oa.TaxCode = 'A2' then 9
    when oa.TaxCode = 'NF' then 20
    when oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG' 
     or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
     then 0
    when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA' then 5
    when oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB' or oa.TaxCode = 'A1' then 18
    when oa.TaxCode = 'NC' then 40
    when oa.TaxCode = 'GA' or oa.TaxCode = 'GH' 
     or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
    then 0
    else 0
end as abap.dec(5,2) ) as TaxRate,
  cast(
    case
        when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 2.5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
        or oa.TaxCode = 'A2'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 9 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'NF'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 20 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
          or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )
    end
as abap.curr(15,2) )

as JOCGValue,
    cast(
    case
        when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 2.5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
        or oa.TaxCode = 'A2'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 9 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'NF'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 20 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
          or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )
    end
as abap.curr(15,2) )

as JOSGValue,
cast(
    case
        when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB'
        or oa.TaxCode = 'A1'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 18 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'NC'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 40 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GH' or oa.TaxCode = 'GA'
          or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )
    end
as abap.curr(15,2) )

as JOIGValue,
cast(
    round(
        case
            when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 2.5 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
            or oa.TaxCode = 'A2'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 9 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'NF'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 20 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
              or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
            then cast( 0 as abap.dec(15,4) )

            else cast( 0 as abap.dec(15,4) )
        end,
        4
    )
as abap.curr(15,2) )

as RoundJOCGValue,
cast(
    round(
        case
            when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 2.5 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
            or oa.TaxCode = 'A2'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 9 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'NF'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 20 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
              or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
            then cast( 0 as abap.dec(15,4) )

            else cast( 0 as abap.dec(15,4) )
        end,
        4
    )
as abap.curr(15,2) )

as RoundJOSGValue,
cast(
    round(
        case
            when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 5 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB'
            or oa.TaxCode = 'A1'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 18 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'NC'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 40 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GH' or oa.TaxCode = 'GA'
              or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
            then cast( 0 as abap.dec(15,4) )

            else cast( 0 as abap.dec(15,4) )
        end,
        4
    )
as abap.curr(15,2) )

as RoundJOIGValue,
     cast('' as abap.cuky( 5 )) as StatisticsCurrency,
     oa.YY1_HSN_Code_COB as ConsumptionTaxCtrlCode,
     ''as CustomerConditionGroup1,
    '' as CustomerConditionGroup2,
     '' as CustomerConditionGroup3,
     '' as CustomerConditionGroup4,
     '' as CustomerConditionGroup5,
     oa.Plant,
     t6.PlantName as PlantName,
     t3.Region as BillToPartyRegion,
     case
    when t3.Region = 'AN' then '35'
    when t3.Region = 'AP' then '28'
    when t3.Region = 'AR' then '12'
    when t3.Region = 'AS' then '18'
    when t3.Region = 'BR' then '10'
    when t3.Region = 'CG' then '22'
    when t3.Region = 'CH' then '04'
    when t3.Region = 'DH' then '25'
    when t3.Region = 'DL' then '07'
    when t3.Region = 'GA' then '30'
    when t3.Region = 'GJ' then '24'
    when t3.Region = 'HP' then '02'
    when t3.Region = 'HR' then '06'
    when t3.Region = 'JH' then '20'
    when t3.Region = 'JK' then '01'
    when t3.Region = 'KA' then '29'
    when t3.Region = 'KL' then '32'
    when t3.Region = 'LA' then '37'
    when t3.Region = 'MH' then '27'
    when t3.Region = 'ML' then '17'
    when t3.Region = 'MN' then '14'
    when t3.Region = 'MP' then '23'
    when t3.Region = 'MZ' then '15'
    when t3.Region = 'NL' then '13'
    when t3.Region = 'OD' then '21'
    when t3.Region = 'OT' then '97'
    when t3.Region = 'PB' then '03'
    when t3.Region = 'PY' then '34'
    when t3.Region = 'RJ' then '08'
    when t3.Region = 'SK' then '11'
    when t3.Region = 'TN' then '33'
    when t3.Region = 'TR' then '16'
    when t3.Region = 'TS' then '36'
    when t3.Region = 'UK' then '05'
    when t3.Region = 'UP' then '09'
    when t3.Region = 'WB' then '19'
end as statecode,
     cast('00000' as  abap.dec(15,3)) as Listprice,
// cast(cd.AmountInTransactionCurrency as  abap.dec(15,3)) as GrossValue_1,
cast(0.00 as  abap.dec(15,3)) as GrossValue_1,
case when oa.IsReversal <> '' or oa.IsReversed <> '' then 'Cancelled'
when clt.ClearingJournalEntry <> '' then 'Close'
//when JEI0.ClearingJournalEntry = '' then 'Open'
else 'Open' end as OverallBillingStatusDesc,
t3.CustomerAccountGroup,
'' as YY1_EMAIL_REFERENCE_SDH,
case when (oa.IsReversal = 'X' or oa.IsReversed = 'X') then oa.ReversalReferenceDocument else cast('' as abap.char(10)) end as OriginalreferenceNo,
case when (oa.IsReversal = 'X' or oa.IsReversed = 'X') then oa.PostingDate else cast('00000000' as abap.dats) end as ApInvoiceDate,
cd.NetDueDate as DueDate,
'' as BillDate,
oa.WBSElement as WBSElement,
oad.Reference1IDByBusinessPartner as PO_NO,
oad.Reference3IDByBusinessPartner  as PODAte,
concat(
  concat(
    concat(
      concat(coalesce(t3.StreetName,''), ', '),
      concat(coalesce(t3.CityName,''), ', ')
    ),
    concat(coalesce(t3.Region,''), ', ')
  ),
  concat(coalesce(t3.Country,''), concat(' - ', coalesce(t3.PostalCode,'')))
) as shipAdd,
concat(
  concat(
    concat(
      concat(coalesce(t3.StreetName,''), ', '),
      concat(coalesce(t3.CityName,''), ', ')
    ),
    concat(coalesce(t3.Region,''), ', ')
  ),
  concat(coalesce(t3.Country,''), concat(' - ', coalesce(t3.PostalCode,'')))
) as BillAdd,
oa.InvoiceReference,
cast('' as abap.char(4)) as SalesOrganization,
tet.AccountingDocumentTypeName,
oa.ReferenceDocument
}
where  
  oa.AccountingDocumentType = 'AB' and oa.TransactionTypeDetermination = ''
  and oa.Ledger = '0L'
group by oa.AccountingDocument,
oa.GrantID,
oa.Fund,
bu.PersonFullName,
oa.DocumentItemText,
cd.DocumentItemText,
    t2.BusinessPartnerFullName,
    oa.WBSElement,
    t3.CityName,
    t3.TaxNumber3,
    t3.Customer,
    t3.CustomerFullName,
    t3.Country,
    t3.StreetName,
    t3.Region,
    t3.PostalCode,
    oa.LedgerGLLineItem,
    oa.ProductGroup ,
    //t7.ProfitCenter,
    oa.CompanyCode,   
    oa.FiscalYear,
    oa.TaxCode,
    oa.PostingDate,
    oa.Quantity,
    oa.BaseUnit,
    oa.WBSElementInternalID,
   t3.Region,
    oa.AccountingDocCreatedByUser,
    clt.ClearingJournalEntry,
     oa.YY1_HSN_Code_COB,
    oa.FiscalPeriod,
    oa.FiscalYear,
      oa.GLAccount,
      oad.BusinessPlace,
      oad.Reference1IDByBusinessPartner,
oad.Reference3IDByBusinessPartner ,
    bplace.BusinessPlaceDescription,
     oa.Plant,
     oa.Product,
     oa.DocumentDate,
     oa.ProfitCenter,
     oa.AccountingDocumentType,
      t6.PlantName,
      oa.ReferenceDocument,
      oa.AmountInCompanyCodeCurrency,
      oa.CompanyCodeCurrency,
      oa.AmountInTransactionCurrency,
      cd.AmountInTransactionCurrency,
      oa.TransactionTypeDetermination,
      oa.TransactionCurrency,
        cd.AmountInCompanyCodeCurrency ,
        cd.AmountInTransactionCurrency,
        tet.AccountingDocumentTypeName,
        oa.AccountingDocumentType,
        t3.CustomerAccountGroup,
        oa.GLAccount,
        gt.GLAccountLongName,
        oa.InvoiceReference,
         t2.BusinessPartner,
         je.DocumentReferenceID ,
         oa.IsReversal,
         cd.NetDueDate,
         oa.ReversalReferenceDocument,
         oa.IsReversed,
         tet.AccountingDocumentTypeName,
         je.AccountingDocumentHeaderText,
         oa.AssignmentReference
       
union all //RV Reversal

select distinct from I_BillingDocument as t0
left outer join I_BillingDocumentItem as t1 on t0.BillingDocument=t1.BillingDocument
left outer join I_OperationalAcctgDocItem as oad on oad.BillingDocument = t0.BillingDocument
and oad.CompanyCode = t0.CompanyCode
and oad.FiscalYear = t0.FiscalYear
//and oad.BillingDocument = t0.BillingDocument
and oad.AccountingDocumentItem = '001'
left outer join I_JournalEntryItem as oa on oa.ReferenceDocument = t0.BillingDocument
and oa.TransactionTypeDetermination = ''
and oa.CompanyCode = t0.CompanyCode
and oa.FiscalYear = t0.FiscalYear
and oa.ReferenceDocumentItem = t1.BillingDocumentItem
//and oa.AccountingDocumentItem = '002'
//and oa.GLAccountType = 'P'
left outer join I_JournalEntry as je on oa.AccountingDocument = je.AccountingDocument and oa.FiscalYear = je.FiscalYear
and oa.CompanyCode = je.CompanyCode
left outer join I_BusinessPlace as bplace on bplace.CompanyCode = oa.CompanyCode
and bplace.BusinessPlace = oad.BusinessPlace
left outer join I_StorageLocation as sto on sto.StorageLocation = t1.StorageLocation
left outer join I_BillingDocumentTypeText as text on text.BillingDocumentType = t0.BillingDocumentType
and text.Language ='E'
left outer join I_BillingDocumentItemPrcgElmnt as cgst
    on cgst.BillingDocument = t1.BillingDocument
    and cgst.BillingDocumentItem = t1.BillingDocumentItem
    and cgst.ConditionType = 'JOCG'
 
left outer join I_BillingDocumentItemPrcgElmnt as sgst
    on sgst.BillingDocument = t1.BillingDocument
    and sgst.BillingDocumentItem = t1.BillingDocumentItem
    and sgst.ConditionType = 'JOSG'
 
left outer join I_BillingDocumentItemPrcgElmnt as igst
    on igst.BillingDocument = t1.BillingDocument
    and igst.BillingDocumentItem = t1.BillingDocumentItem
    and igst.ConditionType = 'JOIG'
 
//left outer join I_BillingDocumentItemPrcgElmnt as t4 on t1.BillingDocument = t4.BillingDocument 
//and t1.BillingDocumentItem=t4.BillingDocumentItem and ( t4.ConditionType = 'JOSG' or t4.ConditionType = 'JOCG'
//or t4.ConditionType = 'JOIG' )
left outer join I_BillingDocumentItemPrcgElmnt as Listprice on t1.BillingDocument=Listprice.BillingDocument
and t1.BillingDocumentItem=Listprice.BillingDocumentItem and (Listprice.ConditionType = 'ZFR1' or Listprice.ConditionType = 'ZP' or Listprice.ConditionType = 'ZPR3')
left outer join ZFINALCONDITIONVALUE_V1 as t8 on t1.BillingDocument = t8.BillingDocument
and t1.BillingDocumentItem=t8.BillingDocumentItem
left outer join ZNETVALUE as t11 on t11.AccountingDocument=t0.AccountingDocument and t11.CompanyCode=t0.CompanyCode 
and t11.FiscalYear = t0.FiscalYear
left outer join I_BusinessPartner as t2 on t0.PayerParty=t2.BusinessPartner
left outer join I_Customer as t3 on t0.PayerParty=t3.Customer
left outer join I_ProductPlantIntlTrd as t5 on t1.Product=t5.Product and t1.Plant=t5.Plant
left outer join I_CnsldtnPlantT as t6 on t1.Plant=t6.Plant
left outer join I_Product as t9 on t9.Product=t1.Product
left outer join I_ExtProdGrpText as t10 on t9.ExternalProductGroup=t10.ExternalProductGroup
left outer join I_ProductGroupText_2 as t12 on t12.ProductGroup=t9.ProductGroup
left outer join I_AdditionalCustomerGroup1Text as add1 on add1.AdditionalCustomerGroup1=t1.AdditionalCustomerGroup1 and add1.Language = 'E'
left outer join I_AdditionalCustomerGroup2Text as add2 on add2.AdditionalCustomerGroup2=t1.AdditionalCustomerGroup2 and add2.Language = 'E'
left outer join I_AdditionalCustomerGroup3Text as add3 on add3.AdditionalCustomerGroup3=t1.AdditionalCustomerGroup3 and add3.Language = 'E'
left outer join I_AdditionalCustomerGroup4Text as add4 on add4.AdditionalCustomerGroup4=t1.AdditionalCustomerGroup4 and add4.Language = 'E'
left outer join I_AdditionalCustomerGroup5Text as add5 on add5.AdditionalCustomerGroup5=t1.AdditionalCustomerGroup5 and add5.Language = 'E'
left outer join I_BillingDocumentItemPrcgElmnt as Disc on t1.BillingDocument=Disc.BillingDocument
and t1.BillingDocumentItem=Disc.BillingDocumentItem and (Disc.ConditionType = 'YK07' or Disc.ConditionType = 'ZK07' or Disc.ConditionType = 'ZK08'
or Disc.ConditionType = 'DPG2')
left outer join I_OverallBillingStatusText as obs on t0.OverallBillingStatus = obs.OverallBillingStatus and obs.Language = 'E'
left outer join I_SalesOrder as so on t1.SalesDocument = so.SalesOrder
left outer join I_GLAccountText as gt on gt.GLAccount = oa.GLAccount
and gt.Language = 'E'
left outer join ZCustomerDatas as cd on cd.AccountingDocument = oa.AccountingDocument
and cd.CompanyCode = oa.CompanyCode
and cd.FiscalYear = oa.FiscalYear
left outer join I_AccountingDocumentTypeText as adt on adt.AccountingDocumentType = oa.AccountingDocumentType
and adt.Language = 'E'
left outer join ZdocumentStatus as clt on clt.AccountingDocument = oa.AccountingDocument
and clt.CompanyCode = oa.CompanyCode
and clt.FiscalYear = oa.FiscalYear
left outer join I_BusinessUserBasic as bu on oa.AccountingDocCreatedByUser = bu.UserID 

{
    key t0.AccountingDocument,
     cast('' as abap.char(20)) as grantid,
 cast('' as abap.char( 10 )) as Fund,
   cast('' as abap.char( 16 )) as original_DocumentReferenceID,
 // bu.PersonFullName as createdby,
    case when oa.AccountingDocCreatedByUser = 'CC0000000002' then 'INTEGRATION' 
    when oa.AccountingDocCreatedByUser = 'INTEGRATION' then 'INTEGRATION'
    else bu.PersonFullName end as createdby,
   //case when cd.DocumentItemText = '' then oa.DocumentItemText else cd.DocumentItemText end as DocumentItemText,
   case 
    when ( oa.DocumentItemText <> '' and oa.DocumentItemText is not null ) 
        then oa.DocumentItemText 
    
    when ( cd.DocumentItemText <> '' and cd.DocumentItemText is not null ) 
        then cd.DocumentItemText
    
    else null 
end as DocumentItemText,
   // oa.WBSElement as wbs_element,
    oa.WBSElementInternalID as wbs_elementinternalid,
    t0.BillingDocument,
    t0.BillingDocumentType,
    oa.AccountingDocumentType,
    t0.DocumentReferenceID,
    t1.BillingDocumentItem,
    t0.PayerParty,
    t2.BusinessPartnerFullName,
    t3.CityName,
    t3.TaxNumber3,
    t0.BillingDocumentDate,
    //t7.ProfitCenter,
    t1.ProfitCenter,
     t1.AdditionalCustomerGroup1,
     add1.AdditionalCustomerGroup1Name,
     t1.AdditionalCustomerGroup2,
     add2.AdditionalCustomerGroup2Name,
     t1.AdditionalCustomerGroup3,
     add3.AdditionalCustomerGroup3Name,
     t1.AdditionalCustomerGroup4,
     add4.AdditionalCustomerGroup4Name,
     t1.AdditionalCustomerGroup5,
     add5.AdditionalCustomerGroup5Name,
     t1.SalesDocument,
          substring( t3.TaxNumber3, 3, 10 ) as pannumber,
     je.AccountingDocumentHeaderText,
     oa.AssignmentReference,
   case 
    when t3.TaxNumber3 <> '' then 'B2B'
    else 'B2C'
end as Gstr1_section,
    t0.CompanyCode,
     oad.BusinessPlace,   
    t0.FiscalYear,
    t1.TaxCode,
    case
when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' 
    or oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' 
    or oa.TaxCode = 'NF'
    or oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG'
     then  '0020900910'
     else '0000000000' end as JOCAccount,
 case
when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD' 
    or oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC' 
    or oa.TaxCode = 'NF'
    or oa.TaxCode = 'GD' or oa.TaxCode = 'GH' or oa.TaxCode = 'GG'
     then  '0020900920'
     else '0000000000' end  as JOSAccount,
         case
when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA' 
    or oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB' 
    or oa.TaxCode = 'NC' 
    or oa.TaxCode = 'GA' or oa.TaxCode = 'GH' 
     or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
    then '0020900900' else '0000000000' end  as  JOIAccount,
    //t0.CreationDate,
    oa.DocumentDate as CreationDate,
    case when oa.AccountingDocCreatedByUser = 'INTEGRATION' then 'CC0000000002' else oa.AccountingDocCreatedByUser end as AccountingDocCreatedByUser,
    oa.PostingDate,
    oa.FiscalPeriod,
    oa.GLAccount,
    gt.GLAccountLongName,
    t11.FiscalYear as AcctYear,
    t10.ExternalProductGroup,
    t10.ExternalProductGroupName,
    case when cgst.ConditionType  = 'JOCG' then 
     'JOC'
     else
    ''
end as CGSTTrasactionKey,
     case when sgst.ConditionType  = 'JOSG' then 
     'JOS'
     else
    ''
end as SGSTTrasactionKey,
     case when igst.ConditionType  = 'JOIG' then 
     'JOI'
     else
    ''
end as IGSTTrasactionKey,
    t1.ProductGroup,
    t12.ProductGroupName,
    t1.Product,
    t1.BillingDocumentItemText,
    // @Semantics.amount.currencyCode: 'TransactionCurrency'
    cast(oa.AmountInTransactionCurrency as abap.dec(15,2 )) as CreditRelatedPrice,
    t1.TransactionCurrency,
   
    t1.BillingQuantity,
    t1.BillingQuantityUnit,
     
     t1.BillingQuantityInBaseUnit,
     t1.BaseUnit,
      case 
  when t0.BillingDocumentType = 'CBRE' 
     //or t0.BillingDocumentType = 'S1' 
     or t0.BillingDocumentType = 'G2' 
     or t0.BillingDocumentType = 'IVS' 
  then -1 * (cast(t1.CreditRelatedPrice as abap.dec(15,3)) *  cast(t1.BillingQuantity as abap.dec(15,3)))
  else (cast(t1.CreditRelatedPrice as abap.dec(15,3)) *  cast(t1.BillingQuantity as abap.dec(15,3)))
    end as GrossValue1,
   // @Semantics.amount.currencyCode: 'TransactionCurrency'
    (cast(t1.CreditRelatedPrice as abap.dec(15,3)) *  cast(t1.BillingQuantity as abap.dec(15,3))) as  GrossValue,
    // @Semantics.amount.currencyCode: 'TransactionCurrency'
      case 
  when t0.BillingDocumentType = 'CBRE' 
     //or t0.BillingDocumentType = 'S1' 
     or t0.BillingDocumentType = 'G2' 
     or t0.BillingDocumentType = 'IVS' 
  then
     -t1.NetAmount
     else
     cast(oa.AmountInCompanyCodeCurrency as abap.curr(15,2) ) end as NetAmount1,
      //@Semantics.amount.currencyCode: 'TransactionCurrency'
      
      //t1.NetAmount,
      cast(0.00 as  abap.dec(15,3)) as NetAmount,
      
      //@Semantics.amount.currencyCode: 'TransactionCurrency'
     Disc.ConditionAmount as DiscountAmount,
      //@Semantics.amount.currencyCode: 'TransactionCurrency'
    case 
  when t0.BillingDocumentType = 'CBRE' 
     //or t0.BillingDocumentType = 'S1' 
     or t0.BillingDocumentType = 'G2' 
     or t0.BillingDocumentType = 'IVS' 
  then -1 *  Disc.ConditionAmount
  else Disc.ConditionAmount
end as DiscountAmount1,
   //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     cast( oa.AmountInCompanyCodeCurrency as abap.curr(15,2 ) ) as DebitAmountinCompCurrency,
      //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     case 
  when t0.BillingDocumentType = 'CBRE' 
     //or t0.BillingDocumentType = 'S1' 
     or t0.BillingDocumentType = 'G2' 
     or t0.BillingDocumentType = 'IVS' 
  then -1 * oa.AmountInCompanyCodeCurrency
  else oa.AmountInCompanyCodeCurrency
end as DebitAmountinCompCurrency1,
     t11.CompanyCodeCurrency,
        //@Semantics.amount.currencyCode: 'TransactionCurrency'
   cast( oa.AmountInTransactionCurrency as abap.curr(15,2 ) ) as DebitAmountinTransCurrency,
       //@Semantics.amount.currencyCode: 'TransactionCurrency'
    case 
  when t0.BillingDocumentType = 'CBRE' 
    // or t0.BillingDocumentType = 'S1' 
     or t0.BillingDocumentType = 'G2' 
     or t0.BillingDocumentType = 'IVS' 
  then -1 * oa.AmountInTransactionCurrency
  else oa.AmountInTransactionCurrency
end as DebitAmountinTransCurrency1,
    t11.TransactionCurrency as DocumentCurrency,
     case when ( t8.JOCGRate <> 0 and t8.JOSGRate <> 0) then 
     ( t8.JOCGRate + t8.JOSGRate )
     else
    t8.JOIGRate
    end as TaxRate,

//   case 
//  when t0.BillingDocumentType = 'CBRE' 
//     or t0.BillingDocumentType = 'S1' 
//     or t0.BillingDocumentType = 'G2' 
//     or t0.BillingDocumentType = 'IVS' 
//  then 1 * t8.JOCGValue
//  else t8.JOCGValue
//end as JOCGValue,
//
//case 
//  when t0.BillingDocumentType = 'CBRE' 
//     or t0.BillingDocumentType = 'S1' 
//     or t0.BillingDocumentType = 'G2' 
//     or t0.BillingDocumentType = 'IVS' 
//  then 1 * t8.JOSGValue
//  else t8.JOSGValue
//end as JOSGValue,
//
//
//case 
//  when t0.BillingDocumentType = 'CBRE' 
//     or t0.BillingDocumentType = 'S1' 
//     or t0.BillingDocumentType = 'G2' 
//     or t0.BillingDocumentType = 'IVS' 
//  then 1 * t8.JOIGValue
//  else t8.JOIGValue
//end as JOIGValue,

  cast(
    case
        when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 2.5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 9 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'NF'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 20 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
          or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )
    end
as abap.curr(15,2) )

as JOCGValue,
    cast(
    case
        when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 2.5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 9 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'NF'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 20 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
          or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )
    end
as abap.curr(15,2) )

as JOSGValue,
cast(
    case
        when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 5 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 18 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'NC'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 40 as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )
             
         when oa.TaxCode = 'FH'
        then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,2) )
             * cast( 18  as abap.dec(5,2) )
             / cast( 100 as abap.dec(5,2) )

        when oa.TaxCode = 'GH' or oa.TaxCode = 'GA'
          or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
        then cast( 0 as abap.dec(15,2) )

        else cast( 0 as abap.dec(15,2) )
    end
as abap.curr(15,2) )

as JOIGValue,

cast(
    round(
        case
            when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 2.5 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 9 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'NF'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 20 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
              or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
            then cast( 0 as abap.dec(15,4) )

            else cast( 0 as abap.dec(15,4) )
        end,
        4
    )
as abap.curr(15,2) )

as RoundJOCGValue,
cast(
    round(
        case
            when oa.TaxCode = 'GE' or oa.TaxCode = 'NE' or oa.TaxCode = 'FD'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 2.5 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GF' or oa.TaxCode = 'ND' or oa.TaxCode = 'FC'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 9 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'NF'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 20 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GG' or oa.TaxCode = 'GH' or oa.TaxCode = 'GD'
              or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
            then cast( 0 as abap.dec(7,4) )

            else cast( 0 as abap.dec(15,4) )
        end,
        4
    )
as abap.curr(15,2) )

as RoundJOSGValue,
cast(
    round(
        case
            when oa.TaxCode = 'GB' or oa.TaxCode = 'NB' or oa.TaxCode = 'FA'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 5 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GC' or oa.TaxCode = 'NA' or oa.TaxCode = 'FB'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 18 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'NC'
            then cast( oa.AmountInCompanyCodeCurrency as abap.dec(15,4) )
                 * cast( 40 as abap.dec(7,4) )
                 / cast( 100 as abap.dec(7,4) )

            when oa.TaxCode = 'GH' or oa.TaxCode = 'GA'
              or oa.TaxCode = 'FE' or oa.TaxCode = 'FF' or oa.TaxCode = 'FG'
            then cast( 0 as abap.dec(7,4) )

            else cast( 0 as abap.dec(15,4) )
        end,
        4
    )
as abap.curr(15,2) )

as RoundJOIGValue,
     t0.StatisticsCurrency,
     t5.ConsumptionTaxCtrlCode,
     t1.CustomerConditionGroup1,
     t1.CustomerConditionGroup2,
     t1.CustomerConditionGroup3,
     t1.CustomerConditionGroup4,
     t1.CustomerConditionGroup5,
     t1.Plant,
     t6.PlantName,
     t3.Region as BillToPartyRegion,
     case
    when t3.Region = 'AN' then '35'
    when t3.Region = 'AP' then '28'
    when t3.Region = 'AR' then '12'
    when t3.Region = 'AS' then '18'
    when t3.Region = 'BR' then '10'
    when t3.Region = 'CG' then '22'
    when t3.Region = 'CH' then '04'
    when t3.Region = 'DH' then '25'
    when t3.Region = 'DL' then '07'
    when t3.Region = 'GA' then '30'
    when t3.Region = 'GJ' then '24'
    when t3.Region = 'HP' then '02'
    when t3.Region = 'HR' then '06'
    when t3.Region = 'JH' then '20'
    when t3.Region = 'JK' then '01'
    when t3.Region = 'KA' then '29'
    when t3.Region = 'KL' then '32'
    when t3.Region = 'LA' then '37'
    when t3.Region = 'MH' then '27'
    when t3.Region = 'ML' then '17'
    when t3.Region = 'MN' then '14'
    when t3.Region = 'MP' then '23'
    when t3.Region = 'MZ' then '15'
    when t3.Region = 'NL' then '13'
    when t3.Region = 'OD' then '21'
    when t3.Region = 'OT' then '97'
    when t3.Region = 'PB' then '03'
    when t3.Region = 'PY' then '34'
    when t3.Region = 'RJ' then '08'
    when t3.Region = 'SK' then '11'
    when t3.Region = 'TN' then '33'
    when t3.Region = 'TR' then '16'
    when t3.Region = 'TS' then '36'
    when t3.Region = 'UK' then '05'
    when t3.Region = 'UP' then '09'
    when t3.Region = 'WB' then '19'
end as statecode,
     // @Semantics.amount.currencyCode: 'TransactionCurrency'
     Listprice.ConditionRateValue as Listprice,
  
//     case 
//  when t0.BillingDocumentType = 'CBRE' 
//     //or t0.BillingDocumentType = 'S1' 
//     or t0.BillingDocumentType = 'G2' 
//     or t0.BillingDocumentType = 'IVS' 
//  then -1 * ((get_numeric_value(Listprice.ConditionRateValue)) * (t1.BillingQuantity))
//  else ((get_numeric_value(Listprice.ConditionRateValue)) * (t1.BillingQuantity))
//end as GrossValue_1,

cast(0.00 as  abap.dec(15,3)) as GrossValue_1,
//obs.OverallBillingStatusDesc,
//case when t0.BillingDocumentType = 'S1' then 'Canceled' else obs.OverallBillingStatusDesc end as OverallBillingStatusDesc,
case when oa.IsReversal <> '' or oa.IsReversed <> '' then 'Cancelled'
when clt.ClearingJournalEntry <> '' then 'Close'
//when JEI0.ClearingJournalEntry = '' then 'Open'
else 'Open' end as OverallBillingStatusDesc,
t3.CustomerAccountGroup,
so.YY1_EMAIL_REFERENCE_SDH,
case when (oa.IsReversal = 'X' or oa.IsReversed = 'X') then oa.ReversalReferenceDocument else cast('' as abap.char(10)) end as OriginalreferenceNo,
case when (oa.IsReversal = 'X' or oa.IsReversed = 'X') then oa.PostingDate else cast('00000000' as abap.dats) end as ApInvoiceDate,
cd.NetDueDate as DueDate,
t1.BillingDocumentDate as BillDate,
//cast('' as abap.numc( 8 )) as WBSElement,
oa.WBSElement as WBSElement,
so.PurchaseOrderByCustomer as PO_NO,
so.CustomerPurchaseOrderDate as PODAte,
concat(
  concat(
    concat(
      concat(coalesce(t3.StreetName,''), ', '),
      concat(coalesce(t3.CityName,''), ', ')
    ),
    concat(coalesce(t3.Region,''), ', ')
  ),
  concat(coalesce(t3.Country,''), concat(' - ', coalesce(t3.PostalCode,'')))
) as shipAdd,
concat(
  concat(
    concat(
      concat(coalesce(t3.StreetName,''), ', '),
      concat(coalesce(t3.CityName,''), ', ')
    ),
    concat(coalesce(t3.Region,''), ', ')
  ),
  concat(coalesce(t3.Country,''), concat(' - ', coalesce(t3.PostalCode,'')))
) as BillAdd,
oa.InvoiceReference,
so.SalesOrganization,
adt.AccountingDocumentTypeName,
oa.ReferenceDocument
  //((get_numeric_value(Listprice.ConditionRateValue)) * (t1.BillingQuantity)) as GrossValue_1
}
where oa.AccountingDocumentType = 'AB' and oa.TransactionTypeDetermination = '' 
and oa.Ledger = '0L'
group by t0.AccountingDocument,
bu.PersonFullName,
oa.WBSElementInternalID,
oa.DocumentItemText,
cd.DocumentItemText,
    t0.BillingDocument,
    t1.CustomsPreference,
    t0.DocumentReferenceID,
    t1.BillingDocumentItem,
    t0.PayerParty,
    t2.BusinessPartnerFullName,
    t3.CityName,
    t3.TaxNumber3,
    t0.BillingDocumentDate,
    t1.ProfitCenter,
    cd.NetDueDate,
    oa.ReversalReferenceDocument,
    oa.IsReversed,
    //t7.ProfitCenter,
    t0.CompanyCode,   
    t0.FiscalYear,
    t1.TaxCode,
    so.SalesOrganization,
     oad.BusinessPlace,
//    t7.JOSAccount,
//    t7.JOCAccount,
//    t7.JOIAccount,
    t0.BillingDocumentType,
    //t0.CreationDate,
    oa.DocumentDate,
    oa.PostingDate,
    oa.FiscalPeriod,
    t11.FiscalYear,
    t10.ExternalProductGroup,
    t10.ExternalProductGroupName,
    t1.ProductGroup,
     t12.ProductGroupName,
    t1.Product,
    t1.BillingDocumentItemText,
    t1.CreditRelatedPrice,
    t1.TransactionCurrency,
    t1.BillingQuantity,
    t1.BillingQuantityUnit,
     t1.BillingQuantityInBaseUnit,
     t1.BaseUnit,
     t1.NetAmount,
     oa.AmountInCompanyCodeCurrency,
     oa.AmountInTransactionCurrency,
     t11.CompanyCodeCurrency,
    t11.TransactionCurrency,
    oa.IsReversal ,
    Listprice.ConditionRateValue,
     t0.StatisticsCurrency,
     t1.Plant,
     t5.ConsumptionTaxCtrlCode,
     t6.PlantName,
     t1.Region,
     obs.OverallBillingStatusDesc,
     t3.CustomerAccountGroup,
     so.YY1_EMAIL_REFERENCE_SDH,
     t1.ReferenceSDDocument,
     t1.BillingDocumentDate,
     oa.WBSElement,
     so.PurchaseOrderByCustomer,
     so.CustomerPurchaseOrderDate,
     t3.CityName,
     t3.Country,
     t3.Region,
     t3.StreetName,
     oa.AccountingDocCreatedByUser,
     t3.PostalCode,
     t1.CustomerConditionGroup1,
     t1.CustomerConditionGroup2,
     t1.CustomerConditionGroup3,
     t1.CustomerConditionGroup4,
     t1.CustomerConditionGroup5,
     t3.Region,t8.JOCGRate,t8.JOSGRate,t8.JOIGRate,t8.JOCGValue,t8.JOSGValue,t8.JOIGValue,oa.AccountingDocumentType,
     t1.AdditionalCustomerGroup1,
     add1.AdditionalCustomerGroup1Name,
     t1.AdditionalCustomerGroup2,
     add2.AdditionalCustomerGroup2Name,
     t1.AdditionalCustomerGroup3,
     add3.AdditionalCustomerGroup3Name,
     t1.AdditionalCustomerGroup4,
     add4.AdditionalCustomerGroup4Name,
     t1.AdditionalCustomerGroup5,
     oa.GLAccount,
     gt.GLAccountLongName,
     oa.InvoiceReference,
     oa.TaxCode,
     cgst.ConditionType ,
     sgst.ConditionType ,
     igst.ConditionType ,
     oa.ReferenceDocument,
     oa.AmountInCompanyCodeCurrency,
     je.AccountingDocumentHeaderText,
     oa.AssignmentReference,
     clt.ClearingJournalEntry,
     adt.AccountingDocumentTypeName,adt.AccountingDocumentTypeName,cd.AmountInTransactionCurrency,
     add5.AdditionalCustomerGroup5Name,t1.SalesDocument,t0.BillingDocumentDate,t1.TaxAmount,Listprice.ConditionRateValue,Disc.ConditionAmount

