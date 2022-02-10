library(readxl)
library(lubridate)
library(dplyr)
#------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------
df <- read_xlsx('C://Users/ppushpendra.STUDENT/Downloads/AMF_US-A32_BASE_HH_1-5.xlsx')
df[df==-9999] <- NA
df$DateTime <- strptime(df$TIMESTAMP_END, format = "%Y%m%d%H%M")
df$imbalance <- abs(df$NETRAD - df$G_1_1_1 -  df$LE - df$H)
#-------------Step 1--------------------------------------------------------
df$LE[df$imbalance >=300] <- NA
df$H[df$imbalance >=300] <- NA
#-------------Step 2--------------------------------------------------------
df <- df %>% group_by(Date=date(DateTime)) %>%
  mutate(daily_imbalance=mean(imbalance, na.rm=T))
df$LE[df$daily_imbalance >=50] <- NA
df$H[df$daily_imbalance >=50] <- NA

#-------------Step 3--------------------------------------------------------
df$LE[is.na(df$H)] <- NA
df$LE[is.na(df$NETRAD)] <- NA
df$LE[is.na(df$TA)] <- NA
df$count <- cumsum(is.na(df$LE))
df <- df %>%  mutate(diff = count - lag(count))
df$diff[is.na(df$diff)]<- 1
df$group <- cumsum(df$diff != lag(df$diff, default = 0))

df <- df %>% group_by(group) %>%
  mutate(counts = sum(diff))

cols <- c('NETRAD','H','RH','LE', 'G_1_1_1', 'TA', 'PA') # Variables of Interest
for (col in cols){
  ApproxFun <- approxfun(x=as.numeric(df$DateTime), y = pull(df, col))
  df[col]<- ApproxFun(as.numeric(df$DateTime))
}

df <- subset(df, df$counts <= 12)  

#-------------Step 4--------------------------------------------------------
df$temp <- 1
df <- df %>% group_by(Date) %>%
  mutate(daily_count = sum(temp))

# Final DataFrame
df <- subset(df, daily_count==48)

# Daily DataFrame
df_daily <- df %>% group_by(Date) %>%
  summarise_all(funs(mean(.,na.rm=T)))

# Visualization
plot(df_daily$NETRAD+df_daily$G_1_1_1, df_daily$LE+df_daily$H)
plot(df_daily$NETRAD)
