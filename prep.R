#start the sparkR with a package to  read csv
sparkR --packages com.databricks:spark-csv_2.10:1.0.3

#download data
download.file("https://data.cityofchicago.org/resource/alternative-fuel-locations.csv?",destfile="out.csv")

#read it as a csv
df <- read.csv(file="out.csv")

#create a dataframe from it
df <- createDataFrame(sqlContext, df)

#save it as a parquet file
saveDF(df,"out.parquet")

#read parquet file
df <- read.df(sqlContext,"out.parquet")

#register as a table and make it available for sql queries
registerTempTable(df,"nameTable")
sdf <- sql(sqlContext, "SELECT name FROM nameTable")
head(sdf)

