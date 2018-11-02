//final static boolean PRINT_PS_DATA_ALL_DBG = true; 
final static boolean PRINT_PS_DATA_ALL_DBG = false;
final static boolean PRINT_PS_DATA_ALL_ERR = true; 
//final static boolean PRINT_PS_DATA_ALL_ERR = false;

//final static boolean PRINT_PS_DATA_SETTINGS_DBG = true; 
final static boolean PRINT_PS_DATA_SETTINGS_DBG = false;
//final static boolean PRINT_PS_DATA_SETTINGS_ERR = true; 
final static boolean PRINT_PS_DATA_SETTINGS_ERR = false;

//final static boolean PRINT_PS_DATA_SETUP_DBG = true; 
final static boolean PRINT_PS_DATA_SETUP_DBG = false;
//final static boolean PRINT_PS_DATA_SETUP_ERR = true; 
final static boolean PRINT_PS_DATA_SETUP_ERR = false;

//final static boolean PRINT_PS_DATA_LOAD_DBG = true; 
final static boolean PRINT_PS_DATA_LOAD_DBG = false;
//final static boolean PRINT_PS_DATA_LOAD_ERR = true; 
final static boolean PRINT_PS_DATA_LOAD_ERR = false;

//final static boolean PRINT_PS_DATA_PARSE_DBG = true; 
final static boolean PRINT_PS_DATA_PARSE_DBG = false;
//final static boolean PRINT_PS_DATA_PARSE_ERR = true; 
final static boolean PRINT_PS_DATA_PARSE_ERR = false;

//final static boolean PRINT_PS_DATA_DRAW_DBG = true; 
final static boolean PRINT_PS_DATA_DRAW_DBG = false;

static color C_PS_DATA_ERR_TEXT = #000000; // Black
static color C_PS_DATA_LINE = 0xFF0000FF; // Blue
static color C_PS_DATA_POINT = 0xFF0000FF; // Blue
static int W_PS_DATA_LINE = 1;
static color C_PS_DATA_RECT_FILL = 0xC0F8F8F8; // White - 0x8 w/ Opaque 75%
static color C_PS_DATA_RECT_STROKE = #000000; // Black
static int W_PS_DATA_RECT_STROKE = 1;
static color C_PS_DATA_RECT_TEXT = #404040; // Black + 0x40

// Define angle adjust variables of PS Data in centi-degree.
static int[] ANGLE_ADJUST = new int[PS_INSTANCE_MAX];
final static int ANGLE_ADJUST_MIN = -1000; // -10.0 degree.
final static int ANGLE_ADJUST_MAX = +1000; // +10.0 degree.

static int PS_DATA_SAVE_ALWAYS_DURATION = 1; // unit is hours. 1 hour

final static int PS_DATA_SAVE_ALWAYS_DURATION_MIN = 1; // 1 hour
final static int PS_DATA_SAVE_ALWAYS_DURATION_MAX = 24; // 24 hours, It will 7 GBytes disk space.

final static int PS_DATA_POINTS_MAX = 1000;
final static int PS_DATA_POINT_WEIGHT = 3;

final static int PS_DATA_PULSE_WIDTH_MAX = 12000;
final static int PS_DATA_PULSE_WIDTH_MIN = 4096;

static int PS_DATA_PULSE_WIDTH_THRESHOLD = 4096;

final static int PS_DATA_INTERFACES_ERR_COUNT_MAX = 6; // 60 seconds = 1 minute

final static int PS_Interface_FILE = 1;
final static int PS_Interface_None = 0;
static enum PS_Interface_enum {
  None,
  FILE,
  MAX
}

static boolean PS_Data_draw_points_with_line;

static int[] PS_Interface = new int[PS_INSTANCE_MAX];
static String[] PS_Interface_str = {"None", "File"};

static String[] FILE_name = new String[PS_INSTANCE_MAX];

static PS_Data PS_Data_handle;

// Define Data buffer array to load binary Data buffer from interfaces
static byte[][] PS_Data_buf = new byte[PS_INSTANCE_MAX][]; 

static boolean PS_Data_draw_points_all_enabled;
static boolean PS_Data_draw_points_all_time_started;
static int PS_Data_draw_points_all_start_time;

static boolean[] PS_Data_draw_params_enabled = new boolean[PS_INSTANCE_MAX];
static int[] PS_Data_draw_params_timer = new int[PS_INSTANCE_MAX];
static int[] PS_Data_draw_params_x = new int[PS_INSTANCE_MAX];
static int[] PS_Data_draw_params_y = new int[PS_INSTANCE_MAX];

static color[] PS_Data_pulse_width_color_value = null;

// Define old time stamp to check time stamp changed for detecting Data buffer changed or not
//long PS_Data_old_time_stamp = -1;

void PS_Data_settings() {
  if(PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_SETTINGS_DBG) println("PS_Data_settings():Enter");
}

