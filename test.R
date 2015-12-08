##test for SparkR
##code must be run inside SparkR, not RStudio as it has the SQL context loaded
##run sparkR on the commandline to run this code

## sources
##https://spark.apache.org/docs/latest/sparkr.html
##http://spark.apache.org/docs/latest/sql-programming-guide.html

## create a dataframe from a local dataframe
df <- createDataFrame(sqlContext,faithful)

## explore the first line
head(df)

#filter some values
dff <- filter(df, df$eruptions > 3)

#show results
head(dff)

#make back a local dataframe
d <- collect(dff)

#to read in json files, they must have a special format, one line of valid json per line
#{"name":"Davy","age":37}
#{"name":"John","age":30}


# Create the DataFrame
df <- createDataFrame(sqlContext, iris)

# Fit a linear model over the dataset.
model <- glm(Sepal_Length ~ Sepal_Width + Species, data = df, family = "gaussian")

# Model coefficients are returned in a similar format to R's native glm().
summary(model)
##$coefficients
##                    Estimate
##(Intercept)        2.2513930
##Sepal_Width        0.8035609
##Species_versicolor 1.4587432
##Species_virginica  1.9468169

# Make predictions based on the model.
predictions <- predict(model, newData = df)
head(select(predictions, "Sepal_Length", "prediction"))
##  Sepal_Length prediction
##1          5.1   5.063856
##2          4.9   4.662076
##3          4.7   4.822788
##4          4.6   4.742432
##5          5.0   5.144212
##6          5.4   5.385281


# Create the DataFrame
df <- createDataFrame(sqlContext, faithful) 

# Get basic information about the DataFrame
df
## DataFrame[eruptions:double, waiting:double]

# Select only the "eruptions" column
head(select(df, df$eruptions))
##  eruptions
##1     3.600
##2     1.800
##3     3.333

# You can also pass in column name as strings 
head(select(df, "eruptions"))

# Filter the DataFrame to only retain rows with wait times shorter than 50 mins
head(filter(df, df$waiting < 50))
##  eruptions waiting
##1     1.750      47
##2     1.750      47
##3     1.867      48

head(summarize(groupBy(df, df$waiting), count = n(df$waiting)))
##  waiting count
##1      81    13
##2      60     6
##3      68     1

# We can also sort the output from the aggregation to get the most common waiting times
waiting_counts <- summarize(groupBy(df, df$waiting), count = n(df$waiting))
head(arrange(waiting_counts, desc(waiting_counts$count)))

##   waiting count
##1      78    15
##2      83    14
##3      81    13


# Convert waiting time from hours to seconds.
# Note that we can assign this to a new column in the same DataFrame
df$waiting_secs <- df$waiting * 60
head(df)
##  eruptions waiting waiting_secs
##1     3.600      79         4740
##2     1.800      54         3240
##3     3.333      74         4440


# Load a JSON file
people <- read.df(sqlContext, "./examples/src/main/resources/people.json", "json")

# Register this DataFrame as a table.
registerTempTable(people, "people")

# SQL statements can be run by using the sql method
teenagers <- sql(sqlContext, "SELECT name FROM people WHERE age >= 13 AND age <= 19")
head(teenagers)