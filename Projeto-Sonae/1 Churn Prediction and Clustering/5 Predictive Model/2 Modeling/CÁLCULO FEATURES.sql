
SELECT 
    aa.CUSTOMER_ACCOUNT_MASK,
    CASE
        WHEN GENDER_M = 0 AND GENDER_F = 0 THEN 1
        WHEN GENDER_M = 1 AND GENDER_F = 0 THEN 2
        WHEN GENDER_M = 0 AND GENDER_F = 1 THEN 3
        WHEN GENDER_M = 1 AND GENDER_F = 1 THEN 4
        WHEN GENDER_M = 9 AND GENDER_F = 9 THEN 9
    END GENDER,
    SEGM_BABY_CD,
    SEGM_JUNIOR_CD,
    SEG_LIFESTAGE_KEY,
    AGE,
    CUSTOMER_REGION,
    a.VM,
    c.N_TRANSACOES,
    IF(e.dif < 150, 'No', 'Yes') churn
FROM
    (SELECT DISTINCT
        CUSTOMER_ACCOUNT_MASK,
            GENDER_F,
            GENDER_M,
            SEGM_BABY_CD,
            SEGM_JUNIOR_CD,
            SEG_LIFESTAGE_KEY,
            AGE,
            CUSTOMER_REGION
    FROM
        dim_data) aa
        LEFT JOIN
    (SELECT 
        CUSTOMER_ACCOUNT_MASK, ROUND(AVG(Payment_value), 2) VM
    FROM
        dim_data
    WHERE
        Quarter_transaction IN (1 , 2)
            AND year_transaction = 2017
    GROUP BY Customer_account_mask) a ON aa.CUSTOMER_ACCOUNT_MASK = a.CUSTOMER_ACCOUNT_MASK
        LEFT JOIN
    (SELECT 
        aa.CUSTOMER_ACCOUNT_MASK, AVG(aa.dif) _MID
    FROM
        (SELECT 
        t1.CUSTOMER_ACCOUNT_MASK,
            t1.TRANSACTION_TIME_KEY Date1,
            MAX(t2.TRANSACTION_TIME_KEY) Date2,
            DATEDIFF(DATE_FORMAT(t1.TRANSACTION_TIME_KEY, '%Y-%m-%d'), DATE_FORMAT(MAX(t2.TRANSACTION_TIME_KEY), '%Y-%m-%d')) dif
    FROM
        dim_data t1
    LEFT JOIN dim_data t2 ON t1.CUSTOMER_ACCOUNT_MASK = t2.CUSTOMER_ACCOUNT_MASK
        AND t1.TRANSACTION_TIME_KEY > t2.TRANSACTION_TIME_KEY
    WHERE
        t1.QUARTER_TRANSACTION IN (1 , 2)
            AND t1.YEAR_TRANSACTION = 2017
    GROUP BY t1.CUSTOMER_ACCOUNT_MASK , t1.TRANSACTION_TIME_KEY) aa
    GROUP BY aa.CUSTOMER_ACCOUNT_MASK) b ON aa.CUSTOMER_ACCOUNT_MASK = b.CUSTOMER_ACCOUNT_MASK
        LEFT JOIN
    (SELECT 
        CUSTOMER_ACCOUNT_MASK,
            COUNT(TRANSACTION_ID_MASK) N_TRANSACOES
    FROM
        dim_data
    WHERE
        Quarter_transaction IN (1 , 2)
            AND year_transaction = 2017
    GROUP BY CUSTOMER_ACCOUNT_MASK) c ON aa.CUSTOMER_ACCOUNT_MASK = c.CUSTOMER_ACCOUNT_MASK
        LEFT JOIN
    (SELECT 
        CUSTOMER_ACCOUNT_MASK,
            DATEDIFF(DATE_FORMAT(20170630, '%Y-%m-%d'), DATE_FORMAT(MAX(TRANSACTION_TIME_KEY), '%Y-%m-%d')) dif
    FROM
        dim_data
    WHERE
        Quarter_transaction IN (1 , 2)
            AND year_transaction = 2017
    GROUP BY CUSTOMER_ACCOUNT_MASK) e ON aa.CUSTOMER_ACCOUNT_MASK = e.CUSTOMER_ACCOUNT_MASK
ORDER BY CUSTOMER_ACCOUNT_MASK
LIMIT 10;

SELECT 
    A.CUSTOMER_ACCOUNT_MASK,
    COUNT(A.TRANSACTION_ID_MASK) / 180 FREQ
FROM
    dim_data A
WHERE
    Quarter_transaction IN (1 , 2)
        AND year_transaction = 2017
GROUP BY A.CUSTOMER_ACCOUNT_MASK;
    
