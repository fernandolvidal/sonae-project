###AMOSTRA DE DESENVOLVIMENTO



###RETIRO UMA AMOSTRA DE 10% DOS PRIMEIROS 6 MESES EM SQL

SELECT *
FROM
dim_transactions
INNER JOIN dim_customer ON dim_transactions.CUSTOMER_CARD_KEY_MASK=dim_customer.CUSTOMER_CARD_KEY_MASK
INNER JOIN dim_time ON dim_transactions.TRANSACTION_TIME_KEY=dim_time.TIME_KEY
WHERE dim_transactions.TRANSACTION_TIME_KEY >='20170101' AND  dim_transactions.TRANSACTION_TIME_KEY <='20170630'
HAVING RAND() < 0.1;

#16 941 LINHAS DE TRANSAÇOES



##IMPORTAR NO R

#RETIRO A NOTAÇAO CIENTIFICA
options(scipen=999)

#RETIRO VARIAVEIS QUE NAO PRECISO

DIM_PRIMEIROS6MESES_AMOSTRA <- DIM_PRIMEIROS6MESES_AMOSTRA %>% select(-TRANSACTION_ID_MASK,-TRANSACTION_HOUR_KEY,-QTY,-VAT_RATE,-DISTRICT,-FULLDATE,-HOM_KEY,-HOM_WEEKDAY_KEY,-SEQ,-FISCAL_YEAR,-LAST_MONTH_DAY_IND,-ISLAMIC_DAY,-ISLAMIC_YEAR,-ISLAMIC_MONTH)
DIM_PRIMEIROS6MESES_AMOSTRA <- DIM_PRIMEIROS6MESES_AMOSTRA %>% select(-TIME_LEVEL,-TIME_KEY.1,-FISCAL_MONTH)
DIM_PRIMEIROS6MESES_AMOSTRA <- DIM_PRIMEIROS6MESES_AMOSTRA %>% select(-TIME_KEY)
DIM_PRIMEIROS6MESES_AMOSTRA <- DIM_PRIMEIROS6MESES_AMOSTRA %>% select(-PAYMENT_ID)

#PARA REMOVER COLUNAS 
Data <- subset( DIM_PRIMEIROS6MESES_AMOSTRA, select = -TIME_KEY )

##FAÇO NOVAS TABELAS PARA COMEÇAR A CALCULAR NOVAS VARIAVEIS

dim_calculo_valormediocompras <- DIM_PRIMEIROS6MESES_AMOSTRA
dim_calculo_ultimomes <- DIM_PRIMEIROS6MESES_AMOSTRA
dim_freqtotal <- DIM_PRIMEIROS6MESES_AMOSTRA
dim_freqtotal_ultimomes <- DIM_PRIMEIROS6MESES_AMOSTRA



####CALCULO O VALOR MÉDIO DE COMPRAS POR CLIENTE

dim_calculo_valormediocompras <- aggregate(dim_calculo_valormediocompras$PAYMENT_VALUE, by = list(dim_calculo_valormediocompras$CUSTOMER_ACCOUNT_MASK), mean)


#####CALCULO O VALOR MEDIO DO ULTIMO MES POR CLIENTE
dim_freqtotal_ultimomes <- dim_freqtotal_ultimomes %>% filter(MONTH==6)
dim_calculo_ultimomes <- aggregate(dim_calculo_ultimomes$PAYMENT_VALUE, by = list(dim_calculo_ultimomes$CUSTOMER_ACCOUNT_MASK), mean)

 ###MUDAR NOME DE COLUNA

colnames(dim_calculo_valormediocompras)[colnames(dim_calculo_valormediocompras)=="Group.1"] <- "CLIENTE" 
colnames(dim_calculo_valormediocompras)[colnames(dim_calculo_valormediocompras)=="x"] <- "VM"

colnames(dim_calculo_ultimomes)[colnames(dim_calculo_ultimomes)=="Group.1"] <- "CLIENTE" 
colnames(dim_calculo_ultimomes)[colnames(dim_calculo_ultimomes)=="x"] <- "VMUM"


##VALOR MEDIO DE FREQUENCIA DE COMPRAS

dim_freqtotal <- dim_freqtotal %>% group_by(CUSTOMER_ACCOUNT_MASK) %>% tally()



#VALOR MEDIO DE FREQUENCIA DE COMPRAS DO ULTIMO MES

dim_freqtotal_ultimomes <- dim_freqtotal_ultimomes %>% filter(MONTH==6)
dim_freqtotal_ultimomes <- dim_freqtotal_ultimomes %>% group_by(CUSTOMER_ACCOUNT_MASK) %>% tally()



