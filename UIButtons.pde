//final static boolean PRINT_UI_BUTTONS_ALL_DBG = true;
final static boolean PRINT_UI_BUTTONS_ALL_DBG = false;

//final static boolean PRINT_UI_BUTTONS_SETUP_DBG = true;
final static boolean PRINT_UI_BUTTONS_SETUP_DBG = false;

//final static boolean PRINT_UI_BUTTONS_ZOOM_DBG = true;
final static boolean PRINT_UI_BUTTONS_ZOOM_DBG = false;

//final static boolean PRINT_UI_BUTTONS_ROTATE_DBG = true;
final static boolean PRINT_UI_BUTTONS_ROTATE_DBG = false;

//final static boolean PRINT_UI_BUTTONS_MIRROR_DBG = true;
final static boolean PRINT_UI_BUTTONS_MIRROR_DBG = false;

//final static boolean PRINT_UI_BUTTONS_ANGLE_DBG = true;
final static boolean PRINT_UI_BUTTONS_ANGLE_DBG = false;

//final static boolean PRINT_UI_BUTTONS_RESET_DBG = true;
final static boolean PRINT_UI_BUTTONS_RESET_DBG = false;

//final static boolean PRINT_UI_BUTTONS_MOUSE_DBG = true;
final static boolean PRINT_UI_BUTTONS_MOUSE_DBG = false;

static color C_UI_BUTTONS_NORMAL = #FFFFFF; // White
static color C_UI_BUTTONS_HIGHLIGHT = #C0C0C0; //
static color C_UI_BUTTONS_TEXT = #000000; // Black
static color C_UI_BUTTONS_BOX = #000000; // Black
static int W_UI_BUTTONS_BOX = 1; // Black

static String UI_Buttons_zoom_minus_str = "-";           // button string zoom minus
static String UI_Buttons_zoom_pluse_str = "+";           // button string zoom pluse
static String UI_Buttons_zoom_caption_str = "Zoom";      // button string zoom caption

//static String UI_Buttons_rotate_ccw_str = "↺";           // button string rotate counter clock-wise
static String UI_Buttons_rotate_cw_str = "↻";            // button string rotate clock-wise
static String UI_Buttons_rotate_caption_str = "Rotate";  // button string rotate caption

static String UI_Buttons_mirror_ud_str = "⇅";            // button string up-down mirror enable
//static String UI_Buttons_mirror_lr_str = "⇄";            // button string left-right mirror enable
static String UI_Buttons_mirror_caption_str = "Mirror";  // button string mirror caption

static String UI_Buttons_angle_minus_str = "-";           // button string angle minus
static String UI_Buttons_angle_pluse_str = "+";           // button string angle pluse
static String UI_Buttons_angle_caption_str = "Angle";      // button string angle caption

static String UI_Buttons_reset_en_str = "0";             // button string reset enable
static String UI_Buttons_reset_en_caption_str = "Reset"; // button string reset enable caption

static boolean UI_Buttons_enabled;
static Buttons_Group UI_Buttons_group_zoom;
static ArrayList<Buttons_Group>[] UI_Buttons_groups_array;
static enum UI_Buttons_action_enum {
  ZOOM_PLUSE, ZOOM_MINUS, ROTATE_CW, ROTATE_CCW, MIRROR_LR, MIRROR_UD, ANGLE_PLUSE, ANGLE_MINUS, RESET, MAX
}

static enum UI_Buttons_state_enum {
  IDLE,
  PASSWORD_REQ,
  DRAW_BUTTONS,
  DISPLAY_MESSAGE,
  MAX
}
static UI_Buttons_state_enum UI_Buttons_state;
static UI_Buttons_state_enum UI_Buttons_state_next;
static int UI_Buttons_timeout_start;

static Message_Box UI_Buttons_Message_Box_handle = null;

