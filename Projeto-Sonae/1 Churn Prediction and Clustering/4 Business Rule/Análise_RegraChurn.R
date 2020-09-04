# Análise inicial para verificação de regra de churn (Considerando todos os cenários antes de confirmação do negócio qu
# que as datas a considerar seriam entre a 1ª e última transações)

# total todas as datas (incluíndo ou não clientes sem compras)
summary(MaxTotal_Union_c_clientesSemCompras$MAX.maxtotal.dif.[MaxTotal_Union_c_clientesSemCompras$Compras=="Com Compras"])
summary(MaxTotal_Union_c_clientesSemCompras$MAX.maxtotal.dif.)
boxplot(MaxTotal_Union_c_clientesSemCompras$MAX.maxtotal.dif., xlab="Total - todas as datas, inclui clientes sem compras")
boxplot(MaxTotal_Union_c_clientesSemCompras$MAX.maxtotal.dif.[MaxTotal_Union_c_clientesSemCompras$Compras=="Com Compras"], xlab="Total - todas as datas, apenas clientes com compras")

#Total - a partir da 1ª transação e considerando a última da BD

summary(MaximoTempoCompras_total_PrimeiraTransacao_20190501)
boxplot(MaximoTempoCompras_total_PrimeiraTransacao_20190501$MAX.maxtotal.dif.,xlab="Total - a partir da 1ª transação e considerando a última da BD")
        
# total todas as datas, inclusive com clientes sem compras 
boxplot(MaximoTempoCompras_total_20190501$MAX.maxtotal.dif.~MaximoTempoCompras_total_20190501$Compras, xlab="Per Sales")
boxplot(MaximoTempoCompras_total_20190501$MAX.maxtotal.dif., xlab="Total")
summary(MaximoTempoCompras_total_20190501$MAX.maxtotal.dif[MaximoTempoCompras_total_20190501$Compras=="Y"])


# total entre datas com compras - a nossa Business Rule Final

summary(MaxTotal_Union_PrimeiraTransacao_UltimaTransacao_sem_null$MAX.maxtotal.dif.)
boxplot(MaxTotal_Union_PrimeiraTransacao_UltimaTransacao_sem_null$MAX.maxtotal.dif.,  xlab="Total - entre a 1ª e última transações", ylab="Intervalo máximo de dias entre transações")


