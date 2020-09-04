SELECT
t3.HIERARCHY_CD,
t3.HIERARCHY_DSC,
t3.HIERARCHY_SUB_LEVEL_CD,
t3.hierarchy_sub_level_dsc,
t3.hierarchy_parent_cd,
t3.HIERARCHY_PARENT_DSC
FROM
cartaocontinente.dim_hierarchy_agreg t3;
/*Colunas a retirar:
hierarchy_family
hierarchy_sub_level_FAMILY
HIERARCHY_PARENT_FAMILY */