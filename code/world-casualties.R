# install.packages("https://cran.r-project.org/src/contrib/Archive/WHO/WHO_0.2.1.tar.gz", source = TRUE, repos = NULL)

u = "http://api.worldbank.org/v2/en/indicator/SH.STA.TRAF.P5?downloadformat=csv"
download.file(u, "crashes.zip")
unzip("crashes.zip")
d = readr::read_csv("API_SH.STA.TRAF.P5_DS2_en_csv_v2_1682271.csv", skip = 4)
# d = data.table::fread("API_SH.STA.TRAF.P5_DS2_en_csv_v2_1682271.csv", skip = 4)
summary(d)

library(tmap)
data("World")
library(sf)
plot(World)
names(World)
head(World$name)
library(dplyr)
df1 = rename(d, name = `Country Name`)
wd = left_join(World, df1)
wd$name[is.na(wd$value)]
tm_shape(shp = wd) + tm_fill("2016")

# not all have data - refactor names - rename...
wd$name[is.na(wd$value)]
df1$name[! df1$name %in% wd$name] # mismatched names

cname = "Russia"
df1$name[grep(cname, df1$name)] = wd$name[grep(cname, wd$name)]
cname = "Britain|United King"
df1$name[grep(cname, df1$name)] = wd$name[grep(cname, wd$name)]
cname = "United States"
df1$name[grep(cname, df1$name)] = wd$name[grep(cname, wd$name)]
cname = "Venez"
df1$name[grep(cname, df1$name)] = wd$name[grep(cname, wd$name)]
cname = "Tanz"
df1$name[grep(cname, df1$name)] = wd$name[grep(cname, wd$name)]
cname = "Iran"
df1$name[grep(cname, df1$name)] = wd$name[grep(cname, wd$name)]
cname = "Bolivia"
df1$name[grep(cname, df1$name)] = wd$name[grep(cname, wd$name)]
cname = "Viet"
df1$name[grep(cname, df1$name)] = wd$name[grep(cname, wd$name)]

df1$name[! df1$name %in% wd$name]

wd = left_join(wd[1:2], df1)
wd$name[is.na(wd$value)]
tm_shape(shp = wd) + tm_fill("2016")

wd = rename(wd, `Road deaths\nper 100,000` = `2016`)

# plot the result - thanks to tmap:
# https://github.com/mtennekes/tmap
wd_mol = sf::st_transform(wd, "+proj=moll")
gr = sf::st_graticule(x = wd_mol)
x =
  tm_shape(gr) +
  tm_lines(alpha = 0.2) +
  tm_shape(wd_mol) +
  tm_borders("grey20") +
  # tm_grid(labels.size = .5, alpha = 0.2, projection = "+proj=moll") +
  tm_fill("Road deaths\nper 100,000", n = 4) +
  tm_text("name", size="AREA")
x
x +
  tm_style_bw()
tmap::tmap_save(x, "figures/road-casualties.png")
tmap::tmap_save(x, "figures/road-casualties.pdf")
browseURL("figures/road-casualties.pdf")