###MUDAR NOME DE COLUNA

colnames(dim_freqtotal_ultimomes)[colnames(dim_freqtotal_ultimomes)=="CUSTOMER_ACCOUNT_MASK"] <- "CLIENTE" 
colnames(dim_freqtotal_ultimomes)[colnames(dim_freqtotal_ultimomes)=="n"] <- "FREQ_MUM"

colnames(dim_freqtotal )[colnames(dim_freqtotal )=="CUSTOMER_ACCOUNT_MASK"] <- "CLIENTE" 
colnames(dim_freqtotal )[colnames(dim_freqtotal )=="n"] <- "FREQ_M"





###CONTAR OS DIAS DESDE A ULTIMA COMPRA ATÉ AO FIM DE 6 MESES

##SELECIONA A ULTIMA TRANSAÇAO

DIM_ULTIMA_TRANSACAO <- DIM_ULTIMA_TRANSACAO %>% group_by(CLIENTE) %>% arrange(CLIENTE, TRANSACTION_TIME_KEY) %>% filter(row_number()==n())



###FAZER CALCULOS COM DATAS PARA SABER HA QUANTO TEMPO UM CLIENTE NAO COMPRA DESDE A ULTIMA TRANSAÇAO

DIM_ULTIMA_TRANSACAO$DIAS_UT <- as.Date(as.character('20170630'), format="%Y%m%d") - as.Date(as.character(DIM_ULTIMA_TRANSACAO$TRANSACTION_TIME_KEY), format="%Y%m%d")



##DEFINI O CHURN A PARTIR DE 150 DIAS 
DIM_ULTIMA_TRANSACAO$CHURN <- ifelse(DIM_ULTIMA_TRANSACAO$DIAS_UT>=150, 'SIM','NAO')


#CALCULAR A QUANTIDADE DE 'SIM'
DIM_CHURNERS <- length(which(DIM_ULTIMA_TRANSACAO$CHURN == 'SIM'))
DIM_CHURNERS
[1] 553
#5989 CLIENTES

#CALCULAR A PERCENTAGEM DE 'SIM' NA TABELA DIM_ULTIMA_TRANSACAO


DIM_CHURNERS <- 100 * length(which(DIM_ULTIMA_TRANSACAO$CHURN == 'SIM')) / length(DIM_ULTIMA_TRANSACAO$CHURN)
DIM_CHURNERS
[1] 9.233595




#QUERO CALCULAR O INTERVALO DE DIAS ENTRE TRANSAÇÃO POR CLIENTE. NO ENTANTO A PRIMEIRA TRANSAÇAO POR CLIENTE CONTABILIZA A TIME_KEY DA TRANSAÇÃO ANTERIOR DE OUTRO CLIENTE

DIM_INTERVALO_DIAS <- DIM_INTERVALO_DIAS %>% 
			arrange(CUSTOMER_ACCOUNT_MASK,TRANSACTION_TIME_KEY) %>%
			mutate(INTERVALO_DIAS = (as.Date(as.character(TRANSACTION_TIME_KEY), format="%Y%m%d"))-lag((as.Date(as.character(TRANSACTION_TIME_KEY), format="%Y%m%d"))))


#RETIRAR A PRIMEIRA LINHA POR CLIENTE, PORQUE ESTÁ ERRADA E TAMBÉM NÃO É NECESSÁRIA PARA O CALCULO DE INTERVALO DE DIAS.

DIM_1LINHA <- DIM_INTERVALO_DIAS %>%
			group_by(CUSTOMER_ACCOUNT_MASK) %>%
			arrange(CUSTOMER_ACCOUNT_MASK,TRANSACTION_TIME_KEY) %>%
			filter(row_number()==1) #seleciona a primeira linha por grupo

#RETIRAR A PRIMEIRA LINHA À TABELA ANTERIOR
dim_sem1linha <- setdiff(dim_intervalo_dias_UM,dim_antijoin, by ="CLIENTE") #PEGUEI NA TABELA NORMAL E RETIREI A PRIMEIRA LINHA QUE ESTAVA NOUTRA TABELA


#OUTRA FORMA DE RETIRAR A PRIMEIRA LINHA
DIM_INTERVALO_DIAS <- DIM_INTERVALO_DIAS[c(FALSE,DIM_INTERVALO_DIAS$CLIENTE[-1]==DIM_INTERVALO_DIAS$CLIENTE[-nrow(DIM_INTERVALO_DIAS)]),]


