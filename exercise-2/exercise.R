# Exercise 2: More ggplot2 Grammar

# Install and load `ggplot2`
# install.packages("ggplot2") # if needed
install.packages("ggplot2")
library(ggplot2)

# For this exercise you will again be working with the `diamonds` data set.
# Use `?diamonds` to review details about this data set
colnames(diamonds) # "carat" "cut" "color" "clarity" "depth" "table" "price" "x" "y" "z" 
nrow(diamonds) # 53940

## Statistical Transformations

# Draw a bar chart of the diamonds data, organized by cut
# The height of each bar is based on the "count" (number) of diamonds with that cut
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

# Use the `stat_count` to apply the statistical transformation "count" to the diamonds
# by cut. You do not need a separate geometry layer!
ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))


# Use the `stat_summary` function to draw a chart with a summary layer.
# Map the x-position to diamond `cut`, and the y-position to diamond `depth`
# Bonus: use `min` as the function ymin, `max` as the function ymax, and `median` as the function y
ggplot(data = diamonds) +
  stat_summary(mapping = aes(x = cut, y = depth)) # function defaults to mean_se()


## Position Adjustments

# Draw a bar chart of diamond data organized by cut, with each bar filled by clarity.
# You should see a _stacked_ bar chart.
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

# Draw the same chart again, but with each element positioned to "fill" the y axis
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

# Draw the same chart again, but with each element positioned to "dodge" each other
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

# Draw a plot with point geometry with the x-position mapped to `cut` and the y-position mapped to `clarity`
# This creates a "grid" grouping the points
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = cut, y = clarity))

# Use the "jitter" position adjustment to keep the points from all overlapping!
# (This works a little better with a sample of diamond data, such as from the previous exercise).
ggplot(data = diamonds) +
  geom_jitter(mapping = aes(x = cut,y = clarity))

## Scales

# Draw a "boxplot" (with `geom_boxplot()`) for the diamond's price (y) by color (x)
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = color, y = price))

# This has a lot of outliers, making it harder to read. To fix this, draw the same plot but
# with a _logarithmic_ scale for the y axis.
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = color, y = log(price)))

# For another version, draw the same plot but with `violin` geometry instead of `boxplot` geometry!
# How does the logarithmic scale change the data presentation?
ggplot(data = diamonds) +
  geom_violin(mapping = aes(x = color, y = price))

ggplot(data = diamonds) +
  geom_violin(mapping = aes(x = color, y = log(price))) # makes the body of the violin wider

# Another interesting plot: draw a plot of the diamonds price (y) by carat (x), using a heatmap of 2d bins
# (geom_bin2d)
# What happens when you make the x and y channels scale logarithmically?
ggplot(data = diamonds) +
  geom_bin2d(mapping = aes(x = carat, y = price))

ggplot(data = diamonds) +
  geom_bin2d(mapping = aes(x = log(carat), y = log(price))) # linear

# Draw a scatter plot for the diamonds  price (y) by carat (x). Color each point by the clarity
# (Remember, this will take a while. Use a sample of the diamonds for faster results)
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price, color = clarity))

# Change the color of the previous plot using a ColorBrewer scale of your choice. What looks nice?
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price, color = clarity)) +
  scale_color_brewer(palette = 3)


## Coordinate Systems

# Draw a bar chart with x-position and fill color BOTH mapped to cut
# For best results, SET the `width` of the geometry to be 1 (fill plot, no space between)
# You can save this to a variable for easier modifications
bar_chart <- ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut), width = 1)

# Draw the same chart, but with the coordinate system flipped
bar_chart +
  coord_flip()

# Draw the same chart, but in a polar coordinate system. Now you have a Coxcomb chart!
bar_chart +
  coord_polar(theta = "y")


## Facets

# Take the scatter plot of price by carat data (colored by clarity) and add _facets_ based on
# the diamond's `color`
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price, color = clarity)) +
  facet_wrap(~color)

## Saving Plots

# Use the `ggsave()` function to save one of your plots (the most recent one generated) to disk.
# Name the output file "my-plot.png".
# Make sure you've set the working directory!!
ggsave(my_plot.png)

