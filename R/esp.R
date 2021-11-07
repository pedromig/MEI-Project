#!/usr/bin/env Rscript

library(dplyr, warn.conflicts = F);
library(ggplot2, warn.conflicts = F);
library(plotly, warn.conflicts = F)
library(htmltools, warn.conflicts = F);

esp.filter <- function(df) {
  data <- df %>%
    dplyr::group_by(exams, probability, instance_seed, solver, max_time) %>%
    dplyr::summarise(
      slots = mean(slots),
      time = mean(time),
      .groups = "drop"
    );
  return(data %>%
    dplyr::group_split(solver, .keep = FALSE)
  );
}

esp.sc3d <- function(df, file) {
  fig <- df %>%
    plotly::plot_ly(x = ~exams, y = ~probability, z = ~time, color = ~time) %>%
    plotly::add_markers() %>%
    plotly::layout(
      scene = list(
        xaxis = list(title = "Exams"),
      yaxis = list(title = "Probability"),
      zaxis = list(title = "Time", dtick = 5)
    )
  );
  htmlwidgets::saveWidget(fig, paste0(file, ".html"));
}

esp.sc2d <- function(df, file) {
  ggplot2::ggplot(df) +
         ggplot2::aes(probability, time, color = exams) +
         ggplot2::geom_point();
  ggplot2::ggsave(file = paste0(file, "_pt_e", ".pdf"));

  ggplot2::ggplot(df) +
          ggplot2::aes(exams, time, color = probability) +
          ggplot2::geom_point();
  ggplot2::ggsave(file = paste0(file, "_et_p", ".pdf"));

  ggplot2::ggplot(df) +
          ggplot2::aes(exams, probability, color = time) +
          ggplot2::geom_point();
  ggplot2::ggsave(file = paste0(file, "_ep_t", ".pdf"));
}
