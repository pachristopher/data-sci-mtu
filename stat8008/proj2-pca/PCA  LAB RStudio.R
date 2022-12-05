## PCA LECTURE 1
################

#install.packages("scatterplot3d") # Install
library("scatterplot3d") # load

require(graphics)
##
# Loading
data(mtcars)
mtcars

# Print the first 6 rows
head(mtcars, 6)
round(cor(mtcars), 5)
attach(mtcars)
plot(hp, cyl, pch=)
## 

pairs(mtcars, main = "mtcars", gap = 1/8)
summary(mtcars)

# Example with USArrests.
# ======================
# PCA with function prcomp
data(USArrests)
head(USArrests)
attach(USArrests)
plot(UrbanPop, Rape, pch=16)
plot(Murder, Rape, pch=16)

#order of variables in scatterplot3d function are x1 (width), x2 (depth), and y (height)
s3d <- scatterplot3d(Murder,Rape,UrbanPop, type = "p",highlight.3d = TRUE, pch = 20)
# Add regression plane
mod <- lm(UrbanPop ~ Murder + Rape, data=USArrests)
s3d$plane3d(mod,draw_polygon = TRUE, draw_lines = TRUE)

mod3 <- lm(Rape ~ UrbanPop + Murder, data=USArrests, col=3) ## wrong plane
s3d$plane3d(mod3,draw_polygon = TRUE, draw_lines = TRUE)
#
s3d2 <- scatterplot3d(Rape,Murder, Assault, type = "p",highlight.3d = TRUE, pch = 20)
# Add regression plane
mod2 <- lm(Assault ~ Rape + Murder, data=USArrests)
s3d2$plane3d(mod2,draw_polygon = TRUE, draw_lines = TRUE)

pca1 = prcomp(USArrests, scale. = FALSE)
pca1
summary(pca1)

# sqrt of eigenvalues
pca1$sdev
# eigen values
ev = (pca1$sdev)^2; ev
# 
# loadings  (cor(Z,X)= u(sqrt(lambda))/sqrt(var(X)*lambda))
head(pca1$rotation) ## show the correlation between the var and PCs
#loadings(pca1)

#########
#######

df = USArrests
cor(USArrests)

pc_raw = prcomp(df); pc_raw
pc = prcomp(df, scale=TRUE); pc
names(pc)
head(pc$rotation)
pc$sdev
v = (pc$sdev)^2 ; v# variance 
sum(v)  # = to number of PCs
sum((pc_raw$sd)^2)

summary(pc)

## importance of components
xx= pc$x
xx = as.data.frame(xx)
xx

cor(xx)

full = cbind(USArrests, xx)
cor(full)

pairs(full, pch=16, col=c(1:9))

-.5358995 * 1.5748783  ## correlation between PC1 and murder = eigen_vector x sqrt(eigen value) = u11*sqrt(lambda1) 

#####
#####

# screeplot eigen values
plot(pca1)
screeplot(pca1, type="line", main="Screeplot")
# Biplot
par(mfrow=c(1,2))
biplot(pca1,scale=0)
biplot(pca1,scale=0, cex=.8)

## Seems more concentrated in the negative side
## Let's Flip the plot
pca.out <- pca1
pca.out$rotation = - pca.out$rotation
pca.out$x = -pca.out$x
biplot(pca.out,scale=0, cex=.7)

# PCs (aka scores) --> weight of each X(state) in the PCi
#pca1$scores[,1:10]
head(pca1$x) ## show the scores be 
head(pca.out$x)
###########################
## PCA with function princomp
###############################
pca2 = princomp(USArrests, cor = TRUE)
pca2
# sqrt of eigenvalues
pca2$sdev
# loadings
unclass(pca2$loadings)
# PCs (aka scores)
head(pca2$scores)

## PCA syntax iii 
# http://factominer.free.fr/docs/EDA_PCA.pdf
# PCA with function PCA
#install.packages("FactoMineR")
library(FactoMineR)
# apply PCA
?PCA
pca3 = PCA(USArrests, graph = FALSE); pca3
pca3 = PCA(USArrests, graph = TRUE, scale.unit = FALSE)
pca3 = PCA(USArrests, graph = TRUE, scale.unit = TRUE)

# matrix with eigenvalues
pca3$eig

# correlations between variables and PCs
pca3$var$coord
# PCs (aka scores)
head(pca3$ind$coord)

# PCA syntax iv
# PCA with function dudi.pca
#install.packages("ade4")
library(ade4) # many options
# http://pbil.univ-lyon1.fr/JTHome/ref/ade4-Rnews.pdf
# apply PCA
?dudi.pca
pca4 = dudi.pca(USArrests, nf = 5, scannf = FALSE)
pca4 = dudi.pca(USArrests, nf = 5, scannf = TRUE)
pca4
#
pca4$eig
pca4$tab
pca4$co
print(pca4)
score(pca4)
s.corcircle(pca4$co)

scatter(pca4)

scatter(pca4)
s.label(pca4$li)

?s.label
#
# eigenvalues
pca4$eig
## loadings
pca4$c1
# correlations between variables and PCs
pca4$co
# PCs
head(pca4$li)

# PCA with function acp
#install.packages("amap")
library(amap)
# apply PCA
?acp
pca5 = acp(USArrests)
pca5
# sqrt of eigenvalues
pca5$sdev
# loadings
pca5$loadings
# scores
head(pca5$scores)


