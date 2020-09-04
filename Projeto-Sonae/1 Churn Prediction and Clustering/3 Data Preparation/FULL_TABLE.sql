CREATE TABLE dim_total
SELECT  t1.TRANSACTION_ID_MASK,
    t1.TRANSACTION_TIME_KEY,
    t1.TRANSACTION_HOUR_KEY,
    t6.DAY,
    t6.DAYOFWEEK,
    t6.FISCAL_MONTH,
    t6.FISCAL_YEAR,
    t6.FULLDATE,
    t6.LAST_MONTH_DAY_IND,
    t6.MONTH,
    t6.QUARTER,
    t6.SEQ,
    t6.WEEK,
    t6.YEAR,	
	t2.CUSTOMER_ACCOUNT_MASK,
    t1.CUSTOMER_CARD_KEY_MASK,
    t2.GENDER_M,
    t2.GENDER_F,
    t2.SEGM_BABY_CD,
    t3.segm_baby_dsc SEGM_BABY_DSC,
    t2.SEGM_JUNIOR_CD,
    t2.SEG_LIFESTAGE_KEY,
    t5.segm_lifestage_dsc SEGM_LIFESTAGE_DSC,
    t2.AGE,
    t2.DISTRICT CUSTOMER_DISTRICT,
    t2.REGION CUSTOMER_REGION,
    t1.MERCH_KEY,
    t7.MERCH_CD,
    t7.MERCH_DSC,
    t7.ADDRESS MERCH_ADDRESS,
    t7.CITY MERCH_CITY,
    t7.COUNTRY MERCH_COUNTRY,
    t7.CREATE_DATE MERCH_CREATE_DATE,
    t7.KEY_END_DATE MERCH_KEY_END_DATE,
    t7.KEY_START_DATE MERCH_KEY_START_DATE,
    t7.LAST_UPDT_DATE MERCH_LAST_UPDT_DATE,
    t7.POST_CODE MERCH_POST_CODE,
    t8.hierarchy_cd HIERARCHY_CD,
    t8.hierarchy_dsc HIERARCHY_DSC,
    t8.FLAG_ONLINE MERCH_HIER_FLAG_ONLINE,
    t8.PAYMENT_SERVICE HIERARCHY_PAYMENT_SERVICE,
    t9.hierarchy_family HIERARCHY_FAMILY,
    t9.ECOSSISTEMA_CC HIERARCHY_AGREG_ECOSSISTEMA_CC,
    t9.hierarchy_parent_cd HIERARCHY_PARENT_CD,
    t9.HIERARCHY_PARENT_DSC,
    t9.HIERARCHY_PARENT_FAMILY,
    t9.HIERARCHY_SUB_LEVEL_CD,
    t9.hierarchy_sub_level_dsc HIERARCHY_SUB_LEVEL_DSC,
    t9.hierarchy_sub_level_FAMILY HIERARCHY_SUB_LEVEL_FAMILY,
    t9.PARTNER_BRAND HIERARCHY_AGREG_PARTNER_BRAND,
    t1.GROSS_SLS_AMT,
    t1.NET_SLS_AMT,
    t1.VAT_AMOUNT,
    t1.VAT_RATE,
    t1.PAYMENT_ID,
    t1.PAYMENT_VALUE
FROM
    dim_transactions t1
        LEFT JOIN
    dim_customer t2 ON t1.CUSTOMER_CARD_KEY_MASK = t2.CUSTOMER_CARD_KEY_MASK
        LEFT JOIN
    dim_segment_baby t3 ON t2.SEGM_BABY_CD = t3.SEGM_BABY_CD
        LEFT JOIN
    dim_segment_junior t4 ON t2.SEGM_JUNIOR_CD = t4.SEGM_JUNIOR_CD
        LEFT JOIN
    dim_segment_lifestage t5 ON t2.SEG_LIFESTAGE_KEY = t5.SEGM_LIFESTAGE_CD
        LEFT JOIN
    dim_time t6 ON t1.transaction_time_key = t6.time_key
        LEFT JOIN
    dim_merchant t7 ON t1.MERCH_KEY = t7.MERCH_KEY
        LEFT JOIN
    dim_merchant_hierarchy t8 ON t7.MERCH_KEY = t8.MERCH_KEY
        LEFT JOIN
    dim_hierarchy_agreg t9 ON t8.hierarchy_cd = t9.hierarchy_cd