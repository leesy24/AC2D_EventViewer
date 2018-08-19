import controlP5.*;

//final static boolean PRINT_UI_SYSTEM_CONFIG_ALL_DBG = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_ALL_DBG = false;
final static boolean PRINT_UI_SYSTEM_CONFIG_ALL_ERR = true;
//final static boolean PRINT_UI_SYSTEM_CONFIG_ALL_ERR = false;

//final static boolean PRINT_UI_SYSTEM_CONFIG_SETUP_DBG = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_SETUP_DBG = false;

//final static boolean PRINT_UI_SYSTEM_CONFIG_UPDATE_DBG = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_UPDATE_DBG = false;

//final static boolean PRINT_UI_SYSTEM_CONFIG_RESET_DBG = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_RESET_DBG = false;

//final static boolean PRINT_UI_SYSTEM_CONFIG_DRAW_DBG = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_DRAW_DBG = false;

//final static boolean PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG = false;

//final static boolean PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG = false;
//final static boolean PRINT_UI_SYSTEM_CONFIG_LISTENER_ERR = true;
final static boolean PRINT_UI_SYSTEM_CONFIG_LISTENER_ERR = false;

static color C_UI_SYSTEM_CONFIG_TEXT = #000000; // Black
static color C_UI_SYSTEM_CONFIG_FILL_NORMAL = #FFFFFF; // White
static color C_UI_SYSTEM_CONFIG_FILL_HIGHLIGHT = #C0C0C0; // White - 0x40
static color C_UI_SYSTEM_CONFIG_BORDER_ACTIVE = #FF0000; // Red
static color C_UI_SYSTEM_CONFIG_BORDER_NORMAL = #000000; // Black
static color C_UI_SYSTEM_CONFIG_CURSOR = #0000FF; // Blue

static boolean UI_System_Config_enabled;

static ControlFont UI_System_Config_cf = null;
static ControlP5 UI_System_Config_cp5_global = null;

static boolean UI_System_Config_changed_any = false;
static int UI_System_Config_x_base;
static int UI_System_Config_y_base;
UI_System_Config_BT_ControlListener UI_System_Config_bt_control_listener;
UI_System_Config_TF_ControlListener UI_System_Config_tf_control_listener;
//UI_System_Config_CP5_CallbackListener UI_System_Config_cp5_callback_listener;

static enum UI_System_Config_tf_enum {
  SYSTEM_PASSWORD,
  FRAME_RATE,
  PS_DATA_SAVE_ALWAYS_DURATION,
  PS_DATA_SAVE_EVENTS_DURATION_DEFAULT,
  PS_DATA_SAVE_EVENTS_DURATION_LIMIT,
  Relay_Module_UART_port_name,
  RELAY_MODULE_UART_REPLY_REQUEST_ENABLED,
  ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX,
  ROI_OBJECT_DETECT_DIAMETER_MIN,
  ROI_OBJECT_DETECT_TIME_MIN,
  ROI_OBJECT_DETECT_KEEP_TIME,
  ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN,
  ROI_OBJECT_MARKER_MARGIN,
  MAX
}

static enum UI_System_Config_state_enum {
  IDLE,
  PASSWORD_REQ,
  WAIT_CONFIG_INPUT,
  DISPLAY_MESSAGE,
  RESET,
  MAX
}
static UI_System_Config_state_enum UI_System_Config_state;
static UI_System_Config_state_enum UI_System_Config_state_next;
static int UI_System_Config_timeout_start;

static Message_Box UI_System_Config_Message_Box_handle = null;

void UI_System_Config_setup()
{
  if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_SETUP_DBG) println("UI_System_Config_setup():Enter");

  //UI_System_Config_enabled = true;
  UI_System_Config_enabled = false;

  UI_System_Config_changed_any = false;

  UI_System_Config_state = UI_System_Config_state_enum.IDLE;

  if (UI_System_Config_cp5_global != null)
  {
    UI_System_Config_reset();
  }
  UI_System_Config_cp5_global = null;

  UI_System_Config_x_base = TEXT_MARGIN;
  UI_System_Config_y_base = TEXT_MARGIN;

}

