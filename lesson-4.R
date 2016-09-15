## Tidy data concept

counts_df <- data.frame(
  day = c("Monday", "Tuesday", "Wednesday"),
  wolf = c(2,1,3),
  hare = c(20,25,30),
  fox = c(4,4,4)
)

## Reshaping multiple columns in category/value pairs

library(tidyr)
counts_gather <- gather(counts_df,
                        key="species",
                        value="count",
                        wolf:fox)

counts_spread <- spread(counts_gather,
                        key=species,
                        value=count)

## Exercise 1

counts_gather <- counts_gather[-8,] #Remove a row from the df
counts_spread <- spread(counts_gather,
                        key=species,
                        value=count,
                        fill=0) #Assigning 0 to missing observations

## Read comma-separated-value (CSV) files

surveys <- read.csv("data/surveys.csv", na.strings="")

## Subsetting and sorting

library(dplyr)
surveys_1990_winter <- filter(surveys, #filter subsets rows
                              year==1990,
                              month %in% 1:3) #%in% for specifying an inclusive range

surveys_1990_winter <- select(surveys_1990_winter,#select subsets columns
                              -year) #remove year column

sorted <- arrange(surveys_1990_winter,#arrange reorders observations
                  desc(species_id),#default is ascending
                  weight)

## Exercise 2

exer2 <- filter(surveys,
                species_id=="RO")
exer2 <- select(exer2,
                record_id,sex,weight)

onestep <- select(filter(surveys, species_id=="RO"),record_id,sex,weight)

## Grouping and aggregation

surveys_1990_winter_gb <- group_by(surveys_1990_winter, species_id)

counts_1990_winter <- summarize(surveys_1990_winter_gb, count = n())

## Exercise 3

DM <- filter(surveys, species_id=="DM")
DM_gb <- group_by(DM, weight,hindfoot_length)
DM_summ <- summarize(group_by(D, mean())
                
summarize(group_by(DM, month), wt=mean(weight, na.rm=T),lgth = mean(hindfoot_length,na.rm=T))

## Pivot tables through aggregate and spread

surveys_1990_winter_gb <- group_by(surveys_1990_winter, ...)
counts_by_month <- ...(surveys_1990_winter_gb, ...)
pivot <- ...

## Transformation of variables

prop_1990_winter <- mutate(...)

## Exercise 4

...

## Chaining with pipes (pipe operator: %>%)

prop_1990_winter_piped <- surveys %>%
  filter(year == 1990, month %in% 1:3) %>%
  select(-year) %>% # select all columns but year
  group_by(species_id) %>% # group by species_id
  summarize(counts=n()) # summarize with counts

