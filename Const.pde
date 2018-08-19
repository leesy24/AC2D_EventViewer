//final static boolean PRINT_CONST_ALL_DBG = true;
final static boolean PRINT_CONST_ALL_DBG = false;

//final static boolean PRINT_CONST_SETUP_DBG = true;
final static boolean PRINT_CONST_SETUP_DBG = false;

// Define default binary buf filename and path 
final static String CONST_FILE_NAME = "const";
final static String CONST_FILE_EXT = ".csv";

void Const_setup()
{
  if (PRINT_CONST_ALL_DBG || PRINT_CONST_SETUP_DBG) println("Const_setup():Enter");

  String file_full_name;

  file_full_name = DATA_DIR_FULL_NAME + CONST_FILE_NAME + CONST_FILE_EXT;

  // A Table object
  Table table;

  // Load config file(CSV type) into a Table object
  // "header" option indicates the file has a header row
  table = loadTable(file_full_name, "header");
  // Check loadTable failed.
  if (table == null)
  {
    if (PRINT_CONST_ALL_DBG || PRINT_CONST_SETUP_DBG) println("Const_setup()"+":loadTable() return null! "+file_full_name);
    //Const_create();
    return;
  }

  for (TableRow variable : table.rows())
  {
    // You can access the fields via their column name (or index)
    String name = variable.getString("Name");
    if (name.equals("SYSTEM_PASSWORD"))
      SYSTEM_PASSWORD = variable.getString("Value");
    else if(name.equals("SYSTEM_UI_TIMEOUT"))
      SYSTEM_UI_TIMEOUT = variable.getInt("Value");
    else if(name.equals("FRAME_RATE"))
      FRAME_RATE = variable.getInt("Value");
    else if (name.equals("PS_DATA_SAVE_ALWAYS_DURATION"))
      PS_DATA_SAVE_ALWAYS_DURATION = variable.getInt("Value");
    else if (name.equals("PS_DATA_SAVE_EVENTS_DURATION_DEFAULT"))
      PS_DATA_SAVE_EVENTS_DURATION_DEFAULT = variable.getInt("Value");
    else if (name.equals("PS_DATA_SAVE_EVENTS_DURATION_LIMIT"))
      PS_DATA_SAVE_EVENTS_DURATION_LIMIT = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_MARKER_MARGIN"))
      ROI_OBJECT_MARKER_MARGIN = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX"))
      ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_DETECT_DIAMETER_MIN"))
      ROI_OBJECT_DETECT_DIAMETER_MIN = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_DETECT_TIME_MIN"))
      ROI_OBJECT_DETECT_TIME_MIN = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_DETECT_KEEP_TIME"))
      ROI_OBJECT_DETECT_KEEP_TIME = variable.getInt("Value");
    else if(name.equals("ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN"))
      ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN = variable.getInt("Value");
    else if(name.equals("C_RELAY_MODULE_INDICATOR_OFF_FILL"))
      C_RELAY_MODULE_INDICATOR_OFF_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_RELAY_MODULE_INDICATOR_OFF_STROKE"))
      C_RELAY_MODULE_INDICATOR_OFF_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("SCREEN_BORDER_WIDTH"))
      SCREEN_BORDER_WIDTH = variable.getInt("Value");
    else if(name.equals("SCREEN_TITLE_HEIGHT"))
      SCREEN_TITLE_HEIGHT = variable.getInt("Value");
    else if(name.equals("SCREEN_X_OFFSET"))
      SCREEN_X_OFFSET = variable.getInt("Value");
    else if(name.equals("SCREEN_Y_OFFSET"))
      SCREEN_Y_OFFSET = variable.getInt("Value");
    else if(name.equals("C_BG"))
      C_BG = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_VERSION_DATE_TEXT"))
      C_VERSION_DATE_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_PS_DATA_ERR_TEXT"))
      C_PS_DATA_ERR_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_NUM_PAD_NORMAL"))
      C_UI_NUM_PAD_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_NUM_PAD_HIGHLIGHT"))
      C_UI_NUM_PAD_HIGHLIGHT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_NUM_PAD_TEXT"))
      C_UI_NUM_PAD_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_NUM_PAD_BOX"))
      C_UI_NUM_PAD_BOX = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_UI_NUM_PAD_BOX"))
      W_UI_NUM_PAD_BOX = variable.getInt("Value");
    else if(name.equals("C_BUBBLE_INFO_RECT_FILL"))
      C_BUBBLE_INFO_RECT_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_BUBBLE_INFO_RECT_STROKE"))
      C_BUBBLE_INFO_RECT_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_BUBBLE_INFO_TEXT"))
      C_BUBBLE_INFO_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_BUTTONS_NORMAL"))
      C_UI_BUTTONS_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_BUTTONS_HIGHLIGHT"))
      C_UI_BUTTONS_HIGHLIGHT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_BUTTONS_TEXT"))
      C_UI_BUTTONS_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_BUTTONS_BOX"))
      C_UI_BUTTONS_BOX = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_UI_BUTTONS_BOX"))
      W_UI_BUTTONS_BOX = variable.getInt("Value");
    else if(name.equals("C_PS_DATA_LINE"))
      C_PS_DATA_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_PS_DATA_POINT"))
      C_PS_DATA_POINT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_PS_DATA_LINE"))
      W_PS_DATA_LINE = variable.getInt("Value");
    else if(name.equals("C_PS_DATA_RECT_FILL"))
      C_PS_DATA_RECT_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_PS_DATA_RECT_STROKE"))
      C_PS_DATA_RECT_STROKE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_PS_DATA_RECT_STROKE"))
      W_PS_DATA_RECT_STROKE = variable.getInt("Value");
    else if(name.equals("C_PS_DATA_RECT_TEXT"))
      C_PS_DATA_RECT_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_GRID_LINE"))
      C_GRID_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_GRID_LINE"))
      W_GRID_LINE = variable.getInt("Value");
    else if(name.equals("C_GRID_TEXT"))
      C_GRID_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_MESSAGE_BOX_FILL"))
      C_MESSAGE_BOX_FILL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_MESSAGE_BOX_TEXT"))
      C_MESSAGE_BOX_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_MESSAGE_BOX_RECT"))
      C_MESSAGE_BOX_RECT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_MESSAGE_BOX_RECT"))
      W_MESSAGE_BOX_RECT = variable.getInt("Value");
    else if(name.equals("C_UI_INTERFACES_TEXT"))
      C_UI_INTERFACES_TEXT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_INTERFACES_FILL_NORMAL"))
      C_UI_INTERFACES_FILL_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_INTERFACES_FILL_HIGHLIGHT"))
      C_UI_INTERFACES_FILL_HIGHLIGHT = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_INTERFACES_BORDER_ACTIVE"))
      C_UI_INTERFACES_BORDER_ACTIVE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_INTERFACES_BORDER_NORMAL"))
      C_UI_INTERFACES_BORDER_NORMAL = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_UI_INTERFACES_CURSOR"))
      C_UI_INTERFACES_CURSOR = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("C_BG_IMAGE_LINE"))
      C_BG_IMAGE_LINE = (int)Long.parseLong(variable.getString("Value"), 16);
    else if(name.equals("W_BG_IMAGE_LINE"))
      W_BG_IMAGE_LINE = variable.getInt("Value");
  }
}