void UI_System_Config_update()
{
  if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_UPDATE_DBG) println("UI_System_Config_update():Enter");

  if (!UI_System_Config_enabled)
  {
    UI_System_Config_reset();
    return;
  }

  if(UI_System_Config_cf == null) {
    UI_System_Config_cf = new ControlFont(SCREEN_PFront,FONT_HEIGHT);
  }

  UI_System_Config_bt_control_listener = new UI_System_Config_BT_ControlListener();
  UI_System_Config_tf_control_listener = new UI_System_Config_TF_ControlListener();
  //UI_System_Config_cp5_callback_listener = new UI_System_Config_CP5_CallbackListener();

  int x, y;
  int w, h;
  String str;

  if(UI_System_Config_cp5_global == null) {
    UI_System_Config_cp5_global = new ControlP5(this, UI_System_Config_cf);
    UI_System_Config_cp5_global.setBackground(C_UI_SYSTEM_CONFIG_FILL_NORMAL);
  }
  else {
    UI_System_Config_reset();
  }

  Textlabel tl_handle;
  Textfield tf_handle;
  Button bt_handle;

  // Outline border
  w = SCREEN_width - TEXT_MARGIN * 2;
  x = UI_System_Config_x_base;
  h = SCREEN_height - TEXT_MARGIN * 2;
  y = UI_System_Config_y_base;
  Textfield tf_outline_border;
  tf_outline_border = UI_System_Config_cp5_global.addTextfield("UI_System_Config_outline_border");
  tf_outline_border
    .setId(-1)
    .setPosition(x+1, y)
    .setSize(w - 2, h)
    .setColorBackground(C_UI_SYSTEM_CONFIG_FILL_NORMAL)
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setText("")
    .setCaptionLabel("")
    .setLock(true)
    ;

  // Title
  textSize(FONT_HEIGHT);
  str = "System Config";
  w = int(textWidth(str));
  x = UI_System_Config_x_base + (SCREEN_width - TEXT_MARGIN * 2) / 2 - w / 2;
  h = FONT_HEIGHT + TEXT_MARGIN * 2;
  y += TEXT_MARGIN;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_title_label");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  int w_max;

  w_max = MIN_INT;

  x = UI_System_Config_x_base + FONT_HEIGHT;
  y = UI_System_Config_y_base + TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN * 2 + FONT_HEIGHT;

  // SYSTEM_PASSWORD
  //y += h + TEXT_MARGIN;
  str = "SYSTEM_PASSWORD(4-digits)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_SYSTEM_PASSWORD");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // FRAME_RATE
  y += h + TEXT_MARGIN;
  str = "FRAME_RATE(Hz)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_FRAME_RATE");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // PS_DATA_SAVE_ALWAYS_DURATION
  y += h + TEXT_MARGIN;
  str = "PS_DATA_SAVE_ALWAYS_DURATION(hour,max."+PS_DATA_SAVE_ALWAYS_DURATION_MAX+")";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_PS_DATA_SAVE_ALWAYS_DURATION");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // PS_DATA_SAVE_EVENTS_DURATION_DEFAULT
  y += h + TEXT_MARGIN;
  str = "PS_DATA_SAVE_EVENTS_DURATION_DEFAULT(sec.,max."+PS_DATA_SAVE_EVENTS_DURATION_MAX/1000+")";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_PS_DATA_SAVE_EVENTS_DURATION_DEFAULT");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // PS_DATA_SAVE_EVENTS_DURATION_LIMIT
  y += h + TEXT_MARGIN;
  str = "PS_DATA_SAVE_EVENTS_DURATION_LIMIT(sec.,max."+PS_DATA_SAVE_EVENTS_DURATION_MAX/1000+")";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_PS_DATA_SAVE_EVENTS_DURATION_LIMIT");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // Relay_Module_UART_port_name
  y += h + TEXT_MARGIN;
  str = "Relay_Module_UART_port_name";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_Relay_Module_UART_port_name");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // RELAY_MODULE_UART_REPLY_REQUEST_ENABLED
  y += h + TEXT_MARGIN;
  str = "RELAY_MODULE_UART_REPLY_REQUEST_ENABLED";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_RELAY_MODULE_UART_REPLY_REQUEST_ENABLEDe");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX
  y += h + TEXT_MARGIN;
  str = "ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX(m)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // ROI_OBJECT_DETECT_DIAMETER_MIN
  y += h + TEXT_MARGIN;
  str = "ROI_OBJECT_DETECT_DIAMETER_MIN(m)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_ROI_OBJECT_DETECT_DIAMETER_MIN");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // ROI_OBJECT_DETECT_TIME_MIN
  y += h + TEXT_MARGIN;
  str = "ROI_OBJECT_DETECT_TIME_MIN(sec.)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_ROI_OBJECT_DETECT_TIME_MIN");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // ROI_OBJECT_DETECT_KEEP_TIME
  y += h + TEXT_MARGIN;
  str = "ROI_OBJECT_DETECT_KEEP_TIME(sec.)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_ROI_OBJECT_DETECT_KEEP_TIME");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN
  y += h + TEXT_MARGIN;
  str = "ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN(m)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  // ROI_OBJECT_MARKER_MARGIN
  y += h + TEXT_MARGIN;
  str = "ROI_OBJECT_MARKER_MARGIN(pixel)";
  w = int(textWidth(str));
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tl_handle = UI_System_Config_cp5_global.addTextlabel("UI_System_Config_ROI_OBJECT_MARKER_MARGIN");
  tl_handle
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_SYSTEM_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  x += w_max + FONT_HEIGHT;
  y = UI_System_Config_y_base + TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN * 2 + FONT_HEIGHT;
  //y = UI_System_Config_y_base + FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN;

  w_max = MIN_INT;

  // SYSTEM_PASSWORD input
  //y += h + TEXT_MARGIN;
  str = SYSTEM_PASSWORD;
  if (str.equals(""))
    w = int(FONT_HEIGHT * 1.5 * 5 / 2 + TEXT_MARGIN * 2);
  else
    w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_SYSTEM_PASSWORD_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.SYSTEM_PASSWORD.ordinal())
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // FRAME_RATE input
  y += h + TEXT_MARGIN;
  str = String.valueOf(FRAME_RATE);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_FRAME_RATE_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.FRAME_RATE.ordinal())
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // PS_DATA_SAVE_ALWAYS_DURATION input
  y += h + TEXT_MARGIN;
  str = String.valueOf(PS_DATA_SAVE_ALWAYS_DURATION);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_PS_DATA_SAVE_ALWAYS_DURATION_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.PS_DATA_SAVE_ALWAYS_DURATION.ordinal())
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // PS_DATA_SAVE_EVENTS_DURATION_DEFAULT input
  y += h + TEXT_MARGIN;
  str = String.valueOf(PS_DATA_SAVE_EVENTS_DURATION_DEFAULT / 1000.);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_PS_DATA_SAVE_EVENTS_DURATION_DEFAULT_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.PS_DATA_SAVE_EVENTS_DURATION_DEFAULT.ordinal())
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // PS_DATA_SAVE_EVENTS_DURATION_LIMIT input
  y += h + TEXT_MARGIN;
  str = String.valueOf(PS_DATA_SAVE_EVENTS_DURATION_LIMIT / 1000.);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_PS_DATA_SAVE_EVENTS_DURATION_LIMIT_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.PS_DATA_SAVE_EVENTS_DURATION_LIMIT.ordinal())
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // Relay_Module_UART_port_name input
  y += h + TEXT_MARGIN;
  str = Relay_Module_UART_port_name;
  if (str.equals(""))
    w = int(FONT_HEIGHT * 1.5 * 5 / 2 + TEXT_MARGIN * 2);
  else
    w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_Relay_Module_UART_port_name_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.Relay_Module_UART_port_name.ordinal())
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // RELAY_MODULE_UART_REPLY_REQUEST_ENABLED input
  y += h + TEXT_MARGIN;
  str = RELAY_MODULE_UART_REPLY_REQUEST_ENABLED?"true":"false";
  w = int(textWidth("false") * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_RELAY_MODULE_UART_REPLY_REQUEST_ENABLED_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.RELAY_MODULE_UART_REPLY_REQUEST_ENABLED.ordinal())
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX input
  y += h + TEXT_MARGIN;
  str = String.valueOf(ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX / 10000.);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX.ordinal())
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // ROI_OBJECT_DETECT_DIAMETER_MIN input
  y += h + TEXT_MARGIN;
  str = String.valueOf(ROI_OBJECT_DETECT_DIAMETER_MIN / 10000.);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_ROI_OBJECT_DETECT_DIAMETER_MIN_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.ROI_OBJECT_DETECT_DIAMETER_MIN.ordinal())
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // ROI_OBJECT_DETECT_TIME_MIN input
  y += h + TEXT_MARGIN;
  str = String.valueOf(ROI_OBJECT_DETECT_TIME_MIN / 1000.);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_ROI_OBJECT_DETECT_TIME_MIN_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.ROI_OBJECT_DETECT_TIME_MIN.ordinal())
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // ROI_OBJECT_DETECT_KEEP_TIME input
  y += h + TEXT_MARGIN;
  str = String.valueOf(ROI_OBJECT_DETECT_KEEP_TIME / 1000.);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_ROI_OBJECT_DETECT_KEEP_TIME_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.ROI_OBJECT_DETECT_KEEP_TIME.ordinal())
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN input
  y += h + TEXT_MARGIN;
  str = String.valueOf(ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN / 10000.);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN.ordinal())
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // ROI_OBJECT_MARKER_MARGIN input
  y += h + TEXT_MARGIN;
  str = String.valueOf(ROI_OBJECT_MARKER_MARGIN);
  w = int(textWidth(str) * 1.5 + TEXT_MARGIN * 2);
  w_max = max(w_max, w);
  h = FONT_HEIGHT + TEXT_MARGIN*2;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_ROI_OBJECT_MARKER_MARGIN_input");
  tf_handle
    .setId(UI_System_Config_tf_enum.ROI_OBJECT_MARKER_MARGIN.ordinal())
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_tf_control_listener)
    .setPosition(x, y).setSize(w, h)
    //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
    .setAutoClear(false)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_NORMAL )
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setColorActive( C_UI_SYSTEM_CONFIG_BORDER_ACTIVE )
    .setColorValueLabel( C_UI_SYSTEM_CONFIG_TEXT )
    .setColorCursor( C_UI_SYSTEM_CONFIG_CURSOR )
    .setCaptionLabel("")
    .setText(str)
    ;
  //println("tf.getText() = ", tf.getText());
  tf_handle.getValueLabel()
      //.setFont(UI_System_Config_cf)
      .setSize(FONT_HEIGHT)
      //.toUpperCase(false)
      ;
  tf_handle.getValueLabel()
      .getStyle()
        .marginTop = -1;
  tf_handle.getValueLabel()
      .getStyle()
        .marginLeft = 1;

  // Button outline border
  w = (FONT_HEIGHT * 7 + TEXT_MARGIN * 2) * 2 + FONT_HEIGHT * 2 + TEXT_MARGIN * 2;
  x = SCREEN_width / 2 - w / 2;
  h = FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN * 2;
  y = SCREEN_height - TEXT_MARGIN * 2 - (FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN) * 1 - TEXT_MARGIN;
  tf_handle = UI_System_Config_cp5_global.addTextfield("UI_System_Config_buttons_border");
  tf_handle
    .setId(-1)
    .setPosition(x+1, y)
    .setSize(w - 2, h)
    .setColorBackground(C_UI_SYSTEM_CONFIG_FILL_NORMAL)
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL )
    .setText("")
    .setCaptionLabel("")
    .setLock(true)
    ;

  str = "OK";
  w = FONT_HEIGHT * 7 + TEXT_MARGIN * 2;
  x = SCREEN_width / 2 - w - FONT_HEIGHT;
  h = FONT_HEIGHT + TEXT_MARGIN * 2;
  y = SCREEN_height - TEXT_MARGIN * 2 - (FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN) * 1;
  bt_handle = UI_System_Config_cp5_global.addButton(str);
  bt_handle.setId(0)
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_bt_control_listener)
    .setPosition(x, y)
    .setSize(w, h)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_HIGHLIGHT ) // Button fill color, when mouse is not over.
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL ) // Button fill color, when mouse over.
    .setColorActive(C_UI_SYSTEM_CONFIG_BORDER_ACTIVE) // Button fill color, when mouse pressed.
    .setColorLabel( C_UI_SYSTEM_CONFIG_FILL_NORMAL ) // Button text color
    ;
