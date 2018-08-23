import controlP5.*;

//final static boolean PRINT_UI_REGIONS_CONFIG_ALL_DBG = true;
final static boolean PRINT_UI_REGIONS_CONFIG_ALL_DBG = false;
final static boolean PRINT_UI_REGIONS_CONFIG_ALL_ERR = true;
//final static boolean PRINT_UI_REGIONS_CONFIG_ALL_ERR = false;

//final static boolean PRINT_UI_REGIONS_CONFIG_SETUP_DBG = true;
final static boolean PRINT_UI_REGIONS_CONFIG_SETUP_DBG = false;

//final static boolean PRINT_UI_REGIONS_CONFIG_UPDATE_DBG = true;
final static boolean PRINT_UI_REGIONS_CONFIG_UPDATE_DBG = false;

//final static boolean PRINT_UI_REGIONS_CONFIG_RESET_DBG = true;
final static boolean PRINT_UI_REGIONS_CONFIG_RESET_DBG = false;

//final static boolean PRINT_UI_REGIONS_CONFIG_DRAW_DBG = true;
final static boolean PRINT_UI_REGIONS_CONFIG_DRAW_DBG = false;

//final static boolean PRINT_UI_REGIONS_CONFIG_INPUT_UPDATE_DBG = true;
final static boolean PRINT_UI_REGIONS_CONFIG_INPUT_UPDATE_DBG = false;

//final static boolean PRINT_UI_REGIONS_CONFIG_LISTENER_DBG = true;
final static boolean PRINT_UI_REGIONS_CONFIG_LISTENER_DBG = false;
//final static boolean PRINT_UI_REGIONS_CONFIG_LISTENER_ERR = true;
final static boolean PRINT_UI_REGIONS_CONFIG_LISTENER_ERR = false;

static color C_UI_REGIONS_CONFIG_TEXT = #000000; // Black
static color C_UI_REGIONS_CONFIG_FILL_NORMAL = #FFFFFF; // White
static color C_UI_REGIONS_CONFIG_FILL_HIGHLIGHT = #C0C0C0; // White - 0x40
static color C_UI_REGIONS_CONFIG_BORDER_ACTIVE = #FF0000; // Red
static color C_UI_REGIONS_CONFIG_BORDER_NORMAL = #000000; // Black
static color C_UI_REGIONS_CONFIG_CURSOR = #0000FF; // Blue

static boolean UI_Regions_Config_enabled;

static ControlFont UI_Regions_Config_cf = null;
static ControlP5 UI_Regions_Config_cp5_global = null;
static ControlP5[] UI_Regions_Config_cp5_local = new ControlP5[PS_INSTANCE_MAX];

static boolean UI_Regions_Config_changed_any = false;
static int[] UI_Regions_Config_x_base = new int[PS_INSTANCE_MAX];
static int[] UI_Regions_Config_y_base = new int[PS_INSTANCE_MAX];
UI_Regions_Config_BT_ControlListener UI_Regions_Config_bt_control_listener;
UI_Regions_Config_TF_ControlListener UI_Regions_Config_tf_control_listener;
//UI_Regions_Config_CP5_CallbackListener UI_Regions_Config_cp5_callback_listener;

static enum UI_Regions_Config_tf_enum {
  REGION_NAME,
  REGION_PRIORITY,
  RELAY_INDEX,
  RELAY_NAME,
  NO_MARK_BIG,
  RECT_FIELD_START_X,
  RECT_FIELD_START_Y,
  RECT_FIELD_END_X,
  RECT_FIELD_END_Y,
  RECT_DASHED_GAP,
  MAX
}

static enum UI_Regions_Config_state_enum {
  IDLE,
  PASSWORD_REQ,
  WAIT_CONFIG_INPUT,
  DISPLAY_MESSAGE,
  RESET,
  MAX
}
static UI_Regions_Config_state_enum UI_Regions_Config_state;
static UI_Regions_Config_state_enum UI_Regions_Config_state_next;
static int UI_Regions_Config_timeout_start;

static Message_Box UI_Regions_Config_Message_Box_handle = null;

void UI_Regions_Config_setup()
{
  if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_SETUP_DBG) println("UI_Regions_Config_setup():Enter");

  //UI_Regions_Config_enabled = true;
  UI_Regions_Config_enabled = false;

  UI_Regions_Config_changed_any = false;

  UI_Regions_Config_state = UI_Regions_Config_state_enum.IDLE;

  if (UI_Regions_Config_cp5_global != null)
  {
    UI_Regions_Config_reset();
  }
  UI_Regions_Config_cp5_global = null;

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (UI_Regions_Config_cp5_local[i] != null)
    {
      UI_Regions_Config_reset_instance(i);
    }
    UI_Regions_Config_cp5_local[i] = null;
    switch (i)
    {
      case 0:
        UI_Regions_Config_x_base[i] = TEXT_MARGIN;
        UI_Regions_Config_y_base[i] = TEXT_MARGIN;
        break;
      case 1:
        UI_Regions_Config_x_base[i] = SCREEN_width / 2;
        UI_Regions_Config_y_base[i] = TEXT_MARGIN;
        break;
    }
  }
}

