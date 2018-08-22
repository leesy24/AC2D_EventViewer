import java.awt.event.KeyEvent;

//final static boolean PRINT_MOUSEKEYFUNC_DBG_ALL = true;
final static boolean PRINT_MOUSEKEYFUNC_DBG_ALL = false;

//final static boolean PRINT_MOUSEKEYFUNC_DBG_POS = true;
final static boolean PRINT_MOUSEKEYFUNC_DBG_POS = false;

//final static boolean PRINT_KEYFUNC_Pressed = true; 
final static boolean PRINT_KEYFUNC_Pressed = false;

//final static boolean PRINT_MOUSEFUNC_Pressed = true; 
final static boolean PRINT_MOUSEFUNC_Pressed = false;

//final static boolean PRINT_MOUSEFUNC_Released = true; 
final static boolean PRINT_MOUSEFUNC_Released = false;

//final static boolean PRINT_MOUSEFUNC_Moved = true; 
final static boolean PRINT_MOUSEFUNC_Moved = false;

//final static boolean PRINT_MOUSEFUNC_Dragged = true; 
final static boolean PRINT_MOUSEFUNC_Dragged = false;

//final static boolean PRINT_MOUSEFUNC_Wheel = true; 
final static boolean PRINT_MOUSEFUNC_Wheel = false;

/**/
void keyPressed()
{
  String msg = "keyPressed():key=(" + int(key) + ")" + ((key>=32 && key<=126)?key:"") + ",keyCode=(" + keyCode + ")" + KeyEvent.getKeyText(keyCode);
  if (PRINT_KEYFUNC_Pressed || PRINT_MOUSEKEYFUNC_DBG_ALL || PRINT_MOUSEKEYFUNC_DBG_POS) println(msg);
  SYSTEM_logger.info(msg);

  UI_System_Config_key_pressed();
  UI_Regions_Config_key_pressed();
  UI_Num_Pad_key_pressed();

  if (key == ESC)
  {
    key = 0;  // Prevents the ESC key from being used.
  }
  else if(key == CODED)
  {
    if(keyCode == KeyEvent.VK_F10)
    {
    }
    else if(keyCode == KeyEvent.VK_F9)
    {
    }
    else if(keyCode == KeyEvent.VK_F8)
    {
      Bubble_Info_enabled = !Bubble_Info_enabled;
    }
    else if(keyCode == KeyEvent.VK_F7)
    {
      PS_Data_draw_points_with_line = !PS_Data_draw_points_with_line;
    }
    else if(keyCode == KeyEvent.VK_F6)
    {
      //UI_Interfaces_enabled = !UI_Interfaces_enabled;
    }
    else if(keyCode == KeyEvent.VK_F5)
    {
      Main_restart_enabled = true;
    }
    else if(keyCode == KeyEvent.VK_F4)
    {
      PS_Data_draw_points_all_enabled = !PS_Data_draw_points_all_enabled;
    }
    else if(keyCode == KeyEvent.VK_F3)
    {
      UI_Regions_Config_enabled = !UI_Regions_Config_enabled;
    }
    else if(keyCode == KeyEvent.VK_F2)
    {
      UI_Buttons_enabled = !UI_Buttons_enabled;
      //mouse_wheel_enabled = !mouse_wheel_enabled;
    }
    else if(keyCode == KeyEvent.VK_F1)
    {
      UI_System_Config_enabled = !UI_System_Config_enabled;
    }
  }
}
/**/
/*
void keyTyped()
{
  println("keyTyped " + int(key) + " " + keyCode);
}
*/
/*
void keyReleased()
{
  println("released " + int(key) + " " + keyCode);
}
*/

void mousePressed()
{
  if (PRINT_MOUSEFUNC_Pressed || PRINT_MOUSEKEYFUNC_DBG_ALL) println("Mouse pressed! ");

  if (PRINT_MOUSEFUNC_Pressed || PRINT_MOUSEKEYFUNC_DBG_ALL || PRINT_MOUSEKEYFUNC_DBG_POS) println("mouseX=" + mouseX + ", mouseY=" + mouseY);
  SYSTEM_logger.info("mousePressed()" + ":X=" + mouseX + ",Y=" + mouseY + ",Button=" + mouseButton);
  //if (PRINT_MOUSEFUNC_Pressed) println("SCREEN_width - mouseX=" + (SCREEN_width - mouseX) + ", mouseY=" + mouseY);

  UI_Num_Pad_mouse_pressed();
  UI_Buttons_mouse_pressed();
  PS_Image_mouse_pressed();
  PS_Data_mouse_pressed();
  ROI_Data_mouse_pressed();
}

void mouseReleased()
{
  if (PRINT_MOUSEFUNC_Released || PRINT_MOUSEKEYFUNC_DBG_ALL) println("Mouse released! ");
  SYSTEM_logger.info("mouseReleased()" + ":X=" + mouseX + ",Y=" + mouseY + ",Button=" + mouseButton);

  UI_System_Config_mouse_moved();
  UI_Regions_Config_mouse_moved();
  UI_Num_Pad_mouse_released();
  UI_Buttons_mouse_released();
  PS_Image_mouse_released();
  ROI_Data_mouse_released();
}

