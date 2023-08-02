load_csv_data <- function(file_name, output_folder) {
  #' 
  #'
  #' @description
  #'
  #' @param file_name char
  #' @param output_folder char

  dir.create(output_folder, recursive = TRUE, showWarnings = FALSE)
  
  # Read the CSV file into a data.table, handle parsing errors
  tryCatch({
    data <- fread(file_name, data.table = FALSE)
  }, error = function(e) {
    message("Error reading ", file_name, ": ", conditionMessage(e))
    return()
  })
}

breakdown_csv <- function(data, name, start_date, end_date) {
  #'
  #'
  #' @description
  #'
  #' @param data df
  #' @param name char
  #' @param start_date char
  #' @param end_date char

  # Filter data within the specified time range
  filtered_data <- data[data$timestamp_local >= start_date & data$timestamp_local <= end_date, ]
  
  # Create a separate CSV file for each month
  monthly_data <- split(filtered_data, format(filtered_data$timestamp_local, "%Y-%m"))
  for (month in names(monthly_data)) {
    month_data <- monthly_data[[month]]
    month_file_path <- file.path(output_folder, paste0(name, "-", month, ".csv"))
    write.csv(month_data, month_file_path, row.names = FALSE)
  }
}