void PS_Data_setup()
{
  if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_SETUP_DBG) println("PS_Data_setup():Enter");

  // Append interface name to window title

  //PS_Data_draw_points_with_line = true;
  PS_Data_draw_points_with_line = false;

  //PS_Data_draw_points_all_enabled = true;
  PS_Data_draw_points_all_enabled = false;
  PS_Data_draw_points_all_time_started = false;

  if (PS_DATA_SAVE_ALWAYS_DURATION > PS_DATA_SAVE_ALWAYS_DURATION_MAX) PS_DATA_SAVE_ALWAYS_DURATION = PS_DATA_SAVE_ALWAYS_DURATION_MAX;
  if (PS_DATA_SAVE_ALWAYS_DURATION < PS_DATA_SAVE_ALWAYS_DURATION_MIN) PS_DATA_SAVE_ALWAYS_DURATION = PS_DATA_SAVE_ALWAYS_DURATION_MIN;

  for (int i = 0; i < PS_INSTANCE_MAX; i++)
  {
    PS_Data_draw_params_enabled[i] = false;
    PS_Data_draw_params_timer[i] = millis();
  }

  PS_Data_handle = new PS_Data();
  if(PS_Data_handle == null)
  {
    if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_SETUP_ERR) println("PS_Data_setup():PS_Data_handle allocation error!");
    SYSTEM_logger.severe("PS_Data_setup():PS_Data_handle allocation error!");
    return;
  }

  Interfaces_File_reset();

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if(PS_Interface[i] == PS_Interface_FILE) {
      Interfaces_File_setup();
      Interfaces_File_handle.open(i, FILE_name[i]);
      PS_Data_handle.file_name[i] = FILE_name[i];
      PS_Data_handle.files_time_long[i] = Interfaces_File_handle.get_files_time_long(i);
    }
    else if(PS_Interface[i] == PS_Interface_None) {
      // Nothing to do.
    }
    else {
      if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_SETUP_ERR) println("PS_Data_setup():PS_Interface["+i+"]="+PS_Interface[i]+" error!");
      SYSTEM_logger.severe("PS_Data_setup():PS_Interface["+i+"]="+PS_Interface[i]+" error!");
    }

    if (PS_Data_pulse_width_color_value == null) {
      // Init. PS_Data_pulse_width_color_value
      int color_size = PS_DATA_PULSE_WIDTH_MAX - PS_DATA_PULSE_WIDTH_MIN + 1;
      int color_step = color_size / 6;
      int color_count = 0;

      PS_Data_pulse_width_color_value = new color[color_size];

      // Starts as violet, becomes indigo
      for (int r = color_step; r > 0; r --) {
        PS_Data_pulse_width_color_value[color_count] =
          color(r*63/color_step + 64, 0, 255);
        color_count ++;
      }
      //println("color_count="+color_count);

      // Starts as indigo, becomes blue
      for (int r = color_step; r > 0; r --) {
        PS_Data_pulse_width_color_value[color_count] =
          color(r*63/color_step, 0, 255);
        color_count ++;
      }
      //println("color_count="+color_count);

      // Starts as blue, becomes green
      for (int gb = 0; gb < color_step; gb ++) {
        PS_Data_pulse_width_color_value[color_count] =
          color(0, gb*255/color_step, (color_step - gb)*255/color_step);
        color_count ++;
      }
      //println("color_count="+color_count);

      // Starts as green, becomes yellow
      for (int r = 0; r < color_step + color_size - color_step * 6; r ++) {
        PS_Data_pulse_width_color_value[color_count] =
          color(r*255/(color_step + color_size - color_step * 6), 255, 0);
        color_count ++;
      }
      //println("color_count="+color_count);

      // Stars as yellow, becomes orange
      for (int g = color_step; g > 0; g --) {
        PS_Data_pulse_width_color_value[color_count] =
          color(255, g*127/color_step + 128, 0);
        color_count ++;
      }
      //println("color_count="+color_count);

      // Starts as orange, becomes red
      for (int g = color_step; g > 0; g --) {
        PS_Data_pulse_width_color_value[color_count] =
          color(255, g*127/color_step, 0);
        color_count ++;
      }
      //println("color_count="+color_count);

      if (color_count != color_size) {
        if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_SETUP_ERR) println("PS_Data_setup()"+":color_count is not match with color_size. " + color_count + "," + color_size);
      }
    }
  }
}

void PS_Data_draw_params_keep_alive(int instance)
{
  if (PS_Data_draw_params_enabled[instance])
  {
    PS_Data_draw_params_timer[instance] = millis();
  }
}


void PS_Data_mouse_pressed()
{
  if (PS_Data_draw_points_all_enabled && PS_Data_draw_points_all_time_started)
  {
    PS_Data_draw_points_all_start_time = millis();
  }

  boolean over[] = new boolean[PS_INSTANCE_MAX];
  boolean over_any = false;
  int i;

  for (i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (PS_Image[i] == null) continue;

    over[i] =
      mouse_is_over(
        Grid_zero_x[i] - PS_Image[i].width / 2,
        Grid_zero_y[i] + PS_Image_y_offset[i],
        PS_Image[i].width,
        PS_Image[i].height);
    if (over[i])
    {
      over_any = true;
    }
  }

  if (!over_any)
  {
    return;
  }

  for (i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (!over[i])
    {
      PS_Data_draw_params_enabled[i] = false;
      continue;
    }

    if (!PS_Data_draw_params_enabled[i])
    {
      PS_Data_draw_params_x[i] = mouseX;
      PS_Data_draw_params_y[i] = mouseY;
      PS_Data_draw_params_enabled[i] = true;
      PS_Data_draw_params_timer[i] = millis();
    }
    else
    {
      PS_Data_draw_params_enabled[i] = false;
    }
  }
}

void PS_Data_mouse_moved()
{
  if (PS_Data_draw_points_all_enabled && PS_Data_draw_points_all_time_started)
  {
    PS_Data_draw_points_all_start_time = millis();
  }

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (PS_Image[i] == null) continue;

    if( mouse_is_over(
          Grid_zero_x[i] - PS_Image[i].width / 2,
          Grid_zero_y[i] + PS_Image_y_offset[i],
          PS_Image[i].width,
          PS_Image[i].height) )
    {
      if (PS_Data_draw_params_enabled[i])
      {
        PS_Data_draw_params_timer[i] = millis();
      }
    }
  }
}

void PS_Data_mouse_dragged()
{
  if (PS_Data_draw_points_all_enabled && PS_Data_draw_points_all_time_started)
  {
    PS_Data_draw_points_all_start_time = millis();
  }

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (PS_Image[i] == null) continue;

    if( mouse_is_over(
          Grid_zero_x[i] - PS_Image[i].width / 2,
          Grid_zero_y[i] + PS_Image_y_offset[i],
          PS_Image[i].width,
          PS_Image[i].height) )
    {
      if (PS_Data_draw_params_enabled[i])
      {
        PS_Data_draw_params_timer[i] = millis();
      }
    }
  }
}

