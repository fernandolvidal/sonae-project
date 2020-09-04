SELECT
T1.MERCH_KEY, T1.FLAG_ONLINE, T1.hierarchy_cd
FROM
cartaocontinente.dim_merchant_hierarchy T1;
/* Retiramos as colunas:
t1.merch_cd
t1.merch_dsc
t1.payment_service
t1.hierarchy_dsc */