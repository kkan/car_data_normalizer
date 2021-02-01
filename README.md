# Task

## Background information:
These example problems are similar to what we run into where we get car data from a wide variety of sources, and need to normalize the data. Many times users will have typos or use shorthand in a given field.

## Instructions:
Please complete the `normalize_data` function below to make the examples pass. Feel free to add classes or helper methods as needed. Include the version of ruby you ran your code in as a comment at the top of the file.

## Things to consider:
- "trim" refers to different features or packages for the same model of vehicle
- Valid years are from 1900 until 2 years in the future from today
- A value that can't be normalized should be returned as is
- Sometimes the trim of a vehicle will be provided in the "model" field, and will need to be extracted to the "trim" field
- The word "blank" should be returned as `nil`

# What's Done

## Data
Data was found at Ebay (https://pages.ebay.com/motors/compatibility/download.html) and imported to SQLite database (`prepare_database.rb`). Database added to git repository, cause it takes some time to populate it.

## Code
`normalize_data` function is completed.