#FAZER O CALCULO DA MÉDIA DE DIAS
dim_sem1linha <- dim_INTERVALO_DIAS %>%
			group_by(CLIENTE) %>%
			mutate(MID= mean(INTERVALO_Dias))
#OU
dim_INTERVALO_DIAS <- aggregate(dim_INTERVALO_DIAS$INTERVALO_DIAS, by = list(dim_INTERVALO_DIAS$CLIENTE), mean)

#QUERO APENAS 1 LINHA POR CLIENTE

dim_sem1linha <- dim_sem1linha %>%
			select(CLIENTE,MID_UM) %>%
			group_by(CLIENTE) %>%
			distinct()

#CALCULAR A MÉDIA DE INTERVALOS POR CLIENTES

DIM_INTERVALO_DIAS <- transform(DIM_INTERVALO_DIAS, INTERVALO_DIAS= as.numeric(INTERVALO_DIAS))
DIM_INTERVALO_DIAS <- DIM_INTERVALO_DIAS %>%
			group_by(CUSTOMER_ACCOUNT_MASK) %>%
			mutate(MID = mean(INTERVALO_DIAS))


#QUERO APENAS 1 LINHA POR CLIENTE

DIM_INTERVALO_DIAS <- DIM_INTERVALO_DIAS %>%
			select(CUSTOMER_ACCOUNT_MASK,MID) %>%
			group_by(CUSTOMER_ACCOUNT_MASK) %>%
			distinct()

#CALCULAR A MEDIA DO INTERVALO DE DIAS NO ULTIMA MES

DIM_INTERVALO_ULTIMOMES <- DIM_INTERVALO_ULTIMOMES %>%
			filter(MONTH==6)

DIM_INTERVALO_ULTIMOMES <- DIM_INTERVALO_ULTIMOMES %>% 
			arrange(CUSTOMER_ACCOUNT_MASK,TRANSACTION_TIME_KEY) %>%
			mutate(MIDUM = (as.Date(as.character(TRANSACTION_TIME_KEY), format="%Y%m%d"))-lag((as.Date(as.character(TRANSACTION_TIME_KEY), format="%Y%m%d"))))
 
DIM_INTERVALO_ULTIMOMES <- DIM_INTERVALO_ULTIMOMES %>%
			group_by(CUSTOMER_ACCOUNT_MASK) %>%
			arrange(CUSTOMER_ACCOUNT_MASK,TRANSACTION_TIME_KEY) %>%
			filter(row_number()!=1)
 
DIM_INTERVALO_ULTIMOMES <- transform(DIM_INTERVALO_ULTIMOMES, MIDUM= as.numeric(MIDUM))
DIM_INTERVALO_ULTIMOMES <- DIM_INTERVALO_ULTIMOMES %>%
			group_by(CUSTOMER_ACCOUNT_MASK) %>%
			mutate(MID_UM = mean(MIDUM))

#RETIRO OS CLIENTE QUE SÓ FIZERAM UMA COMPRA OU COMPRAS APENAS NUM SÓ DIA

dim_media_intervalos <- dim_media_intervalos %>%
			filter(MID !=0)


#PRECISO DE JUNTAR AS TABELAS TODAS
colnames(DIM_ULTIMA_TRANSACAO)[colnames(DIM_ULTIMA_TRANSACAO)=="CUSTOMER_ACCOUNT_MASK"] <- "CLIENTE" 


DIM_1 <- left_join(dim_freqtotal,dim_freqtotal_ultimomes, by = "CLIENTE")
DIM_2 <- left_join( dim_calculo_valormediocompras,dim_freqtotal_ultimomes, by = "CLIENTE")
DIM_3 <- left_join(dim_intervalo_medio,dim_intervalo_dias_UM, by = "CLIENTE")
DIM_TUDO <- left_join(DIM_1,DIM_2, by = "CLIENTE")
DIM_TUDO <- inner_join(dim_tudo,dim_3, by = "CLIENTE")
dim_total <- inner_join(dim_total,dim_CHURNERS, by = "CLIENTE")



#JA TENHO AS FEATURES CRIADAS
names(dim_total)
[1] "CLIENTE"  "FREQ_M"   "FREQ_MUM" "VM"       "VMUM"     "MID"     
[7] "MID_UM"   "CHURN" 


#RETIRO OS NA' POR ZEROS

dim_total[is.na(dim_total)] <- 0



#TENHO DE JUNTAR AS OUTRAS VARIVEIS

