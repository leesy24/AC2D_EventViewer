//final static boolean PRINT_CONFIG_ALL_DBG = true;
final static boolean PRINT_CONFIG_ALL_DBG = false;
final static boolean PRINT_CONFIG_ALL_ERR = true;
//final static boolean PRINT_CONFIG_ALL_ERR = false;

//final static boolean PRINT_CONFIG_SETUP_DBG = true;
final static boolean PRINT_CONFIG_SETUP_DBG = false;
//final static boolean PRINT_CONFIG_SETUP_ERR = true;
final static boolean PRINT_CONFIG_SETUP_ERR = false;

// Define default binary buf filename and path 
final static String CONFIG_FILE_NAME = "config";
final static String CONFIG_FILE_EXT = ".csv";

// This is for argument passed number of config file.
/*
static String CONFIG_instance_number = null;
*/

void Config_setup()
{
  if (PRINT_CONFIG_ALL_DBG || PRINT_CONFIG_SETUP_DBG) println("Config_setup():Enter");

  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    String file_full_name;

    file_full_name = DATA_DIR_FULL_NAME + CONFIG_FILE_NAME + "_" + i + CONFIG_FILE_EXT;

    // A Table object
    Table table;

    // Load config file(CSV type) into a Table object
    // "header" option indicates the file has a header row
    table = loadTable(file_full_name, "header");
    // Check loadTable failed.
    if(table == null)
    {
      if (PRINT_CONFIG_ALL_DBG || PRINT_CONFIG_SETUP_DBG) println("Config_setup()"+":"+i+":loadTable() return null! "+file_full_name);

      file_full_name = sketchPath() + "\\data\\" + CONFIG_FILE_NAME + "_" + i + CONFIG_FILE_EXT;
      table = loadTable(file_full_name, "header");

      // Check loadTable failed.
      if(table == null) {
        if (PRINT_CONFIG_ALL_ERR || PRINT_CONFIG_SETUP_ERR) println("Config_setup()"+":"+i+":loadTable() return null! "+file_full_name);
        continue;
      }
    }

    for (TableRow variable : table.rows())
    {
      // You can access the fields via their column name (or index)
      String name = variable.getString("Name");
      if (name.equals("ZOOM_FACTOR")) {
        ZOOM_FACTOR[i] = variable.getInt("Value"); 
      }
      else if (name.equals("ROTATE_FACTOR")) {
        ROTATE_FACTOR[i] = variable.getFloat("Value"); 
      }
      else if (name.equals("MIRROR_ENABLE")) {
        MIRROR_ENABLE[i] = (variable.getString("Value").toLowerCase().equals("true"))?true:false; 
      }
      else if (name.equals("ANGLE_ADJUST")) {
        ANGLE_ADJUST[i] = variable.getInt("Value"); 
      }
      else if (name.equals("SCREEN_OFFSET_X")) {
        SCREEN_OFFSET_X[i] = variable.getInt("Value");
      }
      else if (name.equals("SCREEN_OFFSET_Y")) {
        SCREEN_OFFSET_Y[i] = variable.getInt("Value");
      }
    }
    if (PRINT_CONFIG_ALL_DBG) println("Config_setup():ROTATE_FACTOR["+i+"]="+ROTATE_FACTOR[i]);
    if (PRINT_CONFIG_ALL_DBG) println("Config_setup():MIRROR_ENABLE["+i+"]="+MIRROR_ENABLE[i]);
    if (PRINT_CONFIG_ALL_DBG) println("Config_setup():ZOOM_FACTOR["+i+"]="+ZOOM_FACTOR[i]);
    if (PRINT_CONFIG_ALL_DBG) println("Config_setup():ANGLE_ADJUST["+i+"]="+ANGLE_ADJUST[i]);
    if (PRINT_CONFIG_ALL_DBG) println("Config_setup():SCREEN_OFFSET_X["+i+"]="+SCREEN_OFFSET_X[i]);
    if (PRINT_CONFIG_ALL_DBG) println("Config_setup():SCREEN_OFFSET_Y["+i+"]="+SCREEN_OFFSET_Y[i]);
  }

}
