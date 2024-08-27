write(file_handle, """
      <?xml version="1.0" encoding="UTF-8"?>
<item>
  <arm_num>1</arm_num>
  <name>Arm 01</name>
</item>
<item>
  <arm_num>2</arm_num>
  <name>Arm 02</name>
</item>
<item>
  <arm_num>3</arm_num>
  <name>Arm 03</name>
</item>
<item>
  <arm_num>4</arm_num>
  <name>Arm 04</name>
</item>
<item>
  <arm_num>5</arm_num>
  <name>Arm 05</name>
</item>
<item>
  <arm_num>6</arm_num>
  <name>Arm 06</name>
</item>
<item>
  <arm_num>7</arm_num>
  <name>Arm 07</name>
</item>
<item>
  <arm_num>8</arm_num>
  <name>Arm 08</name>
</item>
""")
seekstart(file_handle)
@test import_arms(override=1,data=file_name,token=project_token,format=:xml) == "8"
seekstart(file_handle)
@test import_arms(override=1,data=file_name,token=project_token) == "8"

truncate(file_handle,0)
write(file_handle, """
[
  {
    "arm_num": 1,
    "name": "Arm 01"
  },
  {
    "arm_num": 2,
    "name": "Arm 02"
  },
  {
    "arm_num": 3,
    "name": "Arm 03"
  },
  {
    "arm_num": 4,
    "name": "Arm 04"
  },
  {
    "arm_num": 5,
    "name": "Arm 05"
  },
  {
    "arm_num": 6,
    "name": "Arm 06"
  },
  {
    "arm_num": 7,
    "name": "Arm 07"
  },
  {
    "arm_num": 8,
    "name": "Arm 08"
  }
]
""")
seekstart(file_handle)
@test import_arms(override=1,data=file_name,token=project_token,format=:json) == "8"

truncate(file_handle,0)
write(file_handle, """
arm_num,name
1,Drug A
2,Drug B
3,Drug C
4,Drug D
5,Drug E
6,Drug F
7,Drug G
8,Drug H
""")
seekstart(file_handle)
@test import_arms(override=1,data=file_name,token=project_token,format=:csv) == "8"
