#TODO: is it an issue if this example comes straight from the REDCap documentation?
write(file_handle, """
unique_role_name,role_label,design,user_rights,forms,forms_export
U-527D39JXAC,Data Entry Person,1,1,"demographics:1,day_3:1,other:1","demographics:1,day_3:2,other:0"
U-2119C4Y87T,Project Manager,0,0,"demographics:1,day_3:2,other:0","demographics:1,day_3:2,other:0"
""")
seekstart(file_handle)

@test_throws UndefKeywordError import_user_roles(token=project_token)
@test import_user_roles(token=project_token,data=file_name) == "The data is not in the specified format."
seekstart(file_handle)
@test import_user_roles(token=project_token,data=file_name,format=:csv) ==
"""ERROR: The form named \"demographics\" is incorrect for the user role \"U-527D39JXAC\" The form does not exist in this project.\nThe form named \"day_3\" is incorrect for the user role \"U-527D39JXAC\" The form does not exist in this project.\nThe form named \"other\" is incorrect for the user role \"U-527D39JXAC\" The form does not exist in this project.\nThe form named \"demographics\" is incorrect for the user role \"U-527D39JXAC\" The form does not exist in this project.\nThe form named \"day_3\" is incorrect for the user role \"U-527D39JXAC\" The form does not exist in this project.\nThe form named \"other\" is incorrect for the user role \"U-527D39JXAC\" The form does no" ⋯ 96 bytes ⋯ "87T\" The form does not exist in this project.\nThe form named \"day_3\" is incorrect for the user role \"U-2119C4Y87T\" The form does not exist in this project.\nThe form named \"other\" is incorrect for the user role \"U-2119C4Y87T\" The form does not exist in this project.\nThe form named \"demographics\" is incorrect for the user role \"U-2119C4Y87T\" The form does not exist in this project.\nThe form named \"day_3\" is incorrect for the user role \"U-2119C4Y87T\" The form does not exist in this project.\nThe form named \"other\" is incorrect for the user role \"U-2119C4Y87T\" The form does not exist in this project.\nInvalid Unique Role Names: U-527D39JXAC, U-2119C4Y87T"""
