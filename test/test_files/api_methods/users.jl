@test export_users(token=project_token,format=:json) |> JSON.parse |> first |> x -> x["api_import"] == 1


username = ENV["REDCAP_USERNAME"]
settings = export_users(token=project_token,format=:json) |> JSON.parse |> first
@test settings["username"] == username
@test settings["calendar"] == settings["data_quality_create"] == 1
@test import_users(token=project_token,data=(username=username,calendar=0,data_quality_create=0)) == "1"
@test import_users(token=project_token,data=(username=username,email_logging=0),format=:json) == "1"
settings = export_users(token=project_token,format=:json) |> JSON.parse |> first
@test settings["calendar"] == settings["data_quality_create"] == settings["email_logging"] == 0

@test import_users(token=project_token,data=(username=:FAKE_USER_NAME,)) == "1"
@test delete_users(token=project_token,users=[:FAKE_USER_NAME]) == 
"""<?xml version=\"1.0\" encoding=\"UTF-8\" ?><hash><error>You do not have Delete Record privileges</error></hash>"""

#TODO: grant self permission to delete user
#TODO: create and delete multiple users with each format
