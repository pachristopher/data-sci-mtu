#install.packages("foreign")
library(foreign)

data <- read.spss("PCA_STAT8008_Project.sav", to.data.frame=TRUE)

attach(data)
#Manufacturer
head(data, n=4L)
str(data)
data[57,]

data$Cylinders
cars_origin.df = data[-57,-c(3,11:16)] ## Leave Origin and Type
## remove Categorical / Text except Brand& model
                         ## (57)remove mazda RX7 with "Rotative" cylinders
                         ## Other option --> asign a value to Rotative = 6 e.g.
head(dcars_origin, n=1L)

## create var for row.names with Brand&Model
n = dim(dcars_origin)[1]
car=NULL
for(i in 1:n ){ ## create var for row.names with Brand&Model
    car = rbind(car, paste( data[i,14], data[i,15], sep=" ") )
              }
car
## Create new dataframe with row names "cars"
cars_origin.df = data.frame(cars_origin.df,row.names=car)  
head(cars_origin.df,n=1L)
nrow(cars_origin.df)

## Correlation
# Why is there a problem with pairs? - Explain
# Transform the data to apply "pairs"
pairs(cars_origin.df)
# Error in pairs.default(cars_origin.df) : non-numeric argument to 'pairs'
cars_origin.df[,8]  ## Still is categorical -> need to transform as numeric
cars_origin.df[,8] = sapply(cars_origin.df[,8],as.numeric)
cars_origin.df[,8]

str(cars_origin.df)
pairs(cars_origin.df[,-1])  ## Now is working as all vars are numerical

## correlation matrix
library(corrplot)
mcor <- cor(cars_origin.df[,-1])
round(mcor, digits=2)
corrplot(mcor)
col <- colorRampPalette(c('#BB4444','#EE9988', '#FFFFFF','#77AADD','#4477AA'))
corrplot(mcor, method='shade', shade.col=NA, tl.col='black', tl.srt=45,
         col=col(200), addCoef.col='black', addcolorlabel='no', order='AOE')

library(ggcorrplot)
library(ggthemes)
ggcorrplot(mcor, hc.order=T, lab=T, ggtheme = theme_tufte())
?ggcorrplot # - use this corrplot!