names(dim_outrasvariaveis)
[1] "CUSTOMER_ACCOUNT_MASK" "GENDER_M"              "GENDER_F"             
[4] "SEGM_BABY_CD"          "SEGM_JUNIOR_CD"        "SEG_LIFESTAGE_KEY"    
[7] "AGE"                   "REGION" 

#TENHO DE TRANFORMAR AS VARIAVEIS PARA SEREM SEMPRE DE CATEGORIAS IGUAIS


dim_churn_final <- transform(dim_treino,
SEGM_BABY_CD = as.factor(SEGM_BABY_CD),
SEGM_JUNIOR_CD = as.factor(SEGM_JUNIOR_CD),
SEG_LIFESTAGE_KEY = as.factor(SEG_LIFESTAGE_KEY),
REGION = as.factor(REGION),
genero = as.factor(genero),
CHURN = as.factor(CHURN), 
FREQ_M = as.numeric(FREQ_M),
FREQ_MUM = as.numeric(FREQ_MUM),
VM = as.numeric(VM),
VMUM = as.numeric(VMUM),
MID = as.numeric(MID),
MID_UM = as.numeric(MID_UM))

#CODIGO PARA OS 6 MESES SEGUINTES

SELECT *
FROM
dim_transactions
INNER JOIN dim_customer ON dim_transactions.CUSTOMER_CARD_KEY_MASK=dim_customer.CUSTOMER_CARD_KEY_MASK
INNER JOIN dim_time ON dim_transactions.TRANSACTION_TIME_KEY=dim_time.TIME_KEY
WHERE dim_transactions.TRANSACTION_TIME_KEY >='20170701' AND  dim_transactions.TRANSACTION_TIME_KEY <='20171231'
HAVING RAND() < 0.1;


dim_VM <- aggregate(dim_VM$PAYMENT_VALUE, by = list(dim_VM$CLIENTE), mean)
colnames(dim_VM)[colnames(dim_VM)=="Group.1"] <- "CLIENTE" 
colnames(dim_VM)[colnames(dim_VM)=="x"] <- "VM"

dim_VMUM<- dim_VMUM %>% filter(MONTH==12)
dim_VMUM <- aggregate(dim_VMUM$PAYMENT_VALUE, by = list(dim_VMUM$CLIENTE), mean)
colnames(dim_VMUM)[colnames(dim_VMUM)=="Group.1"] <- "CLIENTE" 
colnames(dim_VMUM)[colnames(dim_VMUM)=="VM"] <- "VMUM"

DIM_VALORES_MEDIOS <- left_join(dim_VM,dim_VMUM, by = "CLIENTE")


dim_FREQM <- dim_FREQM %>%
			group_by(CLIENTE) %>%
			tally()
dim_FREQMUM <- dim_FREQMUM %>%
			filter(MONTH==12)
dim_FREQMUM <- dim_FREQMUM %>%
			group_by(CLIENTE) %>%
			tally()
colnames(dim_FREQM)[colnames(dim_FREQM)=="n"] <- "FREQ_M"
colnames(dim_FREQMUM)[colnames(dim_FREQMUM)=="n"] <- "FREQ_MUM"
dim_FREQMEDIA <- left_join(dim_FREQM,dim_FREQMUM, by = "CLIENTE")


dim_ultimatransacao <- dim_ultimatransacao %>%
			group_by(CLIENTE) %>%
			arrange(CLIENTE, TRANSACTION_TIME_KEY) %>%
			filter(row_number()==n())
dim_ultimatransacao$DIAS_UT <- as.Date(as.character('20171231'), format="%Y%m%d") - as.Date(as.character(dim_ultimatransacao$TRANSACTION_TIME_KEY), format="%Y%m%d")
dim_ultimatransacao$CHURN <- ifelse(dim_ultimatransacao$DIAS_UT>=150, 'SIM','NAO')
dim_ultimatransacao <- subset( dim_ultimatransacao, select = -TRANSACTION_TIME_KEY,-DIAS_UT )

dim_MID <- dim_MID %>%
			arrange(CLIENTE,TRANSACTION_TIME_KEY) %>%
			mutate(MID = (as.Date(as.character(TRANSACTION_TIME_KEY), format="%Y%m%d"))-lag((as.Date(as.character(TRANSACTION_TIME_KEY), format="%Y%m%d"))))
dim_MID <- dim_MID[c(FALSE,dim_MID$CLIENTE[-1]==dim_MID$CLIENTE[-nrow(dim_MID)]),]
dim_MID<- transform(dim_MID, MID= as.numeric(MID))
dim_MID <- aggregate(dim_MID$MID2, by = list(dim_MID$CLIENTE), mean)