void UI_Buttons_setup()
{
  if (PRINT_UI_BUTTONS_ALL_DBG || PRINT_UI_BUTTONS_SETUP_DBG) println("UI_Buttons_setup():Enter");

  //UI_Buttons_enabled = true;
  UI_Buttons_enabled = false;

  UI_Buttons_groups_array = new ArrayList[PS_INSTANCE_MAX];

  int offset_top_y_start = FONT_HEIGHT + TEXT_MARGIN + TEXT_MARGIN;
  int w_h = FONT_HEIGHT * 2;
  int center_x_adv = 0;
  int top_y_adv = FONT_HEIGHT * 2;
  int top_y = SCREEN_height / 2 - (top_y_adv * 12 + w_h) / 2;
  //int top_y = SCREEN_height / 2 - FONT_HEIGHT - FONT_HEIGHT * 2 * 2 - TEXT_MARGIN - FONT_HEIGHT - TEXT_MARGIN;

  UI_Buttons_state = UI_Buttons_state_enum.IDLE;

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    UI_Buttons_groups_array[i] = new ArrayList<Buttons_Group>();

    int center_x_start;
    Buttons_Group buttons_group;

    switch (i)
    {
      case 0:
        //center_x_start = TEXT_MARGIN + FONT_HEIGHT + FONT_HEIGHT;
        center_x_start = TEXT_MARGIN + FONT_HEIGHT + FONT_HEIGHT / 2;
        //center_x_adv = FONT_HEIGHT * 3;
        //top_y_adv = 0;
        break;
      case 1:
        //center_x_start = SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT + FONT_HEIGHT);
        center_x_start = SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT + FONT_HEIGHT / 2);
        //center_x_adv = -(FONT_HEIGHT * 3);
        //top_y_adv = 0;
        break;
      default:
        continue;
    }

    buttons_group =
      new Buttons_Group(
        UI_Buttons_zoom_caption_str,
        center_x_start + center_x_adv * 0,
        top_y + top_y_adv * 0,
        C_UI_BUTTONS_BOX,
        W_UI_BUTTONS_BOX,
        C_UI_BUTTONS_NORMAL,
        C_UI_BUTTONS_HIGHLIGHT,
        C_UI_BUTTONS_TEXT);
    buttons_group.add_button(
      UI_Buttons_action_enum.ZOOM_PLUSE, UI_Buttons_zoom_pluse_str,
      0, offset_top_y_start, w_h, w_h);
    buttons_group.add_button(
      UI_Buttons_action_enum.ZOOM_MINUS, UI_Buttons_zoom_minus_str,
       0, offset_top_y_start + FONT_HEIGHT * 2, w_h, w_h);
    UI_Buttons_groups_array[i].add(buttons_group);

    buttons_group =
      new Buttons_Group(
        UI_Buttons_rotate_caption_str,
        center_x_start + center_x_adv * 1,
        top_y + top_y_adv * 3,
        C_UI_BUTTONS_BOX,
        W_UI_BUTTONS_BOX,
        C_UI_BUTTONS_NORMAL,
        C_UI_BUTTONS_HIGHLIGHT,
        C_UI_BUTTONS_TEXT);
    buttons_group.add_button(
      UI_Buttons_action_enum.ROTATE_CW, UI_Buttons_rotate_cw_str,
      0, offset_top_y_start, w_h, w_h);
    /*
    buttons_group.add_button(
      UI_Buttons_action_enum.ROTATE_CCW, UI_Buttons_rotate_ccw_str,
      0, offset_top_y_start + FONT_HEIGHT * 2, w_h, w_h);
    */
    UI_Buttons_groups_array[i].add(buttons_group);

    buttons_group =
      new Buttons_Group(
        UI_Buttons_mirror_caption_str,
        center_x_start + center_x_adv * 2,
        top_y + top_y_adv * 5,
        C_UI_BUTTONS_BOX,
        W_UI_BUTTONS_BOX,
        C_UI_BUTTONS_NORMAL,
        C_UI_BUTTONS_HIGHLIGHT,
        C_UI_BUTTONS_TEXT);
    /*
    buttons_group.add_button(
      UI_Buttons_action_enum.MIRROR_LR, UI_Buttons_mirror_lr_str,
      0, offset_top_y_start, w_h, w_h);
    */
    buttons_group.add_button(
      UI_Buttons_action_enum.MIRROR_UD, UI_Buttons_mirror_ud_str,
      //0, offset_top_y_start + FONT_HEIGHT * 2, w_h, w_h);
      0, offset_top_y_start, w_h, w_h);
    UI_Buttons_groups_array[i].add(buttons_group);

    buttons_group =
      new Buttons_Group(
        UI_Buttons_angle_caption_str,
        center_x_start + center_x_adv * 3,
        top_y + top_y_adv * 7,
        C_UI_BUTTONS_BOX,
        W_UI_BUTTONS_BOX,
        C_UI_BUTTONS_NORMAL,
        C_UI_BUTTONS_HIGHLIGHT,
        C_UI_BUTTONS_TEXT);
    buttons_group.add_button(
      UI_Buttons_action_enum.ANGLE_PLUSE, UI_Buttons_angle_pluse_str,
      0, offset_top_y_start, w_h, w_h);
    buttons_group.add_button(
      UI_Buttons_action_enum.ANGLE_MINUS, UI_Buttons_angle_minus_str,
       0, offset_top_y_start + FONT_HEIGHT * 2, w_h, w_h);
    UI_Buttons_groups_array[i].add(buttons_group);

    buttons_group =
      new Buttons_Group(
        UI_Buttons_reset_en_caption_str,
        center_x_start + center_x_adv * 5,
        top_y + top_y_adv * 10,
        C_UI_BUTTONS_BOX,
        W_UI_BUTTONS_BOX,
        C_UI_BUTTONS_NORMAL,
        C_UI_BUTTONS_HIGHLIGHT,
        C_UI_BUTTONS_TEXT);
    buttons_group.add_button(
      UI_Buttons_action_enum.RESET, UI_Buttons_reset_en_str,
      0, offset_top_y_start, w_h, w_h);
    UI_Buttons_groups_array[i].add(buttons_group);
  }
}

