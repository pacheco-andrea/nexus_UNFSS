# Analyzing data from the UNFSS to understand countries' proposed pathways for more sustainable food systems

# part of the IPBES Nexus Assessment - Chapter 5.food
# author: Andrea Pacheco (pacheco.gracia@gmail.com)

library(dplyr)
library(ggplot2)
library(treemap)

# set/change directory
wdmain <- "G:/My Drive/Projects/IPBES-Nexus/00_analyses/foodPathways-ROs/"
setwd(paste0(wdmain, "data/"))

# 1. Get data on the countries' proposed pathways at the UNFSS ----
# downloaded from the FAO https://datalab.fao.org/datalab/dashboard/food-systems-summit/

c.pathways <- read.csv("rawData_countryPathways.csv")
colnames(c.pathways)
# data show the proposed pathways ("Measure.in.Pathway") by countries, 
# These correspond to 45 themes 
# These themes fit into to 5 action areas

# Connect the pathways data to the action areas
# also downloaded from the FAO https://datalab.fao.org/datalab/dashboard/food-systems-summit/
key <- read.csv("rawData_actionAreas.csv")
head(key) 
key <- select(key, c("Action.Area","Theme"))
# check that the theme names are the same across datasets
key$Theme[order(key$Theme)] == unique(c.pathways$Theme)[order(unique(c.pathways$Theme))]

# join country pathways data with the action areas data
data <- left_join(c.pathways, key, by = "Theme")
colnames(data)
nrow(data) == nrow(c.pathways)


# 2. Visualize the nexiness of the food transformation pathways proposed at the UNFSS ----

# first, i needed to manually classify what pathways were related to what nexus element
# this was double checked with Maysoun Mustafa, who provided the following key for this classification:
setwd(paste0(wdmain, "data/"))
nexusKey <- read.csv("nexusKey.csv")
nexusKey <- select(nexusKey, c("Theme","nexusCorrected"))
colnames(nexusKey) <- c("Theme", "nexus")
data <- left_join(data, nexusKey, by = "Theme")
colnames(data)

# Select only variables of interest:
# (we do not want to consider either means of implementation nor the Priority in Pathway column)
# these extra columns were generating duplicate rows in the data
data <- select(data, c("Country","Theme", "nexus", "Measure.in.Pathway", "Action.Area"))
# remove any duplicate rows (we go from ~21000 observations to ~15000)
data <- unique(data)
nrow(data)

# Make the treemap ----

# This treemap visualizes the number of countries which proposed pathways within one of the 45 themes

# organize data for plotting
treemapData <- data %>%
  group_by(nexus, Theme) %>%
  summarize(total.countries = n_distinct(Country)) # this means the count is the number of distinct/unique countries
head(treemapData)
treemapData$nexus <- factor(treemapData$nexus,
                            levels = c("Biodiversity", "Water", "Food", "Health", "Climate", "Other"))
# abreviate names of themes which are hard to see in the treemap
treemapData$Theme <- gsub("Restoring grasslands and shrublands and savannahs", "RGSS", treemapData$Theme)
treemapData$Theme <- gsub("Resilience to Stress and Vulnerabilities", "RSV", treemapData$Theme)
treemapData$Theme <- gsub("Agrobiodiversity", "Agro- biodiversity", treemapData$Theme)

# plot treemap
# note, can change the resolution and size here!
setwd(paste0(wdmain, "outputs/"))
png(filename = "treemap_UNFSS-NexusThemes.png", width = 34, height = 24, units = "cm", bg = "white", res = 300)
treemap(treemapData,
        index = c("nexus", "Theme"),
        vSize = "total.countries",
        type = "index",
        bg.labels = "transparent",
        border.col = "gray95",
        align.labels = list(c("left", "top"), c("center", "center")),
        fontsize.labels = c(24, 12),
        fontsize.title = 25,
        fontcolor.labels = c("white", "white"),
        palette = c("#799336", "#4A928F","#B65719","#791E32","#4D2D71","#696B5F"),
        overlap.labels=0.5,   
        title = "Nexus elements present across the themes of the UNFSS response options")
dev.off()

# write out this final version of the data:
treemapData
setwd(paste0(wdmain, "outputs/"))
write.csv(treemapData, "UNFSS_nexus.csv", row.names = F)