colnames(dim_MID)[colnames(dim_MID)=="Group.1"] <- "CLIENTE"
colnames(dim_MID)[colnames(dim_MID)=="x"] <- "MID"
dim_MID <- dim_MID %>%
			filter(MID !=0)


dim_MIDUM <- dim_MIDUM %>%
			filter(MONTH==12)
dim_MIDUM <- dim_MIDUM %>%
			arrange(CLIENTE,TRANSACTION_TIME_KEY) %>%
			mutate(MID = (as.Date(as.character(TRANSACTION_TIME_KEY), format="%Y%m%d"))-lag((as.Date(as.character(TRANSACTION_TIME_KEY), format="%Y%m%d"))))
dim_MIDUM <- dim_MIDUM[c(FALSE,dim_MIDUM$CLIENTE[-1]==dim_MIDUM$CLIENTE[-nrow(dim_MIDUM)]),]

dim_MIDUM <- transform(dim_MIDUM, MIDUM= as.numeric(MIDUM))
dim_MIDUM <- aggregate(dim_MIDUM$MID, by = list(dim_MIDUM$CLIENTE), mean)
colnames(dim_MIDUM)[colnames(dim_MIDUM)=="Group.1"] <- "CLIENTE"
colnames(dim_MIDUM)[colnames(dim_MIDUM)=="x"] <- "MIDUM"

dim_MIMEDIA <- left_join(dim_MID,dim_MIDUM, by = "CLIENTE")

dim_total <- inner_join(dim_MIMEDIA, dim_FREQMEDIA, by = "CLIENTE")

dim_total[is.na(dim_total)] <- 0

dim_outrasvariaveis <- dim_outrasvariaveis %>%
			select_all() %>%
			group_by(CLIENTE) %>%
			distinct()

dim_treino <- transform(dim_treino,
SEGM_BABY_CD = as.factor(SEGM_BABY_CD),
SEGM_JUNIOR_CD = as.factor(SEGM_JUNIOR_CD),
SEG_LIFESTAGE_KEY = as.factor(SEG_LIFESTAGE_KEY),
REGION = as.factor(REGION),
genero = as.factor(genero),
CHURN = as.factor(CHURN), 
FREQ_M = as.numeric(FREQ_M),
FREQ_MUM = as.numeric(FREQ_MUM),
VM = as.numeric(VM),
VMUM = as.numeric(VMUM),
MID = as.numeric(MID),
MID_UM = as.numeric(MID_UM))

sapply(dim_treino,class)
          CLIENTE            FREQ_M          FREQ_MUM                VM              VMUM 
        "integer"         "integer"         "numeric"         "numeric"         "numeric" 
              MID            MID_UM             CHURN      SEGM_BABY_CD    SEGM_JUNIOR_CD 
       "difftime"        "difftime"       "character"         "numeric"         "numeric" 
SEG_LIFESTAGE_KEY               AGE            REGION            genero 
        "numeric"         "numeric"       "character"         "numeric" 

DIM_TESTE <- transform(DIM_TESTE,
SEGM_BABY_CD = as.factor(SEGM_BABY_CD),
SEGM_JUNIOR_CD = as.factor(SEGM_JUNIOR_CD),
SEG_LIFESTAGE_KEY = as.factor(SEG_LIFESTAGE_KEY),
REGION = as.factor(REGION),
genero = as.factor(genero),
CHURN = as.factor(CHURN), 
FREQ_M = as.numeric(FREQ_M),
FREQ_MUM = as.numeric(FREQ_MUM),
VM = as.numeric(VM),
VMUM = as.numeric(VMUM),
MID = as.numeric(MID),
MID_UM = as.numeric(MID_UM),
AGE = as.numeric(AGE))

DIM_CHURNERS <- 100 * length(which(DIM_TESTE$CHURN == 'SIM')) / length(DIM_TESTE$CHURN)
DIM_CHURNERS
[1] 0.2005348
DIM_CHURNERS <- length(which(DIM_TESTE$CHURN == 'SIM'))
DIM_CHURNERS
[1] 3


#treino com 2915 cliente. dim teste com 1496. desistiram 1419 clientes


#PERCENTAGEM DAS PROPORÇOES DE CLASSES
prop.table(table(dim_treino$CHURN))

       NAO        SIM 
0.98456261 0.01543739 
prop.table(table(DIM_TESTE$CHURN))

        NAO         SIM 
0.997994652 0.002005348 



