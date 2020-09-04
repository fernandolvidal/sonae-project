#ARVORES

# NOTA # TENHO DE DEFINIR method = "class" MAS NA PARTE DE PREDICT TENHO DE ESCOLHER O type = "prob"
#AS PROBABILIDADES SAO DADAS EM MATRIZ, PARA FAZER AS CURVAS ROC TENHO DE TRANSFORMAR EM VETOR, TRANFORMO EM DATA.FRAME E DEPOIS SELECIONO APENAS 1 COLUNA.


arvore_decisao <- rpart(CHURN ~ FREQ_M + FREQ_MUM + VM + VMUM + MID + MID_UM + genero + SEGM_BABY_CD + SEGM_JUNIOR_CD + SEG_LIFESTAGE_KEY + REGION + AGE, data = dim_treino, parms = list(prior = c(0.01543739, 0.98456261)))


rpart.plot(arvore_decisao)

previsao_arvore <- predict(arvore_decisao, DIM_TESTE, type = "prob", parms = list(prior = c(0.002005348, 0.997994652)))

previsao_tttt <- predict(arvore_decisao, DIM_TESTE, type = "prob")

#> previsao <- predict(arvore_decisao, DIM_TESTE)
#Error: variable 'MID' was fitted with type "other" but type "numeric" was supplied
#CORRIJO O ERRO AO COLOCAR as.vector.
(...) + as.vector(MID) (...)

tabela_previsao <- table(DIM_TESTE$CHURN, previsao)
tabela_previsao
   previsao
       NAO  SIM
  NAO 1393  100
  SIM    1    2

teste_accuracy <- sum(diag(tabela_previsao)) / sum(tabela_previsao)
teste_accuracy
[1] 0.9324866     #ou seja erro 1-0.9324866=0.0675134.6%


FLORESTA <- randomForest(CHURN ~ FREQ_M + FREQ_MUM + VM + VMUM + MID + MID_UM + genero + SEGM_BABY_CD + SEGM_JUNIOR_CD + SEG_LIFESTAGE_KEY + REGION + AGE, data = dim_treino, parms = list(prior = c(0.01543739, 0.98456261)))
print(FLORESTA)


Call:
 randomForest(formula = CHURN ~ FREQ_M + FREQ_MUM + VM + VMUM +   MID + MID_UM + genero + SEGM_BABY_CD + SEGM_JUNIOR_CD + SEG_LIFESTAGE_KEY +  REGION + AGE, data = dim_treino, parms = list(prior = c(0.01543739,0.98456261))) 
               Type of random forest: classification
                     Number of trees: 500
No. of variables tried at each split: 3

        OOB estimate of  error rate: 1.54%
Confusion matrix:
     NAO SIM class.error
NAO 2870   0           0
SIM   45   0           1

importance(FLORESTA)
                  MeanDecreaseGini
FREQ_M                   3.8853135
FREQ_MUM                 1.3078653
VM                      14.4627064
VMUM                     1.1307720
MID                     25.3246242
MID_UM                   0.3532085
genero                   4.0515009
SEGM_BABY_CD             1.1438867
SEGM_JUNIOR_CD           1.9035740
SEG_LIFESTAGE_KEY        5.8460573
REGION                   6.2159663
AGE                     10.6384965

varImpPlot(FLORESTA) #TEMOS UMA REPRESENTAÇAO GRAFICA DA IMPORTANCIA DAS VARIAVEIS

levels(DIM_TESTE$MID) <- levels(dim_treino$MID)
levels(DIM_TESTE$MID_UM) <- levels(dim_treino$MID_UM)
levels(DIM_TESTE$FREQ_M) <- levels(dim_treino$FREQ_M)
levels(DIM_TESTE$FREQ_MUM) <- levels(dim_treino$FREQ_MUM)
levels(DIM_TESTE$VM) <- levels(dim_treino$VM)
levels(DIM_TESTE$VMUM) <- levels(dim_treino$VMUM)
levels(DIM_TESTE$AGE) <- levels(dim_treino$AGE)
levels(DIM_TESTE$CHURN) <- levels(dim_treino$CHURN)
levels(DIM_TESTE$REGION) <- levels(dim_treino$REGION)
levels(DIM_TESTE$SEGM_BABY_CD) <- levels(dim_treino$SEGM_BABY_CD)
levels(DIM_TESTE$SEGM_JUNIOR_CD) <- levels(dim_treino$SEGM_JUNIOR_CD)
levels(DIM_TESTE$SEG_LIFESTAGE_KEY) <- levels(dim_treino$SEG_LIFESTAGE_KEY)
levels(DIM_TESTE$genero) <- levels(dim_treino$genero)


previsaoFLORESTA <- predict(FLORESTA, DIM_TESTE, type = 'class')
head(previsaoFLORESTA)
tabela_previsaoFLORESTA <- table(DIM_TESTE$CHURN, previsaoFLORESTA)
tabela_previsaoFLORESTA
 previsaoFLORESTA
       NAO  SIM
  NAO 1492    1
  SIM    3    0

teste_accuracy_floresta <- sum(diag(tabela_previsaoFLORESTA)) / sum(tabela_previsaoFLORESTA)
teste_accuracy_floresta
[1] 0.9973262     #erro 1-0.9973262 =0.0026738.0.26%

previsaoFLORESTA <- predict(FLORESTA, DIM_TESTE, type = 'prob') #PRECISO DE TER AS PROBABILIDADES
#TENHO DE TRANSFORMAR A MATRIZ COM AS PROBABILIDADE E TORNAR NUMA DATA.FRAME
testes <- data.frame(previsao_tttt)
curvatestes <- roc(DIM_TESTE$CHURN,previsao_tttt$SIM)
plot(curva)
curva_FLORESTA <- roc(DIM_TESTE$CHURN,dataframe$SIM) #OBTENHO UMA CURVA ROC
curva_arvore <- roc(DIM_TESTE$CHURN,pred$SIM) #OBTENHO UMA CURVA ROC

#JUNTAR AS DUAS CURVAS
lines(curva_FLORESTA, col = "blue")
lines(curva_arvore, col = "red")

