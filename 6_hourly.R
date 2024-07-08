# Libraries
library(DBI)
library(odbc)
library(dplyr)
library(crypto2)

# Daily Refresh for BTC
coin_list_all <- crypto_listings(
  which = "latest",
  convert = "USD",
  limit = 1000,
  start_date = sys.date(),
  interval = "day",
  quote = FALSE,
  sort = "cmc_rank",
  sort_dir = "asc",
  sleep = 0,
  wait = 60,
  finalWait = FALSE
)


# Dataframe 6: Ranks 501-600
df6 <- coin_list_all %>% filter(cmc_rank >= 501 & cmc_rank <= 600)


##

hourly_all_coins<-crypto_history(coin_list = df6,convert = "USD",limit = 100, interval= "1h",
                                 sleep = 1, start_date = Sys.Date()-1, end_date = Sys.Date()+1)



# Set up your Azure SQL Database connection
con <- dbConnect(odbc::odbc(), Driver = "ODBC Driver 17 for SQL Server",
                 Server = "cp-io-sql.database.windows.net", Database = "sql_db_ohlcv",
                 UID = "yogass09", PWD = "Qwerty@312",Port = 1433)


# Write data to the SQL database
dbWriteTable(con, "hourly_all_coins_ohlcv", hourly_all_coins, append = TRUE)

# Disconnect from the database
dbDisconnect(con)