//  bt_handle.get()
//    .setSize(FONT_HEIGHT)
//    ;

  str = "Cancel";
  w = FONT_HEIGHT * 7 + TEXT_MARGIN * 2;
  x = SCREEN_width / 2 + FONT_HEIGHT;
  h = FONT_HEIGHT + TEXT_MARGIN * 2;
  y = SCREEN_height - TEXT_MARGIN * 2 - (FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN) * 1;
  bt_handle = UI_System_Config_cp5_global.addButton(str);
  bt_handle.setId(1)
    //.addCallback(UI_System_Config_cp5_callback_listener)
    .addListener(UI_System_Config_bt_control_listener)
    .setPosition(x, y)
    .setSize(w, h)
    .setColorBackground( C_UI_SYSTEM_CONFIG_FILL_HIGHLIGHT ) // Button fill color, when mouse is not over.
    .setColorForeground( C_UI_SYSTEM_CONFIG_BORDER_NORMAL ) // Button fill color, when mouse over.
    .setColorActive(C_UI_SYSTEM_CONFIG_BORDER_ACTIVE) // Button fill color, when mouse pressed.
    .setColorLabel( C_UI_SYSTEM_CONFIG_FILL_NORMAL ) // Button text color
    ;
//  bt_handle.get()
//    .setSize(FONT_HEIGHT)
//    ;

}

