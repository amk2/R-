##### ivw tutorial script

#####  The following script will step you through several basic aspects of R.  

#############################################################################
### Reading in data
#############################################################################

### by default, R will read and write files into the default directory.  In linux, this will be the directory in which R was opened.

### to see which directory is the default directory
getwd()

### in windows or Mac OS, the directory can be set using the gui.
##  Misc > Change Working Directory


### Assuming that the data is in the following directory.  Please change to reflect the correct location.
#dat.dir <- "H:\\FMI.tutorial\\presentations\\pocernich\\"
#wrk.dir <- "H:\\FMI.tutorial\\work"


dat.dir <- "/home/03390878700/Documentos/"
wrk.dir <- "/home/03390878700/Documentos/"




setwd(wrk.dir)

DAT <- read.table(paste(dat.dir, "example1.csv", sep = ""), sep = ",", header = TRUE)
class(DAT$date) <- "POSIXct"  ## changes class of date.  More later

### while we are here - to write data, use the command write.table

write.table(DAT, "test.csv", sep = ",")

### *** key options in the read.table command, header indicate there is a header.  These labels will be used to label columns.  sep = indicates what character is used to separate columns.

### check data source
dim(DAT)  ### dimension of data.  This should conform to the data source.
head(DAT) ### top of data
tail(DAT)  ### check  first and last 10 rows


#############################################################################
##### ways to handle and subset data.frames
#############################################################################

### by dimension

DAT[1:10, 1:5]

### by column name  "$" indicates name
unique(DAT$site)
range(DAT$frcs)
DAT$obs[1:20]

#### create a new variable

DAT$obs.frh <-  DAT$obs + 9/5 + 32
### subset by conditioning rows

## create row id
id <- DAT$obs > 20
tail(id)
sum(id)

DAT.sub <- DAT[id, ]
tail(DAT.sub)

#### get data from HVAR
DAT.sub <- DAT[DAT$site == "HVAR", ]
tail(DAT.sub)


#############################################################################
#### Basic plotting 
#############################################################################

### everything on a plot can be modified!!!  

plot(DAT.sub$date, DAT.sub$obs)

### add some detail
plot(DAT.sub$date, DAT.sub$obs, xlab = "Date", ylab = "Temperature", main = "HVAR Temperature")


### pch defines plotting character, cex = character size, col = color.
plot(DAT.sub$frcs, DAT.sub$obs, xlab = "Forecast", ylab = "Observed",pch  = 16, 
  col = DAT$forecastor, cex = 2, main = "HVAR")

legend("bottomright", legend = levels(DAT.sub$forecastor), col =1:13 , pch = 16 )
abline(0,1)
### OBS: quando rodar no jupyter R , colocar as tres linhas juntas na mesma linha


### note that R converts DAT$forecastor to a number which can define a color.  Colors can also be defined using words e.g. "blue"
### more advanced color pallette are available.  


#### to save a plot.  In windows or Mac OS, a plot can be saved using the GUI.  Using code,

png("test.png", width = 600, height = 600)  ## by default, png specifies figure sizes in pixels.   Other units can be used
###if the argument "units" is changed.

plot(DAT.sub$date, DAT.sub$obs)

dev.off()

### Other common types of plots include bitmap, pdf, jpeg and postscript.

### default plotting symbols.  Note how the color repeat after 8.  This can cause some confusion.
plot(1:25, 1:25, pch = 1:25, col = 1:25, cex = 2)

### See Also heat.colors, topo.colors,  colors, palette, hsv, hcl, rgb, gray and col2rgb for translating to RGB numbers.
#### multiple plots
### a simple way to put multiple plots on a single page.

par(mfrow  = c(2,2), mar = c(4,4,2,1)) ### mfrow defines the 2 by 2 grid, mar adjusts the margins

plot(1:10, 1:10, main = "Plot A")
plot(1:10, 1:10, main = "Plot B")
plot(1:10, 1:10, main = "Plot C")
plot(1:10, 1:10, main = "Plot D")

### pause
plot(1:10, 1:10, main = "Extra")
### note, the par setting remain until you close the window
dev.off()
## or
### graphics.off() ## will close mulitple windows.

### See the function layout for more asymetrical options.


#### factors vs. numerics
#### for many function and statistical models, R take into account the class of each object.  While classes are often determined by default, they can of often need to be changed.

X     <- factor(c(12,14,22))
X
X + 1 ### generates error - you can't add a number to a word.
as.numeric(X) + 1 ### by default, R converts a factor to numeric using the order of the levels, 1,2,3, ... 
    ### this is likely not what someone wants.
as.numeric(as.character(X))  ### what we likely want
### suppose you have been given  a list of postal codes

x <- c(60643, 60655, 60606)
class(x)  ### 
### they are actually labels and you may want to convert them to factors.

fact <- as.factor(x)
fact


#########################################################################################
#### 5 ways to get help in R.
#########################################################################################

help.start()  ### launches a browser based help. This can be called on the gui.
### on the front page of help , see "An Intro to R", "Packages", or "Search Engine".
?boxplot ### if you know the command, ?command will call up the help page
demo()
demo("graphics")
example("boxplot")

### Online, www.r-project.org
### Manuals, books, other
### Mailing lists -  but search archive first!


#########################################################################################
#### packages in R.
#########################################################################################

