q="""data_access_group_name,unique_group_name
       Subset 1,
       Subset 2,
       Subset 3,"""
@test import_DAGs(token=project_token,data=q,format=:csv) == "3"