void UI_Buttons_draw()
{
  //println("UI_Buttons_state=", UI_Buttons_state);
  switch (UI_Buttons_state)
  {
    case IDLE:
      if (!UI_Buttons_enabled)
      {
        break;
      }

      // Check password not required.
      if (SYSTEM_PASSWORD_disabled)
      {
        UI_Buttons_state = UI_Buttons_state_enum.DRAW_BUTTONS;
        UI_Buttons_timeout_start = millis();
        break;
      }

      UI_Num_Pad_setup("Input system password");
      UI_Buttons_state = UI_Buttons_state_enum.PASSWORD_REQ;
      break;
    case PASSWORD_REQ:
      if (!UI_Buttons_enabled)
      {
        UI_Buttons_state = UI_Buttons_state_enum.IDLE;
        break;
      }

      UI_Num_Pad_handle.draw();
      if (!UI_Num_Pad_handle.input_done())
      {
        break;
      }

      if (UI_Num_Pad_handle.input_string == null)
      {
        UI_Buttons_enabled = false;
        UI_Buttons_state = UI_Buttons_state_enum.IDLE;
        break;
      }

      // Input done, check password.
      if (!UI_Num_Pad_handle.input_string.equals(SYSTEM_PASSWORD))
      {
        // Password fail...
        UI_Buttons_Message_Box_handle = new Message_Box("Error !", "Wrong password input!\nYou can NOT access special functions.", 5);
        UI_Buttons_state = UI_Buttons_state_enum.DISPLAY_MESSAGE;
        UI_Buttons_state_next = UI_Buttons_state_enum.IDLE;
        UI_Buttons_enabled = false;
        break;
      }

      UI_Buttons_state = UI_Buttons_state_enum.DRAW_BUTTONS;
      UI_Buttons_timeout_start = millis();
      break;
    case DRAW_BUTTONS:
      if (!UI_Buttons_enabled)
      {
        UI_Buttons_state = UI_Buttons_state_enum.IDLE;
        break;
      }

      if (get_millis_diff(UI_Buttons_timeout_start) > SYSTEM_UI_TIMEOUT * 1000)
      {
        UI_Buttons_enabled = false;
        UI_Buttons_state = UI_Buttons_state_enum.IDLE;
        break;
      }

      for (int i = 0; i < PS_INSTANCE_MAX; i ++)
      {
        for (Buttons_Group buttons_group:UI_Buttons_groups_array[i])
        {
          buttons_group.draw();
        }
      }
      break;
    case DISPLAY_MESSAGE:
      if (UI_Buttons_Message_Box_handle.draw())
      {
        break;
      }
      UI_Buttons_state = UI_Buttons_state_next;
      break;
  }
}

