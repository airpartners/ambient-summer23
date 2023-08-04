#' Load CSV Data from file_name into a data.table object
#'
#' This function reads a CSV file specified by `file_name` into a data.table
#' object. If the file reading encounters any errors, it will print an error
#' message and return. The function also creates an output folder specified by
#' `output_folder` if it doesn't already exist.
#'
#' @param file_name A character value representing the path to the CSV file.
#' @param output_folder A character value for the path to the output folder.
load_csv_data <- function(file_name, output_folder) {
  dir.create(output_folder, recursive = TRUE, showWarnings = FALSE)
  
  # Read the CSV file into a data.table, handle parsing errors
  tryCatch({
    data <- fread(file_name, data.table = FALSE)
  }, error = function(e) {
    message("Error reading ", file_name, ": ", conditionMessage(e))
    return()
  })
}

#' Split and Save CSV Data into Separate Files for Each Month
#'
#' This function takes a data frame (`data`) containing a 'timestamp_local'
#' column and filters the data based on the specified `start_date` and
#' `end_date`. It then splits the filtered data into separate data frames for
#' each month and saves them as individual CSV files with the provided `name`
#' in the filename. The output files will be stored in the current working
#' directory.
#' 
#' @param data A data frame containing the data to be split and saved.
#' @param name A char value that is the base name of the output CSV files.
#' @param start_date A char value representing the start date for filtering.
#' @param end_date A char val representing the end date for filtering.
breakdown_csv <- function(data, name, start_date, end_date) {
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