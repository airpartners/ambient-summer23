library(here)
here::here()

# Render the R Markdown file with custom output settings
rmarkdown::render("plotting/polar_plots.Rmd",
                  output_dir = "figures/polar_plots",
                  output_file = "polar_plots.html")

# Plotting indv html files according to code chunks, ngl don't think this code works
# library(knitr)
#
# # Render each code chunk as a separate HTML file
# knit("plotting/polar_plots.Rmd", "pm1_plot.html", quiet = TRUE, envir = globalenv())
# knit("plotting/polar_plots.Rmd", "pm25_plot.html", quiet = TRUE, envir = globalenv())
# knit("plotting/polar_plots.Rmd", "pm10_plot.html", quiet = TRUE, envir = globalenv())
# knit("plotting/polar_plots.Rmd", "all_pms_plot.html", quiet = TRUE, envir = globalenv())
# knit("plotting/polar_plots.Rmd", "export_plots.html", quiet = TRUE, envir = globalenv())
