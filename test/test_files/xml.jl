#TODO: Translating the data parameter to XML is the more difficult
# However, that's the default format parameter.
# What's the best approach?
#=

<?xml version="1.0" encoding="UTF-8" ?>
<arms>
   <item>
      <arm_num>1</arm_num>
      <name>Drug A</name>
   </item>
   <item>
      <arm_num>2</arm_num>
      <name>Drug B</name>
   </item>
   <item>
      <arm_num>3</arm_num>
      <name>Drug C</name>
   </item>
</arms>

<?xml version="1.0" encoding="UTF-8" ?>
<dags>
   <item>
      <data_access_group_name>CA Site</data_access_group_name>
      <unique_group_name>ca_site</unique_group_name>
   </item>
   <item>
      <data_access_group_name>FL Site</data_access_group_name>
      <unique_group_name>fl_site</unique_group_name>
   </item>
   <item>
      <data_access_group_name>New Site</data_access_group_name>
      <unique_group_name></unique_group_name>
   </item>
</dags>

This one is used for import user-DAG assignment
<?xml version="1.0" encoding="UTF-8" ?>
<items>
   <item>
      <username>ca_dt_person</username>
      <redcap_data_access_group>ca_site</redcap_data_access_group>
   </item>
   <item>
      <username>fl_dt_person</username>
      <redcap_data_access_group>fl_site</redcap_data_access_group>
   </item>
   <item>
      <username>global_user</username>
      <redcap_data_access_group></redcap_data_access_group>
   </item>
</items>

<?xml version="1.0" encoding="UTF-8" ?>
<events>
   <item>
      <event_name>Baseline</event_name>
      <arm_num>1</arm_num>
   </item>
   <item>
      <event_name>Visit 1</event_name>
      <arm_num>1</arm_num>
   </item>
   <item>
      <event_name>Visit 2</event_name>
      <arm_num>1</arm_num>
   </item>
</events>

Import instrument event mappings
<?xml version="1.0" encoding="UTF-8" ?>
<items>
   <item>
      <arm_num>1</arm_num>
      <unique_event_name>baseline_arm_1</unique_event_name>
      <form>demographics</form>
   </item>
   <item>
      <arm_num>1</arm_num>
      <unique_event_name>visit_1_arm_1</unique_event_name>
      <form>day_3</form>
   </item>
   <item>
      <arm_num>1</arm_num>
      <unique_event_name>visit_1_arm_1</unique_event_name>
      <form>other</form>
   </item>
   <item>
      <arm_num>1</arm_num>
      <unique_event_name>visit_2_arm_1</unique_event_name>
      <form>other</form>
   </item>
</items>

Import records is more complicated
EAV XML:

<?xml version="1.0" encoding="UTF-8" ?>
<records>
   <item>
      <record></record>
      <field_name></field_name>
      <value></value>
      <redcap_event_name></redcap_event_name>
   </item>
</records>

Flat XML:

<?xml version="1.0" encoding="UTF-8" ?>
<records>
   <item>
      each data point as an element
      ...
   </item>
</records>

This is used for import_users, where the content parameter is user, not users...
<?xml version="1.0" encoding="UTF-8" ?>
<users>
   <item>
      <username>harrispa</username>
      <expiration>2015-12-07</expiration>
      <user_rights>1</user_rights>
      <design>0</design>
      <forms>
         <demographics>1</demographics>
         <day_3>2</day_3>
         <other>0</other>
      </forms>
      <forms_export>
         <demographics>1</demographics>
         <day_3>0</day_3>
         <other>2</other>
      </forms_export>
   </item>
</users>

Import user roles
<?xml version="1.0" encoding="UTF-8" ?>
<users>
   <item>
      <unique_role_name>U-527D39JXAC</unique_role_name>
      <role_label>Data Entry Person</role_label>
      <user_rights>1</user_rights>
      <design>0</design>
      <forms>
         <demographics>1</demographics>
         <day_3>2</day_3>
         <other>0</other>
      </forms>
      <forms_export>
         <demographics>1</demographics>
         <day_3>0</day_3>
         <other>2</other>
      </forms>
   </item>
</users>

Import user rolw assignments
<?xml version="1.0" encoding="UTF-8" ?>
<items>
   <item>
      <username>ca_dt_person</username>
      <unique_role_name>U-2119C4Y87T</unique_role_name>
   </item>
   <item>
      <username>fl_dt_person</username>
      <unique_role_name>U-2119C4Y87T</unique_role_name>
   </item>
   <item>
      <username>global_user</username>
      <unique_role_name></unique_role_name>
   </item>
</items>

=#