#### packages online www.r-project.org
#### Select CRAN > "Choose a mirror site" > this is where you would get R binaries and source code as well.  Currently 1779 packages.
#### Task view may help you find information by topic.
#### See verification package

### install.package("verification, dependencies = TRUE)  ## no need to run - these packages are already installed on your machinces.

### before using a library, a package must be loaded.

library(verification)

### go to help browser to find information about package

example(verify)

### verify is function that includes many methods.  (Its overloaded.)  Depending on the 
mod <- verify(obs = DAT$obs, pred = DAT$frcs, frcst.type = "cont", obs.type = "cont")

summary(mod)

#########################################################################################
#### special topics, 
#########################################################################################

#####dates

 ### to format a date
### Handling dates in R can be viewed as cumbersome and awkward.  On the other hand, it can be viewed as very thorough and flexible

## to read in odd date formats, R converts character strings to a data class using strptime function

X <- "20081225  13:30:30"

T1 <- strptime(X, format = "%Y%m%d  %H:%M:%S", tz = "GMT")
class(T1)  ## POSIXlt is a complex time format, with separate objects for each component of time.
length(T1)
names(T1)
T1$year

### Typically, dates can be used  more easily in the POSIXct format

T2 <- as.POSIXct(T1)
length(T2)

### to convert characters into dates see "strptime"
### also see as.POSIXct, as.POSIXlt ...
### see ?axis.Date for information on formating the axis with different intervals.


#########################################################################################
#### a simple loop.
#########################################################################################

### Make 9 plots of observed - forcast for the the first nine stations.

stations <- unique(DAT$site)[1:6]
for(i in 1:6){
	sub <-DAT[DAT$site == stations[i], ] ##  subset data.  Note many plotting function also have a subset argument.
	png(paste("fig.", stations[i], ".png", sep = ""))
	plot(sub$date, sub$obs, main = stations[i])
	dev.off()
	}

### A simple loop illustrating resampling.
value <- verify(obs = DAT.sub$obs, pred = DAT.sub$frcs, frcst.type = "cont", obs.type = "cont")$MSE

OUT <- numeric()

for(i in 1:100){
id <- 1:nrow(DAT.sub)
id.resample <- sample(x = id, size = nrow(DAT.sub), replace = TRUE )
sub <- DAT.sub[id.resample, ]
mod <- verify(obs = sub$obs, pred = sub$frcs, frcst.type = "cont", obs.type = "cont")
OUT[i] <- mod$MSE
}

hist(OUT)
abline(v = value, col = 2, lwd = 2)
### note - this is not the best way to bootstrap data.  See boot function for 
### for further details.


### extra - the package lattice provides a much more powerful set of tools for exploring arrays of data.  This package has a very steep
### learning curve.

library(lattice)
xyplot(obs~date|site, data = DAT, as.table = TRUE, layout = c(4,5))

#########################################################################################
##### aggregate data
### to summarize data
aggregate(DAT$obs - DAT$frc, by = list(forecastor = DAT$forecastor), mean)

aggregate(DAT$obs - DAT$frc, by = list(forecastor = DAT$forecastor), mean, na.rm = TRUE)  ## can take arguments for the summary function 

aggregate(DAT$obs - DAT$frc, by = list(forecastor = DAT$site), mean, na.rm = TRUE)  ## can take arguments for the summary function 

aggregate(DAT$obs - DAT$frc, by = list(forecastor = DAT$forecastor, site = DAT$site), mean, na.rm = TRUE)  ## can take arguments for the summary 

#########################################################################################

### ensembles and matrixes
### the following example uses basic function in R to manipulate matrixes.  Many of these operations
### are useful for summarizing and describing ensembles.
### Note the usefulness of sweep and apply functions.  These functions also work with higher dimension 
### arrays.  

### create simulated data
### ensemble of 10 members + obs
X <- NULL
for(i in 1:11){
	X <- cbind(X, rnorm(100, mean = rnorm(1,20)))
	}
	
ENS <- data.frame(X)
names(ENS) <- c("obs", paste("E", 1:10, sep = ""))

####

FRC <- ENS[,-1] ### isolate forecasts
ERROR <- ENS$obs - FRC


### Estimate bias by ensembel member

BIAS <- apply(ERROR, 2, mean)

### remove bias from each member

FRC.adj <- sweep(FRC, 2, BIAS, "+")

### summarize each forecast by ensemble mean and standard deviation

ENS.mean <- apply(FRC.adj, 1, mean)	
ENS.sd <- apply(FRC.adj, 1, sd)	

### calculate the p-value of each forecast.  (The likelihood of the forecast given a specific distribution.)

ENS.pval <- pnorm(ENS$obs, mean = ENS.mean, sd = ENS.sd)

### If the forecast has good resolution, the distribution of these points will be well distributed.

hist(ENS.pval, breaks = seq(0,1, 0.1))  ### Is this uniform?  It is

### convert to probabilsitc forcast for values greater than 22

temp <- FRC.adj > 22

ENS.prob.forecast <- apply(temp, 1, sum)/10

#### calculate rank of observed value

### create a function which will operate on each row of data.

f <- function(x){
	rank(x)[1]
	}

OBS.rank <- apply(ENS, 1, f)

#### spatial plots - see fields