void UI_System_Config_reset()
{
  if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_RESET_DBG) println("UI_System_Config_reset():Enter");

  if(UI_System_Config_cp5_global == null) {
    return;
  }

  List<ControllerInterface<?>> cp5_list = UI_System_Config_cp5_global.getAll();

  for (ControllerInterface controller:cp5_list)
  {
    //println("UI_System_Config_reset():cp5.name:"+controller.getName());
    UI_System_Config_cp5_global.remove(controller.getName());
  }

  //UI_System_Config_cp5_global.setGraphics(this,0,0);

  UI_System_Config_cp5_global = null;
}

void UI_System_Config_draw()
{
  if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_DRAW_DBG) println("UI_System_Config_draw():Enter");

  //println("UI_System_Config_state=", UI_System_Config_state);
  switch (UI_System_Config_state)
  {
    case IDLE:
      if (!UI_System_Config_enabled)
      {
        break;
      }

      /**/
      // Disable other config UI if enabled.
      if (UI_Regions_Config_enabled)
      {
        UI_Regions_Config_enabled = false;
        break;
      }
      if (UI_Interfaces_enabled)
      {
        UI_Interfaces_enabled = false;
        break;
      }
      /**/

      // Check password not required.
      if (SYSTEM_PASSWORD_disabled)
      {
        UI_System_Config_state = UI_System_Config_state_enum.WAIT_CONFIG_INPUT;
        UI_System_Config_update();
        UI_System_Config_changed_any = false;
        UI_System_Config_timeout_start = millis();
        break;
      }

      UI_Num_Pad_setup("Input system password");
      UI_System_Config_state = UI_System_Config_state_enum.PASSWORD_REQ;
      UI_System_Config_timeout_start = millis();
      break;
    case PASSWORD_REQ:
      if (!UI_System_Config_enabled)
      {
        //UI_System_Config_reset();
        UI_System_Config_state = UI_System_Config_state_enum.IDLE;
        UI_Interfaces_enabled = true;
        break;
      }

      /*
      // Disable this config UI if other config UI enabled.
      if (UI_Regions_Config_enabled)
      {
        UI_System_Config_enabled = false;
        UI_System_Config_state = UI_System_Config_state_enum.IDLE;
        break;
      }
      */

      if (get_millis_diff(UI_System_Config_timeout_start) > SYSTEM_UI_TIMEOUT * 1000)
      {
        UI_System_Config_enabled = false;
        UI_System_Config_state = UI_System_Config_state_enum.IDLE;
        UI_Interfaces_enabled = true;
        break;
      }

      UI_Num_Pad_handle.draw();
      if (!UI_Num_Pad_handle.input_done())
      {
        break;
      }

      if (UI_Num_Pad_handle.input_string == null)
      {
        //UI_System_Config_reset();
        UI_System_Config_enabled = false;
        UI_System_Config_state = UI_System_Config_state_enum.IDLE;
        UI_Interfaces_enabled = true;
        break;
      }

      // Input done, check password.
      if (!UI_Num_Pad_handle.input_string.equals(SYSTEM_PASSWORD))
      {
        // Password fail...
        UI_System_Config_Message_Box_handle = new Message_Box("Error !", "Wrong password input!\nYou can NOT access special functions.", 5);
        UI_System_Config_state = UI_System_Config_state_enum.DISPLAY_MESSAGE;
        UI_System_Config_state_next = UI_System_Config_state_enum.IDLE;
        UI_System_Config_enabled = false;
        UI_Interfaces_enabled = true;
        break;
      }
      UI_System_Config_state = UI_System_Config_state_enum.WAIT_CONFIG_INPUT;
      UI_System_Config_update();
      UI_System_Config_changed_any = false;
      UI_System_Config_timeout_start = millis();
      break;
    case WAIT_CONFIG_INPUT:
      if (!UI_System_Config_enabled)
      {
        UI_System_Config_reset();
        UI_System_Config_state = UI_System_Config_state_enum.IDLE;
        UI_Interfaces_enabled = true;
        break;
      }

      if (get_millis_diff(UI_System_Config_timeout_start) > SYSTEM_UI_TIMEOUT * 1000)
      {
        UI_System_Config_reset();
        UI_System_Config_enabled = false;
        UI_System_Config_state = UI_System_Config_state_enum.IDLE;
        UI_Interfaces_enabled = true;
        break;
      }

      /*
      // Skip this config UI if other config UI enabled.
      if (UI_Regions_Config_enabled)
      {
        break;
      }
      */

      if (UI_System_Config_changed_any)
      {
        UI_System_Config_reset();
        // Update done! Indicate updated.
        UI_System_Config_Message_Box_handle = new Message_Box("Update done !", "New configuration will applied right now.", 3);
        UI_System_Config_state = UI_System_Config_state_enum.DISPLAY_MESSAGE;
        UI_System_Config_state_next = UI_System_Config_state_enum.RESET;
        break;
      }
      break;
    case DISPLAY_MESSAGE:
      if (UI_System_Config_Message_Box_handle.draw())
      {
        break;
      }
      UI_System_Config_state = UI_System_Config_state_next;
      break;
    case RESET:
      UI_Interfaces_enabled = true;
      // To restart program set frameCount to -1, this wiil call setup() of main.
      //frameCount = -1;
      break;
  }
}

