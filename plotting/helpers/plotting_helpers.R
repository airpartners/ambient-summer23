#' Save a plot as JPG
#'
#' This function saves a given plot as a JPG image file.
#'
#' @param plot The plot to be saved.
#' @param filename The filename for the JPG image file (with ".jpg" extension).
save_plot_as_jpg <- function(plot, filename) {
  ggsave(
    plot,
    filename = filename,
    device = "jpg",
    width = 10,
    height = 6
  )
}

#' Save a plot as PNG
#'
#' This function saves a given plot as a PNG image file.
#'
#' @param plot The plot to be saved.
#' @param filename The filename for the PNG image file (with ".png" extension).
save_plot_as_png <- function(plot, filename) {
  ggsave(
    plot,
    filename = filename,
    device = "png",
    width = 10,
    height = 6
  )
}

#' Save a plot as SVG
#'
#' This function saves a given plot as an SVG image file.
#'
#' @param plot The plot to be saved.
#' @param filename The filename for the SVG image file (with ".svg" extension).
save_plot_as_svg <- function(plot, filename) {
  ggsave(
    plot,
    filename = filename,
    device = "svg",
    width = 10,
    height = 6
  )
}

#' Find the maximum sum of PM1, PM2.5, and PM10 values for each month
#'
#' This function takes a data frame containing PM1, PM2.5, and PM10 values,
#' grouped by month and site, and returns a data frame containing the maximum
#' sum of these values for each month.
#'
#' @param data A data frame with columns: month, sitename, and value
#'              (numeric values for PM1, PM2.5, or PM10).
#' @return A data frame with columns: month, sitename, and sum_value
#'          (maximum sum of PM1, PM2.5, and PM10 values for each month).
find_max_pollutant <- function(data) {
  max_sensors <- data %>%
    group_by(month, sitename) %>%
    summarise(sum_value = sum(value)) %>%
    group_by(month) %>%
    filter(sum_value == max(sum_value)) %>%
    select(month, sitename, sum_value)
  
  return(max_sensors)
}

#' Generate Monthly Graphs
#'
#' This function takes in a dataset of monthly pollutant averages, and generates
#' separate bar graphs for each month and location. The missing data is filled
#' with 0, and the resulting graphs are returned as a list.
#'
#' @param monthly_averages A data frame containing the monthly pollutant avr.
#' @param y_axis_max The maximum value for the y-axis in the generated graphs.
#' @param color_mapping A vector specifying the color mapping for different
#'                      pollutant types in the graphs.
#'
#' @return A list of ggplot2 objects, each representing a separate graph for
#'         each month and location.
generate_monthly_graphs <-
  function(monthly_averages,
           y_axis_max,
           color_mapping) {
    # STEP 1: FILL IN MISSING DATA AS 0
    # Create a complete grid of all possible combinations of locations and months
    all_locations <- unique(monthly_averages$sitename)
    all_months <- unique(monthly_averages$month)
    complete_grid <-
      expand.grid(sitename = all_locations, month = all_months)
    
    # Merge actual data with the complete grid and fill missing values with zeros
    monthly_averages_complete <-
      merge(complete_grid, monthly_averages, all.x = TRUE)
    monthly_averages_complete[is.na(monthly_averages_complete$value), "value"] <-
      0
    
    # STEP 2: GRAPHING
    # Create separate graphs for each month and location
    monthly_graphs <- lapply(all_months, function(m) {
      month_data <- subset(monthly_averages_complete, month == m)
      
      # Create the bar graph with the value formatted to two decimal places
      ggplot(month_data, aes(
        x = sitename,
        y = round(value, 2),
        fill = pollutant
      )) +
        geom_col(position = "stack") +
        geom_text(
          aes(label = round(value, 2)),
          position = position_stack(vjust = 0.5),
          color = "black",
          size = 1.5
        ) +
        labs(x = "Sensor ID", y = "ug/m3") +
        ggtitle(paste("Monthly Average Pollutant Levels by Sensor -", m)) +
        theme_minimal() +
        theme(
          axis.text.x = element_text(
            angle = 90,
            vjust = 0.5,
            size = 7
          ),
          legend.position = "bottom"
        ) +
        scale_fill_manual(values = color_mapping, guide = guide_legend(reverse = FALSE)) +
        coord_cartesian(ylim = c(0, y_axis_max))
    })
    
    # STEP 3: RETURN PRODUCT
    return(monthly_graphs)
  }

#' Generate Yearly Graphs
#'
#' This function takes a data frame of yearly pollutant sums for different locations
#' and generates separate bar graphs for each year and location, showing the total
#' pollutant levels by sensor. The function completes the data grid with missing
#' combinations of locations and years and fills in any missing data with zeros.
#'
#' @param yearly_sums A data frame containing yearly pollutant sums
#' @param y_axis_max Numeric value representing the maximum value for the y-axis
#'                   in the generated graphs.
#' @param color_mapping A vector of color codes used to map pollutant types to
#'                      different colors in the graphs.
#'
#' @return A list of ggplot objects, where each element represents a separate
#'         graph for each year. Each graph shows the total pollutant levels for
#'         different locations (sensor IDs) as stacked bars. The data is
#'         formatted with values rounded to two decimal places and displayed as
#'         labels on the bars.
generate_yearly_graph <- function(yearly_sums, color_mapping) {
  # STEP 1: FILL IN MISSING DATA AS 0
  # Create a complete grid of all possible combinations of locations and years
  all_locations <- unique(yearly_sums$sitename)
  all_years <- unique(yearly_sums$year)
  complete_grid <-
    expand.grid(sitename = all_locations, year = all_years)
  
  # Merge actual data with the complete grid and fill missing values with zeros
  yearly_sums_complete <-
    merge(complete_grid, yearly_sums, all.x = TRUE)
  yearly_sums_complete[is.na(yearly_sums_complete$value), "value"] <-
    0
  
  # STEP 2: GRAPHING
  # Create separate graphs for each year and location
  yearly_graphs <- lapply(all_years, function(y) {
    year_data <- subset(yearly_sums_complete, year == y)
    
    # Create the bar graph with the value formatted to two decimal places
    ggplot(year_data, aes(
      x = sitename,
      y = round(value),
      fill = pollutant
    )) +
      geom_col(position = "stack") +
      geom_text(
        aes(label = value),
        position = position_stack(vjust = 0.5),
        color = "black",
        size = 3
      ) +
      labs(x = "Sensor ID", y = "ug/m3") +
      ggtitle(paste("Yearly Total Pollutant Levels by Sensor - Yearly Sum")) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(
          angle = 90,
          vjust = 0.5,
          size = 7
        ),
        legend.position = "bottom"
      ) +
      scale_fill_manual(values = color_mapping, guide = guide_legend(reverse = FALSE))
  })
  
  # STEP 3: RETURN PRODUCT
  return(yearly_graphs)
}