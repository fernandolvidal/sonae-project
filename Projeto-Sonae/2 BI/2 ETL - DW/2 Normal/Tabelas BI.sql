
/*DIM_TIME_DW*/

SELECT
  TIME_KEY
, YEAR
, QUARTER
, MONTH
, DAY
, FULLDATE
, WEEK
, DAYOFWEEK
, HOM_KEY
, HOM_WEEKDAY_KEY
, LAST_MONTH_DAY_IND
, SEQ
, TIME_LEVEL
, FISCAL_YEAR
, FISCAL_MONTH
, ISLAMIC_YEAR
, ISLAMIC_MONTH
, ISLAMIC_DAY
FROM dim_time;


/*DIM_CUSTOMER_DW*/

SELECT 
    t1.CUSTOMER_ACCOUNT_MASK,
    t1.CUSTOMER_CARD_KEY_MASK,
    t1.DISTRICT CUSTOMER_DISTRICT,
    t1.REGION CUSTOMER_REGION,
    t1.GENDER_F,
    t1.GENDER_M,
    CASE
        WHEN t1.AGE < 18 OR t1.AGE > 100 THEN 50
        ELSE t1.AGE
    END AGE,
    t2.segm_baby_dsc SEGM_BABY_DSC,
    t3.segm_junior_dsc SEGM_JUNIOR_DSC,
    t4.segm_lifestage_dsc SEGM_LIFESTAGE_DSC
FROM
    dim_customer t1
        LEFT JOIN
    dim_segment_baby t2 ON t1.SEGM_BABY_CD = t2.SEGM_BABY_CD
        LEFT JOIN
    dim_segment_junior t3 ON t1.SEGM_JUNIOR_CD = t3.SEGM_JUNIOR_CD
        LEFT JOIN
    dim_segment_lifestage t4 ON t1.SEG_LIFESTAGE_KEY = t4.segm_lifestage_cd;
	

/*DIM_MERCH_DW*/	

SELECT 
    t3.MERCH_KEY,
    t3.MERCH_CD,
    t3.MERCH_DSC,
    t3.CITY MERCH_CITY,
    t3.COUNTRY MERCH_COUNTRY,
    t4.FLAG_ONLINE MERCH_FLAG_ONLINE,
    t4.HIERARCHY_CD,
    t4.PAYMENT_SERVICE,
    t5.HIERARCHY_DSC,
    t5.HIERARCHY_SUB_LEVEL_CD,
    t5.hierarchy_sub_level_dsc HIERARCHY_SUB_LEVEL_DSC,
    t5.hierarchy_parent_cd HIERARCHY_PARENT_CD,
    t5.HIERARCHY_PARENT_DSC,
    t5.ECOSSISTEMA_CC,
    CASE
        WHEN
            (t3.POST_CODE LIKE '00%'
                AND t3.COUNTRY = 'PRT')
        THEN
            RIGHT(t3.POST_CODE,
                LENGTH(t3.POST_CODE) - 2)
        WHEN
            (t3.POST_CODE LIKE '%% %%'
                AND t3.COUNTRY = 'PRT')
        THEN
            REPLACE(t3.POST_CODE, ' ', '')
        WHEN
            (t3.POST_CODE LIKE '%%-%%'
                AND t3.COUNTRY = 'PRT')
        THEN
            REPLACE(t3.POST_CODE, '-', '')
        ELSE t3.POST_CODE
    END POST_CODE
FROM
    dim_merchant t3
        LEFT JOIN
    dim_merchant_hierarchy t4 ON t3.MERCH_KEY = t4.MERCH_KEY
        LEFT JOIN
    dim_hierarchy_agreg t5 ON t4.hierarchy_cd = t5.HIERARCHY_CD;

	
/*DIM_GEO_TRANSAC_DW*/

SELECT 
    t1.TRANSACTION_TIME_KEY,
    t1.TRANSACTION_ID_MASK,
    t2.CUSTOMER_ACCOUNT_MASK,
    t2.DISTRICT CUSTOMER_DISTRICT,
    'PRT' CUSTOMER_COUNTRY,
    t3.COUNTRY MERCH_COUNTRY,
    t1.MERCH_KEY,
    CASE
        WHEN
            (t3.POST_CODE LIKE '00%'
                AND t3.COUNTRY = 'PRT')
        THEN
            RIGHT(t3.POST_CODE,
                LENGTH(t3.POST_CODE) - 2)
        WHEN
            (t3.POST_CODE LIKE '%% %%'
                AND t3.COUNTRY = 'PRT')
        THEN
            REPLACE(t3.POST_CODE, ' ', '')
        WHEN
            (t3.POST_CODE LIKE '%%-%%'
                AND t3.COUNTRY = 'PRT')
        THEN
            REPLACE(t3.POST_CODE, '-', '')
        ELSE t3.POST_CODE
    END MERCH_ZIP_CODE
FROM
    dim_transactions t1
        LEFT JOIN
    dim_merchant t3 ON t1.MERCH_KEY = t3.MERCH_KEY
        LEFT JOIN
    dim_customer t2 ON t1.CUSTOMER_CARD_KEY_MASK = t2.CUSTOMER_CARD_KEY_MASK;
	