void mouseMoved()
{
  if (PRINT_MOUSEFUNC_Moved || PRINT_MOUSEKEYFUNC_DBG_ALL) println("Mouse moved!");
  if (PRINT_MOUSEFUNC_Moved || PRINT_MOUSEKEYFUNC_DBG_ALL || PRINT_MOUSEKEYFUNC_DBG_POS) println("\t mouseX=" + mouseX + ", mouseY=" + mouseY + ", mousePressed=" + mousePressed);

  UI_System_Config_mouse_dragged();
  UI_Regions_Config_mouse_dragged();
  UI_Num_Pad_mouse_moved();
  UI_Buttons_mouse_moved();
  PS_Image_mouse_moved();
  PS_Data_mouse_moved();
  ROI_Data_mouse_moved();
}

void mouseDragged() 
{
  if (PRINT_MOUSEFUNC_Dragged || PRINT_MOUSEKEYFUNC_DBG_ALL) println("Mouse dragged!");
  if (PRINT_MOUSEFUNC_Dragged || PRINT_MOUSEKEYFUNC_DBG_ALL || PRINT_MOUSEKEYFUNC_DBG_POS) println("\t mouseX=" + mouseX + ", mouseY=" + mouseY + ", mousePressed=" + mousePressed);

  UI_Num_Pad_mouse_dragged();
  UI_Buttons_mouse_dragged();
  PS_Image_mouse_dragged();
  PS_Data_mouse_dragged();
  ROI_Data_mouse_dragged();
}

void mouseWheel(MouseEvent event)
{
  int wheel_count = event.getCount();
  SYSTEM_logger.info("mouseWheel()" + ":X=" + mouseX + ",Y=" + mouseY + ",Button=" + mouseButton + ",Count=" + wheel_count);
  //int zoom_factor_save = ZOOM_FACTOR[0];

  if (PRINT_MOUSEFUNC_Wheel || PRINT_MOUSEKEYFUNC_DBG_ALL) println("Mouse wheeled!\n\t count=" + wheel_count);

  //if (!mouse_wheel_enabled) return;

  UI_Buttons_mouse_wheel(wheel_count);

// Disable mouse x y changing by wheel zoom feature.
/*
  // Check zoom factor changed.
  if (zoom_factor_save != ZOOM_FACTOR[0])
  {
    final int const_x_base = (ROTATE_FACTOR[0] == 135)?(SCREEN_width + DRAW_OFFSET_X[0] - mouseX):(mouseX - DRAW_OFFSET_X[0]);
    final int const_y_base = (ROTATE_FACTOR[0] == 225)?(SCREEN_height + DRAW_OFFSET_Y[0] - mouseY):(mouseY - DRAW_OFFSET_Y[0]);
    final int const_x_offset = (ROTATE_FACTOR[0] == 315 || ROTATE_FACTOR[0] == 135)?(TEXT_MARGIN + FONT_HEIGHT / 2):(SCREEN_width / 2);
    final int const_y_offset = (ROTATE_FACTOR[0] == 45 || ROTATE_FACTOR[0] == 225)?(TEXT_MARGIN + FONT_HEIGHT / 2):(SCREEN_height / 2);
    final float const_x_ratio = (ROTATE_FACTOR[0] == 135)?(float(zoom_factor_save) / float(ZOOM_FACTOR[0]) - 1.0):(1.0 - float(zoom_factor_save) / float(ZOOM_FACTOR[0]));
    final float const_y_ratio = (ROTATE_FACTOR[0] == 225)?(float(zoom_factor_save) / float(ZOOM_FACTOR[0]) - 1.0):(1.0 - float(zoom_factor_save) / float(ZOOM_FACTOR[0]));

    //println("old ZOOM_FACTOR[0]=" + zoom_factor_save + ", new ZOOM_FACTOR[0]=" + ZOOM_FACTOR[0]);
    //println("SCREEN_width - mouseX=" + (SCREEN_width - mouseX) + ", mouseY=" + mouseY);
    //println("DRAW_OFFSET_X[0]=" + DRAW_OFFSET_X[0] + ", DRAW_OFFSET_Y[0]=" + DRAW_OFFSET_Y[0]);
    //println("(SCREEN_height - mouseY - DRAW_OFFSET_Y[0]) * const_ratio=" + ((SCREEN_height - mouseY - DRAW_OFFSET_Y[0]) * const_ratio));
    //println("(SCREEN_height - mouseY - DRAW_OFFSET_Y[0])=" + ((SCREEN_height - mouseY - DRAW_OFFSET_Y[0])));

    DRAW_OFFSET_X[0] += int((const_x_base - const_x_offset) * const_x_ratio);
    DRAW_OFFSET_Y[0] += int((const_y_base - const_y_offset) * const_y_ratio);

    Screen_update_variable();
  }
*/
}

boolean mouse_is_over(int r_x, int r_y, int r_width, int r_height)
{
  if( mouseX >= r_x && mouseX <= r_x+r_width
      && 
      mouseY >= r_y && mouseY <= r_y+r_height
    )
  {
    return true;
  }
  else
  {
    return false;
  }
}