static int UI_Buttons_mouse_drag_base_x;
static int UI_Buttons_mouse_drag_base_y;
static int UI_Buttons_mouse_drag_base_instance = -1;

int UI_Buttons_get_instance_xy(int x, int y)
{
  if (x < SCREEN_width / 2) return 0;
  else if (x > SCREEN_width / 2) return 1;
  return -1;
}

void UI_Buttons_mouse_pressed()
{
  if (!UI_Buttons_enabled) return;

  int instance = UI_Buttons_get_instance_xy(mouseX, mouseY);
  if (PRINT_UI_BUTTONS_MOUSE_DBG) println("UI_Buttons_mouse_pressed():" + "UI_Buttons_get_instance_xy(" + mouseX + "," + mouseY + ")=" + instance);
  if (instance != -1)
  {
    UI_Buttons_mouse_drag_base_x = mouseX - DRAW_OFFSET_X[instance];
    UI_Buttons_mouse_drag_base_y = mouseY - DRAW_OFFSET_Y[instance];
    UI_Buttons_mouse_drag_base_instance = instance;
    if (PRINT_UI_BUTTONS_MOUSE_DBG) println("UI_Buttons_mouse_pressed():" + "UI_Buttons_mouse_drag_base_x=" + UI_Buttons_mouse_drag_base_x + ",UI_Buttons_mouse_drag_base_y=" + UI_Buttons_mouse_drag_base_y);
  }

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    for (Buttons_Group buttons_group:UI_Buttons_groups_array[i])
    {
      if (buttons_group.is_focused()) {
        // Disable mouse drag function when issue button action.
        UI_Buttons_mouse_drag_base_instance = -1;
        switch (buttons_group.get_action())
        {
          case ZOOM_PLUSE:
            UI_Buttons_zoom_pluse(i);
            break;
          case ZOOM_MINUS:
            UI_Buttons_zoom_minus(i);
            break;
          case ROTATE_CW:
            UI_Buttons_rotate_cw(i);
            break;
          case ROTATE_CCW:
            UI_Buttons_rotate_ccw(i);
            break;
          case MIRROR_UD:
            UI_Buttons_mirror_ud(i);
            break;
          case MIRROR_LR:
            UI_Buttons_mirror_lr(i);
            break;
          case ANGLE_PLUSE:
            UI_Buttons_angle_pluse(i);
            break;
          case ANGLE_MINUS:
            UI_Buttons_angle_minus(i);
            break;
          case RESET:
            UI_Buttons_reset_en(i);
            break;
        }
      }
    }
  }
}

void UI_Buttons_mouse_released()
{
  if (!UI_Buttons_enabled) return;

  if (UI_Buttons_mouse_drag_base_instance != -1)
    UI_Buttons_mouse_drag_base_instance = -1;
}