void UI_Regions_Config_update()
{
  if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_UPDATE_DBG) println("UI_Regions_Config_update():Enter");

  if (!UI_Regions_Config_enabled)
  {
    UI_Regions_Config_reset();
    return;
  }

  if(UI_Regions_Config_cf == null) {
    UI_Regions_Config_cf = new ControlFont(SCREEN_PFront,FONT_HEIGHT);
  }

  UI_Regions_Config_bt_control_listener = new UI_Regions_Config_BT_ControlListener();
  UI_Regions_Config_tf_control_listener = new UI_Regions_Config_TF_ControlListener();
  //UI_Regions_Config_cp5_callback_listener = new UI_Regions_Config_CP5_CallbackListener();

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    UI_Regions_Config_update_instance(i);
  }

  int x, y;
  int w, h;
  String str;

  if(UI_Regions_Config_cp5_global == null) {
    UI_Regions_Config_cp5_global = new ControlP5(this, UI_Regions_Config_cf);
    UI_Regions_Config_cp5_global.setBackground(C_UI_REGIONS_CONFIG_FILL_NORMAL);
  }
  else {
    UI_Regions_Config_reset();
  }

  Textfield tf_handle;
  Button bt_handle;

  // Button outline border
  w = (FONT_HEIGHT * 7 + TEXT_MARGIN * 2) * 2 + FONT_HEIGHT * 2 + TEXT_MARGIN * 2;
  x = SCREEN_width / 2 - w / 2;
  h = FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN * 2;
  y = SCREEN_height - TEXT_MARGIN * 2 - (FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN) * 1 - TEXT_MARGIN;
  tf_handle = UI_Regions_Config_cp5_global.addTextfield("UI_Regions_Config_buttons_border");
  tf_handle
    .setId(-1)
    .setPosition(x+1, y)
    .setSize(w - 2, h)
    .setColorBackground(C_UI_REGIONS_CONFIG_FILL_NORMAL)
    .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
    .setText("")
    .setCaptionLabel("")
    .setLock(true)
    ;

  str = "OK";
  w = FONT_HEIGHT * 7 + TEXT_MARGIN * 2;
  x = SCREEN_width / 2 - w - FONT_HEIGHT;
  h = FONT_HEIGHT + TEXT_MARGIN * 2;
  y = SCREEN_height - TEXT_MARGIN * 2 - (FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN) * 1;
  bt_handle = UI_Regions_Config_cp5_global.addButton(str);
  bt_handle.setId(0)
    //.addCallback(UI_Regions_Config_cp5_callback_listener)
    .addListener(UI_Regions_Config_bt_control_listener)
    .setPosition(x, y)
    .setSize(w, h)
    .setColorBackground( C_UI_REGIONS_CONFIG_FILL_HIGHLIGHT ) // Button fill color, when mouse is not over.
    .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL ) // Button fill color, when mouse over.
    .setColorActive(C_UI_REGIONS_CONFIG_BORDER_ACTIVE) // Button fill color, when mouse pressed.
    .setColorLabel( C_UI_REGIONS_CONFIG_FILL_NORMAL ) // Button text color
    ;
//  bt_handle.get()
//    .setSize(FONT_HEIGHT)
//    ;

  str = "Cancel";
  w = FONT_HEIGHT * 7 + TEXT_MARGIN * 2;
  x = SCREEN_width / 2 + FONT_HEIGHT;
  h = FONT_HEIGHT + TEXT_MARGIN * 2;
  y = SCREEN_height - TEXT_MARGIN * 2 - (FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN) * 1;
  bt_handle = UI_Regions_Config_cp5_global.addButton(str);
  bt_handle.setId(1)
    //.addCallback(UI_Regions_Config_cp5_callback_listener)
    .addListener(UI_Regions_Config_bt_control_listener)
    .setPosition(x, y)
    .setSize(w, h)
    .setColorBackground( C_UI_REGIONS_CONFIG_FILL_HIGHLIGHT ) // Button fill color, when mouse is not over.
    .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL ) // Button fill color, when mouse over.
    .setColorActive(C_UI_REGIONS_CONFIG_BORDER_ACTIVE) // Button fill color, when mouse pressed.
    .setColorLabel( C_UI_REGIONS_CONFIG_FILL_NORMAL ) // Button text color
    ;
//  bt_handle.get()
//    .setSize(FONT_HEIGHT)
//    ;
}

