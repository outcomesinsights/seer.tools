# Example and possible function for denominators
# # read in 3 files of population counts
# pop_files <- c("./data/raw/SEER_1973_2012_TEXTDATA/populations/expanded.race.by.hispanic/yr2005.lo_2nd_half/singleages.txt",
#                "./data/raw/SEER_1973_2012_TEXTDATA/populations/expanded.race.by.hispanic/yr2000_2012.ca_ky_lo_nj_ga/singleages.txt",
#                "./data/raw/SEER_1973_2012_TEXTDATA/populations/expanded.race.by.hispanic/yr2000_2012.ca_ky_lo_nj_ga/singleages.txt")
# x <- lapply(pop_files, function (x) {
#         read_fwf(
#             x,
#             col_positions = pop_input_specs,
#             col_types = pop_coltype,
#             progress = FALSE)
#     }) %>%
#     rbindlist()
# denom <- x[year > 1999, .(pop = sum(population)), by = .(year)][order(year)]

