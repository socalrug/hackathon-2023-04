#!/usr/bin/env Rscript
library("optparse")
library(readr)

option_list = list(
  make_option(c("-t", "--team"), type="character", default=NULL,
              help="File with a single team name per line. If not specified it uses standard in.", metavar="character"),
  make_option(c("-o", "--out"), type="character", default=NULL,
              help="Output file name. If not specified it uses standard out", metavar="character"),
  make_option(c("-n", "--num"), type="logical", default=FALSE, action="store_true",
              help="Include an order number")
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);
file_in <- if (is.null(opt$team)) stdin() else opt$team
file_out <- if (is.null(opt$out)) stdout() else opt$out
team <- readr::read_csv2(file_in, show_col_types = FALSE)[[1]]
team_order <-
tibble(
  order = if (opt$num) seq(length(team)) else NULL,
  team = sample(team, size = length(team), replace = FALSE)) |>
  readr::write_csv(file_out, col_names = FALSE)