void UI_Regions_Config_update_instance(int instance)
{
  if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_UPDATE_DBG) println("UI_Regions_Config_update_instance("+instance+"):Enter");

  if (!UI_Regions_Config_enabled)
  {
    UI_Regions_Config_reset_instance(instance);
    return;
  }

  int x, y;
  int w, h;
  String str;

  if(UI_Regions_Config_cp5_local[instance] == null) {
    UI_Regions_Config_cp5_local[instance] = new ControlP5(this, UI_Regions_Config_cf);
    UI_Regions_Config_cp5_local[instance].setBackground(C_UI_REGIONS_CONFIG_FILL_NORMAL);
  }
  else {
    UI_Regions_Config_reset_instance(instance);
  }

  Textlabel tl_handle;
  Textfield tf_handle;
  Button bt_handle;

  // Outline border
  w = SCREEN_width / 2 - TEXT_MARGIN;
  x = UI_Regions_Config_x_base[instance];
  h = SCREEN_height - TEXT_MARGIN * 2;
  y = UI_Regions_Config_y_base[instance];
  Textfield tf_outline_border;
  tf_outline_border = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_outline_border");
  tf_outline_border
    .setId(-1)
    .setPosition(x+1, y)
    .setSize(w - 2, h)
    .setColorBackground(C_UI_REGIONS_CONFIG_FILL_NORMAL)
    .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
    .setText("")
    .setCaptionLabel("")
    .setLock(true)
    ;

  // Title
  textSize(FONT_HEIGHT);
  str = "Regions "+instance+" Config";
  w = int(textWidth(str));
  x = UI_Regions_Config_x_base[instance] + (SCREEN_width / 2 - TEXT_MARGIN * 2) / 2 - w / 2;
  h = FONT_HEIGHT + TEXT_MARGIN * 2;
  y += TEXT_MARGIN;
  tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_title_label");
  tl_handle
    //.addCallback(UI_Regions_Config_cp5_callback_listener)
    .setText(str)
    .setPosition(x, y)
    .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
    .setHeight(h)
    ;
  tl_handle.get()
      .setSize(FONT_HEIGHT)
      ;

  for (int region_csv_index = 0; region_csv_index < Regions_handle.get_regions_csv_size_for_index(instance); region_csv_index ++)
  {
    int w_max;
    int save_x;
    int save_w;

    w_max = MIN_INT;

    // Region name
    x = UI_Regions_Config_x_base[instance] + FONT_HEIGHT;
    y = UI_Regions_Config_y_base[instance] + TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN * 2 + FONT_HEIGHT;
    y += (FONT_HEIGHT + TEXT_MARGIN*2 + TEXT_MARGIN + TEXT_MARGIN) * 4 * region_csv_index;
    str = "Region name";
    w = int(textWidth(str));
    w_max = max(w_max, w - FONT_HEIGHT);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_region_name_"+region_csv_index);
    tl_handle
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    x += FONT_HEIGHT;

    // Rect. start x and y
    y += h + TEXT_MARGIN;
    str = "Rect. start x/y(m)";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_rect_start_xy_"+region_csv_index);
    tl_handle
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    /*
    // Rect. y
    y += h + TEXT_MARGIN;
    str = "Rect. y(m)";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_rect_y_"+region_csv_index);
    tl_handle
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;
    */

    // Rect. end x and y
    y += h + TEXT_MARGIN;
    str = "Rect. end x/y(m)";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_rect_end_xy_"+region_csv_index);
    tl_handle
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    /*
    // Rect. h
    y += h + TEXT_MARGIN;
    str = "Rect. h(m)";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_rect_h_"+region_csv_index);
    tl_handle
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;
    */

    // Rect. dashed gap
    y += h + TEXT_MARGIN;
    str = "Rect. dash(pixel)";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_rect_dash_"+region_csv_index);
    tl_handle
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    x += w_max + FONT_HEIGHT;
    y = UI_Regions_Config_y_base[instance] + TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN * 2 + FONT_HEIGHT;
    //y = UI_Regions_Config_y_base[instance] + FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN;
    y += (FONT_HEIGHT + TEXT_MARGIN*2 + TEXT_MARGIN + TEXT_MARGIN) * 4 * region_csv_index;

    w_max = MIN_INT;

    // Region name input
    //y += h + TEXT_MARGIN;
    str = Regions_handle.get_region_csv_name(instance, region_csv_index);
    if (str.equals(""))
      w = int(FONT_HEIGHT * 5 / 2 + TEXT_MARGIN * 2);
    else
      w = int(textWidth(str) + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_region_name_input_"+region_csv_index);
    tf_handle
      .setId(instance*1000+region_csv_index*100+UI_Regions_Config_tf_enum.REGION_NAME.ordinal())
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

    // Rect. start x input
    y += h + TEXT_MARGIN;
    str = String.valueOf(Regions_handle.get_region_csv_rect_field_x(instance, region_csv_index)/100.);
    w = int(textWidth(str) * 1.5 + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_rect_start_x_input_"+region_csv_index);
    tf_handle
      .setId(instance*1000+region_csv_index*100+UI_Regions_Config_tf_enum.RECT_FIELD_START_X.ordinal())
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

    // Rect. start y input
    save_x = x;
    x += w + TEXT_MARGIN;
    save_w = w + TEXT_MARGIN;
    //y += h + TEXT_MARGIN;
    str = String.valueOf(Regions_handle.get_region_csv_rect_field_y(instance, region_csv_index)/100.);
    w = int(textWidth(str) * 1.5 + TEXT_MARGIN*2);
    w_max = max(w_max, w + save_w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_rect_start_y_input_"+region_csv_index);
    tf_handle
      .setId(instance*1000+region_csv_index*100+UI_Regions_Config_tf_enum.RECT_FIELD_START_Y.ordinal())
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;
    x = save_x;

    // Rect. end x input
    y += h + TEXT_MARGIN;
    str =
      String.valueOf(
        (
          Regions_handle.get_region_csv_rect_field_x(instance, region_csv_index)
          +
          Regions_handle.get_region_csv_rect_field_width(instance, region_csv_index)
        )
        /
        100.);
    w = int(textWidth(str) * 1.5 + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_rect_end_x_input_"+region_csv_index);
    tf_handle
      .setId(instance*1000+region_csv_index*100+UI_Regions_Config_tf_enum.RECT_FIELD_END_X.ordinal())
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

    // Rect. end y input
    save_x = x;
    x += w + TEXT_MARGIN;
    save_w = w + TEXT_MARGIN;
    //y += h + TEXT_MARGIN;
    str =
      String.valueOf(
        (
          Regions_handle.get_region_csv_rect_field_y(instance, region_csv_index)
          +
          Regions_handle.get_region_csv_rect_field_height(instance, region_csv_index)
        )
        /
        100.);
    w = int(textWidth(str) * 1.5 + TEXT_MARGIN*2);
    w_max = max(w_max, w + save_w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_rect_end_y_input_"+region_csv_index);
    tf_handle
      .setId(instance*1000+region_csv_index*100+UI_Regions_Config_tf_enum.RECT_FIELD_END_Y.ordinal())
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;
    x = save_x;

    // Rect. dash input
    y += h + TEXT_MARGIN;
    str = String.valueOf(Regions_handle.get_region_csv_rect_dashed_gap(instance, region_csv_index));
    w = int(textWidth(str) * 1.5 + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_rect_dash_input_"+region_csv_index);
    tf_handle
      .setId(instance*1000+region_csv_index*100+UI_Regions_Config_tf_enum.RECT_DASHED_GAP.ordinal())
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

    x += w_max + FONT_HEIGHT;
    y = UI_Regions_Config_y_base[instance] + TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN * 2 + FONT_HEIGHT;
    //y = UI_Regions_Config_y_base[instance] + FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN;
    y += (FONT_HEIGHT + TEXT_MARGIN*2 + TEXT_MARGIN + TEXT_MARGIN) * 4 * region_csv_index;

    w_max = MIN_INT;

    // Priority
    //y += h + TEXT_MARGIN;
    str = "Priority";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_priority_"+region_csv_index);
    tl_handle
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    // Relay index
    y += h + TEXT_MARGIN;
    str = "Relay index";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_relay_index_"+region_csv_index);
    tl_handle
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    // Relay name
    y += h + TEXT_MARGIN;
    str = "Relay name";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_relay_name_"+region_csv_index);
    tl_handle
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    // No mark big
    y += h + TEXT_MARGIN;
    str = "No mark big";
    w = int(textWidth(str));
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tl_handle = UI_Regions_Config_cp5_local[instance].addTextlabel("UI_Regions_Config_no_mark_big_"+region_csv_index);
    tl_handle
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .setText(str)
      .setPosition(x, y)
      .setColorValue(C_UI_REGIONS_CONFIG_TEXT)
      .setHeight(h)
      ;
    tl_handle.get()
        .setSize(FONT_HEIGHT)
        ;

    x += w_max + FONT_HEIGHT;
    y = UI_Regions_Config_y_base[instance] + TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN * 2 + FONT_HEIGHT;
    //y = UI_Regions_Config_y_base[instance] + FONT_HEIGHT + TEXT_MARGIN * 2 + TEXT_MARGIN;
    y += (FONT_HEIGHT + TEXT_MARGIN*2 + TEXT_MARGIN + TEXT_MARGIN) * 4 * region_csv_index;

    w_max = MIN_INT;

    // Priority input
    //y += h + TEXT_MARGIN;
    str = String.valueOf(Regions_handle.get_region_csv_priority(instance, region_csv_index));
    w = int(textWidth(str) + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_priority_input_"+region_csv_index);
    tf_handle
      .setId(instance*1000+region_csv_index*100+UI_Regions_Config_tf_enum.REGION_PRIORITY.ordinal())
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

    // Relay index input
    y += h + TEXT_MARGIN;
    str = String.valueOf(Regions_handle.get_region_csv_relay_index(instance, region_csv_index));
    w = int(textWidth(str) + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_relay_index_input_"+region_csv_index);
    tf_handle
      .setId(instance*1000+region_csv_index*100+UI_Regions_Config_tf_enum.RELAY_INDEX.ordinal())
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

    // Relay index input
    y += h + TEXT_MARGIN;
    str = Relay_Module_get_relay_name(Regions_handle.get_region_csv_relay_index(instance, region_csv_index));
    if (str == null)
    {
      str = "";
    }
    //if (str != null)
    //{
    //save_x = x;
    //x += w + TEXT_MARGIN;
    //save_w = w + TEXT_MARGIN;
    if (str.equals(""))
      w = int(FONT_HEIGHT * 5 / 2 + TEXT_MARGIN * 2);
    else
      w = int(textWidth(str) + TEXT_MARGIN*2);
    //w_max = max(w_max, w + save_w);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_relay_name_input_"+region_csv_index);
    tf_handle
      .setId(instance*1000+region_csv_index*100+UI_Regions_Config_tf_enum.RELAY_NAME.ordinal())
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;
    //x = save_x;
    //}

    // No mark big input
    y += h + TEXT_MARGIN;
    str = Regions_handle.get_region_csv_no_mark_big(instance, region_csv_index)?"true":"false";
    w = int(textWidth("false") + TEXT_MARGIN*2);
    w_max = max(w_max, w);
    h = FONT_HEIGHT + TEXT_MARGIN*2;
    tf_handle = UI_Regions_Config_cp5_local[instance].addTextfield("UI_Regions_Config_no_mark_bit_input_"+region_csv_index);
    tf_handle
      .setId(instance*1000+region_csv_index*100+UI_Regions_Config_tf_enum.NO_MARK_BIG.ordinal())
      //.addCallback(UI_Regions_Config_cp5_callback_listener)
      .addListener(UI_Regions_Config_tf_control_listener)
      .setPosition(x, y)
      .setSize(w, h)
      //.setHeight(FONT_HEIGHT + TEXT_MARGIN*2)
      .setAutoClear(false)
      .setColorBackground( C_UI_REGIONS_CONFIG_FILL_NORMAL )
      .setColorForeground( C_UI_REGIONS_CONFIG_BORDER_NORMAL )
      .setColorActive( C_UI_REGIONS_CONFIG_BORDER_ACTIVE )
      .setColorValueLabel( C_UI_REGIONS_CONFIG_TEXT )
      .setColorCursor( C_UI_REGIONS_CONFIG_CURSOR )
      .setCaptionLabel("")
      .setText(str)
      ;
    //println("tf.getText() = ", tf.getText());
    tf_handle.getValueLabel()
        //.setFont(UI_Regions_Config_cf)
        .setSize(FONT_HEIGHT)
        //.toUpperCase(false)
        ;
    tf_handle.getValueLabel()
        .getStyle()
          .marginTop = -1;
    tf_handle.getValueLabel()
        .getStyle()
          .marginLeft = 1;

  }
}

void UI_Regions_Config_reset()
{
  if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_RESET_DBG) println("UI_Regions_Config_reset():Enter");

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    UI_Regions_Config_reset_instance(i);
  }

  if(UI_Regions_Config_cp5_global == null) {
    return;
  }

  List<ControllerInterface<?>> cp5_list = UI_Regions_Config_cp5_global.getAll();

  for (ControllerInterface controller:cp5_list)
  {
    //println("name:"+controller.getName());
    UI_Regions_Config_cp5_global.remove(controller.getName());
  }

  UI_Regions_Config_cp5_global.setGraphics(this,0,0);

  UI_Regions_Config_cp5_global = null;
}

void UI_Regions_Config_reset_instance(int instance)
{
  if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_RESET_DBG) println("UI_Regions_Config_reset_instance("+instance+"):Enter");

  if(UI_Regions_Config_cp5_local[instance] == null) {
    return;
  }

  List<ControllerInterface<?>> cp5_list = UI_Regions_Config_cp5_local[instance].getAll();

  for (ControllerInterface controller:cp5_list)
  {
    //println("name:"+controller.getName());
    UI_Regions_Config_cp5_local[instance].remove(controller.getName());
  }

  UI_Regions_Config_cp5_local[instance].setGraphics(this,0,0);

  UI_Regions_Config_cp5_local[instance] = null;
}

void UI_Regions_Config_draw()
{
  if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_DRAW_DBG) println("UI_Regions_Config_draw():Enter");

  //println("UI_Regions_Config_state=", UI_Regions_Config_state);
  switch (UI_Regions_Config_state)
  {
    case IDLE:
      if (!UI_Regions_Config_enabled)
      {
        break;
      }

      /**/
      // Disable other config UI if enabled.
      if (UI_System_Config_enabled)
      {
        UI_System_Config_enabled = false;
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
        UI_Regions_Config_state = UI_Regions_Config_state_enum.WAIT_CONFIG_INPUT;
        UI_Regions_Config_update();
        UI_Regions_Config_changed_any = false;
        UI_Regions_Config_timeout_start = millis();
        break;
      }

      UI_Num_Pad_setup("Input system password");
      UI_Regions_Config_state = UI_Regions_Config_state_enum.PASSWORD_REQ;
      UI_Regions_Config_timeout_start = millis();
      break;
    case PASSWORD_REQ:
      if (!UI_Regions_Config_enabled)
      {
        //UI_Regions_Config_reset();
        UI_Regions_Config_state = UI_Regions_Config_state_enum.IDLE;
        UI_Interfaces_enabled = true;
        break;
      }

      /*
      // Disable this config UI if other config UI enabled.
      if (UI_Regions_Config_enabled)
      {
        UI_Regions_Config_enabled = false;
        UI_Regions_Config_state = UI_Regions_Config_state_enum.IDLE;
        break;
      }
      */

      if (get_millis_diff(UI_Regions_Config_timeout_start) > SYSTEM_UI_TIMEOUT * 1000)
      {
        UI_Regions_Config_enabled = false;
        UI_Regions_Config_state = UI_Regions_Config_state_enum.IDLE;
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
        //UI_Regions_Config_reset();
        UI_Regions_Config_enabled = false;
        UI_Regions_Config_state = UI_Regions_Config_state_enum.IDLE;
        UI_Interfaces_enabled = true;
        break;
      }

      // Input done, check password.
      if (!UI_Num_Pad_handle.input_string.equals(SYSTEM_PASSWORD))
      {
        // Password fail...
        UI_Regions_Config_Message_Box_handle = new Message_Box("Error !", "Wrong password input!\nYou can NOT access special functions.", 5);
        UI_Regions_Config_state = UI_Regions_Config_state_enum.DISPLAY_MESSAGE;
        UI_Regions_Config_state_next = UI_Regions_Config_state_enum.IDLE;
        UI_Regions_Config_enabled = false;
        UI_Interfaces_enabled = true;
        break;
      }
      UI_Regions_Config_state = UI_Regions_Config_state_enum.WAIT_CONFIG_INPUT;
      UI_Regions_Config_update();
      UI_Regions_Config_changed_any = false;
      UI_Regions_Config_timeout_start = millis();
      break;
    case WAIT_CONFIG_INPUT:
      if (!UI_Regions_Config_enabled)
      {
        UI_Regions_Config_reset();
        UI_Regions_Config_state = UI_Regions_Config_state_enum.IDLE;
        UI_Interfaces_enabled = true;
        break;
      }

      if (get_millis_diff(UI_Regions_Config_timeout_start) > SYSTEM_UI_TIMEOUT * 1000)
      {
        UI_Regions_Config_reset();
        UI_Regions_Config_enabled = false;
        UI_Regions_Config_state = UI_Regions_Config_state_enum.IDLE;
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

      if (UI_Regions_Config_changed_any)
      {
        UI_Regions_Config_reset();
        // Update done! Indicate updated.
        UI_Regions_Config_Message_Box_handle = new Message_Box("Update done !", "New configuration will applied right now.", 3);
        UI_Regions_Config_state = UI_Regions_Config_state_enum.DISPLAY_MESSAGE;
        UI_Regions_Config_state_next = UI_Regions_Config_state_enum.RESET;
        break;
      }
      break;
    case DISPLAY_MESSAGE:
      if (UI_Regions_Config_Message_Box_handle.draw())
      {
        break;
      }
      UI_Regions_Config_state = UI_Regions_Config_state_next;
      break;
    case RESET:
      UI_Regions_Config_reset();
      UI_Regions_Config_enabled = false;
      UI_Regions_Config_state = UI_Regions_Config_state_enum.IDLE;
      UI_Interfaces_enabled = true;
      Main_restart_enabled = true;
      // To restart program set frameCount to -1, this wiil call setup() of main.
      //frameCount = -1;
      break;
  }
}

void UI_Regions_Config_input_update()
{
  if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_INPUT_UPDATE_DBG) println("UI_Regions_Config_input_update():Enter");

  boolean updated = false;
  boolean updated_relay = false;

  for (int i = 0; i < PS_INSTANCE_MAX; i ++) {
    List<Textfield> cp5_tf_list = UI_Regions_Config_cp5_local[i].getAll(Textfield.class);
    //println(cp5_tf_list);
    boolean updated_instance;
    updated_instance = false;
    for (Textfield tf_handle:cp5_tf_list) {
      //println("Id="+tf_handle.getId()+":Text="+tf_handle.getText());
      if (tf_handle.getId() == -1) continue;
      int instance = tf_handle.getId() / 1000;
      if (i != instance) continue;
      int region_csv_index = tf_handle.getId() % 1000 / 100;
      UI_Regions_Config_tf_enum tf_enum = UI_Regions_Config_tf_enum.values()[tf_handle.getId() % 100];
      //println("instance="+instance+":region_csv_index="+region_csv_index+",tf_enum="+tf_enum);
      Region_CSV region_csv = Regions_handle.get_region_csv_element(instance, region_csv_index);

      String str;
      int val;
      boolean bool;

      str = tf_handle.getText();
      switch (tf_enum) {
        case REGION_NAME: // Region name
          if (str.equals(region_csv.name)) {
            break;
          }
          region_csv.name = str;
          updated_instance = true;
          if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Updated instance="+instance+":region_csv_index="+region_csv_index+",tf_enum="+tf_enum);
          break;
        case REGION_PRIORITY: // Region priority
          try {
            val = Integer.parseInt(str.trim());
          }
          catch (NumberFormatException e) {
            break;
          }
          if (val == region_csv.priority) {
            break;
          }
          region_csv.priority = val;
          updated_instance = true;
          if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Updated instance="+instance+":region_csv_index="+region_csv_index+",tf_enum="+tf_enum);
          break;
        case RELAY_INDEX: {
          try {
            val = Integer.parseInt(str.trim());
          }
          catch (NumberFormatException e) {
            break;
          }
          if (val != -1 && !Relay_Module_check_relay_index(val)) {
            break;
          }
          if (val == region_csv.relay_index) {
            break;
          }
          // Check other relay_index text field has same with this.
          int i_;
          for (i_ = 0; i_ < PS_INSTANCE_MAX; i_ ++) {
            int region_csv_index_;
            for (region_csv_index_ = 0; region_csv_index_ < Regions_handle.get_regions_csv_size_for_index(i_); region_csv_index_ ++)
            {
              if (region_csv_index_ == region_csv_index) continue;
              int relay_index_;
              try {
                relay_index_ =
                  Integer.parseInt(
                    UI_Regions_Config_cp5_local[i_]
                      .get(
                        Textfield.class,
                        "UI_Regions_Config_relay_index_input_"+region_csv_index_)
                          .getText());
              }
              catch (NumberFormatException e) {
                continue;
              }
              catch (NullPointerException e) {
                continue;
              }
              if (relay_index_ != -1 && relay_index_ == val) {
                // Found same relay_index.
                break;
              }
            }
            if (region_csv_index_ != Regions_handle.get_regions_csv_size_for_index(i_)) {
              // Found same relay_index.
              break;
            }
          }
          if (i_ != PS_INSTANCE_MAX) {
            // Found same relay_index.
            break;
          }
          region_csv.relay_index = val;
          updated_instance = true;
          if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Updated instance="+instance+":region_csv_index="+region_csv_index+",tf_enum="+tf_enum);
          break;
        }
        case RELAY_NAME: {
          // Get relay_index input value from text field of this region.
          try {
            val =
              Integer.parseInt(
                UI_Regions_Config_cp5_local[i]
                  .get(
                    Textfield.class,
                    "UI_Regions_Config_relay_index_input_"+region_csv_index)
                      .getText());
          }
          catch (NumberFormatException e) {
            break;
          }
          catch (NullPointerException e) {
            break;
          }
          if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():instance="+instance+":region_csv_index="+region_csv_index+":input relay_index="+val);
          // Check other relay_index text field has same with this.
          int i_;
          for (i_ = 0; i_ < PS_INSTANCE_MAX; i_ ++) {
            int region_csv_index_;
            for (region_csv_index_ = 0; region_csv_index_ < Regions_handle.get_regions_csv_size_for_index(i_); region_csv_index_ ++)
            {
              if (region_csv_index_ == region_csv_index) continue;
              int relay_index_;
              try {
                relay_index_ =
                  Integer.parseInt(
                    UI_Regions_Config_cp5_local[i_]
                      .get(
                        Textfield.class,
                        "UI_Regions_Config_relay_index_input_"+region_csv_index_)
                          .getText());
              }
              catch (NumberFormatException e) {
                continue;
              }
              catch (NullPointerException e) {
                continue;
              }
              if (relay_index_ != -1 && relay_index_ == val) {
                // Found same relay_index.
                break;
              }
            }
            if (region_csv_index_ != Regions_handle.get_regions_csv_size_for_index(i_)) {
              // Found same relay_index.
              break;
            }
          }
          if (i_ != PS_INSTANCE_MAX) {
            // Found same relay_index.
            break;
          }
          // Check relay_index is valid.
          if (!Relay_Module_check_relay_index(val)) {
            if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():instance="+instance+":region_csv_index="+region_csv_index+":relay_index is not valid. "+val);
            break;
          }
          // Check relay name is valid.
          if (str.equals("")) {
            if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():instance="+instance+":region_csv_index="+region_csv_index+":relay_name is blank. "+str+","+Relay_Module_get_relay_name(val));
            break;
          }
          if (str.equals(Relay_Module_get_relay_name(val))) {
            if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():instance="+instance+":region_csv_index="+region_csv_index+":relay_name is same. "+str+","+Relay_Module_get_relay_name(val));
            break;
          }
          Relay_Module_set_relay_name(region_csv.relay_index, str);
          updated_relay = true;
          if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Updated instance="+instance+":region_csv_index="+region_csv_index+",tf_enum="+tf_enum);
          break;
        }
        case NO_MARK_BIG: // No mark big
          bool = str.toLowerCase().equals("true")?true:false;
          if (bool == region_csv.no_mark_big) {
            break;
          }
          region_csv.no_mark_big = bool;
          updated_instance = true;
          if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Updated instance="+instance+":region_csv_index="+region_csv_index+",tf_enum="+tf_enum);
          break;
        case RECT_FIELD_START_X: // Rect field start x
          try {
            val = int(Float.parseFloat(str.trim()) * 100.0);
          }
          catch (NumberFormatException e) {
            break;
          }
          if (val == region_csv.rect_field_x) {
            break;
          }
          region_csv.rect_field_x = val;
          updated_instance = true;
          if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Updated instance="+instance+":region_csv_index="+region_csv_index+",tf_enum="+tf_enum);
          break;
        case RECT_FIELD_START_Y: // Rect field start y
          try {
            val = int(Float.parseFloat(str.trim()) * 100.0);
          }
          catch (NumberFormatException e) {
            break;
          }
          if (val == region_csv.rect_field_y) {
            break;
          }
          region_csv.rect_field_y = val;
          updated_instance = true;
          if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Updated instance="+instance+":region_csv_index="+region_csv_index+",tf_enum="+tf_enum);
          break;
        case RECT_FIELD_END_X: // Rect field end x
          // Get start_x input value from text field of this region.
          int start_x;
          try {
            start_x =
              int(Float.parseFloat(
                UI_Regions_Config_cp5_local[i]
                  .get(
                    Textfield.class,
                    "UI_Regions_Config_rect_start_x_input_"+region_csv_index)
                      .getText()) * 100.0);
          }
          catch (NumberFormatException e) {
            break;
          }
          catch (NullPointerException e) {
            break;
          }
          try {
            val = int(Float.parseFloat(str.trim()) * 100.0);
          }
          catch (NumberFormatException e) {
            break;
          }
          if (start_x > val) {
            break;
          }
          if ((val - start_x) == region_csv.rect_field_width) {
            break;
          }
          region_csv.rect_field_width = val - start_x;
          updated_instance = true;
          if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Updated instance="+instance+":region_csv_index="+region_csv_index+",tf_enum="+tf_enum);
          break;
        case RECT_FIELD_END_Y: // Rect field end y
          // Get start_y input value from text field of this region.
          int start_y;
          try {
            start_y =
              int(Float.parseFloat(
                UI_Regions_Config_cp5_local[i]
                  .get(
                    Textfield.class,
                    "UI_Regions_Config_rect_start_y_input_"+region_csv_index)
                      .getText()) * 100.0);
          }
          catch (NumberFormatException e) {
            break;
          }
          catch (NullPointerException e) {
            break;
          }
          try {
            val = int(Float.parseFloat(str.trim()) * 100.0);
          }
          catch (NumberFormatException e) {
            break;
          }
          if (start_y > val) {
            break;
          }
          if ((val - start_y) == region_csv.rect_field_height) {
            break;
          }
          region_csv.rect_field_height = val - start_y;
          updated_instance = true;
          if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Updated instance="+instance+":region_csv_index="+region_csv_index+",tf_enum="+tf_enum);
          break;
        case RECT_DASHED_GAP: // Rect dashed gap
          try {
            val = Integer.parseInt(str.trim());
          }
          catch (NumberFormatException e) {
            break;
          }
          if (val == region_csv.rect_dashed_gap) {
            break;
          }
          region_csv.rect_dashed_gap = val;
          updated_instance = true;
          if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Updated instance="+instance+":region_csv_index="+region_csv_index+",tf_enum="+tf_enum);
          break;
        default:
          if (PRINT_UI_REGIONS_CONFIG_ALL_ERR || PRINT_UI_REGIONS_CONFIG_LISTENER_ERR) println("UI_Regions_Config_BT_ControlListener:controlEvent():instance="+instance+":region_csv_index="+region_csv_index+",tf_enum="+tf_enum+" error!");
          SYSTEM_logger.severe("UI_Regions_Config_BT_ControlListener:controlEvent():instance="+instance+":region_csv_index="+region_csv_index+",tf_enum="+tf_enum+" error!");
          break;
      } // End of switch (tf_enum)
    } // End of for (Textfield tf_handle:cp5_tf_list)
    if (updated_instance) {
      //Regions_handle.update_regions_csv_file(i);
      updated = true;
      if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Updated instance="+i);
    }
  } // End of for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  if (updated_relay) {
    //Relay_Module_update_relays_csv_file();
    updated = true;
    if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Updated relay");
  }
  if (updated) {
    if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Updated");
    UI_Regions_Config_changed_any = true;
  }
  else {
    UI_Regions_Config_enabled = false;
  }
}

class UI_Regions_Config_BT_ControlListener implements ControlListener {
  public void controlEvent(ControlEvent theEvent) {
    if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():Enter");

    Button bt_handle = (Button)theEvent.getController();
    int button_index = bt_handle.getId();

    if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_BT_ControlListener:controlEvent():button_index="+button_index);

    if (button_index != 0) // Button is not OK.
    {
      UI_Regions_Config_enabled = false;
      return;
    }

    UI_Regions_Config_input_update();
  }
}

class UI_Regions_Config_TF_ControlListener implements ControlListener {
  int col;
  public void controlEvent(ControlEvent theEvent) {
    if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_TF_ControlListener:controlEvent():Enter");

    Textfield tf_handle = (Textfield)theEvent.getController();
    if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_TF_ControlListener:controlEvent():getId="+tf_handle.getId());
    if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_TF_ControlListener:controlEvent():getValue="+tf_handle.getValue());
    if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_TF_ControlListener:controlEvent():getText="+tf_handle.getText());

    Button bt_handle = UI_Regions_Config_cp5_global.get(Button.class, "OK");
    // Check bt_handle.
    if (bt_handle == null) {
      return;
    }

    int button_index = bt_handle.getId();
    if (PRINT_UI_REGIONS_CONFIG_ALL_DBG || PRINT_UI_REGIONS_CONFIG_LISTENER_DBG) println("UI_Regions_Config_TF_ControlListener:controlEvent():button_index="+button_index);
    // Check Button is OK.
    if (button_index != 0) {
      // Button is not OK.
      return;
    }

    UI_Regions_Config_input_update();
  }
}

/*
class UI_Regions_Config_CP5_CallbackListener implements CallbackListener {
  public void controlEvent(CallbackEvent theEvent) {
    UI_Regions_Config_timeout_start = millis();
  }
}
*/

void UI_Regions_Config_key_pressed()
{
  if (!UI_Regions_Config_enabled) return;

  if (key == ESC)
  {
    // Disable UI_Regions_Config.
    UI_Regions_Config_enabled = false;
  }
}

void UI_Regions_Config_mouse_moved()
{
  if (!UI_Regions_Config_enabled) return;

  UI_Regions_Config_timeout_start = millis();
}

void UI_Regions_Config_mouse_dragged()
{
  if (!UI_Regions_Config_enabled) return;

  UI_Regions_Config_timeout_start = millis();
}
