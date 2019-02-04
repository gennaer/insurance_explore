library(data.table)

# import data file
data1 <- fread('LoanStats3a.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")
data2 <- fread('LoanStats3b.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")
data3 <- fread('LoanStats3c.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")
data4 <- fread('LoanStats3d.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")

data5<- fread('LoanStats_2016Q1.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")
data6<- fread('LoanStats_2016Q2.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")
data7<- fread('LoanStats_2016Q3.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")
data8<- fread('LoanStats_2016Q4.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")

data9<- fread('LoanStats_2017Q1.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")
data10<- fread('LoanStats_2017Q2.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")
data11<- fread('LoanStats_2017Q3.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")
data12<- fread('LoanStats_2017Q4.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")

data13<- fread('LoanStats_2018Q1.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")
data14<- fread('LoanStats_2018Q2.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")
data15<- fread('LoanStats_2018Q3.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="id")

allData <- rbind(data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12,data13,data14,data15)

write.csv(allData,file='allLoanData.csv')