import processing.serial.*;

//final static boolean PRINT_RELAY_MODULE_ALL_DBG = true;
final static boolean PRINT_RELAY_MODULE_ALL_DBG = false;
final static boolean PRINT_RELAY_MODULE_ALL_ERR = true;
//final static boolean PRINT_RELAY_MODULE_ALL_ERR = false;

//final static boolean PRINT_RELAY_MODULE_SETUP_DBG = true;
final static boolean PRINT_RELAY_MODULE_SETUP_DBG = false;
//final static boolean PRINT_RELAY_MODULE_SETUP_ERR = true;
final static boolean PRINT_RELAY_MODULE_SETUP_ERR = false;

//final static boolean PRINT_RELAY_MODULE_RESET_DBG = true;
final static boolean PRINT_RELAY_MODULE_RESET_DBG = false;
//final static boolean PRINT_RELAY_MODULE_RESET_ERR = true;
final static boolean PRINT_RELAY_MODULE_RESET_ERR = false;

//final static boolean PRINT_RELAY_MODULE_SET_RELAY_DBG = true;
final static boolean PRINT_RELAY_MODULE_SET_RELAY_DBG = false;
//final static boolean PRINT_RELAY_MODULE_SET_RELAY_ERR = true;
final static boolean PRINT_RELAY_MODULE_SET_RELAY_ERR = false;

//final static boolean PRINT_RELAY_MODULE_WRITE_DBG = true;
final static boolean PRINT_RELAY_MODULE_WRITE_DBG = false;
//final static boolean PRINT_RELAY_MODULE_WRITE_ERR = true;
final static boolean PRINT_RELAY_MODULE_WRITE_ERR = false;

//final static boolean PRINT_RELAY_MODULE_READ_DBG = true;
final static boolean PRINT_RELAY_MODULE_READ_DBG = false;
//final static boolean PRINT_RELAY_MODULE_READ_ERR = true;
final static boolean PRINT_RELAY_MODULE_READ_ERR = false;

//final static boolean PRINT_RELAY_MODULE_LOAD_DBG = true;
final static boolean PRINT_RELAY_MODULE_LOAD_DBG = false;
//final static boolean PRINT_RELAY_MODULE_LOAD_ERR = true;
final static boolean PRINT_RELAY_MODULE_LOAD_ERR = false;

static color C_RELAY_MODULE_INDICATOR_OFF_FILL = 0x40000000; // Black
static color C_RELAY_MODULE_INDICATOR_OFF_STROKE = 0xFF404040; // Dark gray

//static boolean RELAY_MODULE_UART_REPLY_REQUEST_ENABLED = true;
static boolean RELAY_MODULE_UART_REPLY_REQUEST_ENABLED = false;

static boolean Relay_Module_UART_enabled = true;

static Serial Relay_Module_UART_handle = null;  // The handle of UART(serial port)

static String Relay_Module_UART_port_name = "NA"; // String: name of the port (COM1 is the default)
static int Relay_Module_UART_baud_rate = 115200; // int: 9600 is the default
static char Relay_Module_UART_parity = 'N'; // char: 'N' for none, 'E' for even, 'O' for odd, 'M' for mark, 'S' for space ('N' is the default)
static int Relay_Module_UART_data_bits = 8; // int: 8 is the default
static float Relay_Module_UART_stop_bits = 1.0; // float: 1.0, 1.5, or 2.0 (1.0 is the default)

final static int RELAY_MODULE_NUMBER_OF_RELAYS = 4;

final static int RELAY_MODULE_CHECK_INTERVAL_IDLE = 1000;

// Define default table filename and ext.
final static String RELAY_MODULE_RELAYS_FILE_NAME = "relays";
final static String RELAY_MODULE_RELAYS_FILE_EXT = ".csv";

static boolean Relay_Module_output_block_enabled;

static boolean[] Relay_Module_output_val = new boolean[RELAY_MODULE_NUMBER_OF_RELAYS];
static boolean[] Relay_Module_output_block = new boolean[RELAY_MODULE_NUMBER_OF_RELAYS];
static int Relay_Module_output_interval;
static int Relay_Module_output_timer;
static ArrayList<UI_Relay_Indicator> Relay_Module_indicators = null;
static ArrayList<Relay_CSV> Relay_Module_relays_csv = null;

class Relay_CSV {
  String relay_name;
  int relay_index;
  int indicator_scr_center_x;
  int indicator_scr_top_y;
  int indicator_text_height;
}

