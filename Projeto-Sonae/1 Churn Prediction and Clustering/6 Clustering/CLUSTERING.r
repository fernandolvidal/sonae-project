##CLUSTER KMEANS AND HIERARCHICAL CLUSTER



###### FUNÇAO PARA NORMALIZAR A AMOSTRA

normalize<- function(x){return((x-min(x))/(max(x)-min(x)))}


##APLICO A FUNÇAO DE NORMALIZAÇAO
amostranormalizada<- normalize(amostra)

##REALIZO O KMEANS
kmeans2 <- kmeans(amostranormalizada, centers = 5, iter.max = 20)
plot(amostranormalizada[,], col=kmeansteste$cluster) 
plot(amostranormalizada[,], col=kmeans2$cluster) 

##VER DADOS DOS CENTROS DOS CLUSTERS
kmeansteste$centers
kmeansteste$size


#PLOT DOS CLUSTERS POR VARIAVEIS
plot(amostranormalizada[,], col=kmeansteste$cluster) 


###VISUALIZAR EM RTSNE

tsne_model_1 = Rtsne(as.matrix(amostranormalizada), check_duplicates=FALSE, pca=TRUE, perplexity=30, theta=0.5, dims=2)
d_tsne_1 = as.data.frame(tsne_model_1$Y)
View(d_tsne_1)
ggplot(d_tsne_1, aes(x=V1, y=V2)) +
		geom_point(size=0.25) +
		guides(colour=guide_legend(override.aes=list(size=6))) +
		xlab("") + ylab("") +
		ggtitle("t-SNE") +
		theme_light(base_size=20) +
		theme(axis.text.x=element_blank(),
		axis.text.y=element_blank()) +
		scale_colour_brewer(palette = "Set2")
d_tsne_1_original=d_tsne_1
fit_cluster_kmeans=kmeans(scale(d_tsne_1), 5)
d_tsne_1_original$cl_kmeans = factor(fit_cluster_kmeans$cluster)
fit_cluster_hierarchical=hclust(dist(scale(d_tsne_1)))
d_tsne_1_original$cl_hierarchical = factor(cutree(fit_cluster_hierarchical, k=5))
plot_cluster=function(data, var_cluster, palette)
{
		ggplot(data, aes_string(x="V1", y="V2", color=var_cluster)) +
		geom_point(size=0.25) +
		guides(colour=guide_legend(override.aes=list(size=6))) +
		xlab("") + ylab("") +
		ggtitle("") +
		theme_light(base_size=20) +
		theme(axis.text.x=element_blank(),
		axis.text.y=element_blank(),
		legend.direction = "horizontal", 
		legend.position = "bottom",
		legend.box = "horizontal") + 
		scale_colour_brewer(palette = palette) 
}
plot_k=plot_cluster(d_tsne_1_original, "cl_kmeans", "Accent")
plot_h=plot_cluster(d_tsne_1_original, "cl_hierarchical", "Set1")
library(gridExtra)
grid.arrange(plot_k, plot_h,  ncol=2)


#CLUSTERING PAM
#CLUSTERING COM PAM (partitioning around medoids) COM DISTANCE GOWER (que não é bem uma distância)

#TABELA CUSTOMER 
#(tirei uma amostra de 10 mil linhas)

#NAO SELECIONEI AS COLUNAS COM ID

#COLOQUEI AS SEGUINTES VARIAVEIS NUMERICAS COMO CATEGORICAS
> amostra$SEGM_BABY_CD <- as.factor(amostra$SEGM_BABY_CD)
> amostra$SEGM_JUNIOR_CD <- as.factor(amostra$SEGM_JUNIOR_CD)
> amostra$SEG_LIFESTAGE_KEY <- as.factor(amostra$SEG_LIFESTAGE_KEY)
> amostra$genero <- as.factor(amostra$genero)

#CALCULO A DISTANCIA GOWER (isto aplica-se a situações em que tenho varios tipos de variaveis)
> gower_dist <- daisy(amostra, metric = "gower")

#FAÇO UMA MATRIX COM AS DISTANCIAS CALCULADAS
> gower_mat <- as.matrix(gower_dist)

[isto a seguir é um aparte, é só para ter uma ideia do que tenho. nao é obrigatório fazer isto]
#QUERO SABER QUAL O PAR DE CLIENTES QUE SAO MAIS SIMILARES (APRESENTAM MENOR DISTANCIA DE GOWER NA MATRIZ)
> amostra[which(gower_mat == min(gower_mat[gower_mat != min(gower_mat)]), arr.ind = TRUE)[1, ], ]
[isto a seguir é um aparte, é só para ter uma ideia do que tenho. nao é obrigatorio fazer isto]
#QUERO SABER QUAL O PAR DE CLIENTES QUE SAO MAIS DISSIMILARES (APRESENTAM MAIOR DISTANCIA DE GOWER NA MATRIZ)
> amostra[which(gower_mat == max(gower_mat[gower_mat != max(gower_mat)]), arr.ind = TRUE)[1, ], ]

##VOU CALCULAR O NUMERO DE CLUSTER QUE PRECISO PELA SILHOUTTE (PARA DESCOBRIR O K)
##FAÇO UM CICLO FOR PARA CALCULAR SILHOUTTE NUMA LISTA DE 2:8 
> for(i in 2:8){  
+     pam_fit <- pam(gower_dist, diss = TRUE, k = i)  
+     sil_width[i] <- pam_fit$silinfo$avg.width  
+ }

> plot(1:8, sil_width, xlab = "Number of clusters", ylab = "Silhouette Width") #FAÇO PLOT DOS PONTOS QUE CALCULEI ATRAS
> lines(1:8, sil_width) #CRIO LINHAS NO GRAFICO

##PELO GRAFICO SEI QUE O K É 5
> k <- 5

> pam_fit <- pam(gower_dist, diss = TRUE, k)

> pam_results <- amostra %>% mutate(cluster = pam_fit$clustering) %>% group_by(cluster) %>% do(the_summary = summary(.))
> pam_results$the_summary


##PARA PODER VISUALIZAR O CLUSTER EM "LOWER DIMENSIONAL SPACE" TENHO DE USAR O RTSNE()
> tsne_obj <- Rtsne(gower_dist, is_distance = TRUE)

##FAÇO UMA DATRAFRAME COM PONTOS EM X E Y COM AS DISTANCiaS QUE CALCULEI PARA O CLUSTERING PAM
> tsne_data <- tsne_obj$Y %>% data.frame() %>% setNames(c("X", "Y")) %>% mutate(cluster = factor(pam_fit$clustering))

##PARA VISUALIZAR O CLUSTER
ggplot(aes(x = X, y = Y), data = tsne_data) + geom_point(aes(color = cluster))