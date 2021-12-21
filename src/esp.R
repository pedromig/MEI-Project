#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(plotly)
  library(htmlwidgets)
})

gg_qqline2 <- function (x, y, probs = c(0.25, 0.75), qtype = 7, ...){
    stopifnot(length(probs) == 2)
    x <- quantile(x, probs, names = FALSE, type = qtype, na.rm = TRUE)
    y <- quantile(y, probs, names = FALSE, type = qtype, na.rm = TRUE)

    slope <- diff(y) / diff(x)
    int <- y[1L] - slope * x[1L]
    geom_abline(aes(slope = slope, intercept = int), linetype = 2, ...)
}

esp.qqplotm <- function(df, exams, probabilities) {
  cat("=> Generating Q-Q Plots... ")
  data <- df %>% 
    pivot_wider(names_from = solver, values_from = time) %>%
    select(-instance_seed, -solver_seed, -max_time, -slots)
   data <- data %>% filter({{exams}}, {{probabilities}})
  ggplot(data, mapping = aes(x = sort(code1), y = sort(code2))) + 
     geom_point(color = "steelblue") +
     gg_qqline2(data$code1, data$code2) +
     facet_grid(probability ~ exams, 
                labeller = labeller(
                  .rows = function (s) paste0("P = ", s),
                    .cols = function (s) paste0("N = ", s)), 
               scales = "free") + 
     labs(x = "code1", y = "code2", title = "Q-Q Plot (code 1 vs code 2)")+
     theme(plot.title = element_text(hjust = 0.5))

  ggsave(file.path(out, "qqmatrix.pdf"), width = 10, height = 10)
  cat("DONE!\n")
}

esp.sc3d <- function(df, exams, probabilities) {
  cat("=> Generating 3d scatter plots... ")
  data <- df %>% 
    pivot_wider(names_from = solver, values_from = time) %>%
    select(-instance_seed, -solver_seed, -max_time)   
  solvers <- df %>% distinct(solver) %>% pull(solver) 
  data <- data %>% filter({{exams}}, {{probabilities}})

  for (solver in solvers) {
   fig <- data %>%
      select(exams, probability, slots, as.name(solver)) %>%
      rename(time = as.name(solver)) %>%
      plot_ly(x = ~exams, y = ~probability, z = ~time, color = ~slots,
        width=1000, height=1000) %>%
      add_markers() %>%
      layout(
        title = ~paste0("\n"," Data Overview - ", solver, "\n3D Scatter Plot"),
        scene = list(
            xaxis = list(title = "Exams"),
            yaxis = list(title = "Probability"),
            zaxis = list(title = "CPU Time (s)"),
            camera = list(eye = list(x = -0.95, y = -1.9, z = 0.1))
         ),
        plot_bgcolor = 'rgb(243, 243, 243)'
      );
    f <- paste0("esp_", solver, "_sc3d.html")
    withr::with_dir(out, saveWidget(as_widget(fig), file=f))
  }
  cat("DONE!\n")
}

esp.boxplotm <- function(df, exams, probabilities) {
  cat("=> Generating box plots\n")
  data <- df %>% 
    pivot_wider(names_from = solver, values_from = time) %>%
    select(-max_time, -slots)
  solvers <- df %>% distinct(solver) %>% pull(solver) 
  data <- data %>% filter({{exams}}, {{probabilities}})
  for (solver in solvers) { 
    ggplot(data, mapping = aes(x = factor(instance_seed), 
                               y = get(solver), 
                               fill = factor(instance_seed))) + 
       stat_boxplot(geom = "errorbar") +
       geom_boxplot(outlier.fill = "black", outlier.shape = 23, outlier.size = 3) +
       stat_summary(fun = "mean", geom = "point", shape = 8, size = 2, color = "red") +
       geom_jitter(width = 0.2, color = "steelblue") +
       facet_grid(probability ~ exams, 
                  labeller = labeller(
                    .rows = function (s) paste0("P = ", s),
                    .cols = function (s) paste0("N = ", s)
                  ), scales = "free") + 
          labs(x = "Instance", y = "CPU Time (s)", 
               title = paste0("Box Plots ", solver),
               fill = "seed") +
          theme(plot.title = element_text(hjust = 0.5), axis.text.x=element_blank())
    f <-  paste0("bpmatrix_", solver, ".pdf")
    ggsave(file.path(out, f), width = 10, height = 10)
  }
}

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) {
  stop("Usage: ./main.R {FILE} {OUT}")
} 

file <- args[1]
if (!file.exists(file)) {
  stop("(", file, ") input file does not exist!")
}

out <- args[2]
if (!dir.exists(out)) {
  dir.create(out)
}

df <- read.csv(args[1], header = TRUE, sep = ",");
#esp.qqplotm(df, exams < 25)
esp.boxplotm(df, exams == 15 , probability == 0.4)
#esp.sc3d(df, probability == c(0.2,0.4,0.6, 0.8))