static boolean Relay_Module_set_relay_thread_setup_done;
static boolean Relay_Module_set_relay_thread_run;

static boolean Relay_Module_set_relay_first_done = false;
static boolean Relay_Module_UART_error_flag = false;

static enum Relay_Module_UART_read_state_enum {
  IDLE,
  DATA,
  CHECK_SUM,
  MAX
}

static Relay_Module_UART_read_state_enum Relay_Module_UART_read_state = Relay_Module_UART_read_state_enum.IDLE;

static Message_Box Relay_Moude_Message_Box_handle = null;

void Relay_Module_setup()
{
  if (PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_SETUP_DBG) println("Relay_Module_setup():Enter");

  boolean found = false;

  //printArray(Serial.list());

  Relay_Module_output_block_enabled = true;
  //Relay_Module_output_block_enabled = false;

  Relay_Module_output_interval = 0; // to set at initial time.
  Relay_Module_output_timer = millis();

  Relay_Module_set_relay_first_done = false;
  Relay_Module_UART_error_flag = false;
  Relay_Module_UART_read_state = Relay_Module_UART_read_state_enum.IDLE;

  String file_full_name;
  Table table;

  file_full_name = DATA_DIR_FULL_NAME + RELAY_MODULE_RELAYS_FILE_NAME + RELAY_MODULE_RELAYS_FILE_EXT;

  // Load lines file(CSV type) into a Table object
  // "header" option indicates the file has a header row
  table = loadTable(file_full_name, "header");
  // Check loadTable failed.
  if(table == null) {
    if (PRINT_RELAY_MODULE_ALL_ERR || PRINT_RELAY_MODULE_SETUP_ERR) println("Relay_Module_setup():loadTable("+file_full_name+") Error!");
    SYSTEM_logger.severe("Relay_Module_setup():loadTable("+file_full_name+") Error!");
    return;
  }

  if (Relay_Module_indicators == null)
  {
    Relay_Module_indicators = new ArrayList();
  }
  else
  {
    Relay_Module_indicators.clear();
  }

  for (int relay_index = 0; relay_index < RELAY_MODULE_NUMBER_OF_RELAYS; relay_index ++)
  {
    Relay_Module_output_val[relay_index] = false;
    Relay_Module_output_block[relay_index] = false;
    Relay_Module_indicators.add(new UI_Relay_Indicator());
  }

  if (Relay_Module_relays_csv == null)
  {
    Relay_Module_relays_csv = new ArrayList();
  }
  else
  {
    Relay_Module_relays_csv.clear();
  }

  for (TableRow variable:table.rows()) {
    Relay_CSV relay_csv = new Relay_CSV();

    int relay_index = variable.getInt("Relay_Index");
    String relay_name = variable.getString("Relay_Name");
    int indicator_scr_center_x = variable.getInt("Indicator_Screen_Center_X");
    int indicator_scr_top_y = variable.getInt("Indicator_Screen_Top_Y");
    int indicator_text_height = variable.getInt("Idicator_Text_Height");

    relay_csv.relay_name = relay_name;
    relay_csv.relay_index = relay_index;
    relay_csv.indicator_scr_center_x = indicator_scr_center_x;
    relay_csv.indicator_scr_top_y = indicator_scr_top_y;
    relay_csv.indicator_text_height = indicator_text_height;
    Relay_Module_relays_csv.add(relay_csv);

    // If name start with # than skip it.
    if (relay_name.length() > 0 && relay_name.charAt(0) == '#') {
      continue;
    }

    for (int instance = 0; instance < PS_INSTANCE_MAX; instance ++)
    {
      int region_index;
      for (region_index = 0; region_index < Regions_handle.regions_array[instance].size(); region_index ++)
      {
        Region_Data region_data = Regions_handle.regions_array[instance].get(region_index);

        if (region_data.relay_index != relay_index) continue;

        int x, y, w, h, r;
        int stroke_w;
        color on_fill_c;
        color off_fill_c;
        color on_stroke_c;
        color off_stroke_c;
        String on_text = "ON";
        String off_text = "OFF";
        float on_text_width, off_text_width, text_width_max;

        on_text = relay_name + (relay_name.length() == 0?"":" ") + on_text;
        off_text = relay_name + (relay_name.length() == 0?"":" ") + off_text;

        textSize(indicator_text_height);
        on_text_width = textWidth(on_text);
        off_text_width = textWidth(off_text);
        text_width_max = max(on_text_width, off_text_width);

        w = int(text_width_max + indicator_text_height / 4.0 * 2.0);
        h = int(indicator_text_height + indicator_text_height / 4.0 * 2.0);
        x = int(indicator_scr_center_x - w / 2.0);
        y = indicator_scr_top_y;
        r = int(indicator_text_height / 4.0);
        stroke_w = region_data.marker_stroke_weight;
        on_fill_c = region_data.marker_fill_color;
        off_fill_c = C_RELAY_MODULE_INDICATOR_OFF_FILL;
        on_stroke_c = region_data.marker_stroke_color;
        off_stroke_c = C_RELAY_MODULE_INDICATOR_OFF_STROKE;
        Relay_Module_indicators
          .get(relay_index)
            .set(
              x, y, w, h, r,
              stroke_w,
              on_fill_c, off_fill_c,
              on_stroke_c, off_stroke_c,
              indicator_text_height,
              on_text, int(indicator_scr_center_x - on_text_width / 2.0),
              off_text, int(indicator_scr_center_x - off_text_width / 2.0));
        break;
      }
      if (region_index != Regions_handle.regions_array[instance].size())
        break;
    }
  }

  Relay_Module_set_relay_thread_run = false;
  if (!Relay_Module_set_relay_thread_setup_done)
  {
    thread("Relay_Module_set_relay_thread");
    Relay_Module_set_relay_thread_setup_done = true;
  }

  // Reset Serial. 
  if (Relay_Module_UART_handle != null)
  {
    Relay_Module_UART_handle.stop();
    Relay_Module_UART_handle = null;
  }

  if (Relay_Module_UART_port_name.equals("")
      ||
      Relay_Module_UART_port_name.equals("NA"))
  {
    Relay_Module_UART_enabled = false;
    return;
  }

  Relay_Module_UART_enabled = true;

  // Check Relay_Module_UART_port_name with the available serial ports
  for (String port:Serial.list())
  {
    if (PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_SETUP_DBG) println("Relay_Module_setup():Serial port name="+port);
    //println("Relay_Module_setup():Serial port name="+port);
    if (port.equals(Relay_Module_UART_port_name.toUpperCase()))
    {
      found = true;
      break;
    }
  }
  if (!found)
  {
    if(PRINT_RELAY_MODULE_ALL_ERR || PRINT_RELAY_MODULE_SETUP_ERR) println("Relay_Module_setup():Can not find com port error! \""+Relay_Module_UART_port_name+"\"");
    SYSTEM_logger.severe("Relay_Module_setup():Can not find com port error! \""+Relay_Module_UART_port_name+"\"");
    return;
  }

  try
  {
    // Open the port you are using at the rate you want:
    Relay_Module_UART_handle = new Serial(this, Relay_Module_UART_port_name, Relay_Module_UART_baud_rate, Relay_Module_UART_parity, Relay_Module_UART_data_bits, Relay_Module_UART_stop_bits);
    Relay_Module_UART_handle.clear();
    Relay_Module_UART_handle.buffer(1);
  }
  catch (Exception e)
  {
    Relay_Module_UART_handle = null;
  }
}

