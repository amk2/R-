#
# Entendendo Fatores e Listas no R
# Fonte : Data Manipulation with R - Phil Spector
# Fatores: -assume um número limitado de valores
#          -normalmente, variaveis categóricas
#          - muito usado em modelagem estatistica
# -fatores utilizam menos espaço, pois R arquiva cada nivel (level) só uma vez
# variaveis numericas ou caracteres podem ser transformadas em fatores (FACTOR), mas os niveis (levels) dos fatores 
# serao sempre caracter. Os dados dos fatores são armazenados com vetores de inteiros.
# Por isso o read.table convertera as variaveis caracter em fatores, exceto se definirmos
# 
#
 data <- c(1,2,2,3,1,2,3,3,1,2,3,3,1) # é um vetor e nao um array!! 
 
 fdata <- factor(data)
 
 dim(fdata) # veja o que acontece. Por que? Dica: veja o help.
 
 fdata  # qual a diferença de data?
 
 attributes (fdata)
 #
 # alterando valores (levels)
 #

 rdata = factor(data,labels=c("I","II","III"))
 rdata
 attributes(rdata) # o levels são os mesmos?
 #
 # Ordenando fatores para permitir comparacoes 
 #
 mons = c("March","April","January","November","January",
             "September","October","September","November","August",
             "January","November","November","February","May","August",
             "July","December","August","August","September","November",
             "February","April")
 mons = factor(mons)
 table(mons) # pequena estatistica dos dados
 mons
 #
 # Considerando a ordem dos dados para fins de comparaca
 # 
mons = factor(mons,levels=c("January","February","March", "April","May","June","July",
                            "August", "September","October","November","December"),ordered=TRUE)
mons[1] < mons[2]

#
# Considerando a ordem dos dados para fins de comparaca
#
fert = c(10,20,20,50,10,20,10,50,20)
fert = factor(fert,levels=c(10,20,50),ordered=TRUE)  # definindo que a ordem importa
attributes(fert)
fert
table(fert)
#
#Mas se precisamos realizar algumas estatistica precisamos retornar 
#
mean(fert)  # o que acontece?

mean(as.numeric(levels(fert)[fert])) # metodo 1 para definir os niveis com numericos
mean(as.numeric(as.character(fert))) # metodo 2 para definir os niveis com numericos. converte para caracter e depois numerico!

levels(fert)[1]  # acessando o niveis
#
# Manipulando fatores
#
head(women)   # dados disponiveis no R.
?women        # peso em lbs e altura em in
range(women$weight)
#
wfact = cut(women$weight,3) # cria intervaloes para a variavel amplitude dos intervalos (164-115)/3=49/3=16.33
table(wfact)
#
wfact = cut(women$weight,3,labels=c("Low","Medium","High"))
table(wfact)

# RESUMO DE COMANDOS

# FACTOR, LEVELS, NLEVELS,ATTRIBUTES, cut, range,as.character,as.numeric,table

##########################################################################################
#
# LISTAS - 
##########################################################################################

# Aceita dados de diferente tipos e tamanhos
# Algumas funcoes do R retornam resultados como listas

mylist = list(a=c(1,2,3),b=c("cat","dog","duck"), d=factor("a","b","a"))
sapply(mylist,mode)
mylist 

mylist = list(c(1,4,6),"dog",3,"cat",TRUE,c(9,10,11))
mylist 
mylist[1]
mylist[2]

