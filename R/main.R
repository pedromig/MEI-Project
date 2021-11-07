#!/usr/bin/env Rscript

source("esp.R")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Usage: ./main.R {FILE}");
}

out <- "../plots"
if (!dir.exists(out)) {
  dir.create(out)
}

df <- esp.filter(read.csv(args[1], header = T, sep = ","));
code1 <- df[[1]]
code2 <- df[[2]]

esp.sc3d(code1, file.path(out, "c1sc3d"));
esp.sc3d(code2, file.path(out, "c2sc3d"));

esp.sc2d(code1, file.path(out, "c1sc2d"));
esp.sc2d(code2, file.path(out, "c2sc2d"));