void Relay_Module_reset()
{
  if (PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_RESET_DBG) println("Relay_Module_reset():Enter");

  // Check UART port config changed
  if (Relay_Module_UART_handle != null)
  {
    Relay_Module_UART_handle.stop();
    Relay_Module_UART_handle = null;
  }
}

void Relay_Module_output()
{
  boolean updated = false;

  for (int instance = 0; instance < PS_INSTANCE_MAX; instance ++)
  {
    boolean output;
    for (int region_index = 0; region_index < Regions_handle.get_regions_size_for_index(instance); region_index ++)
    {
      int relay_index;
      output = Regions_handle.get_region_has_object(instance, region_index);
      relay_index = Regions_handle.get_region_relay_index(instance, region_index);
      //println("relay_index="+relay_index);
      if (relay_index < 0 || relay_index >= RELAY_MODULE_NUMBER_OF_RELAYS)
      {
        continue;
      }
      if (output != Relay_Module_output_val[relay_index])
      {
        Relay_Module_output_val[relay_index] = output;
        // Relay output will block when PS Interface is FILE.
        if (PS_Interface[instance] == PS_Interface_FILE
            &&
            Relay_Module_output_block_enabled)
        {
          Relay_Module_output_block[relay_index] = true;
        }
        else
        {
          Relay_Module_output_block[relay_index] = false;
        }
        updated = true;
      }
    }
  }
  //Dbg_Time_logs_handle.add("Relay_Module_output():for loop");

  Relay_Module_draw_indicator();
  //Dbg_Time_logs_handle.add("Relay_Module_output():Relay_Module_draw_indicator()");

  if (RELAY_MODULE_UART_REPLY_REQUEST_ENABLED
      &&
      Relay_Module_UART_error_flag)
  {
    if (!Relay_Moude_Message_Box_handle.draw())
    {
      Relay_Module_UART_error_flag = false;
    }
    //Dbg_Time_logs_handle.add("Relay_Module_output():Relay_Moude_Message_Box_handle.draw()");
  }

  if (!updated
      &&
      get_millis_diff(Relay_Module_output_timer) < Relay_Module_output_interval)
  {
    return;
  }
  Relay_Module_output_timer = millis();
  Relay_Module_output_interval = RELAY_MODULE_CHECK_INTERVAL_IDLE;

  Relay_Module_set_relay();
  //Dbg_Time_logs_handle.add("Relay_Module_output():Relay_Module_set_relay()");
}

