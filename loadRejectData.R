library(data.table)

# import data file
data1 <- fread('RejectStatsA.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")
data2 <- fread('RejectStatsB.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")
data3 <- fread('RejectStatsD.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")

data4<- fread('RejectStats_2016Q1.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")
data5<- fread('RejectStats_2016Q2.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")
data6<- fread('RejectStats_2016Q3.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")
data7<- fread('RejectStats_2016Q4.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")

data8<- fread('RejectStats_2017Q1.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")
data9<- fread('RejectStats_2017Q2.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")
data10<- fread('RejectStats_2017Q3.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")
data11<- fread('RejectStats_2017Q4.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")

data12<- fread('RejectStats_2018Q1.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")
data13<- fread('RejectStats_2018Q2.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")
data14<- fread('RejectStats_2018Q3.csv',header=TRUE, data.table = FALSE, fill=TRUE, skip="Amount Requested")

allData <- rbind(data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12,data13,data14)

write.csv(allData,file='allRejectLoanData.csv')
