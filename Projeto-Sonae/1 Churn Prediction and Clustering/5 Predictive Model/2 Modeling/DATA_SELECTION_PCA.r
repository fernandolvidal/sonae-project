#ver correlaçoes dos dados multivariados

FAMD (dim_treino_01_06_2017, ncp = 5, sup.var = NULL, ind.sup = NULL, graph = TRUE)

*The results are available in the following objects:

  name          description                             
1 "$eig"        "eigenvalues and inertia"               
2 "$var"        "Results for the variables"             
3 "$ind"        "results for the individuals"           
4 "$quali.var"  "Results for the qualitative variables" 
5 "$quanti.var" "Results for the quantitative variables"

res.famd <- FAMD(dim_treino_01_06_2017, graph = FALSE)
print(res.famd)

*The results are available in the following objects:

  name          description                             
1 "$eig"        "eigenvalues and inertia"               
2 "$var"        "Results for the variables"             
3 "$ind"        "results for the individuals"           
4 "$quali.var"  "Results for the qualitative variables" 
5 "$quanti.var" "Results for the quantitative variables"

eig.val <- get_eigenvalue(res.famd)
> head(eig.val)
      eigenvalue variance.percent cumulative.variance.percent
Dim.1   2.581370         8.901275                    8.901275
Dim.2   2.243821         7.737315                   16.638590
Dim.3   1.532563         5.284698                   21.923288
Dim.4   1.429923         4.930768                   26.854056
Dim.5   1.371091         4.727899                   31.581955

fviz_screeplot(res.famd)


fviz_famd_var(res.famd, repel = TRUE

fviz_famd_var(res.famd, repel = TRUE)

fviz_contrib(res.famd, "var", axes = 2)
#The red dashed line on the graph above indicates the expected average value, If the contributions were uniform.
quanti.var <- get_famd_var(res.famd, "quanti.var")
fviz_famd_var(res.famd, "quanti.var", col.var = "contrib", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE)

fviz_famd_var(res.famd, "quanti.var",col.var = "contrib",gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel = TRUE)

quali.var <- get_famd_var(res.famd, "quali.var")
fviz_famd_var(res.famd, "quali.var", col.var = "contrib",gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"))

fviz_famd_var(res.famd, "quali.var", col.var = "contrib", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE)


#####clustofvar

names(dim_treino_01_06_2017)
 [1] "CLIENTE"           "MID"               "MID_UM"           
 [4] "FREQ_M"            "FREQ_MUM"          "VM"               
 [7] "VMUM"              "AGE"               "REGION"           
[10] "genero"            "SEGM_BABY_CD"      "SEGM_JUNIOR_CD"   
[13] "SEG_LIFESTAGE_KEY" "CHURN"   

xqual <- dim_treino_01_06_2017[,c(9,10,11,12,13,14)]
xquant <- dim_treino_01_06_2017[,c(2,3,4,5,6,7,8)]
tree <- hclustvar(xquant, xqual)
plot(tree)


#para aumentar o height
dend <- as.dendrogram(tree)
plot(raise.dendrogram(dend , 8), main = "Dendrogram")