void UI_Buttons_mouse_moved()
{
  if (!UI_Buttons_enabled) return;

  UI_Buttons_timeout_start = millis();

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    for (Buttons_Group buttons_group:UI_Buttons_groups_array[i])
    {
      buttons_group.mouse_moved();
    }
  }
}

void UI_Buttons_mouse_dragged()
{
  if (!UI_Buttons_enabled) return;

  UI_Buttons_timeout_start = millis();

  if (PRINT_UI_BUTTONS_MOUSE_DBG) println("UI_Buttons_mouse_dragged():" + "UI_Buttons_mouse_drag_base_x=" + UI_Buttons_mouse_drag_base_x + ",UI_Buttons_mouse_drag_base_y=" + UI_Buttons_mouse_drag_base_y);

  int instance = UI_Buttons_get_instance_xy(mouseX, mouseY);
  if (PRINT_UI_BUTTONS_MOUSE_DBG) println("UI_Buttons_mouse_dragged():" + "UI_Buttons_get_instance_xy(" + mouseX + "," + mouseY + ")=" + instance);
  if (instance != -1)
  {
    if (instance == UI_Buttons_mouse_drag_base_instance)
    {
      DRAW_OFFSET_X[instance] = mouseX - UI_Buttons_mouse_drag_base_x;
      DRAW_OFFSET_Y[instance] = mouseY - UI_Buttons_mouse_drag_base_y;
      //println("DRAW_OFFSET_X["+instance+"]=" + DRAW_OFFSET_X[instance] + ",DRAW_OFFSET_Y["+instance+"]=" + DRAW_OFFSET_Y[instance]);
      Screen_update_variable();

      if (PRINT_UI_BUTTONS_MOUSE_DBG) println("UI_Buttons_mouse_dragged():" + "DRAW_OFFSET_X["+instance+"]:" + DRAW_OFFSET_X[instance] + ", DRAW_OFFSET_Y["+instance+"]:" + DRAW_OFFSET_Y[instance]);
    }
  }

  for (int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    for (Buttons_Group buttons_group:UI_Buttons_groups_array[i])
    {
      buttons_group.mouse_dragged();
    }
  }
}

void UI_Buttons_mouse_wheel(int wheel_count)
{
  if (!UI_Buttons_enabled) return;

  UI_Buttons_timeout_start = millis();

  if (wheel_count > 0)
  {
    //for (; wheel_count > 0; wheel_count -= 1)
    {
      for (int i = 0; i < PS_INSTANCE_MAX; i ++)
        UI_Buttons_zoom_minus(i);
    }
  }
  else if (wheel_count < 0)
  {
    //for (; wheel_count < 0; wheel_count += 1)
    {  
      for (int i = 0; i < PS_INSTANCE_MAX; i ++)
        UI_Buttons_zoom_pluse(i);
    }
  }
}

void UI_Buttons_zoom_minus(int instance)
{
  if (ZOOM_FACTOR[instance] >= 5000)
  {
    if(PRINT_UI_BUTTONS_ZOOM_DBG) println("ZOOM_FACTOR["+instance+"]=" + ZOOM_FACTOR[instance]);
    return;
  }

  if (ZOOM_FACTOR[instance] < 200) ZOOM_FACTOR[instance] += 10;
  else if (ZOOM_FACTOR[instance] < 1000) ZOOM_FACTOR[instance] += 100;
  else if (ZOOM_FACTOR[instance] < 2000) ZOOM_FACTOR[instance] += 200;
  else ZOOM_FACTOR[instance] += 500;
  Screen_update_variable();
  //Config_update();

  if(PRINT_UI_BUTTONS_ZOOM_DBG) println("ZOOM_FACTOR["+instance+"]=" + ZOOM_FACTOR[instance]);
}