void UI_System_Config_input_update()
{
  if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_input_update():Enter");

  List<Textfield> cp5_tf_list = UI_System_Config_cp5_global.getAll(Textfield.class);
  //println(cp5_tf_list);

  boolean updated = false;

  for (Textfield tf_handle:cp5_tf_list) {
    //println("Id="+tf_handle.getId()+":Text="+tf_handle.getText());
    if (tf_handle.getId() == -1) continue;
    UI_System_Config_tf_enum tf_enum = UI_System_Config_tf_enum.values()[tf_handle.getId()];
    //println("tf_enum="+tf_enum);

    String str;
    int val;
    boolean bool;

    str = tf_handle.getText();
    switch (tf_enum) {
      case SYSTEM_PASSWORD:
        if (str.length() == 0) {
          //SYSTEM_PASSWORD_disabled = true;
          break;
        }
        //SYSTEM_PASSWORD_disabled = false;
        if (!str.matches("[0-9]+") || str.length() != 4) {
          break;
        }
        if (str.equals(SYSTEM_PASSWORD)) {
          break;
        }
        SYSTEM_PASSWORD = str;
        updated = true;
        if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated SYSTEM_PASSWORD="+SYSTEM_PASSWORD+",tf_enum="+tf_enum);
        break;
      case FRAME_RATE:
        try {
          val = Integer.parseInt(str.trim());
        }
        catch (NumberFormatException e) {
          break;
        }
        if (val == FRAME_RATE) {
          break;
        }
        FRAME_RATE = val;
        updated = true;
        if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated FRAME_RATE="+FRAME_RATE+",tf_enum="+tf_enum);
        break;
      case PS_DATA_SAVE_ALWAYS_DURATION:
        try {
          val = int(Float.parseFloat(str.trim()));
        }
        catch (NumberFormatException e) {
          break;
        }
        if (val == PS_DATA_SAVE_ALWAYS_DURATION) {
          break;
        }
        PS_DATA_SAVE_ALWAYS_DURATION = val;
        updated = true;
        if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated PS_DATA_SAVE_ALWAYS_DURATION="+PS_DATA_SAVE_ALWAYS_DURATION+",tf_enum="+tf_enum);
        break;
      case PS_DATA_SAVE_EVENTS_DURATION_DEFAULT:
        try {
          val = int(Float.parseFloat(str.trim()) * 1000.0);
        }
        catch (NumberFormatException e) {
          break;
        }
        if (val == PS_DATA_SAVE_EVENTS_DURATION_DEFAULT) {
          break;
        }
        PS_DATA_SAVE_EVENTS_DURATION_DEFAULT = val;
        updated = true;
        if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated PS_DATA_SAVE_EVENTS_DURATION_DEFAULT="+PS_DATA_SAVE_EVENTS_DURATION_DEFAULT+",tf_enum="+tf_enum);
        break;
      case PS_DATA_SAVE_EVENTS_DURATION_LIMIT:
        try {
          val = int(Float.parseFloat(str.trim()) * 1000.0);
        }
        catch (NumberFormatException e) {
          break;
        }
        if (val == PS_DATA_SAVE_EVENTS_DURATION_LIMIT) {
          break;
        }
        PS_DATA_SAVE_EVENTS_DURATION_LIMIT = val;
        updated = true;
        if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated PS_DATA_SAVE_EVENTS_DURATION_LIMIT="+PS_DATA_SAVE_EVENTS_DURATION_LIMIT+",tf_enum="+tf_enum);
        break;
      case Relay_Module_UART_port_name:
        if (str.equals(Relay_Module_UART_port_name)) {
          break;
        }
        Relay_Module_UART_port_name = str;
        updated = true;
        if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated Relay_Module_UART_port_name="+Relay_Module_UART_port_name+",tf_enum="+tf_enum);
        break;
      case RELAY_MODULE_UART_REPLY_REQUEST_ENABLED:
        bool = str.toLowerCase().equals("true")?true:false;
        if (bool == RELAY_MODULE_UART_REPLY_REQUEST_ENABLED) {
          break;
        }
        RELAY_MODULE_UART_REPLY_REQUEST_ENABLED = bool;
        updated = true;
        if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated RELAY_MODULE_UART_REPLY_REQUEST_ENABLED="+RELAY_MODULE_UART_REPLY_REQUEST_ENABLED+",tf_enum="+tf_enum);
        break;
      case ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX:
        try {
          val = int(Float.parseFloat(str.trim()) * 10000.0);
        }
        catch (NumberFormatException e) {
          break;
        }
        if (val == ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX) {
          break;
        }
        ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX = val;
        updated = true;
        if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX="+ROI_OBJECT_DETECT_POINTS_DISTANCE_MAX+",tf_enum="+tf_enum);
        break;
      case ROI_OBJECT_DETECT_DIAMETER_MIN:
        try {
          val = int(Float.parseFloat(str.trim()) * 10000.0);
        }
        catch (NumberFormatException e) {
          break;
        }
        if (val == ROI_OBJECT_DETECT_DIAMETER_MIN) {
          break;
        }
        ROI_OBJECT_DETECT_DIAMETER_MIN = val;
        updated = true;
        if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated ROI_OBJECT_DETECT_DIAMETER_MIN="+ROI_OBJECT_DETECT_DIAMETER_MIN+",tf_enum="+tf_enum);
        break;
      case ROI_OBJECT_DETECT_TIME_MIN:
        try {
          val = int(Float.parseFloat(str.trim()) * 1000.0);
        }
        catch (NumberFormatException e) {
          break;
        }
        if (val == ROI_OBJECT_DETECT_TIME_MIN) {
          break;
        }
        ROI_OBJECT_DETECT_TIME_MIN = val;
        updated = true;
        if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated ROI_OBJECT_DETECT_TIME_MIN="+ROI_OBJECT_DETECT_TIME_MIN+",tf_enum="+tf_enum);
        break;
      case ROI_OBJECT_DETECT_KEEP_TIME:
        try {
          val = int(Float.parseFloat(str.trim()) * 1000.0);
        }
        catch (NumberFormatException e) {
          break;
        }
        if (val == ROI_OBJECT_DETECT_KEEP_TIME) {
          break;
        }
        ROI_OBJECT_DETECT_KEEP_TIME = val;
        updated = true;
        if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated ROI_OBJECT_DETECT_KEEP_TIME="+ROI_OBJECT_DETECT_KEEP_TIME+",tf_enum="+tf_enum);
        break;
      case ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN:
        try {
          val = int(Float.parseFloat(str.trim()) * 10000.0);
        }
        catch (NumberFormatException e) {
          break;
        }
        if (val == ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN) {
          break;
        }
        ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN = val;
        updated = true;
        if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN="+ROI_OBJECT_NO_MARK_BIG_DIAMETER_MIN+",tf_enum="+tf_enum);
        break;
      case ROI_OBJECT_MARKER_MARGIN:
        try {
          val = Integer.parseInt(str.trim());
        }
        catch (NumberFormatException e) {
          break;
        }
        if (val == ROI_OBJECT_MARKER_MARGIN) {
          break;
        }
        ROI_OBJECT_MARKER_MARGIN = val;
        updated = true;
        if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated ROI_OBJECT_MARKER_MARGIN="+ROI_OBJECT_MARKER_MARGIN+",tf_enum="+tf_enum);
        break;
      default:
        if (PRINT_UI_SYSTEM_CONFIG_ALL_ERR || PRINT_UI_SYSTEM_CONFIG_LISTENER_ERR) println("UI_System_Config_BT_ControlListener:controlEvent():tf_enum="+tf_enum+" error!");
        SYSTEM_logger.severe("UI_System_Config_BT_ControlListener:controlEvent():tf_enum="+tf_enum+" error!");
        break;
    } // End of switch (tf_enum)
  } // End of for (Textfield tf_handle:cp5_tf_list)
  if (updated) {
    //Const_create();
    if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_INPUT_UPDATE_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Updated");
    UI_System_Config_changed_any = true;
  }
  else {
    UI_System_Config_enabled = false;
  }
}