private void Relay_Module_set_relay()
{
  if (!Relay_Module_UART_enabled) return;

  if (RELAY_MODULE_UART_REPLY_REQUEST_ENABLED)
  {
    if (Relay_Module_set_relay_first_done
        &&
        !Arrays.equals(Relay_Module_UART_write_data_buf, Relay_Module_UART_read_data_buf))
    {
      Relay_Moude_Message_Box_handle = new Message_Box("Relay Module Error !", "Check Relay Module and Serial port name ("+Relay_Module_UART_port_name+") available.", 5);
      Relay_Module_UART_error_flag = true;
    }
    else
    {
      if (Relay_Moude_Message_Box_handle != null)
      {
        Relay_Moude_Message_Box_handle.set_forced_timeout();
        Relay_Moude_Message_Box_handle = null;
      }
      Relay_Module_UART_error_flag = false;
    }

    Relay_Module_UART_read_data_buf[0] = '0';
    Relay_Module_set_relay_first_done = true;
  }

  Relay_Module_set_relay_thread_run = true;

}

static byte[] Relay_Module_UART_write_data_buf = new byte[RELAY_MODULE_NUMBER_OF_RELAYS + 2];

void Relay_Module_set_relay_thread()
{
  do
  {
    delay(FRAME_TIME);

    if (!Relay_Module_set_relay_thread_run) continue;

    if (RELAY_MODULE_UART_REPLY_REQUEST_ENABLED)  Relay_Module_UART_write_data_buf[0] = 'Q';
    else                                  Relay_Module_UART_write_data_buf[0] = 'R';

    int cnt = 0;
    int relay_index;
    for (relay_index = 0; relay_index < RELAY_MODULE_NUMBER_OF_RELAYS; relay_index ++)
    {
      // Relay output will off when PS Interface is FILE.
      if (Relay_Module_output_val[relay_index]
          &&
          !Relay_Module_output_block[relay_index])
      {
        Relay_Module_UART_write_data_buf[relay_index + 1] = '1';
        cnt ++;
      }
      else
      {
        Relay_Module_UART_write_data_buf[relay_index + 1] = '0';
      }
    }
    Relay_Module_UART_write_data_buf[relay_index + 1] = byte('0' + cnt);
    Relay_Module_UART_write(Relay_Module_UART_write_data_buf);

    Relay_Module_set_relay_thread_run = false;
  } while (true);
}

private void Relay_Module_draw_indicator()
{
  for (int relay_index = 0; relay_index < RELAY_MODULE_NUMBER_OF_RELAYS; relay_index ++)
  {
    UI_Relay_Indicator indicator = Relay_Module_indicators.get(relay_index);
    indicator.draw(Relay_Module_output_val[relay_index]);
  }
}

boolean Relay_Module_check_relay_index(int relay_index)
{
  if (relay_index < 0) return false;
  for (Relay_CSV relay_csv:Relay_Module_relays_csv)
  {
    if (relay_csv.relay_index != relay_index) continue;
    return true;
  }
  return false;
}

