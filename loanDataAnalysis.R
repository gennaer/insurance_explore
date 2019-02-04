library(data.table)
library(lubridate)
library(ggplot2)
library(plyr)

# load in data that has been grouped together from 2007-2018
data <- fread('allLoanData.csv',header=TRUE, data.table = FALSE, fill=TRUE)
data$loan_amnt_m <- data$loan_amnt/1000000

# show total amount of loans per month from 2007-2018
loanTotalByMonth <- aggregate(data$loan_amnt_m,list(data$issue_d),sum)
loanTotalByMonth <- loanTotalByMonth[-c(1),] # delete empty first row
loanTotalByMonth$date <- parse_date_time(loanTotalByMonth$Group.1, "my")
loanTotalByMonth <- loanTotalByMonth[order(as.Date(loanTotalByMonth$date, format="%Y-%m-%d")),]

p <- ggplot(data=loanTotalByMonth, aes(x=date,y=x)) + geom_line(color="red",size=1)
p + labs(y = 'Total Amount Loaned per Month (in millions)', x='Date') + 
  theme(axis.text=element_text(size=12))

# group by purpose of loan
loanTotalByMonthPurpose <- aggregate(data$loan_amnt_m,list(data$issue_d,data$purpose),sum)
loanTotalByMonthPurpose <- loanTotalByMonthPurpose[-c(1),] # delete empty first row
loanTotalByMonthPurpose$date <- parse_date_time(loanTotalByMonthPurpose$Group.1, "my")
loanTotalByMonthPurpose <- loanTotalByMonthPurpose[order(as.Date(loanTotalByMonthPurpose$date, format="%Y-%m-%d")),]

p2 <- ggplot(data=loanTotalByMonthPurpose, aes(x=date,y=x,colour=Group.2))
p2 + geom_line() + labs(y = 'Total Amount Loaned per Month (in millions)', x='Date', color='Loan Purpose') + 
  theme(axis.text=element_text(size=12))

# group by "grade" (riskiness of loan)
loanGradeByMonthGrade <- aggregate(data$grade,list(data$issue_d,data$grade),length)
loanGradeByMonthGrade <- loanGradeByMonthGrade[-c(1),]
loanGradeByMonthGrade$date <- parse_date_time(loanGradeByMonthGrade$Group.1, "my")
loanGradeByMonthGrade <- loanGradeByMonthGrade[order(as.Date(loanGradeByMonthGrade$date, format="%Y-%m-%d")),]
loanGradeByMonthGrade$count1000 <- loanGradeByMonthGrade$x/1000

# read in historic stock data (NYSE) over same time period
nyse <- fread('NYA.csv',header=TRUE, data.table = FALSE)
nyse$Date <- parse_date_time(nyse$Date,"$Y-$m-$d")

p3 <- ggplot() 
p3 <- p3 + geom_bar(data=loanGradeByMonthGrade,aes(x=date,y=count1000,fill=Group.2),position="fill",stat="identity") + 
  labs(x='Date',y="Prop. Loan Risk Grade", fill='Loan Risk Grade') +
  theme(axis.text=element_text(size=12)) + 
  geom_line(data=nyse,aes(x=Date,y=Close/20000),colour='black')
p3 + scale_y_continuous(sec.axis = sec_axis(~.*20000, name = "NYSE"))

p4 <- ggplot(data=loanGradeByMonthGrade, aes(x=date,y=count1000,colour=Group.2))
p4 + geom_line() + labs(y = 'Num. Loans (Thousands)', x='Date', colour='Loan Risk Grade') + 
  theme(axis.text=element_text(size=12))

# number of loans by purpose
nLoanByPurpose <- aggregate(data$purpose,list(data$purpose),length)
# average amount requested by purpose
avgLoanByPurpose <- aggregate(data$loan_amnt,list(data$purpose),mean)
avgLoanByPurpose <- avgLoanByPurpose[-c(1),]

# number of loans by purpose by month
nLoanByMonthPurpose <- aggregate(data$purpose,list(data$purpose,data$issue_d),length)
nLoanByMonthPurpose <- nLoanByMonthPurpose[-c(1),]
nLoanByMonthPurpose$date <- parse_date_time(nLoanByMonthPurpose$Group.2, "my")
nLoanByMonthPurpose <- nLoanByMonthPurpose[order(as.Date(nLoanByMonthPurpose$date, format="%Y-%m-%d")),]

p5 <- ggplot(data=nLoanByMonthPurpose, aes(x=date,y=x,colour=Group.1))
p5 + geom_line() + labs(y = 'Number of Loans per Month', x='Date', color='Loan Purpose') + 
  theme(axis.text=element_text(size=12))

finalMonth <- nLoanByMonthPurpose[nLoanByMonthPurpose$Group.2=='Sep-2018',]
finalMonth$prop <- finalMonth$x/sum(finalMonth$x)

# compare to rejections
reject_data <- fread('allRejectLoanData.csv',header=TRUE, data.table = FALSE, fill=TRUE)
#reject_data <- reject_data[reject_data$`Loan Title`!='',]
#reject_data <- reject_data[reject_data$`Loan Title`!=' ',]