void UI_Buttons_zoom_pluse(int instance)
{
  if (ZOOM_FACTOR[instance] <= 20)
  {
    if(PRINT_UI_BUTTONS_ZOOM_DBG) println("ZOOM_FACTOR["+instance+"]=" + ZOOM_FACTOR[instance]);
    return;
  }

  if (ZOOM_FACTOR[instance] <= 200) ZOOM_FACTOR[instance] -= 10;
  else if (ZOOM_FACTOR[instance] <= 1000) ZOOM_FACTOR[instance] -= 100;
  else if (ZOOM_FACTOR[instance] <= 2000) ZOOM_FACTOR[instance] -= 200;
  else ZOOM_FACTOR[instance] -= 500;
  Screen_update_variable();
  //Config_update();

  if(PRINT_UI_BUTTONS_ZOOM_DBG) println("ZOOM_FACTOR["+instance+"]=" + ZOOM_FACTOR[instance]);
}

void UI_Buttons_rotate_ccw(int instance)
{
  ROTATE_FACTOR[instance] -= 90;
  if (ROTATE_FACTOR[instance] < 0) ROTATE_FACTOR[instance] += 360;
  Screen_update_offsets();
  Screen_update_variable();
  //Config_update();
  if(PRINT_UI_BUTTONS_ROTATE_DBG) println("ROTATE_FACTOR[instance]=" + ROTATE_FACTOR[instance]);
}

void UI_Buttons_rotate_cw(int instance)
{
  if (ROTATE_FACTOR[instance] == 135 && MIRROR_ENABLE[instance] == true)
  {
    ROTATE_FACTOR[instance] = 225;
    MIRROR_ENABLE[instance] = false;
  }
  else if (ROTATE_FACTOR[instance] == 225 && MIRROR_ENABLE[instance] == false)
  {
    ROTATE_FACTOR[instance] = 135;
    MIRROR_ENABLE[instance] = true;
  }
  else if (ROTATE_FACTOR[instance] == 45 && MIRROR_ENABLE[instance] == true)
  {
    ROTATE_FACTOR[instance] = 135;
    MIRROR_ENABLE[instance] = false;
  }
  else if(ROTATE_FACTOR[instance] == 135 && MIRROR_ENABLE[instance] == false)
  {
    ROTATE_FACTOR[instance] = 45;
    MIRROR_ENABLE[instance] = true;
  }
  else if (ROTATE_FACTOR[instance] == 315 && MIRROR_ENABLE[instance] == false)
  {
    ROTATE_FACTOR[instance] = 225;
    MIRROR_ENABLE[instance] = true;
  }
  else if (ROTATE_FACTOR[instance] == 225 && MIRROR_ENABLE[instance] == true)
  {
    ROTATE_FACTOR[instance] = 315;
    MIRROR_ENABLE[instance] = false;
  }
  else if (ROTATE_FACTOR[instance] == 45 && MIRROR_ENABLE[instance] == false)
  {
    ROTATE_FACTOR[instance] = 315;
    MIRROR_ENABLE[instance] = true;
  }
  else if(ROTATE_FACTOR[instance] == 315 && MIRROR_ENABLE[instance] == true)
  {
    ROTATE_FACTOR[instance] = 45;
    MIRROR_ENABLE[instance] = false;
  }

/*
  ROTATE_FACTOR[instance] += 90;
  if (ROTATE_FACTOR[instance] > 360) ROTATE_FACTOR[instance] -= 360;
*/
  Screen_update_offsets();
  Screen_update_variable();
  //Config_update();
  if(PRINT_UI_BUTTONS_ROTATE_DBG) println("ROTATE_FACTOR[instance]=" + ROTATE_FACTOR[instance]);
}

void UI_Buttons_mirror_ud(int instance)
{
  MIRROR_ENABLE[instance] = !MIRROR_ENABLE[instance];
  if (ROTATE_FACTOR[instance] == 45 || ROTATE_FACTOR[instance] == 225)
  {
    if (ROTATE_FACTOR[instance] == 45) { // OK
      ROTATE_FACTOR[instance] = 225;
    }
    else /*if (ROTATE_FACTOR[instance] == 225)*/ { // OK
      ROTATE_FACTOR[instance] = 45;
    }
  }
  Screen_update_offsets();
  Screen_update_variable();
  //Config_update();
  if(PRINT_UI_BUTTONS_MIRROR_DBG) println("MIRROR_ENABLE[instance]=" + MIRROR_ENABLE[instance] + ", ROTATE_FACTOR[instance]=" + ROTATE_FACTOR[instance]);
}