String Relay_Module_get_relay_name(int relay_index)
{
  if (relay_index < 0) return null;
  for (Relay_CSV relay_csv:Relay_Module_relays_csv)
  {
    if (relay_csv.relay_index != relay_index) continue;
    return relay_csv.relay_name;
  }
  return null;
}

void Relay_Module_set_relay_name(int relay_index, String relay_name)
{
  if (relay_index < 0) return;
  for (Relay_CSV relay_csv:Relay_Module_relays_csv)
  {
    if (relay_csv.relay_index != relay_index) continue;
    relay_csv.relay_name = relay_name;
  }
}

void Relay_Module_update_relays_csv_file()
{
  // A Table object
  Table table;

  table = new Table();
  table.addColumn("Relay_Index");
  table.addColumn("Relay_Name");
  table.addColumn("Indicator_Screen_Center_X");
  table.addColumn("Indicator_Screen_Top_Y");
  table.addColumn("Idicator_Text_Height");

  for (Relay_CSV relay_csv:Relay_Module_relays_csv) {
    TableRow variable = table.addRow();
    variable.setInt(    "Relay_Index",
                        relay_csv.relay_index);
    variable.setString( "Relay_Name",
                        relay_csv.relay_name);
    variable.setInt(    "Indicator_Screen_Center_X",
                        relay_csv.indicator_scr_center_x);
    variable.setInt(    "Indicator_Screen_Top_Y",
                        relay_csv.indicator_scr_top_y);
    variable.setInt(    "Idicator_Text_Height",
                        relay_csv.indicator_text_height);
  }

  String file_full_name;

  file_full_name = DATA_DIR_FULL_NAME + RELAY_MODULE_RELAYS_FILE_NAME + RELAY_MODULE_RELAYS_FILE_EXT;
  saveTable(table, file_full_name);
}

void Relay_Module_UART_clear()
{
  if(Relay_Module_UART_handle == null) return;
  Relay_Module_UART_handle.clear();
}

void Relay_Module_UART_write(byte[] buf)
{
  if (PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_WRITE_DBG) println("Relay_Module_UART_write():buf.length="+buf.length);
  if (Relay_Module_UART_handle == null)
  {
    if (PRINT_RELAY_MODULE_ALL_ERR || PRINT_RELAY_MODULE_WRITE_ERR) println("Relay_Module_UART_write():Relay_Module_UART_handle=null");
    SYSTEM_logger.severe("Relay_Module_UART_write():Relay_Module_UART_handle=null");
    return;
  }
  Relay_Module_UART_handle.write(buf);
}

static byte[] Relay_Module_UART_read_data_buf = new byte[RELAY_MODULE_NUMBER_OF_RELAYS+2];
static int Relay_Module_UART_read_data_count;
static byte Relay_Module_UART_read_check_sum;

void Relay_Module_UART_read(byte[] buf)
{

  if(PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_READ_DBG) println("Relay_Module_UART_read():Enter");

  for (int index = 0; index < buf.length; index ++) {
    do { // do while loop for continue statement on switch.
      if(PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_READ_DBG) println("Relay_Module_UART_read():Relay_Module_UART_read_state="+Relay_Module_UART_read_state);
      switch (Relay_Module_UART_read_state) {
        case IDLE:
          if (buf[index] != 'Q') break;
          Relay_Module_UART_read_state = Relay_Module_UART_read_state_enum.DATA;
          Relay_Module_UART_read_data_count = 0;
          Relay_Module_UART_read_data_buf[Relay_Module_UART_read_data_count] = buf[index];
          Relay_Module_UART_read_data_count ++;
          Relay_Module_UART_read_check_sum = '0';
          break;
        case DATA:
          if (buf[index] != '0' && buf[index] != '1') {
            Relay_Module_UART_read_state = Relay_Module_UART_read_state_enum.IDLE;
            continue;
          }
          Relay_Module_UART_read_data_buf[Relay_Module_UART_read_data_count] = buf[index];
          Relay_Module_UART_read_data_count ++;
          Relay_Module_UART_read_check_sum += buf[index] - '0';
          if (Relay_Module_UART_read_data_count == RELAY_MODULE_NUMBER_OF_RELAYS + 1)
            Relay_Module_UART_read_state = Relay_Module_UART_read_state_enum.CHECK_SUM;
          break;
        case CHECK_SUM:
          if (buf[index] != Relay_Module_UART_read_check_sum) {
            Relay_Module_UART_read_state = Relay_Module_UART_read_state_enum.IDLE;
            continue;
          }
          Relay_Module_UART_read_data_buf[Relay_Module_UART_read_data_count] = buf[index];
          Relay_Module_UART_read_data_count ++;
          if(PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_READ_DBG) {
            print("Relay_Module_UART_read()"+":Relay_Module_UART_read_data_count="+Relay_Module_UART_read_data_count+":");
            for (int i = 0; i < Relay_Module_UART_read_data_count; i ++) {
              print(char(Relay_Module_UART_read_data_buf[i]));
            }
            println("");
          }
          Relay_Module_UART_read_state = Relay_Module_UART_read_state_enum.IDLE;
          break;
        default:
          if (PRINT_RELAY_MODULE_ALL_ERR || PRINT_RELAY_MODULE_READ_ERR) println("Relay_Module_UART_read():switch case error! "+Relay_Module_UART_read_state);
          break;
      }
      break;
    } while (true);
  } // End of for (int index = 0; index < buf.length; index ++)
}

