#' Get Census Counts for Any Country
#' Gets population counts by age for any country using a 2-letter country code, as provided
#' by the US Census international data.
#' Derived from original code at https://raw.githubusercontent.com/walkerke/teaching-with-datavis/master/pyramids/rcharts_pyramids.R
# United States is code "US".  Use countrycode package and use FIPS 10-4 (two letter) code
#` from ISO short country name list for other countries

#' @param countries Uses gsub on URL.  Can be vector of names (eg, c("US", "UK") and will group into region if A=aggregate.
#' @param agg  This defaults to "aggregate" at the moment (other option is "separate").
#' @param years Uses gsub on URL.  Can be vector (eg, c(2015,2016,2017,2018)) and will stack years
#' @param ages is set at 10 for 5 year age groups and 15 for 1 year age groups (default)
#' @param rvalue R = 1 or -1 (Need to check this one for what it does.  Set at -1 for now.)
#' @return Results in a dataframe with one row per age. Note that even with 1 year ages, 85 is 85-89, 90 is 90-94, 95 is 95-99, and 100 is 100 and older.
#' @import magrittr
#' @examples
#' \dontrun{
#' pop1 <- get_pop_by_age("US", 2015)
#' saveRDS(pop1, "./data/analysis/us_2015_1yr.rds")
#' }
#' @export
get_pop_by_age <- function(countries, years, ages = 15, agg = "aggregate", rvalue = -1L) {
    op <- options(stringsAsFactors = FALSE)
    on.exit(options(op))
    baseurl <-
    "http://www.census.gov/population/international/data/idb/region.php?N=%20Results%20&T=tttt&A=aaaa&RT=0&Y=yyyy&R=rrrr&C=cccc"
     url <-
         gsub("yyyy", years, baseurl) %>%
         gsub("cccc", countries, .) %>%
         gsub("aaaa", agg, .) %>%
         gsub("tttt", ages, .) %>%
         gsub("rrrr", rvalue, .)
     df <-
         XML::readHTMLTable(url) %>%
         data.frame(stringsAsFactors = FALSE)
     nms <- c("year", "age", "total", "male", "female", "percent", "pctMale", "pctFemale", "sexratio")
     names(df) <- nms
     df[6:9] <- list(NULL) # remove pct rows
     df <- df[!df$age %in% c("Total", "Median Age"), ] # remove useless rows
     df$age <- gsub("(-\\d+|\\+)", "", df$age)
     df <- lapply(df, function(x) as.integer(as.character(gsub(",", "", x)))) %>%
         data.frame()
     attr(df, "site") <- "http://www.census.gov/population/international/data/idb/region.php"
     attr(df, "date_accessed") <- Sys.Date()
   return(df)
}