class UI_System_Config_BT_ControlListener implements ControlListener {
  public void controlEvent(ControlEvent theEvent) {
    if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():Enter");

    Button bt_handle = (Button)theEvent.getController();
    // Check bt_handle.
    if (bt_handle == null) {
      return;
    }

    int button_index = bt_handle.getId();
    if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_BT_ControlListener:controlEvent():button_index="+button_index);

    // Check Button is OK.
    if (button_index != 0) {
      // Button is not OK. Disable UI_System_Config.
      UI_System_Config_enabled = false;
      return;
    }

    UI_System_Config_input_update();
  }
}

class UI_System_Config_TF_ControlListener implements ControlListener {
  public void controlEvent(ControlEvent theEvent) {
    if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_TF_ControlListener:controlEvent():Enter");

    Textfield tf_handle = (Textfield)theEvent.getController();
    if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_TF_ControlListener:controlEvent():getId="+tf_handle.getId());
    if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_TF_ControlListener:controlEvent():getValue="+tf_handle.getValue());
    if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_TF_ControlListener:controlEvent():getText="+tf_handle.getText());

    Button bt_handle = UI_System_Config_cp5_global.get(Button.class, "OK");
    // Check bt_handle.
    if (bt_handle == null) {
      return;
    }

    int button_index = bt_handle.getId();
    if (PRINT_UI_SYSTEM_CONFIG_ALL_DBG || PRINT_UI_SYSTEM_CONFIG_LISTENER_DBG) println("UI_System_Config_TF_ControlListener:controlEvent():button_index="+button_index);
    // Check Button is OK.
    if (button_index != 0) {
      // Button is not OK.
      return;
    }

    UI_System_Config_input_update();
  }
}

/*
class UI_System_Config_CP5_CallbackListener implements CallbackListener {
  public void controlEvent(CallbackEvent theEvent) {
    UI_System_Config_timeout_start = millis();
  }
}
*/

void UI_System_Config_key_pressed()
{
  if (!UI_System_Config_enabled) return;

  if (key == ESC)
  {
    // Disable UI_System_Config.
    UI_System_Config_enabled = false;
  }
}

void UI_System_Config_mouse_moved()
{
  if (!UI_System_Config_enabled) return;

  UI_System_Config_timeout_start = millis();
}

void UI_System_Config_mouse_dragged()
{
  if (!UI_System_Config_enabled) return;

  UI_System_Config_timeout_start = millis();
}