# USSING prcomp
# load ggplot2
library(ggplot2)
# create data frame with scores
pca1
scores = as.data.frame(pca1$x)
# plot of observations
ggplot(data = scores, aes(x = PC1, y = PC2, label =
                            rownames(scores))) +
  geom_hline(yintercept = 0, colour = "gray65") +
  geom_vline(xintercept = 0, colour = "gray65") +
  geom_text(colour = "tomato", alpha = 0.8, size = 4) +
  ggtitle("PCA plot of USA States - Crime Rates")

     
## signs are random
require(graphics)
## the variances of the variables in the
## USArrests data vary by orders of magnitude, so scaling is appropriate
prcomp(USArrests)  # inappropriate
prcomp(USArrests, scale = TRUE)
prcomp(~ Murder + Assault + Rape, data = USArrests, scale = TRUE)
plot(prcomp(USArrests))
summary(prcomp(USArrests, scale = TRUE))
biplot(prcomp(USArrests, scale = TRUE))

# 3D Scatter plot
scatterplot3d(x, y=NULL, z=NULL)
scatterplot3d(USArrests[ ,1:3])
# color= c(2,3,4) ,pch = c(16,17,18))
# ==================================================
# ANOTHER EXAMPLE ##########
## IRIS DATASET

head(iris)
# Remove categorical variable Species (5)
iris.pca = iris[1:4]


pca1 = prcomp(iris.pca, scale. = TRUE)
pca1
summary(pca1)

# sqrt of eigenvalues
pca1$sdev
# eigen values
ev = (pca1$sdev)^2; ev
# 
# loadings  (cor(Z,X)= u(sqrt(lambda))/sqrt(var(X)*lambda))
head(pca1$rotation) ## show the correlation between the var and PCs
#loadings(pca1)

# screeplot eigen values
plot(pca1)
screeplot(pca1, type="line", main="Screeplot")
# Biplot
#par(mfrow=c(1,1))
biplot(pca1)

## Seems more concentrated in the negative side
## Let's Flip the plot
pca.out <- pca1
pca.out$rotation <- -pca.out$rotation
pca.out$x <- -pca.out$x
biplot(pca.out,scale=0, cex=.7)

# PCs (aka scores) --> weight of each X(state) in the PCi
#pca1$scores[,1:10]
head(pca1$x) ## show the scores be 



#####################
## ========================================================
## FACTOR MINER
library("FactoMineR")
#install.packages("factoextra")
library("factoextra")
## PCA of IRIS dataset
head(iris, 3)
# Remove categorical variable Species (5)
iris.pca <- PCA(iris[,-5], graph = FALSE)

eig.val <- get_eigenvalue(iris.pca)
eig.val


# FUNCTIONS FOR VISUALIZATION AND INTERPRETATION 
#==============================================
#get_eigenvalue(res.pca): Extract the eigenvalues/variances of principal components
#fviz_eig(res.pca): Visualize the eigenvalues
#get_pca_ind(res.pca), get_pca_var(res.pca): Extract the results for individuals and variables, respectively.
#fviz_pca_ind(res.pca), fviz_pca_var(res.pca): Visualize the results individuals and variables, respectively.
#fviz_pca_biplot(res.pca): Make a biplot of individuals and variables.
# Screeplot
fviz_eig(iris.pca, addlabels = TRUE, ylim = c(0, 90))
# Variables results
var <- get_pca_var(iris.pca)
var


# Coordinates
head(var$coord)
# Cos2: quality on the factore map
head(var$cos2)
# Contributions to the principal components
head(var$contrib)

# Correlation circle
fviz_pca_var(iris.pca, col.var = "black")

# colour by group
fviz_pca_ind(iris.pca,
             geom.ind = "point", # show points only (nbut not "text")
             col.ind = iris$Species, # color by groups
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             addEllipses = TRUE, # Concentration ellipses
             legend.title = "Groups"
)
# Biplot 
fviz_pca_biplot(iris.pca, repel = TRUE,
                col.var = "#2E9FDF", # Variables color
                col.ind = "#696969"  # Individuals color
)

##############################################
# http://factominer.free.fr/more/EDA_PCA.pdf #
# ------------------------------------------ #

library(FactoMineR)

mat=matrix(rnorm(7*200,0,1),ncol=200)
mat
PCA(mat)


data(decathlon)
res <- PCA(decathlon,quanti.sup=11:12,quali.sup=13)
summary(res)
res$var$cor
plot(res,habillage=13)
res$eig

####
pca1 = prcomp(decathlon[, 1:(dim(decathlon)[2] - 2) ], scale. = TRUE)
pca1
summary(pca1)
# sqrt of eigenvalues
pca1$sdev
# eigen values
ev = (pca1$sdev)^2; ev
# loadings  (cor(Z,X)= u(sqrt(lambda))/sqrt(var(X)*lambda))
head(pca1$rotation) ## show the correlation between the var and PCs
#loadings(pca1)
# screeplot eigen values
plot(pca1)
screeplot(pca1, type="line", main="Screeplot")
# Biplot
par(mfrow=c(1,1))
biplot(pca1,scale=0)
biplot(pca1,scale=0, cex=.8)
##

x11()
barplot(res$eig[,1],main="Eigenvalues",names.arg=1:nrow(res$eig))
res$ind$coord
res$ind$cos2
res$ind$contrib
dimdesc(res)


######################################

## MTCARS DATASET

mtcars

#install.packages("parameters")
library(parameters) 
check_sphericity_bartlett(mtcars)
######################
######################

library(GGally)
rmtcars <- mtcars[, c(1:7, 10, 11)]
ggcorr(rmtcars)
library(ggcorrplot)
cor_data <- cor(rmtcars); cor_data
ggcorrplot(cor_data)


library(PerformanceAnalytics)
chart.Correlation(rmtcars, histogram = T, method='pearson', pch=16)