// A PS_Data class
class PS_Data {
  int[] scan_number = new int[PS_INSTANCE_MAX];
  int[] time_stamp = new int[PS_INSTANCE_MAX];
  //long[] time_stamp = new long[PS_INSTANCE_MAX];
  float[] scan_angle_start = new float[PS_INSTANCE_MAX];
  float[] scan_angle_size = new float[PS_INSTANCE_MAX];
  float[] scan_angle_step = new float[PS_INSTANCE_MAX];
  int[] number_of_echoes = new int[PS_INSTANCE_MAX];
  int[] incremental_count = new int[PS_INSTANCE_MAX];
  float[] system_temperature = new float[PS_INSTANCE_MAX];
  int[] system_status = new int[PS_INSTANCE_MAX];
  int[] data_content = new int[PS_INSTANCE_MAX];
  int[] number_of_points = new int[PS_INSTANCE_MAX];
  int[] number_of_points_error = new int[PS_INSTANCE_MAX];
  int[][] distances = new int[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  float[][] point_angle_degree = new float[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  int[][] mi_x = new int[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  int[][] mi_y = new int[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  int[][] scr_x = new int[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  int[][] scr_y = new int[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  int[][] pulse_width = new int[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  color[][] pulse_width_color = new color[PS_INSTANCE_MAX][PS_DATA_POINTS_MAX];
  int[] pulse_width_low_count = new int[PS_INSTANCE_MAX];
  String[] parse_err_str = new String[PS_INSTANCE_MAX];
  int[] parse_err_cnt = new int[PS_DATA_POINTS_MAX];
  int[] load_take_time = new int[PS_INSTANCE_MAX];
  int[] load_done_prev_millis = new int[PS_INSTANCE_MAX];
  int[] load_done_interval_millis = new int[PS_INSTANCE_MAX];
  int[] load_done_interval_count = new int[PS_INSTANCE_MAX];
  int[] load_done_interval_millis_accu = new int[PS_INSTANCE_MAX];
  String[] file_name = new String[PS_INSTANCE_MAX];
  int[] files_time_long = new int[PS_INSTANCE_MAX];
  boolean[] time_stamp_reseted = new boolean[PS_INSTANCE_MAX];
  boolean[] interfaces_err_started = new boolean[PS_INSTANCE_MAX];
  int[] interfaces_err_start_millis = new int[PS_INSTANCE_MAX];
  int[] interfaces_err_count = new int[PS_INSTANCE_MAX];

  // Test time_stamp wrap-around.
  //int[] time_stamp_offset = new int[PS_INSTANCE_MAX];
  //long[] time_stamp_offset = new long[PS_INSTANCE_MAX];

  // Create the PS_Data
  PS_Data() {
    if (PRINT_PS_DATA_ALL_DBG) println("PS_Data:constructor():");
    // Init. class variables.
    //println("PS_Data_buf[0]="+PS_Data_buf[0]+",PS_Data_buf[1]="+PS_Data_buf[1]);
    for (int i = 0; i < PS_INSTANCE_MAX; i++) {
      scan_number[i] = 0;
      time_stamp[i] = -1;
      scan_angle_start[i] = 0;
      scan_angle_size[i] = 0;
      scan_angle_step[i] = 0;
      number_of_echoes[i] = 0;
      incremental_count[i] = 0;
      system_temperature[i] = 0;
      system_status[i] = 0;
      data_content[i] = 0;
      number_of_points[i] = 0;
      number_of_points_error[i] = 0;
      parse_err_str[i] = null;
      parse_err_cnt[i] = 0;
      load_take_time[i] = 0;
      load_done_prev_millis[i] = -1;
      load_done_interval_millis[i] = -1;
      load_done_interval_count[i] = 0;
      load_done_interval_millis_accu[i] = 0;
      file_name[i] = null;
      files_time_long[i] = -1;
      time_stamp_reseted[i] = false;
      // Test time_stamp wrap-around.
      //time_stamp_offset[i] = -1;
      //time_stamp_last[i] = -1L;
      interfaces_err_started[i] = false;
    }
  }

  // Load PS_Data_buf
  public boolean load(int instance) {
    String interfaces_err_str;

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_LOAD_DBG) println("PS_Data:load("+instance+"):");
    //if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_LOAD_DBG) println(""PS_Data:load("+instance+"):PS_Data_buf["+instance+"]="+PS_Data_buf[instance]);

    if (PS_Interface[instance] == PS_Interface_FILE && Interfaces_File_handle != null) {
      if (Interfaces_File_handle.load(instance) != true) {
        interfaces_err_str = Interfaces_File_handle.get_error(instance);
        if (interfaces_err_str != null) {
          draw_error(instance, interfaces_err_str);
          if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_LOAD_DBG) println("PS_Data:load("+instance+"):"+PS_Interface_str[PS_Interface[instance]]+":error!:" + interfaces_err_str);
        }
        else if (parse_err_str[instance] != null) {
          draw_error(instance, parse_err_str[instance]);
          if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_LOAD_DBG) println("PS_Data:load("+instance+"):"+PS_Interface_str[PS_Interface[instance]]+":parse() error!:" + parse_err_str[instance]);
        }
        return false;
      }
      // No mean in FILE interface.
      load_take_time[instance] = -1;
      file_name[instance] = Interfaces_File_handle.get_file_name(instance);
    }
    else if (PS_Interface[instance] == PS_Interface_None) {
      // No mean in None interface.
      load_take_time[instance] = -1;
      return false;
    }
    else {
      if (PRINT_PS_DATA_ALL_ERR || PRINT_PS_DATA_LOAD_ERR) println("PS_Data:load("+instance+"):PS_Interface["+instance+"] error! " + PS_Interface[instance]);
      return false;
    }

    if (load_done_interval_millis[instance] == -1) {
      load_done_prev_millis[instance] = millis();
      load_done_interval_millis[instance] = 0;
    }
    else {
      int millis_curr = millis();
      load_done_interval_millis[instance] = get_int_diff(millis_curr, load_done_prev_millis[instance]);
      load_done_prev_millis[instance] = millis_curr;
      load_done_interval_millis_accu[instance] += load_done_interval_millis[instance];
      if (load_done_interval_millis_accu[instance] < 0) {
        load_done_interval_millis_accu[instance] = (load_done_interval_millis_accu[instance] - load_done_interval_millis[instance]) / load_done_interval_count[instance];
        SYSTEM_logger.info("PS_Data:load(" + instance + "):Refresh avg time=" + load_done_interval_millis_accu[instance] + ",count=" + load_done_interval_count[instance]);
        load_done_interval_count[instance] = 0;
      }
      load_done_interval_count[instance] ++;
      if (load_done_interval_count[instance] < 0) {
        load_done_interval_millis_accu[instance] = (load_done_interval_millis_accu[instance] - load_done_interval_millis[instance]) / (load_done_interval_count[instance] - 1);
        SYSTEM_logger.info("PS_Data:load(" + instance + "):Refresh avg time=" + load_done_interval_millis_accu[instance] + ",count=" + (load_done_interval_count[instance] - 1));
        load_done_interval_count[instance] = 1;
      }
      if ((load_done_interval_count[instance] % 1000) == 0) {
        SYSTEM_logger.info("PS_Data:load(" + instance + "):Refresh avg time=" + (load_done_interval_millis_accu[instance] / load_done_interval_count[instance]) + ",count=" + load_done_interval_count[instance]);
      }
    }

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_LOAD_DBG) println("PS_Data:load("+instance+"):"+PS_Interface_str[PS_Interface[instance]]+":ok!");

    return true;
  }

  // Parsing Data buffer
  public boolean parse(int instance) {
    String func;
    int i = 0; // index for navigating Data bufffer.
    int crc_c; // calculated CRC
    int t_n_points; // temp number_of_points
    int len;
    int n_params;
    int crc;

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("PS_Data:parse("+instance+"):Enter");

    // Get function code.
    func = get_str_bytes(PS_Data_buf[instance], i, 4);
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",func=" + func);
    // Check function code is "GSCN".
    if (func.equals("GSCN") != true) {
      parse_err_str[instance] = "Error: Function code is invalid! " + func;
      draw_error(instance, parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
    i = i + 4;

    // Get Data buffer length.
    // : size of the following Data buffer record, without the CRC checksum
    len = get_int32_bytes(PS_Data_buf[instance], i);
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",length=" + len);
    // Check Data buffer record length with binary Data buffer length
    if (PS_Data_buf[instance].length < (len + 12)) {
      parse_err_str[instance] = "Error: PS_Data buf length is invalid!:" + PS_Data_buf[instance].length + "," + len;
      draw_error(instance, parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
    i = i + 4;

    // Get CRC and Calculate CRC
    crc = get_int32_bytes(PS_Data_buf[instance], 4 + 4 + len);
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + (4 + 4 + len) + ",crc=" + crc);
    crc_c = get_crc32(PS_Data_buf[instance], 0, 4 + 4 + len);
    // Check CRC ok?
    if(crc != crc_c) {
      parse_err_str[instance] = "Error: PS_Data buf crc error!:" + crc + "," + crc_c;
      draw_error(instance, parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }

    // Get number of parameters.
    // : the number of following parameters. Becomes 0 if no scan is available.
    n_params = get_int32_bytes(PS_Data_buf[instance], i);
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",number of parameters=" + n_params);
    if (n_params == 0) {
      parse_err_str[instance] = "Error: No scan data is available! n_params = 0";
      draw_error(instance, parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
    i = i + 4;

    // Get Number of points
    // : the number of measurement points in the scan.
    t_n_points = get_int32_bytes(PS_Data_buf[instance], 4 + 4 + 4 + n_params * 4);
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + (4 + 4 + 4 + n_params * 4) + ",number of points=" + t_n_points);
    // Check Number of points
    if (t_n_points > PS_DATA_POINTS_MAX || t_n_points <= 0) {
      parse_err_str[instance] = "Error: Number of points invalid! number_of_points is " + t_n_points;
      draw_error(instance, parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
    number_of_points[instance] = t_n_points;

    if (n_params >= 1) {
      // Get scan number(index).
      // : the number of the scan (starting with 1), should be the same as in the command request.
      scan_number[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",scan number=" + scan_number[instance]);
      i = i + 4;
    }

    if (n_params >= 2) {
      if (PS_Interface[instance] == PS_Interface_FILE) {
        time_stamp[instance] = millis();
      }

      //time_stamp[instance] = get_long32_bytes(PS_Data_buf[instance], i);
      // Test time_stamp wrap-around.
      /*
      if (time_stamp_offset[instance] == -1) {
      //if (time_stamp_offset[instance] == -1L) {
        time_stamp_offset[instance] = 0xffffffff - time_stamp[instance] - 10000;
        //time_stamp_offset[instance] = 0x7fffffffffffffffL - time_stamp[instance] - 10000;
      }
      time_stamp[instance] += time_stamp_offset[instance];
      */

      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",time stamp=" + time_stamp[instance]);
      i = i + 4;
/*
      // Check time_stamp is changed
      if (PS_Data_old_time_stamp == time_stamp[instance]) {
        parse_err_str[instance] = "Scan Data buffer is not changed!:" + time_stamp[instance];
        draw_error(instance, parse_err_str[instance]);
        if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("Scan Data buffer is not changed!:" + time_stamp[instance]);
        //parse_err_cnt[instance] ++;
        //return false;
      }
      PS_Data_old_time_stamp = time_stamp[instance];
*/
    }

    if (n_params >= 3) {
      // Get Scan start direction.
      // : direction to the first measured point, given in the user angle system (typical unit is 0,001 deg)
      scan_angle_start[instance] = get_int32_bytes(PS_Data_buf[instance], i) / 1000.0;
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",scan start angle=" + scan_angle_start[instance]);
      i = i + 4;
    }
  
    if (n_params >= 4) {
      // Get Scan angle
      // : the scan angle in the user angle system. Typically 90.000.
      int val = get_int32_bytes(PS_Data_buf[instance], i);
      scan_angle_size[instance] = val / 1000.0;
      scan_angle_step[instance] = float(val) / float(number_of_points[instance]) / 1000.0;
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",scan range angle=" + scan_angle_size[instance]);
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",scan step angle=" + scan_angle_step[instance]);
      i = i + 4;
    }
  
    if (n_params >= 5) {
      // Get Number of echoes per point
      // : the number of echoes measured for each direction.
      number_of_echoes[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",number of echos=" + number_of_echoes[instance]);
      i = i + 4;
    }
  
    if (n_params >= 6) {
      // Get Incremental count
      // : a direction provided by an external incremental encoder.
      incremental_count[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",encoder value=" + incremental_count[instance]);
      i = i + 4;
    }
  
    if (n_params >= 7) {
      // Get system system_temperature
      // : the system_temperature as measured inside of the scanner.
      // : This information can be used to control an optional air condition.
      system_temperature[instance] = get_int32_bytes(PS_Data_buf[instance], i) / 10f;
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",system temperature=" + system_temperature[instance]);
      i = i + 4;
    }
  
    if (n_params >= 8) {
      // Get System status
      // : contains a bit field with about the status of peripheral devices.
      system_status[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",system status=" + system_status[instance]);
      i = i + 4;
    }
  
    if (n_params >= 9) {
      // Get data data_content
      // : This parameter is built by the size of a single measurement record.
      // : It defines the data_content of the Data buffer section:
      //    o 4 Bytes: distances in 1/10 mm only.
      //    o 8 Bytes: distances in 1/10 mm and pulse widths in picoseconds
      //    o Any other value than 4 be read as "8 Bytes".
      data_content[instance] = get_int32_bytes(PS_Data_buf[instance], i);
      if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",data_content=" + data_content[instance]);
      i = i + 4;
    }
  
    // Check number of parameters is larger than 9 such as unknown parameters.
    if (n_params > 9) {
      // Skip index for remained unknown parameters.
      i = i + 4 * (n_params - 9);
    }
  
// Skip the get Number of points. this already done above.
/*
    // Get Number of points
    // : the number of measurement points in the scan.
    number_of_points[instance] = get_int32_bytes(PS_Data_buf[instance], i);
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",number_of_points[instance]=" + number_of_points[instance]);
    if (number_of_points[instance] > PS_DATA_POINTS_MAX || number_of_points[instance] <= 0) {
      parse_err_str[instance] = "Error: Number of points invalid! number_of_points is " + number_of_points[instance];
      draw_error(instance, parse_err_str[instance]);
      if (PRINT_PS_DATA_PARSE_ERR) println(parse_err_str[instance]);
      parse_err_cnt[instance] ++;
      return false;
    }
*/
    i = i + 4;

    number_of_points_error[instance] = 0;

    for (int j = 0; j < number_of_points[instance]; j++) {
      // Get Distance
      // : units are 1/10 mm.
      // : The distance value is -2147483648 (0x80000000) in case that the echo signal was too low.
      // : The distance value is 2147483647 (0x7FFFFFFF) in case that the echo signal was noisy.
      distances[instance][j] = get_int32_bytes(PS_Data_buf[instance], i);
      point_angle_degree[instance][j] =
        scan_angle_start[instance]
        -
        45.0
        +
        (ANGLE_ADJUST[instance] / 100.0)
        +
        (j * scan_angle_size[instance] / number_of_points[instance]);
      // No echo or Noisy
      if (distances[instance][j] == 0x80000000
          ||
          distances[instance][j] == 0x7fffffff) {
        mi_x[instance][j] = MIN_INT;
        mi_y[instance][j] = MIN_INT;
        scr_x[instance][j] = MIN_INT;
        scr_y[instance][j] = MIN_INT;
        number_of_points_error[instance] ++;
      }
      else {
        mi_x[instance][j] = int(distances[instance][j] * cos(radians(point_angle_degree[instance][j])));
        mi_y[instance][j] = int(distances[instance][j] * sin(radians(point_angle_degree[instance][j])));

        final int offset_x =
          (ROTATE_FACTOR[instance] == 315)
          ?
          (TEXT_MARGIN + FONT_HEIGHT / 2)
          :
          (
            (ROTATE_FACTOR[instance] == 135)
            ?
            (SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT / 2))
            :
            (SCREEN_width / 2)
          );
        final int offset_y =
          (ROTATE_FACTOR[instance] == 45)
          ?
          (TEXT_MARGIN + FONT_HEIGHT / 2)
          :
          (
            (ROTATE_FACTOR[instance] == 225)
            ?
            (SCREEN_height - (TEXT_MARGIN + FONT_HEIGHT / 2))
            :
            (SCREEN_height / 2)
          );

        if (ROTATE_FACTOR[instance] == 315) {
          scr_x[instance][j] = mi_y[instance][j] / ZOOM_FACTOR[instance];
          scr_y[instance][j] = mi_x[instance][j] / ZOOM_FACTOR[instance];
          //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + distance + ",point_angle_degree=" + point_angle_degree[instance][j] + ",scr_x=" + scr_x[instance][j] + ",scr_y=", scr_y[instance][j]);
          scr_x[instance][j] += offset_x;
          if (MIRROR_ENABLE[instance])
            scr_y[instance][j] += offset_y;
          else
            scr_y[instance][j] = offset_y - scr_y[instance][j];
        }
        else if (ROTATE_FACTOR[instance] == 45) {
          scr_x[instance][j] = mi_x[instance][j] / ZOOM_FACTOR[instance];
          scr_y[instance][j] = mi_y[instance][j] / ZOOM_FACTOR[instance];
          //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + distance + ",point_angle_degree=" + point_angle_degree[instance][j] + ",scr_x=" + scr_x[instance][j] + ",scr_y=", scr_y[instance][j]);
          if (MIRROR_ENABLE[instance])
            scr_x[instance][j] = offset_x - scr_x[instance][j];
          else
            scr_x[instance][j] += offset_x;
          scr_y[instance][j] += offset_y;
        }
        else if (ROTATE_FACTOR[instance] == 135) {
          scr_x[instance][j] = mi_y[instance][j] / ZOOM_FACTOR[instance];
          scr_y[instance][j] = mi_x[instance][j] / ZOOM_FACTOR[instance];
          //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + distance + ",point_angle_degree=" + point_angle_degree[instance][j] + ",scr_x=" + scr_x[instance][j] + ",scr_y=", scr_y[instance][j]);
          scr_x[instance][j] = offset_x - scr_x[instance][j];
          if (MIRROR_ENABLE[instance])
            scr_y[instance][j] = offset_y - scr_y[instance][j];
          else
            scr_y[instance][j] += offset_y;
        }
        else /*if (ROTATE_FACTOR[instance] == 225)*/ {
          scr_x[instance][j] = mi_x[instance][j] / ZOOM_FACTOR[instance];
          scr_y[instance][j] = mi_y[instance][j] / ZOOM_FACTOR[instance];
          //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + distance + ",point_angle_degree=" + point_angle_degree[instance][j] + ",scr_x=" + scr_x[instance][j] + ",scr_y=", scr_y[instance][j]);
          if (MIRROR_ENABLE[instance])
            scr_x[instance][j] += offset_x;
          else
            scr_x[instance][j] = offset_x - scr_x[instance][j];
          scr_y[instance][j] = offset_y - scr_y[instance][j];
        }
        scr_x[instance][j] += DRAW_OFFSET_X[instance];
        scr_y[instance][j] += DRAW_OFFSET_Y[instance];

        //println("PS_Data:parse("+instance+"):"+"j="+j+",mi_x="+mi_x[instance][j]+",mi_y="+mi_y[instance][j]);
        //println("PS_Data:parse("+instance+"):"+"j="+j+",scr_x="+scr_x[instance][j]+",scr_y="+scr_y[instance][j]);
      }
      i = i + 4;

      // Check pulse width exist
      if (data_content[instance] != 4) {
        // Get Pulse width
        // : indications of the signal's strength and are provided in picoseconds.
        pulse_width[instance][j] = get_int32_bytes(PS_Data_buf[instance], i);
        //println("index=" + i + ",point=", j, ",pulse width=" + pulse_width);

        //print("[" + j + "]=" + pulse_width[instance][j] + " ");
        if(pulse_width[instance][j] >= PS_DATA_PULSE_WIDTH_MAX)
        {
          pulse_width_color[instance][j] =
            PS_Data_pulse_width_color_value[
              PS_DATA_PULSE_WIDTH_MAX - PS_DATA_PULSE_WIDTH_MIN];
          //pulse_width_color[instance][j] = color(255,255,255,255); // White
          //pulse_width_color[instance][j] = color(0,0,0,0); // Black
        }
        else if(pulse_width[instance][j] <= PS_DATA_PULSE_WIDTH_MIN)
        {
          pulse_width_color[instance][j] =
            PS_Data_pulse_width_color_value[0];
          //pulse_width_color[instance][j] = color(255,255,255,255); // White
        }
        else
        {
          pulse_width_color[instance][j] =
            PS_Data_pulse_width_color_value[
              pulse_width[instance][j] - PS_DATA_PULSE_WIDTH_MIN];
          //pulse_width_color[instance][j] = color(255,255,255,255); // White
          //pulse_width_color[instance][j] = color(0,0,0,0); // Black
        }

        i = i + 4;
      }
      else {
        pulse_width[instance][j] = -1;
        pulse_width_color[instance][j] = C_PS_DATA_POINT;
      }
    }

// Skip the get CRC. this already done above.
/*
    // Get CRC
    // : Checksum
    crc = get_int32_bytes(PS_Data_buf[instance], i);
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_PARSE_DBG) println("index=" + i + ",crc=" + crc);
    i = i + 4;
*/  

    pulse_width_low_count[instance] = 0;

    // Clear parse error string and count
    parse_err_str[instance] = null;
    parse_err_cnt[instance] = 0;

    return true;
  } // End of parse()

