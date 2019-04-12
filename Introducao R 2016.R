##### Script Tutorial

#####  O script abaixo  mostrara varios aspectos basicos do  R.  
 
#############################################################################
### Lendo Dados
#############################################################################

### Por default o R ira ler e salvar os arquivos no diretorio onde o R foi aberto.


### ver qual o diretório atual
getwd()

### No Windows ou na MAC o diretorio pode ser alterado utilizando a interface grafica
##  Misc > Change Working Directory


### Defina abaixo o diretorio dos dados  e o diretorio de trabalho.

wrk.dir <- "C:/Users/Nilza/Dropbox/Apresentacao 2016/Curso R/Scripts/" # laptop MB
dat.dir <- "C:/Users/Nilza/Dropbox/Apresentacao 2016/Curso R/Scripts/" # laptop MB
setwd(wrk.dir)

# vamos ler o arquivo exemple1.csv que deverá estar no diretorio atual
DAT <- read.table(paste(dat.dir, "example1.csv", sep = ""), sep = ",", header = TRUE)
class(DAT$date) <- "POSIXct"  ## Mude a classe da variavel date.  Mais detalhes abaixo

###  Ja que estamos aqui, vamos gravar os dados os dados? - para gravar dados use o comando WRITE.TABLE.

write.table(DAT, "test.csv", sep = ",")

### *** parametros no comando READ.TABLE: header - indica que há uma cabeçalho que serão os nomes da coluna.sep = indica que os campos sao separados por colunas.

###  checando os dados
dim(DAT)  ### dimensao dos dados. 
head(DAT) ### 
tail(DAT)  ### mostra as 10 primeiras linhas


#############################################################################
##### Formas de lidar com data.frames e criar subconjuntos 
#############################################################################

### Por dimensao

DAT[1:10, 1:5]

### Pelo nome das colunas "$" indica o nome
unique(DAT$site)  # retorna valores sem duplicar
range(DAT$frcs)  # exibe valores minimo e maximo 
DAT$obs[1:20]

#### Criando novas variaveis 

DAT$obs.frh <-  DAT$obs + 9/5 + 32  #acesse DAT e diga o que aconteceu!!
### subconjunto de dados dada uma condicao para colunas 

## create row id
id <- DAT$obs > 20
tail(id)
sum(id)   ##???

DAT.sub <- DAT[id, ]
tail(DAT.sub)

#### Obter dados onde coluna site=HVAR
DAT.sub <- DAT[DAT$site == "HVAR", ]
tail(DAT.sub)


#############################################################################
#### Basic plotting 
#############################################################################

### Tudo em um grafico pode ser modificado!!!  

plot(DAT.sub$date, DAT.sub$obs)

### adicionado alguns detalhes
plot(DAT.sub$date, DAT.sub$obs, xlab = "Date", ylab = "Temperature", main = "HVAR Temperature")


### pch define o simbolo a ser utilizado, cex = tamanho do simbolo, col = cor.
plot(DAT.sub$frcs, DAT.sub$obs, xlab = "Forecast", ylab = "Observed",pch  = 16,col = DAT$forecastor, cex = 2, main = "HVAR")  # explique o col= DAT$forecastor!! 
# veja que estamos usando um subconjunto de DAT onde site=HVAR

legend("bottomright", legend = levels(DAT.sub$forecastor), col =1:13 , pch = 16 ) # explicar fator e uso levels
abline(0,1)

### Veja que o R converteu DAT$forecastor em numeros que definem as cores, mas as cores tambem podem ser definidas
#   com palavras: "blue", "red", etc. 
## paleta de cores mais avançadas tambem estao disponíveis

#### Salvar o graficos.  No wndoes ou no MAC os graficos podem ser salvas com a interface grafica (eu nao aconselho!)

png("test2.png", width = 600, height = 600)  ## Por padrao png define o tamanho da figura me pixels.
### outras unidades podem ser definidas se mudarmos o argumento 'units' .De uma olhada no help!! ?units

plot(DAT.sub$frcs, DAT.sub$obs, xlab = "Forecast", ylab = "Observed",pch  = 16,col = DAT$forecastor, cex = 2, main = "HVAR")  # explique o col= DAT$forecastor!! 
# veja que estamos usando um subconjunto de DAT onde site=HVAR

legend("bottomright", legend = levels(DAT.sub$forecastor), col =1:13 , pch = 16 ) # explicar fator e uso levels
abline(0,1)

plot(DAT.sub$date, DAT.sub$obs)

dev.off()   

### Outros tipos de arquivos para graficos: bitmap,pdf,jped e postscript