attach(cars_origin.df)
# 3d plots
library(scatterplot3d)
?scatterplot3d
#order of variables in scatterplot3d function are x1 (width), x2 (depth), and y (height)
s3d <- scatterplot3d(Cylinders,MPG.city,EngineSize, type = "p",highlight.3d = TRUE, pch = 20)
# Add regression plane
mod1_1 <- lm(MPG.city ~ Cylinders + EngineSize, data=cars_origin.df)
s3d$plane3d(mod1_1,draw_polygon = TRUE, draw_lines = TRUE)
mod1_2 <- lm(Cylinders ~  MPG.city + EngineSize, data=cars_origin.df)
s3d$plane3d(mod1_2,draw_polygon = TRUE, draw_lines = TRUE)
mod1_3 <- lm(EngineSize ~  MPG.city + Cylinders, data=cars_origin.df)
s3d$plane3d(mod1_3,draw_polygon = TRUE, draw_lines = TRUE)
# PLot 2
s3d2 <- scatterplot3d(Cylinders,Horsepower,EngineSize, type = "p",highlight.3d = TRUE, pch = 20)
mod2_1 <- lm(Cylinders ~ Horsepower + EngineSize, data=cars_origin.df)
s3d2$plane3d(mod2_1, draw_polygon = TRUE, draw_lines = TRUE)
mod2_2 <- lm(Horsepower ~ Cylinders + EngineSize, data=cars_origin.df)
s3d2$plane3d(mod2_2, draw_polygon = TRUE, draw_lines = TRUE)
mod2_3 <- lm(EngineSize ~ Horsepower + Cylinders, data=cars_origin.df)
s3d2$plane3d(mod2_3, draw_polygon = TRUE, draw_lines = TRUE)
# Plot 3
s3d3 <- scatterplot3d(Cylinders,Fuel.tank.capacity,EngineSize, type = "p",highlight.3d = TRUE, pch = 20)
mod3_1 <- lm(Cylinders ~ Fuel.tank.capacity + EngineSize, data=cars_origin.df)
s3d3$plane3d(mod3_1, draw_polygon = TRUE, draw_lines = TRUE)
mod3_2 <- lm(Fuel.tank.capacity ~ Cylinders + EngineSize, data=cars_origin.df)
s3d3$plane3d(mod3_2, draw_polygon = TRUE, draw_lines = TRUE)
mod3_3 <- lm(EngineSize ~ Cylinders + Fuel.tank.capacity, data=cars_origin.df)
s3d3$plane3d(mod3_3, draw_polygon = TRUE, draw_lines = TRUE)
# Plot 4
s3d4 <- scatterplot3d(Fuel.tank.capacity,Horsepower, MPG.city, type = "p",highlight.3d = TRUE, pch = 20)
mod4_1 <- lm(MPG.city ~ Fuel.tank.capacity + Horsepower, data=cars_origin.df)
s3d3$plane3d(mod4_1, draw_polygon = TRUE, draw_lines = TRUE)
mod4_2 <- lm(Horsepower ~ MPG.city + Fuel.tank.capacity, data = cars_origin.df)
s3d4$plane3d(mod4_2, draw_polygon = T, draw_lines = T)
mod4_3 <- lm(Fuel.tank.capacity ~ Horsepower+MPG.city, data = cars_origin.df)
s3d4$plane3d(mod4_3, draw_polygon = TRUE, draw_lines = TRUE)
# maybe a relnship between cylinders and fuel.tank.capacity from 3_3 lm
# also 4_3 lm

# test to check whether dataset suitable for implementing data reduction techniques
library(parameters) 
?check_sphericity_bartlett
check_sphericity_bartlett(cars_origin.df[,-1])
# sufficient significant correlation

# PCA
# base R
pca1 = prcomp(cars_origin.df[,-1], scale. = FALSE)
pca1
summary(pca1)
?prcomp
pc_scale <- prcomp(cars_origin.df[,-1], scale = TRUE)
pc_scale
# using princomp function
?princomp
mod_princomp <- princomp(cars_origin.df[,-1], cor=TRUE)
mod_princomp

# using factominer
library(FactoMineR)
?PCA
mod_miner <- PCA(cars_origin.df[,-1], scale.unit = TRUE)
mod_miner

#(a) eigenvalues and eigenvectors
# sqrt of eigenvalues
pc_scale$sdev
# eigen values
ev = (pc_scale$sdev)^2; ev
mod_princomp$sdev^2
mod_miner$eig

# eigenvectors = loadings (=rotation)
pc_scale$rotation
mod_princomp$loadings
mod_miner$var


# (b) amount of info explained by each component and cum variance
summary(pc_scale)
summary(mod_princomp)
mod_miner$eig

# (c) resulting factor loadings (equivalent to eigenvectors)
pc_scale$rotation
# loadings  (cor(Z,X)= u(sqrt(lambda))/sqrt(var(X)*lambda))
head(pca1$rotation) ## show the correlation between the var and PCs
# PCs (aka scores) --> weight of each X(state) in the PCi
head(pc_scale$x, n=5L) ## show the scores (value of the rotated data)
head(mod_miner$ind$coord)

# (d) correlations between variables and PCs
pc_scale$rotation # 'factor matrix'
biplot(pc_scale)
?biplot

cos2 <- mod_miner$var$cos2
colnames(cos2) <- c('PC1','PC2','PC3','PC4','PC5')
cos2

fviz_contrib(pc_scale, choice = "var", axes = 1, top = 8)
fviz_contrib(pc_scale, choice = "var", axes = 2, top = 8)

