//final static boolean PRINT_BG_IMAGE_ALL_DBG = true;
final static boolean PRINT_BG_IMAGE_ALL_DBG = false;
//final static boolean PRINT_BG_IMAGE_ALL_ERR = true;
final static boolean PRINT_BG_IMAGE_ALL_ERR = false;

//final static boolean PRINT_BG_IMAGE_SETUP_DBG = true; 
final static boolean PRINT_BG_IMAGE_SETUP_DBG = false;
//final static boolean PRINT_BG_IMAGE_SETUP_ERR = true; 
final static boolean PRINT_BG_IMAGE_SETUP_ERR = false;

//final static boolean PRINT_BG_IMAGE_DRAW_DBG = true; 
final static boolean PRINT_BG_IMAGE_DRAW_DBG = false;
//final static boolean PRINT_BG_IMAGE_DRAW_ERR = true; 
final static boolean PRINT_BG_IMAGE_DRAW_ERR = false;

// Define default binary buf filename and path 
final static String BG_IMAGE_FILE_NAME = "bg_image";
final static String BG_IMAGE_FILE_EXT = ".csv";
static String BG_IMAGE_file_full_name;

static color C_BG_IMAGE_LINE = #000000;
static int W_BG_IMAGE_LINE = 3;

static Points_Data BG_IMAGE_data;

void BG_Image_setup()
{
  if(PRINT_BG_IMAGE_ALL_DBG || PRINT_BG_IMAGE_SETUP_DBG) println("BG_Image_setup():Enter");

  BG_IMAGE_file_full_name = DATA_DIR_FULL_NAME + BG_IMAGE_FILE_NAME + BG_IMAGE_FILE_EXT;

  // A Table object
  Table table;

  // Load lines file(CSV type) into a Table object
  // "header" option indicates the file has a header row
  table = loadTable(BG_IMAGE_file_full_name, "header");
  // Check loadTable failed.
  if(table == null)
  {
    if (PRINT_BG_IMAGE_ALL_ERR || PRINT_BG_IMAGE_SETUP_ERR) println("BG_Image_setup():loadTable() return null! "+BG_IMAGE_file_full_name);
    SYSTEM_logger.severe("BG_Image_setup():loadTable() return null! "+BG_IMAGE_file_full_name);
    return;
  }

  //println("table.getRowCount()=" + table.getRowCount());
  BG_IMAGE_data = new Points_Data(table.getRowCount());
  if(BG_IMAGE_data == null)
  {
    if (PRINT_BG_IMAGE_ALL_ERR || PRINT_BG_IMAGE_SETUP_ERR) println("BG_Image_setup():Points_Data return null!");
    SYSTEM_logger.severe("BG_Image_setup():Points_Data return null!");
    return;
  }
  //println("BG_IMAGE_data.length=" + BG_IMAGE_data.length);

  int i = 0;
  String X, Y, Weight, Color;
  for(TableRow variable : table.rows())
  {
    X = variable.getString("X");
    Y = variable.getString("Y");
    Weight = variable.getString("Weight");
    Color = variable.getString("Color");
    //println("X="+X+",Y="+Y+",Weight="+Weight+",Color="+Color);

    if(X == null || Y == null)
    {
      continue;
    }

    if( X.toUpperCase().equals("CUT")
        ||
        Y.toUpperCase().equals("CUT")
      )
    {
      BG_IMAGE_data.scr_x[i] = MIN_INT;
      BG_IMAGE_data.scr_y[i] = MIN_INT;
      //println("BG_IMAGE_data.x[" + i + "]=" + "CUT" + ",BG_IMAGE_data.y[" + i + "]=" + "CUT");
    }
    else
    {
      // You can access the fields via their column name (or index)
      BG_IMAGE_data.scr_x[i] = variable.getInt("X");
      BG_IMAGE_data.scr_y[i] = variable.getInt("Y");
      if(Weight == null)
      {
        BG_IMAGE_data.w[i] = W_BG_IMAGE_LINE;
      }
      else
      {
        BG_IMAGE_data.w[i] = variable.getInt("Weight");
      }
      if(Color == null)
      {
        BG_IMAGE_data.c[i] = C_BG_IMAGE_LINE;
      }
      else
      {
        BG_IMAGE_data.c[i] = (int)Long.parseLong(variable.getString("Color"), 16);
      }
      if (PRINT_BG_IMAGE_ALL_DBG || PRINT_BG_IMAGE_SETUP_DBG) println("BG_IMAGE_data.x[" + i + "]=" + BG_IMAGE_data.scr_x[i] + ",BG_IMAGE_data.y[" + i + "]=" + BG_IMAGE_data.scr_y[i] + ",BG_IMAGE_data.w[" + i + "]=" + BG_IMAGE_data.w[i] + ",BG_IMAGE_data.c[" + i + "]=" + BG_IMAGE_data.c[i]);
    }
    i ++;
  }
  for(; i < BG_IMAGE_data.length; i ++)
  {
    BG_IMAGE_data.scr_x[i] = MIN_INT;
    BG_IMAGE_data.scr_y[i] = MIN_INT;
  }
}

void BG_Image_draw()
{
  if(BG_IMAGE_data == null) return;

  int x_curr, y_curr;
  int w_curr;
  color c_curr;
  int x_prev = MIN_INT, y_prev = MIN_INT;
  int w_prev = W_BG_IMAGE_LINE;
  color c_prev = C_BG_IMAGE_LINE;
  boolean drawed = false;

  for(int i = 0; i < BG_IMAGE_data.length; i ++)
  {
    x_curr = BG_IMAGE_data.scr_x[i];
    y_curr = BG_IMAGE_data.scr_y[i];
    w_curr = BG_IMAGE_data.w[i];
    c_curr = BG_IMAGE_data.c[i];
    if (PRINT_BG_IMAGE_ALL_DBG || PRINT_BG_IMAGE_DRAW_DBG) println("BG_IMAGE_data[" + i + "]:x_curr=" + x_curr + ",y_curr=" + y_curr + ",w_curr=" + w_curr + ",c_curr=" + c_curr);
    if( x_curr == MIN_INT 
        ||
        y_curr == MIN_INT
      )
    {
      if(!drawed && x_prev != MIN_INT && y_prev != MIN_INT)
      {
        fill(c_prev);
        // Sets the color and weight used to draw lines and borders around shapes.
        stroke(c_prev);
        strokeWeight(w_prev);
        point(x_prev, y_prev);
      }
      x_prev = MIN_INT;
      y_prev = MIN_INT;
      continue;
    }

    //println("x_curr=" + x_curr + ",y_curr=" + y_curr + ",x_prev=" + x_prev + ",y_prev=" + y_prev);
    if(x_prev != MIN_INT && y_prev != MIN_INT)
    {
      fill(c_prev);
      // Sets the color and weight used to draw lines and borders around shapes.
      stroke(c_prev);
      strokeWeight(w_prev);
      line(x_prev, y_prev, x_curr, y_curr);
      drawed = true;
    }
    else
    {
      drawed = false;
    }
    // Save data for drawing line between previous and current points. 
    x_prev = x_curr;
    y_prev = y_curr;
    w_prev = w_curr;
    c_prev = c_curr;
  }

  if(!drawed && x_prev != MIN_INT && y_prev != MIN_INT)
  {
    fill(c_prev);
    // Sets the color and weight used to draw lines and borders around shapes.
    stroke(c_prev);
    strokeWeight(w_prev);
    point(x_prev, y_prev);
  }
}
