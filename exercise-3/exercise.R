# Exercise 3: Mapping with ggplot2

# Install and load `ggplot2` and `dplyr`
library("ggplot2")
library("dplyr")

# Read in the election data file (.csv)
# BE SURE TO SET YOUR WORKING DIRECTORY!
election <- read.csv('data/2016_US_County_Level_Presidential_Results.csv', stringsAsFactors = FALSE)

# Inspect the `election` data frame to understand the data you're working with
colnames(election) # "X" "votes_dem" "votes_gop" "total_votes" "per_dem" "per_gop" "diff" "per_point_diff" "state_abbr" "county_name" "combined_fips" 
head(election)
nrow(election) #3141

# Consider: what column contains state names? What column contains county names?
# What format are those county names in?
## State Names: state.abbr (str)
## County Names: county_name (str)

# Use `map_data()` to load the `county` map of the US, storing it in a variable
counties <- map_data("county")

# Inspect this data frame to understand what data yu're working with
View(us.states)

# Consider: what column contains state names? What column contains county names?
# What format are those county names in?
## State Names: region
## County Names: subregion

### Data Wrangling

# The format for the states and and counties are different, so we need some way to match them
# The `election` data does have FIPS codes (https://en.wikipedia.org/wiki/FIPS_county_code)
# which we can use to match. A data frame that links FIPS to the state and county names is
# available from the `maps` library (which you should install and load)

# Use `data()` to load the `"county.fips"` data frame into the environment (does not return anything)
data("county.fips")

# Inspect the `county.fips` data frame to see what you got
View(county.fips)

# Use a `join` operation to add the `fips` column to your `counties` data frame.
# Note that you may need to use `paste0()` and `mutate() to make a column of "state,county"
# to join by!
# Note: don't worry about Alaska for this exercise.
counties <- mutate(counties, polyname = paste0(region, ",", subregion))

counties <- full_join(counties, county.fips, by = c("polyname" = "polyname"))

# Now you can join the `counties` map data (with fips!) to the `election` data
# Hint: use `by = c("fips" = "combined_fips")` to specify the column to join by
election <- full_join(counties, election, by = c("fips" = "combined_fips"))

# One more change: add a column to store whether the Democrat or the Republication party
# had the higher number of votes ("won" the county)
# Hint: start by adding a column of logical values (TRUE/FALSE) of whether a party one,
#       and then join that with a simple data frame that matches to Strings
election <- mutate(election, Won = votes_dem > votes_gop)

boolean <- c(TRUE, FALSE)
Party <- c("Democrats", "Republicans")
winner <- data.frame(boolean, Party)

election <- full_join(election, winner, by = c("Won" = "boolean"))

### Data Visualization

# Finally, plot the polygons of the map!
# Be sure and specify the `x` (longitude), `y` (latitude), and `group` (group) asthetics
# Use the `coord_quick_map()` coordinate system to make it look nice
ggplot(data = election) +
  geom_polygon(aes(x = long, y = lat, group = group)) +
  coord_quickmap()

# Modify the above plot so that each geometry is filled based on which party won the county
# Specify a `manual` fill scale to make Democratic counties "blue" and Republican counties "red"
cols <- c("Democrats" = "blue", "Republicans" = "red", "NA" = "black")

ggplot(data = election) +
  geom_polygon(aes(x = long, y = lat, group = group, fill = factor(Party))) +
  coord_quickmap() +
  scale_color_manual(values = cols, aesthetics = "fill")


# For fun: how else can you fill in this map? What other insights can you produce?