void UI_Buttons_mirror_lr(int instance)
{
  MIRROR_ENABLE[instance] = !MIRROR_ENABLE[instance];
  if (ROTATE_FACTOR[instance] == 315 || ROTATE_FACTOR[instance] == 135)
  {
    if (ROTATE_FACTOR[instance] == 315) { // OK
      ROTATE_FACTOR[instance] = 135;
    }
    else /*if (ROTATE_FACTOR[instance] == 135)*/ { // OK
      ROTATE_FACTOR[instance] = 315;
    }
  }
  Screen_update_offsets();
  Screen_update_variable();
  //Config_update();
  if(PRINT_UI_BUTTONS_MIRROR_DBG) println("MIRROR_ENABLE[" + instance + "]=" + MIRROR_ENABLE[instance] + ",ROTATE_FACTOR[" + instance + "]=" + ROTATE_FACTOR[instance]);
}

void UI_Buttons_angle_minus(int instance)
{
  if (ANGLE_ADJUST[instance] <= ANGLE_ADJUST_MIN)
  {
    ANGLE_ADJUST[instance] = ANGLE_ADJUST_MIN;
    return;
  }

  ANGLE_ADJUST[instance] -= 10;

  PS_Data_draw_params_keep_alive(instance);

  Screen_update_variable();
  //Config_update();
  if(PRINT_UI_BUTTONS_ANGLE_DBG) println("ANGLE_ADJUST["+instance+"]=" + ANGLE_ADJUST[instance]);
}

void UI_Buttons_angle_pluse(int instance)
{
  if (ANGLE_ADJUST[instance] >= ANGLE_ADJUST_MAX)
  {
    ANGLE_ADJUST[instance] = ANGLE_ADJUST_MAX;
    return;
  }

  ANGLE_ADJUST[instance] += 10;

  PS_Data_draw_params_keep_alive(instance);

  Screen_update_variable();
  //Config_update();
  if(PRINT_UI_BUTTONS_ANGLE_DBG) println("ANGLE_ADJUST["+instance+"]=" + ANGLE_ADJUST[instance]);
}

void UI_Buttons_reset_en(int instance)
{
  //if(PRINT_UI_BUTTONS_RESET_DBG) println("UI_Buttons_reset_en()" + "\n\tZOOM_FACTOR[" + instance + "]=" + ZOOM_FACTOR[instance] + "\n\tMIRROR_ENABLE[" + instance + "]=" + MIRROR_ENABLE[instance] + "\n\tDRAW_OFFSET_X[" + instance + "]=" + DRAW_OFFSET_X[instance] + ",DRAW_OFFSET_Y[" + instance + "]=" + DRAW_OFFSET_Y[instance]);
  if(PRINT_UI_BUTTONS_RESET_DBG) println("UI_Buttons_reset_en(" + instance + "):" + "\n\tDRAW_OFFSET_X[" + instance + "]=" + DRAW_OFFSET_X[instance] + ",DRAW_OFFSET_Y[" + instance + "]=" + DRAW_OFFSET_Y[instance]);

  //DRAW_OFFSET_X[instance] = DRAW_OFFSET_Y[instance] = 0;
  //MIRROR_ENABLE[instance] = false;
  //ZOOM_FACTOR[instance] = 100;
  ANGLE_ADJUST[instance] = 0;

  PS_Data_draw_params_keep_alive(instance);

  Screen_update_offsets();
  Screen_update_variable();
  //Config_update();
}

