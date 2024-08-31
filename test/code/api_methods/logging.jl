export_logging(token=project_token, format=:json) |>JSON.parse |> DataFrame
@test export_logging(token=project_token,format=:json, endTime="1999-01-01") |> JSON.parse |> DataFrame == DataFrame()

#TODO: Users might try to use returnFormat, but it has to be format...
