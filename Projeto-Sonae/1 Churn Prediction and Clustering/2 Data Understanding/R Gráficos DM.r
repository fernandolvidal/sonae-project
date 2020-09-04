install.packages("XML")
install.packages("reshape2")


library(XML)
library(reshape2)
library(plyr)
library(ggplot)
library(ggplot2)
library(XML)
library(devtools)
library(XML)
library(reshape2)


#criar a ligação
conn <- dbconnect(MySQL(), user='a20182820', password='changeme', dbname='a20182820', host='vsrv01.inesctec.pt')


# abre ligacaom a bd
CUSTOMERS<-dbSendQuery(conn, "SELECT  * FROM dim_customer_v2")

# vai buscar dados
CUSTOMERS = fetch(CUSTOMERS, n=-1)

dbDisconnect(conn)

# Importar com csv
CUSTOMERS <-customer_v2

summary(CUSTOMERS)

#ver se existem na
sapply(CUSTOMERS, function(x) sum(is.na(x))) 

graph_genderf <- ggplot(CUSTOMERS, aes(x=GENDER_F))  + ggtitle("Gênero Feminino") + xlab("Gênero Feminino") + geom_bar(aes(y = 20*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentagem") + coord_flip() + theme(
  # Change axis lines
  axis.line = element_line(),
  
  # Change axis ticks text labels: font color, size and face
  axis.text = element_text(),       # Change tick labels for all axes
  axis.text.x = element_text(),     # Change x axis tick labels only
  axis.text.x.top = element_text(), # x axis tick labels on top axis
  axis.text.y = element_text(),     # Change y axis tick labels only
  axis.text.y.right = element_text(),# y  axis tick labels on top axis
  
  # Change axis ticks line: font color, size, linetype and length
  axis.ticks = element_line(),      # Change ticks line fo all axes
  axis.ticks.x = element_line(),    # Change x axis ticks only
  axis.ticks.y = element_line(),    # Change y axis ticks only
  axis.ticks.length = unit(2, "pt") # Change the length of tick marks
) 


#Tentativa de criar um template de cores para os gráficos 
pbs_colors <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
                "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


graph_genderm <- ggplot(CUSTOMERS, aes(x=GENDER_M))  + ggtitle("Gênero Masculino") + xlab("Gênero Masculino") + geom_bar(aes(y = 20*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentagem") + coord_flip() + theme(
  # Change axis lines
  axis.line = element_line(),
  
  # Change axis ticks text labels: font color, size and face
  axis.text = element_text(),       # Change tick labels for all axes
  axis.text.x = element_text(),     # Change x axis tick labels only
  axis.text.x.top = element_text(), # x axis tick labels on top axis
  axis.text.y = element_text(),     # Change y axis tick labels only
  axis.text.y.right = element_text(),# y  axis tick labels on top axis
  
  # Change axis ticks line: font color, size, linetype and length
  axis.ticks = element_line(),      # Change ticks line fo all axes
  axis.ticks.x = element_line(),    # Change x axis ticks only
  axis.ticks.y = element_line(),    # Change y axis ticks only
  axis.ticks.length = unit(2, "pt") # Change the length of tick marks
) 

graph_genderf
graph_genderm


#pie chart
library(ggplot2)
# Barplot
pie(CUSTOMERS$GENDER_F, main="Gênero Feminino")



graph_age <- ggplot(CUSTOMERS, aes(x=AGE))  + ggtitle("AGE") + xlab("AGE") + geom_bar(aes(y = 20*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentagem") + coord_flip() + theme(
  # Change axis lines
  axis.line = element_line(),
  
  # Change axis ticks text labels: font color, size and face
  axis.text = element_text(),       # Change tick labels for all axes
  axis.text.x = element_text(),     # Change x axis tick labels only
  axis.text.x.top = element_text(), # x axis tick labels on top axis
  axis.text.y = element_text(),     # Change y axis tick labels only
  axis.text.y.right = element_text(),# y  axis tick labels on top axis
  
  # Change axis ticks line: font color, size, linetype and length
  axis.ticks = element_line(),      # Change ticks line fo all axes
  axis.ticks.x = element_line(),    # Change x axis ticks only
  axis.ticks.y = element_line(),    # Change y axis ticks only
  axis.ticks.length = unit(2, "pt") # Change the length of tick marks
) 


graph_age


## corta a variável age em grupos de idade com intervalos de 5 anos
CUSTOMERS$AGE_GROUP <- cut(CUSTOMERS$AGE, breaks = seq(0, 100, 5), right = FALSE) 
CUSTOMERS$N_CUSTOMERS <- 10 ## each sampled respondent represents 10 individuals

## agrega a informação por GENDER_F e grupo de idade
CUSTOMERS <- aggregate(formula = N_CUSTOMERS ~ GENDER_F + AGE_GROUP, data = CUSTOMERS, FUN = sum)

summary(CUSTOMERS)
head(CUSTOMERS)


## ordena a data primeiramente por genero e depois por grupo de idade
CUSTOMERS <- with(CUSTOMERS, CUSTOMERS[order(GENDER_F,AGE_GROUP),])

## adiciona label ao grupo de idades
CUSTOMERS$AGE_GROUP <- rep(unique(CUSTOMERS$AGE_GROUP)[1:20], 2)



## utiliza as 3 variáveis necessárias
CUSTOMERS <- CUSTOMERS[,c("GENDER_F","AGE_GROUP","N_CUSTOMERS")]
summary(CUSTOMERS)

## alinha à esquerda mulheres e à direita não mulheres
CUSTOMERS$N_CUSTOMERS <- ifelse(CUSTOMERS$GENDER_F == "1", -1*CUSTOMERS$N_CUSTOMERS, CUSTOMERS$N_CUSTOMERS)


## gráfico
pyramidGH2 <- ggplot(CUSTOMERS, aes(x = AGE_GROUP, y = N_CUSTOMERS, fill = GENDER_F)) + 
  geom_bar(data = subset(CUSTOMERS, GENDER_F == "1"), stat = "identity") +
  geom_bar(data = subset(CUSTOMERS, GENDER_F == "0"), stat = "identity") + 
  scale_y_continuous(labels = paste0(as.character(c(seq(2, 0, -1), seq(1, 2, 1))), "m")) + 
  coord_flip()

pyramidGH2