# fix some of the names in the loan title to make them match the purpose column in the accepted loans
reject_data$`Loan Title` <- tolower(reject_data$`Loan Title`)
reject_data$`Loan Title` <- gsub(" ","_",reject_data$`Loan Title`)
reject_data$purpose <- NA
reject_data$purpose[grepl("^car$",reject_data$`Loan Title`)] <- "car"
reject_data$purpose[grepl("credit_card",reject_data$`Loan Title`)] <- "credit_card"
reject_data$purpose[grepl("debt_consolidation",reject_data$`Loan Title`)] <- "debt_consolidation"
reject_data$purpose[grepl("educational",reject_data$`Loan Title`)] <- "educational"
reject_data$purpose[grepl("home_improvement",reject_data$`Loan Title`)] <- "home_improvement"
reject_data$purpose[grepl("^house$",reject_data$`Loan Title`)] <- "house"
reject_data$purpose[grepl("major_purchase",reject_data$`Loan Title`)] <- "major_purchase"
reject_data$purpose[grepl("medical",reject_data$`Loan Title`)] <- "medical"
reject_data$purpose[grepl("moving",reject_data$`Loan Title`)] <- "moving"
reject_data$purpose[grepl("other",reject_data$`Loan Title`)] <- "other"
reject_data$purpose[grepl("renewable_energy",reject_data$`Loan Title`)] <- "renewable_energy"
reject_data$purpose[grepl("small_business",reject_data$`Loan Title`)] <- "small_business"
reject_data$purpose[grepl("vacation",reject_data$`Loan Title`)] <- "vacation"
reject_data$purpose[grepl("wedding",reject_data$`Loan Title`)] <- "wedding"

reject_data$purpose[grepl("con[s|c]ol",reject_data$`Loan Title`)] <- 'debt_consolidation'
reject_data$purpose[grepl("restructure",reject_data$`Loan Title`)] <- 'debt_consolidation'
reject_data$purpose[grepl("college",reject_data$`Loan Title`)] <- 'educational'
reject_data$purpose[grepl("school",reject_data$`Loan Title`)] <- 'educational'
reject_data$purpose[grepl("student",reject_data$`Loan Title`)] <- 'educational'
reject_data$purpose[grepl("tuition",reject_data$`Loan Title`)] <- 'educational'
reject_data$purpose[grepl("education",reject_data$`Loan Title`)] <- 'educational'
reject_data$purpose[grepl("auto",reject_data$`Loan Title`)] <- 'car'
reject_data$purpose[grepl("car_|car\\>",reject_data$`Loan Title`)] <- 'car'
reject_data$purpose[grepl("vehic",reject_data$`Loan Title`)] <- 'car'
reject_data$purpose[grepl("motor",reject_data$`Loan Title`)] <- 'car'
reject_data$purpose[grepl("truck",reject_data$`Loan Title`)] <- 'car'
reject_data$purpose[grepl("cancer",reject_data$`Loan Title`)] <- 'medical'
reject_data$purpose[grepl("doctor",reject_data$`Loan Title`)] <- 'medical'
reject_data$purpose[grepl("medic",reject_data$`Loan Title`)] <- 'medical'
reject_data$purpose[grepl("surgery",reject_data$`Loan Title`)] <- 'medical'
reject_data$purpose[grepl("remodel",reject_data$`Loan Title`)] <- 'home_improvement'
reject_data$purpose[grepl("renov",reject_data$`Loan Title`)] <- 'home_improvement'
reject_data$purpose[grepl("roof",reject_data$`Loan Title`)] <- 'home_improvement'
reject_data$purpose[grepl("buy.*home",reject_data$`Loan Title`)] <- 'house'
reject_data$purpose[grepl("buy.*house",reject_data$`Loan Title`)] <- 'house'
reject_data$purpose[grepl("^home$",reject_data$`Loan Title`)] <- 'house'
reject_data$purpose[grepl("mov",reject_data$`Loan Title`)] <- 'moving'
reject_data$purpose[grepl("business",reject_data$`Loan Title`)] <- "small_business"
reject_data$purpose[is.na(reject_data$purpose)] <- "other"

reject_data$date <- as.Date(reject_data$`Application Date`,"%Y-%m-%d")
reject_data$dateMY <- parse_date_time(format(reject_data$date,"%m-%Y"),"my")

rejectAppsByMonthPurpose <- aggregate(reject_data$purpose,list(reject_data$dateMY,reject_data$purpose),length)
rejectAppsByMonthPurpose <- rejectAppsByMonthPurpose[order(as.Date(rejectAppsByMonthPurpose$Group.1, format="%Y-%m-%d")),]

rejectAppsByMonthPurpose$count1000 <- rejectAppsByMonthPurpose$x/1000

p6 <- ggplot(data=rejectAppsByMonthPurpose, aes(x=Group.1,y=count1000,colour=Group.2))
p6 + geom_line() + labs(y = 'Num. Rejected Loans (Thousands)', x='Date', color='Loan Purpose') + 
  theme(axis.text=element_text(size=12))