#' Retrieve a single device's data and save to csv
#'
#' @description
#' This function takes a sensor ID and make an API call to https://quant-aq.com/
#' to retrieve raw and final data from Roxbury MODPM and Modulair devices. The
#' function then merges all data for that sensor (raw, final, all time in range)
#' into the same data frame and saves that data frame into a .csv file.
#'
#' @param device_id A character value representing the

process_device_id <- function(device_id) {
  # STEP 1: RETRIEVING DATA FROM QUANT-AQ
  # Initialize empty sensor data frame
  merged_data_per_sensor <- data.frame()
  for (date in time_range) {
    # Print device id and date in console
    cat(paste0("\n", device_id, ": ", date))
    # Initialize empty daily data frames
    raw_df <- data.frame()
    final_df <- data.frame()
    merged_data_per_day <- data.frame()
    for (state in c("raw/", "")) {
      # Construct device URL for API call
      device_url <-
        paste0(device_id, "/data-by-date/", state, date, "/")
      # Send GET request
      raw_data <- GET(
        url = paste0(base_url, device_url),
        authenticate(api_key, "", type = "basic"),
        encoding = "UTF-8"
      )
      # Option 1: Simply ignore the faulty API responses
      # Option 2: Commit <1af8a62915811ba44d4f7e4b2cc6eab7c97240c1> gives
      # you detailed errors
      if (status_code(raw_data) != 200) {
        cat(" Error API return !200")
        return()
      }
      data <- content(raw_data, as = "text", encoding = "UTF-8")
      parsed_data <- fromJSON(data)
      # Check if the data is empty or has zero rows
      if (is.null(parsed_data) ||
          is.null(parsed_data$data) ||
          length(parsed_data$data) == 0) {
        # Skip processing if the data is empty
        cat(" Empty data")
        next
      }
      # Save raw and final data accordingly
      if (state == "raw/") {
        raw_df <- as.data.frame(parsed_data$data)
      } else {
        final_df <- as.data.frame(parsed_data$data)
      }
    }
    
    # STEP 2: MERGE DATA HANDLERS
    # Skip processing if the either raw or final data is empty or has zero rows
    if (is.null(raw_df) || nrow(raw_df) == 0) {
      merged_data_per_day <- final_df
      cat(" Empty raw data")
    }
    else if (is.null(final_df) || nrow(final_df) == 0) {
      merged_data_per_day <- raw_df
      cat(" Empty final data")
    }
    # Merge raw and final data
    else {
      merged_data_per_day <-
        merge(raw_df, final_df, by = "timestamp_local")
    }
    cat(" -- DONE PER DAY")
    # Skip processing if the merged data is empty or has zero rows
    if (is.null(merged_data_per_day) ||
        nrow(merged_data_per_day) == 0) {
      cat("(empty day data)")
      next
    }
    # Initialize flag to track nested status
    is_nested <- TRUE
    # Flatten any nested data frames
    while (is_nested) {
      # Check if the data frame is nested
      is_nested <-
        any(sapply(merged_data_per_day, function(x)
          is.list(x) || is.data.frame(x)))
      # Flatten any nested data frames
      if (is_nested) {
        cols_to_unnest <-
          names(merged_data_per_day)[sapply(merged_data_per_day, is.data.frame)]
        # Unnest with duplicate handling strategy
        merged_data_per_day <-
          unnest_wider(
            merged_data_per_day,
            cols_to_unnest,
            names_repair = "unique",
            names_sep = ""
          )
      }
      else {
        break
      }
    }
    # Merge data per day to bigger df
    merged_data_per_sensor <-
      rbind(merged_data_per_sensor, merged_data_per_day)
  }
  
  # STEP 3: SAVE DATA TO CSV
  # Create csv file path
  csv_file_path <-
    file.path(data_folder_path, paste0(device_id, ".csv"))
  # Try writing the df into a CSV file and handle errors
  tryCatch({
    write.csv(merged_data_per_sensor, file = csv_file_path)
  },
  error = function(e) {
    cat(
      paste0("Error writing CSV file for ", device_id, "\n"),
      file = "error_log.txt",
      append = TRUE
    )
  })
  cat(paste0("\n-- DONE PER SENSOR ", device_id, " --"))
}