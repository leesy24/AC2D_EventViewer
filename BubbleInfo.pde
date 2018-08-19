static boolean Bubble_Info_enabled = false;
//final static boolean Bubble_Info_enabled = true;

static color C_BUBBLE_INFO_RECT_FILL = 0xC0F8F8F8; // White - 0x8 w/ Opaque 75%
static color C_BUBBLE_INFO_RECT_STROKE = #000000; // Black
static color C_BUBBLE_INFO_TEXT = #000000; // Black

final int BUBBLE_INFO_TIMEOUT = 2000; // 2 seconds

boolean BUBBLE_INFO_AVAILABLE = false;
boolean BUBBLE_INFO_DISPLAY = false;
int BUBBLE_INFO_POINT;
float BUBBLE_INFO_DISTANCE;
float BUBBLE_INFO_COR_X;
float BUBBLE_INFO_COR_Y;
float BUBBLE_INFO_ANGLE;
int BUBBLE_INFO_PULSE_WIDTH;
int BUBBLE_INFO_TIMER = -BUBBLE_INFO_TIMEOUT;
int BUBBLE_INFO_BOX_X, BUBBLE_INFO_BOX_Y;
final static int BUBBLE_INFO_POINT_WH = 10;

void Bubble_Info_draw()
{
  if (!Bubble_Info_enabled) return;

  ArrayList<String> strings = new ArrayList<String>();
  int x, y, w, h, tl = 5, tr = 5, br = 0, bl = 5;

  if (BUBBLE_INFO_AVAILABLE || get_millis_diff(BUBBLE_INFO_TIMER) < BUBBLE_INFO_TIMEOUT)
  {

    BUBBLE_INFO_DISPLAY = true;
    if (BUBBLE_INFO_AVAILABLE)
    {
      BUBBLE_INFO_TIMER = millis();
      BUBBLE_INFO_AVAILABLE = false;
      //BUBBLE_INFO_BOX_X = mouseX;
      //BUBBLE_INFO_BOX_Y = mouseY;
    }

    strings.add("Point:" + BUBBLE_INFO_POINT);
    strings.add("Angle:" + BUBBLE_INFO_ANGLE + "°");
    strings.add("Distance:" + BUBBLE_INFO_DISTANCE + "m");
    strings.add("Coord. X:" + BUBBLE_INFO_COR_X + "m");
    strings.add("Coord. Y:" + BUBBLE_INFO_COR_Y + "m");
    strings.add("Pulse width:" + BUBBLE_INFO_PULSE_WIDTH);

    // Get max string width
    textSize(FONT_HEIGHT);
    w = 0;
    for (String string:strings)
    {
      w = max(w, int(textWidth(string)));
    }
    w += TEXT_MARGIN + TEXT_MARGIN;

    h = TEXT_MARGIN + FONT_HEIGHT * strings.size() + TEXT_MARGIN;
    x = BUBBLE_INFO_BOX_X - BUBBLE_INFO_POINT_WH/2 - w;
    y = BUBBLE_INFO_BOX_Y - BUBBLE_INFO_POINT_WH/2 - h;
    if(x < 0 && y < 0) {
      br = 5;
      tl = 0;
      x = BUBBLE_INFO_BOX_X + BUBBLE_INFO_POINT_WH/2;
      y = BUBBLE_INFO_BOX_Y + BUBBLE_INFO_POINT_WH/2;
    }
    else if(x < 0) {
      br = 5;
      bl = 0;
      x = BUBBLE_INFO_BOX_X + BUBBLE_INFO_POINT_WH/2;
    }
    else if(y < 0) {
      br = 5;
      tr = 0;
      y = BUBBLE_INFO_BOX_Y + BUBBLE_INFO_POINT_WH/2;
    }
    
    // Sets the color used to draw box and borders around shapes.
    fill(C_BUBBLE_INFO_RECT_FILL);
    stroke(C_BUBBLE_INFO_RECT_STROKE);
    strokeWeight(1);
    rect(x, y, w, h, tl, tr, br, bl);
    // Sets the color used to draw text and borders around shapes.
    fill(C_BUBBLE_INFO_TEXT);
    stroke(C_BUBBLE_INFO_TEXT);
    textAlign(LEFT, BASELINE);
    int i = 0;
    x += TEXT_MARGIN;
    y +=  TEXT_MARGIN + FONT_HEIGHT - 1;
    for (String string:strings)
    {
      text(string, x, y + FONT_HEIGHT * i);
      i ++;
    }
  }
  else
  {
    BUBBLE_INFO_DISPLAY = false;
  }
}