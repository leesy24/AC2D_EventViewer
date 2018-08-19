void Grid_update_rotate_225(int instance)
{
  final int const_screen_x_start = TEXT_MARGIN;
  final int const_screen_x_end = SCREEN_width - TEXT_MARGIN;
  final int const_screen_y_start = TEXT_MARGIN + FONT_HEIGHT;
  final int const_screen_y_end = SCREEN_height - TEXT_MARGIN;
  final int const_font_height_d_2 = FONT_HEIGHT / 2;
  //final float const_zoom_factor_d_100 = ZOOM_FACTOR[instance] / 100.0;
  final int const_grid_offset_x = ((SCREEN_width % 100) / 2) + (DRAW_OFFSET_X[instance] % 100) + (((SCREEN_width / 100) % 2 == 0)?0:50);
  final int const_grid_offset_y = const_screen_y_end - const_font_height_d_2 + (DRAW_OFFSET_Y[instance] % 100);
  final int const_str_offset_ix = SCREEN_width / 100 / 2 * 100 + DRAW_OFFSET_X[instance] / 100 * 100;
  final int const_str_offset_iy = DRAW_OFFSET_Y[instance] / 100 * 100;
  //final int const_str_base_ix_y = const_screen_y_end + DRAW_OFFSET_Y[instance];
  final int const_str_base_ix_y =
    (DRAW_OFFSET_Y[instance] < const_screen_y_start - const_screen_y_end)
    ?
    const_screen_y_start
    :
    ((DRAW_OFFSET_Y[instance] > 0)
      ?
      const_screen_y_end
      :
      (const_screen_y_end + DRAW_OFFSET_Y[instance])
    );
  final int const_str_base_iy_x = (SCREEN_width / 2) + DRAW_OFFSET_X[instance];
  int x, y;
  int ix, iy;
  int x_zero, y_zero;
  String string;
  float distance = 0.0;

  if (MIRROR_ENABLE[instance])
    x_zero = 0;
  else
    x_zero = SCREEN_width;
  for (ix = -100; ix <= SCREEN_width + 100; ix += 100) {
    if (MIRROR_ENABLE[instance])
      //distance = const_zoom_factor_d_100 * float(ix - const_str_offset_ix) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (ix - const_str_offset_ix)) / 100.0 / 100.0;
    else
      //distance = const_zoom_factor_d_100 * float(const_str_offset_ix - ix) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (const_str_offset_ix - ix)) / 100.0 / 100.0;
    //println("ix="+ix+":d="+distance);
    if (distance == 0.0) {
      x_zero = ix + const_grid_offset_x;
      break;
    }
  }
  //println("ix="+ix+":d="+distance);
  if (ix > SCREEN_width + 100 && distance < 0.0)
    if (MIRROR_ENABLE[instance])
      x_zero = SCREEN_width;
    else
      x_zero = 0;
  //println("x_zero="+x_zero);

  y_zero = SCREEN_height;
  for (iy = 0; iy <= SCREEN_height + 100; iy += 100) {
    //distance = const_zoom_factor_d_100 * float(iy + const_str_offset_iy) / 100.0;
    distance = (ZOOM_FACTOR[instance] * (iy + const_str_offset_iy)) / 100.0 / 100.0;
    if (distance >= 0.0) {
      y_zero = const_grid_offset_y - iy;
      break;
    }
  }
  //println("iy="+iy+":d="+distance);
  if (iy > SCREEN_height + 100 && distance < 0.0)
    y_zero = 0;
  //println("y_zero="+y_zero);

  Grid_scr_y_min[instance] = min(Grid_scr_y_min[instance], 0);
  Grid_scr_y_max[instance] = max(Grid_scr_y_max[instance], y_zero);
  for (ix = -100; ix <= SCREEN_width + 100; ix += 100) {
    if (MIRROR_ENABLE[instance])
      //distance = const_zoom_factor_d_100 * float(ix - const_str_offset_ix) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (ix - const_str_offset_ix)) / 100.0 / 100.0;
    else
      //distance = const_zoom_factor_d_100 * float(const_str_offset_ix - ix) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (const_str_offset_ix - ix)) / 100.0 / 100.0;
    x = ix + const_grid_offset_x;
    if (distance >= 0.0 && x >= 0 && x <= SCREEN_width) {
      Grid_Lines_array[instance].add(new Grid_Line_Data(x, 0, x, y_zero));
      //println("ix="+ix+":offset_x="+const_grid_offset_x+",x="+(ix + const_grid_offset_x));
      //println("ix="+ix+":x="+x);
      Grid_scr_x_min[instance] = min(Grid_scr_x_min[instance], x);
      Grid_scr_x_max[instance] = max(Grid_scr_x_max[instance], x);
    }
  }

  if (MIRROR_ENABLE[instance])
  {
    Grid_scr_x_min[instance] = min(Grid_scr_x_min[instance], x_zero);
    Grid_scr_x_max[instance] = max(Grid_scr_x_max[instance], SCREEN_width);
  }
  else
  {
    Grid_scr_x_min[instance] = min(Grid_scr_x_min[instance], 0);
    Grid_scr_x_max[instance] = max(Grid_scr_x_max[instance], x_zero);
  }
  for (iy = 0; iy <= SCREEN_height + 100; iy += 100) {
    //distance = const_zoom_factor_d_100 * float(iy + const_str_offset_iy) / 100.0;
    distance = (ZOOM_FACTOR[instance] * (iy + const_str_offset_iy)) / 100.0 / 100.0;
    y = const_grid_offset_y - iy;
    if (distance >= 0.0 && y >= 0 && y <= SCREEN_height) {
      if (MIRROR_ENABLE[instance]) {
        Grid_Lines_array[instance].add(new Grid_Line_Data(x_zero, y, SCREEN_width, y));
      }
      else {
        Grid_Lines_array[instance].add(new Grid_Line_Data(0, y, x_zero, y));
      }
      //println("iy="+iy+":offset_y="+const_grid_offset_y+",y="+(const_grid_offset_y - iy));
      //println("iy="+iy+":y="+y);
      Grid_scr_y_min[instance] = min(Grid_scr_y_min[instance], y);
      Grid_scr_y_max[instance] = max(Grid_scr_y_max[instance], y);
    }
  }

  textSize(FONT_HEIGHT);

  y = const_str_base_ix_y;
  //if (y < const_screen_y_start) y = const_screen_y_start;
  //if (y > const_screen_y_end) y = const_screen_y_end;
  for (ix = -100; ix <= SCREEN_width + 100; ix += 100) {
    if (MIRROR_ENABLE[instance])
      //distance = const_zoom_factor_d_100 * float(ix - const_str_offset_ix) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (ix - const_str_offset_ix)) / 100.0 / 100.0;
    else
      //distance = const_zoom_factor_d_100 * float(const_str_offset_ix - ix) / 100.0;
      distance = (ZOOM_FACTOR[instance] * (const_str_offset_ix - ix)) / 100.0 / 100.0;
    if (distance >= 0.0) {
      string = distance + "m";
      x = ix + const_grid_offset_x;
      if(distance == 0.0)
        Grid_zero_x[instance] = x;
      x = x - int(textWidth(string) / 2.0);
      if (x > 0 && x < SCREEN_width
          &&
          y > 0 && y < SCREEN_height)
        Grid_Texts_array[instance].add(new Grid_Text_Data(string, x, y));
      //println("iy=" + iy + ":x=" + x + ",y=" + y + "," + string);
    }
  }

  for (iy = 0; iy <= SCREEN_height + 100; iy += 100) {
    //distance = const_zoom_factor_d_100 * float(iy + const_str_offset_iy) / 100.0;
    distance = (ZOOM_FACTOR[instance] * (iy + const_str_offset_iy)) / 100.0 / 100.0;
    if (distance >= 0.0) {
      string = distance + "m";
      x = const_str_base_iy_x - int(textWidth(string)/2);
      if (x < const_screen_x_start)
        x = const_screen_x_start;
      if (x > const_screen_x_end - int(textWidth(string)))
        x = const_screen_x_end - int(textWidth(string));
      y = const_grid_offset_y - iy;
      if(distance == 0.0)
        Grid_zero_y[instance] = y;
      y = y + const_font_height_d_2;
      if (x > 0 && x < SCREEN_width
          &&
          y > 0 && y < SCREEN_height)
        Grid_Texts_array[instance].add(new Grid_Text_Data(string, x, y));
      //println("ix=" + ix + ":x=" + x + ",y=" + y + "," + string);
    }
  }
}
