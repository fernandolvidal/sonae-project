/*VALIDAÇÕES TABELA DIM_CUSTOMER*/

/*Número de cartões por cliente */

SELECT 
    CUSTOMER_ACCOUNT_MASK, COUNT(CUSTOMER_CARD_KEY_MASK) NUM_CAR
FROM
    cartaocontinente.dim_customer T1
    GROUP BY  CUSTOMER_ACCOUNT_MASK
    ORDER BY COUNT(CUSTOMER_CARD_KEY_MASK) DESC;
	

/*Número de clientes por género*/
/*NOTAS: 791 CLIENTES COM A COLUNA GENDER_F E GENDER_M A NULL*/

SELECT 
    COUNT(t1.CUSTOMER_ACCOUNT_MASK) num_clientes,
    CASE
        WHEN t1.GENDER_F = 0 AND t1.GENDER_M = 0 THEN 1
        WHEN t1.GENDER_F = 1 AND t1.GENDER_M = 0 THEN 2
        WHEN t1.GENDER_F = 0 AND t1.GENDER_M = 1 THEN 3
        WHEN t1.GENDER_F = 1 AND t1.GENDER_M = 1 THEN 4
        WHEN
            t1.GENDER_F IS NULL
                AND t1.GENDER_M IS NULL
        THEN
            5
    END type_gender
FROM
    cartaocontinente.dim_customer t1
GROUP BY CASE
    WHEN t1.GENDER_F = 0 AND t1.GENDER_M = 0 THEN 1
    WHEN t1.GENDER_F = 1 AND t1.GENDER_M = 0 THEN 2
    WHEN t1.GENDER_F = 0 AND t1.GENDER_M = 1 THEN 3
    WHEN t1.GENDER_F = 1 AND t1.GENDER_M = 1 THEN 4
    WHEN
        t1.GENDER_F IS NULL
            AND t1.GENDER_M IS NULL
    THEN
        5
END;


/*Numero de clientes com age a null*/
/*NOTAS: 5696 CLIENTES COM AGE NULL*/
 SELECT 
    'NUM_CUSTOMENS' AS LABEL,
    COUNT(T1.CUSTOMER_ACCOUNT_MASK) NUM
FROM
    cartaocontinente.dim_customer T1 
 UNION ALL SELECT 
    'NUM_CUSTOMENS_AGE_NULL',
    COUNT(T1.CUSTOMER_ACCOUNT_MASK)  
FROM
    cartaocontinente.dim_customer T1
WHERE
    T1.AGE IS NULL ;
	

/*Número de clientes por Distrito*/
/*NOTAS: 7281 CUSTOMERS COM DISTRICT A NULL */

SELECT 
    T1.DISTRICT, COUNT(T1.CUSTOMER_ACCOUNT_MASK) NUM_CUSTOMERS
FROM
    cartaocontinente.dim_customer T1
GROUP BY T1.DISTRICT
ORDER BY T1.DISTRICT


/*Número de clientes por segmento baby e junior*/
/*NOTAS: 45164 customens com segmento baby & junior null*/

 SELECT 
    COUNT(T1.CUSTOMER_ACCOUNT_MASK) NUM_CUSTOMERS,
    T2.segm_baby_dsc,
    T3.segm_junior_dsc
FROM
    cartaocontinente.dim_customer T1
        LEFT JOIN
    cartaocontinente.dim_segment_baby T2 ON T1.SEGM_BABY_CD = T2.SEGM_BABY_CD
        LEFT JOIN
    cartaocontinente.dim_segment_junior T3 ON T1.SEGM_JUNIOR_CD = T3.SEGM_JUNIOR_CD
GROUP BY T2.segm_baby_dsc , T3.segm_junior_dsc;


/*Volume de clientes por Segmento Lifestage */
/*NOTA: 29127 CLIENTES COM LIFSTAGE A NULL*/

SELECT 
    COUNT(t1.CUSTOMER_ACCOUNT_MASK) num_customers,
    t2.segm_lifestage_dsc
FROM
    cartaocontinente.dim_customer t1
        LEFT JOIN
    cartaocontinente.dim_segment_lifestage t2 ON t1.SEG_LIFESTAGE_KEY = t2.segm_lifestage_cd
GROUP BY t2.segm_lifestage_dsc;