  // Draw params of parsed Data buffer
  public void draw_params(int instance) {
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_params("+instance+"):Enter");

    if (!PS_Data_draw_params_enabled[instance]) return;

    if (get_millis_diff(PS_Data_draw_params_timer[instance]) >= SYSTEM_UI_TIMEOUT * 1000) {
      PS_Data_draw_params_enabled[instance] = false;
    }

    ArrayList<String> strings = new ArrayList<String>();

    strings.add("Interface:" + PS_Interface_str[PS_Interface[instance]]);
    if (files_time_long[instance] != -1)
      strings.add("Time long:" + files_time_long[instance]/1000. + "s");
    if (file_name[instance] != null)
      strings.add("File name:" + file_name[instance]);
    if (load_take_time[instance] != -1)
      strings.add("Response t.:" + load_take_time[instance] + "ms");
    if (load_done_interval_millis[instance] != -1)
      strings.add("Refresh t.:" + load_done_interval_millis[instance] + "(" + (load_done_interval_count[instance] == 0?"N/A":load_done_interval_millis_accu[instance]/load_done_interval_count[instance]) + ")" + "ms");
    if (PS_Interface[instance] != PS_Interface_None) {
      strings.add("Scan number:" + scan_number[instance]);
      strings.add("Time stamp:" + time_stamp[instance]);
      strings.add("Scan start angle:" + (scan_angle_start[instance] + ANGLE_ADJUST[instance] / 100.) + "°");
      strings.add("Scan angle size:" + (ANGLE_ADJUST[instance] > 0?(scan_angle_size[instance] - ANGLE_ADJUST[instance] / 100.):scan_angle_size[instance]) + "°");
      strings.add("Number of echoes:" + number_of_echoes[instance]);
      //strings.add("Encoder count:" + incremental_count[instance]);
      strings.add("System temp.:" + system_temperature[instance] + "°C");
      strings.add("System status:" + system_status[instance]);
      strings.add("Data content:" + data_content[instance]);
      strings.add("Num. points:" + number_of_points[instance] + "(" + number_of_points_error[instance] + ")");
      if (data_content[instance] != 4) {
        strings.add("Skip points(<"+PS_DATA_PULSE_WIDTH_THRESHOLD+"):" + pulse_width_low_count[instance]);
      }
    }
    strings.add("Time-out:" + ((SYSTEM_UI_TIMEOUT * 1000 + 1000 - get_millis_diff(PS_Data_draw_params_timer[instance]))/1000) + "s");

    // Get max string width
    textSize(FONT_HEIGHT);
    int witdh_max = 0;
    for (String string:strings) {
      witdh_max = max(witdh_max, int(textWidth(string)));    
    }

    int rect_w, rect_h;
    int rect_x, rect_y;
    int rect_tl = 5, rect_tr = 5, rect_br = 5, rect_bl = 5;
    if (ROTATE_FACTOR[instance] == 315) {
      if (MIRROR_ENABLE[instance]) {
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance] - rect_w - 1;
        rect_y = PS_Data_draw_params_y[instance];
        rect_tr = 0;
      }
      else {
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance] - rect_w - 1;
        rect_y = PS_Data_draw_params_y[instance] - rect_h - 1;
        rect_br = 0;
      }
    }
    else if (ROTATE_FACTOR[instance] == 45) {
      if (MIRROR_ENABLE[instance]) {
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance];
        rect_y = PS_Data_draw_params_y[instance];
        rect_tl = 0;
      }
      else {
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance] - rect_w - 1;
        rect_y = PS_Data_draw_params_y[instance];
        rect_tr = 0;
      }
    }
    else if (ROTATE_FACTOR[instance] == 135) {
      if (MIRROR_ENABLE[instance]) {
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance];
        rect_y = PS_Data_draw_params_y[instance] - rect_h - 1;
        rect_bl = 0;
      }
      else {
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance];
        rect_y = PS_Data_draw_params_y[instance];
        rect_tl = 0;
      }
    }
    else /*if (ROTATE_FACTOR[instance] == 225)*/ {
      if (MIRROR_ENABLE[instance]) {
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance] - rect_w - 1;
        rect_y = PS_Data_draw_params_y[instance] - rect_h - 1;
        rect_br = 0;
      }
      else {
        rect_w = witdh_max + TEXT_MARGIN * 2;
        rect_h = FONT_HEIGHT * strings.size() + TEXT_MARGIN * 2;
        rect_x = PS_Data_draw_params_x[instance];
        rect_y = PS_Data_draw_params_y[instance] - rect_h - 1;
        rect_bl = 0;
      }
    }

    // Check rect over the screen.
    if (rect_tr == 0 || rect_br == 0) {
      if (rect_x < 0)
        rect_x = 0;
    }
    else if (rect_tl == 0 || rect_bl == 0) {
      if (rect_x + rect_w >= SCREEN_width)
        rect_x = SCREEN_width - rect_w - 1;
    }

    // Draw rect
    fill(C_PS_DATA_RECT_FILL);
    // Sets the color and weight used to draw lines and borders around shapes.
    stroke(C_PS_DATA_RECT_STROKE);
    strokeWeight(W_PS_DATA_RECT_STROKE);
    rect(rect_x, rect_y, rect_w, rect_h, rect_tl, rect_tr, rect_br, rect_bl);

    // Sets the color used to draw lines and borders around shapes.
    fill(C_PS_DATA_RECT_TEXT);
    stroke(C_PS_DATA_RECT_TEXT);
    textAlign(LEFT, BASELINE);
    final int str_x = rect_x + TEXT_MARGIN;
    final int str_y = rect_y + TEXT_MARGIN - 1;
    for( int i = 0; i < strings.size(); i ++) {
      String string = strings.get(i);
      text(string, str_x, str_y + FONT_HEIGHT * (1 + i));
    }
  } // End of draw_params()
  
  // Draw points of parsed Data buffer
  public void draw_points(int instance)
  {
    int distance;
    int mi_x, mi_y;
    int point_x_curr, point_y_curr;
    int pulse_width;
    int point_size_curr = PS_DATA_POINT_WEIGHT; // Set weight of point rect
    color point_color_curr = C_PS_DATA_POINT;
    boolean point_is_contains_curr;
    int point_x_prev = MIN_INT, point_y_prev = MIN_INT;
    int point_size_prev = PS_DATA_POINT_WEIGHT; // Set weight of point rect
    boolean point_is_contains_prev = false;
    color point_color_prev = C_PS_DATA_POINT;
    color line_color = C_PS_DATA_LINE;

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_points("+instance+"):Enter");

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_points("+instance+"):number_of_points="+number_of_points[instance]);

    if (PS_Data_draw_points_all_enabled) {
      if (!PS_Data_draw_points_all_time_started) {
        PS_Data_draw_points_all_start_time = millis();
        PS_Data_draw_points_all_time_started = true;
      }
      else {
        if (get_millis_diff(PS_Data_draw_points_all_start_time) > SYSTEM_UI_TIMEOUT * 1000) {
          PS_Data_draw_points_all_enabled = false;
          PS_Data_draw_points_all_time_started = false;
        }
      }
    }

    // Sets the weight used to rect borders around shapes.
    strokeWeight(1);

    if (time_stamp_reseted[instance]) {
      ROI_Data_handle.clear_objects(instance);
      time_stamp_reseted[instance] = false;
    }
    ROI_Data_handle.clear_points(instance);
    ROI_Data_handle.set_time_stamp(instance, time_stamp[instance]);
    ROI_Data_handle.set_angle_step(instance, scan_angle_step[instance]);

    for (int j = 0; j < number_of_points[instance]; j++) {
      // Get Distance
      // : units are 1/10 mm.
      // : The distance value is -2147483648 (0x80000000) in case that the echo signal was too low.
      // : The distance value is 2147483647 (0x7FFFFFFF) in case that the echo signal was noisy.
      distance = this.distances[instance][j];
      mi_x = this.mi_x[instance][j];
      mi_y = this.mi_y[instance][j];
      point_x_curr = this.scr_x[instance][j];
      point_y_curr = this.scr_y[instance][j];
      pulse_width = this.pulse_width[instance][j];

      if (point_x_curr == MIN_INT && point_y_curr == MIN_INT) {
        //if (PRINT_PS_DATA_DRAW_DBG) println("point=", j, ",distance=" + "No echo");
        point_x_prev = MIN_INT;
        point_y_prev = MIN_INT;
        point_color_prev = -1;
        point_is_contains_prev = false;
      }
      else {
        /*
        int region_index = Regions_check_point_contains(instance, mi_x, mi_y);
        if (region_index >= 0) {
          ROI_Data_handle.add_point(instance, region_index, mi_x, mi_y, point_x_curr, point_y_curr);
          point_is_contains_curr = true;
          if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_points("+instance+"):"+Regions_handle.get_region_name(instance, region_index)+":x="+mi_x+",y="+mi_y);
        }
        */
        if ((data_content[instance] != 4 && pulse_width >= PS_DATA_PULSE_WIDTH_THRESHOLD)
            ||
            data_content[instance] == 4) {
          ArrayList<Integer> region_indexes = Regions_handle.get_region_indexes_contains_point(instance, mi_x, mi_y);
          if (region_indexes.size() > 0) {
            ROI_Data_handle.add_point(instance, region_indexes, mi_x, mi_y, point_x_curr, point_y_curr);
            point_is_contains_curr = true;
            if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_points("+instance+"):"+Regions_handle.get_region_name(instance, region_indexes.get(0))+":x="+mi_x+",y="+mi_y);
          }
          else {
            point_is_contains_curr = false;
          }
        }
        else {
          if ((data_content[instance] != 4 && pulse_width < PS_DATA_PULSE_WIDTH_THRESHOLD)) {
            pulse_width_low_count[instance] ++;
          }
          point_is_contains_curr = false;
          if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_points("+instance+")"+":x="+mi_x+",y="+mi_y+",pw="+pulse_width);
        }

        if (point_is_contains_curr
            ||
            PS_Data_draw_points_all_enabled) {
          // Check pulse width exist
          if (data_content[instance] != 4) {
            point_color_curr = pulse_width_color[instance][j];
            if(point_color_prev != -1) {
              line_color = (point_color_curr + point_color_prev) / 2;
            }
          }
          else {
            point_color_curr = C_PS_DATA_POINT;
            point_color_prev = C_PS_DATA_POINT;
            line_color = C_PS_DATA_LINE;
          }

          if (Bubble_Info_enabled) {
            final int mouse_over_range =
              (ZOOM_FACTOR[instance] < 50)
              ?
              (PS_DATA_POINT_WEIGHT + (50 - ZOOM_FACTOR[instance]) / 10)
              :
              PS_DATA_POINT_WEIGHT; // Range for mouse over point rect. Adjust mouse over range by ZOOM_FACTOR.
            final int mouse_over_x_min = mouseX - mouse_over_range;
            final int mouse_over_x_max = mouseX + mouse_over_range;
            final int mouse_over_y_min = mouseY - mouse_over_range;
            final int mouse_over_y_max = mouseY + mouse_over_range;

            // Check mouse pointer over point rect.
            if( BUBBLE_INFO_AVAILABLE != true
                &&
                (point_x_curr > mouse_over_x_min && point_x_curr < mouse_over_x_max)
                &&
                (point_y_curr > mouse_over_y_min && point_y_curr < mouse_over_y_max)
              ) {
              //println("point=" + j + ",distance=" + (float(distance)/10000.0) + "m(" + (mi_x/10000.0) + "," + (mi_y/10000.0) + ")" + ",pulse width=" + pulse_width);
              BUBBLE_INFO_AVAILABLE = true;
              BUBBLE_INFO_POINT = j;
              BUBBLE_INFO_DISTANCE = float(distance/10)/1000.0;
              // Check need to rotate x,y.
              if (ROTATE_FACTOR[instance] == 315 || ROTATE_FACTOR[instance] == 135)
              {
                BUBBLE_INFO_COR_X = float(mi_y/10)/1000.0;
                BUBBLE_INFO_COR_Y = float(mi_x/10)/1000.0;
              }
              else
              {
                BUBBLE_INFO_COR_X = float(mi_x/10)/1000.0;
                BUBBLE_INFO_COR_Y = float(mi_y/10)/1000.0;
              }
              BUBBLE_INFO_BOX_X = point_x_curr;
              BUBBLE_INFO_BOX_Y = point_y_curr;
              BUBBLE_INFO_ANGLE = float(int(point_angle_degree[instance][j]*100.0))/100.0;
              BUBBLE_INFO_PULSE_WIDTH = pulse_width;
              point_size_curr = BUBBLE_INFO_POINT_WH;
            }
            else {
              // Reset width and height point rect
              point_size_curr = PS_DATA_POINT_WEIGHT;
            }
          }
        }

        // Draw first a previous point if possible.
        if (point_x_prev != MIN_INT && point_y_prev != MIN_INT) {
          if (point_is_contains_prev
              ||
              PS_Data_draw_points_all_enabled) {
            if (PS_Data_draw_points_with_line
                &&
                ( point_is_contains_curr
                  ||
                  PS_Data_draw_points_all_enabled)) {
              fill(line_color);
              stroke(line_color);
              // Sets the weight used to draw line.
              strokeWeight(W_PS_DATA_LINE);
              line(point_x_prev, point_y_prev, point_x_curr, point_y_curr);
              // Sets the weight used to rect borders around shapes.
              strokeWeight(1);
            }
            fill(point_color_prev);
            stroke(point_color_prev);
            //for (int x = point_x_prev - point_size_prev / 2; x <= point_x_prev + point_size_prev / 2; x ++) {
            //  line(x, point_y_prev - point_size_prev / 2, x, point_y_prev + point_size_prev / 2);
            //}
            //for (int x = point_x_prev - point_size_prev / 2; x <= point_x_prev + point_size_prev / 2; x ++) {
            //  for (int y = point_y_prev - point_size_prev / 2; y <= point_y_prev + point_size_prev / 2; y ++) {
            //    point(x, y);
            //  }
            //}
            rect( point_x_prev - point_size_prev / 2,
                  point_y_prev - point_size_prev / 2,
                  point_size_prev,
                  point_size_prev );
          }
        }

        // And than, Draw current point if possible.
        if (point_is_contains_curr
            ||
            PS_Data_draw_points_all_enabled) {
          fill(point_color_curr);
          stroke(point_color_curr);
          //for (int x = point_x_curr - point_size_curr / 2; x <= point_x_curr + point_size_curr / 2; x ++) {
          //  line(x, point_y_curr - point_size_curr / 2, x, point_y_curr + point_size_curr / 2);
          //}
          //for (int x = point_x_curr - point_size_curr / 2; x <= point_x_curr + point_size_curr / 2; x ++) {
          //  for (int y = point_y_curr - point_size_curr / 2; y <= point_y_curr + point_size_curr / 2; y ++) {
          //    point(x, y);
          //  }
          //}
          rect( point_x_curr - point_size_curr / 2,
                point_y_curr - point_size_curr / 2,
                point_size_curr,
                point_size_curr );
          // Save point data for drawing line between previous and current points. 
          point_x_prev = point_x_curr;
          point_y_prev = point_y_curr;
          point_color_prev = point_color_curr;
          point_size_prev = point_size_curr;
          point_is_contains_prev = point_is_contains_curr;
        }
        else {
          point_x_prev = MIN_INT;
          point_y_prev = MIN_INT;
          point_color_prev = -1;
          point_is_contains_prev = false;
        }
      }
    } // End of for (int j = 0; j < number_of_points[instance]; j++)

    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_points("+instance+"):Exit");
  } // End of draw_points()
  
  public void draw_error(int instance, String message)
  {
    if (PRINT_PS_DATA_ALL_DBG || PRINT_PS_DATA_DRAW_DBG) println("PS_Data:draw_error("+instance+"):");

    // Sets the color used to draw lines and borders around shapes.
    fill(C_PS_DATA_ERR_TEXT);
    stroke(C_PS_DATA_ERR_TEXT);
    textSize(FONT_HEIGHT*2);
    textAlign(CENTER, CENTER);
    text( message,
          Grid_scr_x_min[instance],
          Grid_scr_y_min[instance],
          Grid_scr_x_max[instance] - Grid_scr_x_min[instance],
          Grid_scr_y_max[instance] - Grid_scr_y_min[instance]);
  }
}
