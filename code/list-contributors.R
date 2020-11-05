# List contributors
# source: https://github.com/Robinlovelace/geocompr/blob/master/code/list-contributors.R

# attach packages
library(gh)
library(tidyverse)

#**********************************************************
# 2 CONTRIBUTOR LIST---------------------------------------
#**********************************************************

# git has to be in PATH
out_json = gh::gh(endpoint = "/repos/ITSLeeds/rrsrr/contributors", .limit = "Inf")
link = vapply(out_json, "[[", FUN.VALUE = "", "html_url")
name = gsub(pattern = "https://github.com/", "", link)
commits = paste0("https://github.com/ITSLeeds/rrsrr/commits?author=", name)
out_df = tibble(name, link)
# remove book authors
filter(out_df, !grepl("robin", name, TRUE))