class Buttons_Group {
  private ArrayList<Button_Instance> buttons = new ArrayList<Button_Instance>();
  private int center_x, top_y;
  private String text;
  private int text_left_x;
  private color stroke_c;
  private int stroke_w;
  private color fill_c_normal;
  private color fill_c_highlight;
  private color fill_c_text;
  private UI_Buttons_action_enum action;

  Buttons_Group(String text, int center_x, int top_y, color stroke_c, int stroke_w, color fill_c_normal, color fill_c_highlight, color fill_c_text) {
    this.text = text;
    this.center_x = center_x;
    textSize(FONT_HEIGHT);
    this.text_left_x = int(center_x - textWidth(text) / 2.0);
    this.top_y = top_y;
    this.stroke_c = stroke_c;
    this.stroke_w = stroke_w;
    this.fill_c_normal = fill_c_normal;
    this.fill_c_highlight = fill_c_highlight;
    this.fill_c_text = fill_c_text;
  }

  public void set_caption_text(String text) {
    this.text = text;
  }

  public void add_button(UI_Buttons_action_enum action, String text, int center_x_offset, int top_y_offset, int w, int h) {
    this.buttons
      .add(
        new Button_Instance(
          action,
          text,
          this.center_x + center_x_offset - w / 2,
          this.top_y + top_y_offset,
          w,
          h));
  }

  public void draw() {
    textSize(FONT_HEIGHT);
    // Sets the color and weight used to draw lines and borders around shapes.
    stroke(stroke_c);
    strokeWeight(stroke_w);
    textAlign(LEFT, TOP);
    for (Button_Instance button:buttons) {
      button.draw(fill_c_normal, fill_c_highlight, fill_c_text);
    }
    //textAlign(LEFT, TOP);
    text(text, text_left_x, top_y);
  }

  public UI_Buttons_action_enum get_action() {
    return action;
  }

  public boolean is_focused() {
    for (Button_Instance button:buttons) {
      if (button.is_focused()) {
        this.action = button.get_action();
        return true;
      }
    }
    return false;
  }

  public void mouse_moved() {
    for (Button_Instance button:buttons) {
      button.mouse_moved();
    }
  }

  public void mouse_dragged() {
    for (Button_Instance button:buttons) {
      button.mouse_dragged();
    }
  }
}

class Button_Instance {
  private UI_Buttons_action_enum action;
  private int left_x, top_y;
  private int w, h;
  private String text;
  private int text_left_x, text_top_y;
  private boolean focused;
  private boolean pressed;

  Button_Instance(UI_Buttons_action_enum action, String text, int left_x, int top_y, int w, int h) {
    this.action = action;
    this.text = text;
    this.left_x = left_x;
    textSize(FONT_HEIGHT);
    this.text_left_x = left_x + int(w / 2.0 - textWidth(text) / 2.0) + 1;
    this.text_top_y = top_y + int(h / 2.0 - FONT_HEIGHT / 2.0) - 2;
    this.top_y = top_y;
    this.w = w;
    this.h = h;
    this.focused = false;
    this.pressed = false;
  }

  public void set_text(String text) {
    this.text = text;
  }

  public void draw(color fill_c_normal, color fill_c_highlight, color fill_c_text) {
    if (focused) {
      fill(fill_c_highlight);
    }
    else {
      fill(fill_c_normal);
    }
    rect(left_x, top_y, w, h);
    fill(fill_c_text);
    text(text, text_left_x, text_top_y);
  }

  public UI_Buttons_action_enum get_action() {
    return action;
  }

  public boolean is_focused() {
    return focused;
  }

  public void mouse_moved() {
    if (mouse_is_over(left_x, top_y, w, h)) {
      focused = true;
    }
    else
    {
      focused = false;
    }
  }

  public void mouse_dragged() {
    if (mouse_is_over(left_x, top_y, w, h)) {
      focused = true;
    }
    else
    {
      focused = false;
    }
  }
}