# (e) screeplot
plot(pc_scale)
screeplot(pc_scale, type='lines', main='')
?screeplot
fviz_screeplot(mod_miner)

# (f) use PC scores to interp reln between obs & each component
row.names(cars_origin.df)
cars_origin.df['Mercedes-Benz 190E',]
pc_scale$x["Mercedes-Benz 190E          ",]
row.names(pc_scale$x)

# (g) factoMineR, factoextra
library(factoextra)
fviz_eig(pc_scale) # screeplot
fviz_pca_var(pc_scale) # correlation circle - like the biplot
fviz_pca_ind(pc_scale) # 
fviz_pca(pc_scale, xlab='PC1', ylab='PC2') # biplot
# join df to 
head(cars_origin.df$Origin)
cars.pca <- PCA(cars_origin.df[,-c(1)], graph = FALSE)
fviz_pca_ind(cars.pca, geom.ind = 'point', col.ind = cars_origin.df$Origin,
             addEllipses = TRUE, legend.title='Origin of cars', 
             geom.var=c("arrow"))

fviz_pca_biplot(cars.pca, col.ind = cars_origin.df$Origin, addEllipses = TRUE,
                legend.title='Origin of cars', geom.ind = 'point',
                xlab='PC1', ylab='PC2')

fviz_pca_biplot(pc_scale, col.ind = cars_origin.df$Origin, addEllipses = TRUE,
                legend.title='Origin of cars', geom.ind = 'point',
                xlab='PC1', ylab='PC2')

# USA only

x <- split(cars_origin.df, cars_origin.df$Origin)
head(x[['USA']]$Origin)
usa <- x[['USA']][,-1]
head(usa)
nrow(usa)

# PCA
# base R
usa_prcomp = prcomp(usa, scale. = TRUE)
usa_prcomp
# using factominer
usa_miner <- PCA(usa, scale.unit = TRUE)
usa_miner

#(a) eigenvalues and eigenvectors
# sqrt of eigenvalues
usa_prcomp$sdev
# eigen values
ev = (usa_prcomp$sdev)^2; ev
usa_miner$eig

# eigenvectors = loadings (=rotation)
usa_prcomp$rotation
usa_miner$var

# (b) amount of info explained by each component and cum variance
summary(usa_prcomp)
summary(usa_miner)
usa_miner$eig

# (c) resulting factor loadings (equivalent to eigenvectors)
usa_prcomp$rotation
# loadings  (cor(Z,X)= u(sqrt(lambda))/sqrt(var(X)*lambda))
# PCs (aka scores) --> weight of each X(state) in the PCi
head(usa_prcomp$x, n=5L) ## show the scores (value of the rotated data)
head(usa_miner$ind$coord)

# (d) correlations between variables and PCs
usa_prcomp$rotation # 'factor matrix'
#biplot(usa_prcomp) # use factoextra biplot instead

usa_cos2 <- usa_miner$var$cos2
colnames(usa_cos2) <- c('PC1','PC2','PC3','PC4','PC5')
usa_cos2

fviz_contrib(usa_prcomp, choice = "var", axes = 1, top = 8)
fviz_contrib(usa_prcomp, choice = "var", axes = 2, top = 8)

# (e) screeplot
plot(usa_prcomp)
screeplot(usa_prcomp, type='lines', main='')
fviz_screeplot(usa_miner)

# (f) use PC scores to interp reln between obs & each component
row.names(usa)
usa["Ford          Crown_Victoria",]
usa_prcomp$x["Ford          Crown_Victoria",]

# (g) factoMineR, factoextra
fviz_eig(usa_prcomp) # screeplot
fviz_pca_var(usa_prcomp) # correlation circle - like the biplot
fviz_pca_ind(usa_prcomp) # 
fviz_pca(usa_prcomp, xlab='PC1', ylab='PC2') # biplot