### Simbolos dos graficos. Veja que as cores se repetem apos 8 item.  This can cause some confusion.
plot(1:25, 1:25, pch = 1:25, col = 1:25, cex = 2)


### Veja tambem: heat.colors, topo.colors,  colors, palette, hsv, hcl, rgb, gray and col2rgb para obter o numeros  RGB.
plot(1:25, 1:25, pch = 1:25, col = rainbow(24), cex = 2)  # ?heat.colors


#### Multiplos plots
### Uma forma simples de se obter varios graficos em uma unica pagina

par(mfrow  = c(2,2), mar = c(4,4,2,1)) ### mfrow define grade  2X 2 , mar ajustas as margens

plot(1:10, 1:10, main = "Plot A")
plot(1:10, 1:10, main = "Plot B")
plot(1:10, 1:10, main = "Plot C")
plot(1:10, 1:10, main = "Plot D")

### pause
plot(1:10, 1:10, main = "Extra")
### Observe que a configuracao se mantem ate que tela seja fechada
dev.off()
## or
### graphics.off() ## fechara multiplos graficos

### Veja a funcao LAYOUT para opcoes mais assimetricas.


#### factors vs. numerics
#### Para varias funcoes e modelos estatistico o R leva em consideracao a classe do objeto, 
#### que podem alterados 

X     <- factor(c(12,14,22))
X
X + 1 ### erro n?o podemos adicionar numero a uma letra
as.numeric(X) + 1 ### por default, R converte fatores para numerico usando a ordem dos niveis (levels), 1,2,3, ... 
    ### normalmente, n?o ? o que queremos
as.numeric(as.character(X))  ### Agora sim! 
### Suponha os valores abaixo

x <- c(24220, 26000, 23000)
class(x)  ### 
### Agora vamos converte-los a fatores.

fact <- as.factor(x)
fact


#########################################################################################
#### Obtendo ajuda no R
#########################################################################################

help.start()  ### acesso a um help no browser. Chamado na interface grafica. 
### Na pagina incial , veja "An Intro to R", "Packages", or "Search Engine".
?boxplot ### Se vc conhece o comando, digite ?comando para acessar a pagina de ajuda
demo()
demo("graphics")
example("boxplot")

### Online, www.r-project.org
### Manuais, livros, etc.
### Mailing lists - j? me ajudaram bastante!


#########################################################################################
#### Pacotes in R.
#########################################################################################

#### Online www.r-project.org
#### Selecine CRAN > "Selecione um mirror" > Onde encontramos o R para instalacao.
#### 
#### Baixando o pacote VERIFICATION 

install.packages("verification", dependencies = TRUE) # Tente utilizar a interface grafica

### Antes de utilizar o pacote devemos carrega-lo

library(verification)

### go to help browser to find information about package

example(verify) # nao rodou no Rscript, mas tente na interface do R!
example(InsectSprays) # exemplo do help do R!! Muito bom, pessoal!

help(package="verification")  # descobrindo os comando deste pacote

### Verify e uma funcao que inclui varios metodos  
mod <- verify(obs = DAT$obs, pred = DAT$frcs, frcst.type = "cont", obs.type = "cont")

summary(mod)  # nao conhece o comando? Obtenha ajuda!Nos diga o que acontece.

#########################################################################################
#### Muito importante na DPN!! Manipulando datas e horas 
#########################################################################################

#####dates

 ### Formatando datas
### Algumas vezes lidar com datas no R pode ser bem complexo, mas ? tamb?m bastante flexivel.

## R converte  de data para caracter com a funcao strptime

X <- "20081225  13:30:30"

T1 <- strptime(X, format = "%Y%m%d  %H:%M:%S", tz = "GMT")
class(T1)  ## POSIXlt is a complex time format, with separate objects for each component of time.
length(T1)
names(T1)
T1$year  ## ??? VRF saida!

### Normalmente, data pode ser lidas mais facilmente com o formato POSIXct.

T2 <- as.POSIXct(T1)
length(T2)

### Converte de caracter para datas veja "strptime"
### Veja tambem  as.POSIXct, as.POSIXlt ...
### Veja ?axis.Date  para informa??es sobre formatacao de eixos com diferentes intervalos

#Executando o R 

source("Myscript.R")

# Executar no Shell: Instalarr Rscript  # uso este, pois consigo fazer todo o script na linguagem R sem
#                    misturar com shell

# Executar na linha de comando ou dentro de um script shell

# R CMD BATCH Myscript.R   # costumava usar este comando dentro do script shell