void Relay_Module_UART_serialEvent(Serial serial_port)
{
  if(PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_READ_DBG) println("Relay_Module_UART_serialEvent():Enter");

  try {
    byte[] data;
    int length = 0;  // Bytes length by readBytes()

    length = serial_port.available();
    if(PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_READ_DBG) println("Relay_Module_UART_serialEvent():serial_port.available()=" + length);
    data = serial_port.readBytes(length);
    if(length != data.length) {
      if (PRINT_RELAY_MODULE_ALL_ERR || PRINT_RELAY_MODULE_READ_ERR) println("Relay_Module_UART_serialEvent():"+"Error: UART read length error! " + length + "," + data.length);
      return;
    }
    if(PRINT_RELAY_MODULE_ALL_DBG || PRINT_RELAY_MODULE_READ_DBG) {
      print("Relay_Module_UART_serialEvent()"+":length="+length);
      for (int i = 0; i < length; i ++) {
        print(":["+i+"]"+"="+data[i]+"("+char(data[i])+")");
      }
      println("");
    }
    Relay_Module_UART_read(data);
  }
  catch (Exception e) {
    if (PRINT_RELAY_MODULE_ALL_ERR || PRINT_RELAY_MODULE_READ_ERR) println("Relay_Module_UART_serialEvent():"+e.toString());
  }
} 

class UI_Relay_Indicator {
  int x, y;
  int w, h;
  int r;
  int stroke_w;
  color on_fill_c;
  color off_fill_c;
  color on_stroke_c;
  color off_stroke_c;
  int text_height;
  String on_text;
  int on_text_x;
  String off_text;
  int off_text_x;

  private boolean init = false;

  UI_Relay_Indicator() {
  }

  void set(int x, int y, int w, int h, int r, int stroke_w, color on_fill_c, color off_fill_c, color on_stroke_c, color off_stroke_c, int text_height, String on_text, int on_text_x, String off_text, int off_text_x) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.r = r;
    this.stroke_w = stroke_w;
    this.on_fill_c = on_fill_c;
    this.off_fill_c = off_fill_c;
    this.on_stroke_c = on_stroke_c;
    this.off_stroke_c = off_stroke_c;
    this.text_height = text_height;
    this.on_text = on_text;
    this.on_text_x = on_text_x;
    this.off_text = off_text;
    this.off_text_x = off_text_x;
    init = true;
    //println("UI_Relay_Indicator():set():"+"x="+x+",y="+y+",w="+w+",h="+h);
    //println("UI_Relay_Indicator:set():off_stroke_c="+Integer.toHexString(off_stroke_c));
    //println("UI_Relay_Indicator:set():off_fill_c="+Integer.toHexString(off_fill_c));
  }

  void draw(boolean on) {
    if (!init) return;
    // Sets the color and weight used to draw lines and borders around shapes.
    if (on) {
      stroke(on_stroke_c);
      fill(on_fill_c);
    }
    else {
      stroke(off_stroke_c);
      fill(off_fill_c);
    }
    strokeWeight(stroke_w);
    rect(x, y, w, h, r, r, r, r);

    textAlign(LEFT, TOP);
    textSize(text_height);
    if (on) {
      fill(on_stroke_c);
      text(on_text, on_text_x, y);
    }
    else {
      fill(off_stroke_c);
      text(off_text, off_text_x, y);
    }
  }
}
