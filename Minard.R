library(HistData)
library(ggmap)
library(ggrepel)

data(Minard.troops)
data(Minard.cities)
data(Minard.temp)

## Not run: 
#' ## Load required packages
require(ggplot2)
require(scales)
require(gridExtra)



#' ## plot path of troops, and another layer for city names
#' 

plot_troops <- ggplot(Minard.troops, aes(long, lat)) +
  geom_path(aes(size = survivors, colour = direction, group = group),
            lineend = "round", linejoin = "round") 
plot_cities <- geom_text 



#' ## Combine these, and add scale information, labels, etc.
#' Set the x-axis limits for longitude explicitly, to coincide with those for temperature

breaks <- c(1, 2, 3) * 10^5 
plot_minard <- plot_troops + plot_cities +
  scale_size("Survivors", range = c(1, 10), 
             breaks = breaks, labels = scales::comma(breaks)) +
  scale_color_manual("Direction", 
                     values = c("green", "red"), 
                     labels=c("Advance", "Retreat")) +
  coord_cartesian(xlim = c(24, 38)) +
  xlab("Longitude") + 
  ylab("Latitude") + 
  ggtitle("Napoleon's March on Moscow") +
  theme_bw() +
  theme(legend.position=c(.8, .2), legend.box="horizontal")

#' ## plot temperature vs. longitude, with labels for dates
plot_temp <- ggplot(Minard.temp, aes(long, temp)) +
  geom_path(color="blue", size=2.5) +
  geom_point(size=2) +
  geom_text(aes(label=date)) +
  xlab("Longitude") + ylab("Temperature") +
  coord_cartesian(xlim = c(24, 38)) + 
  theme_bw()


#' The plot works best if we  re-scale the plot window to an aspect ratio of ~ 2 x 1
# windows(width=10, height=5)

#' Combine the two plots into one
grid.arrange(plot_minard, plot_temp, nrow=2, heights=c(3,1))

march.1812.ne.europe <- c(left = 23.5, bottom = 53.4, right = 38.1, top = 56.3)

march.1812.ne.europe.map <- get_stamenmap(bbox = march.1812.ne.europe,zoom = 8 ,
                                          maptype = "watercolor", where = "cache")

march.1812.plot <- ggmap(march.1812.ne.europe.map) + geom_path(data = Minard.troops, aes(x = long, y = lat, group = group, 
                                                                                  color = direction, size = survivors),
                                                               lineend = "round") +
  geom_point(data = Minard.cities, aes(x = long, y = lat),
             color = "#DC5B44") +
  geom_text_repel(data = Minard.cities, aes(x = long, y = lat, label = city),
                  color = "#DC5B44", family = "Open Sans Condensed Bold") +
  scale_size(range = c(0.5, 10)) + 
  
  theme_nothing()

march.1812.plot

grid.arrange(plot_minard, march.1812.plot, plot_temp, nrow=3, ncol=1)

## End(Not run)

