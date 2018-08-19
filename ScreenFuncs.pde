//final static boolean PRINT_SCREENFUNC_ALL_DBG = true;
final static boolean PRINT_SCREENFUNC_ALL_DBG = false;

//final static boolean PRINT_SCREENFUNC_SETTINGS_DBG = true;
final static boolean PRINT_SCREENFUNC_SETTINGS_DBG = false;

//final static boolean PRINT_SCREENFUNC_SETUP_DBG = true;
final static boolean PRINT_SCREENFUNC_SETUP_DBG = false;

// Define minimum screen width and height.
final static int MIN_SCREEN_WIDTH = 100;
final static int MIN_SCREEN_HEIGHT = 100;

static int SCREEN_BORDER_WIDTH = 4; //8;
static int SCREEN_TITLE_HEIGHT = 27; //31;

static int SCREEN_X_OFFSET = 1; //3;
static int SCREEN_Y_OFFSET = 1; //5;


// Define default screen x, y, width and height.
static int SCREEN_x = 0;
static int SCREEN_y = 0;
//static int SCREEN_width = 1920;
//static int SCREEN_height = 1080;
//static int SCREEN_width = 1024;
//static int SCREEN_height = 768;
static int SCREEN_width = 1024;
static int SCREEN_height = 600;
//static int SCREEN_width = 640;
//static int SCREEN_height = 480;

//static float SCREEN_x_ratio = 0.0;
//static float SCREEN_y_ratio = 0.0;
//static float SCREEN_width_ratio = 0.5;
//static float SCREEN_height_ratio = 0.5;

// Define zoom factor variables.
int[] ZOOM_FACTOR = new int[PS_INSTANCE_MAX];

// Define rotate factor variables.
float[] ROTATE_FACTOR = new float[PS_INSTANCE_MAX];

// Define mirror variables.
boolean[] MIRROR_ENABLE = new boolean[PS_INSTANCE_MAX];

// Define offset of screen to draw.
int[] SCREEN_OFFSET_X = new int[PS_INSTANCE_MAX];
int[] SCREEN_OFFSET_Y = new int[PS_INSTANCE_MAX];

// Define offset of misc. draw.
int[] DRAW_OFFSET_X = new int[PS_INSTANCE_MAX];
int[] DRAW_OFFSET_Y = new int[PS_INSTANCE_MAX];

// Define just font height variables.
int FONT_HEIGHT;

// Define just text area margin variables.
int TEXT_MARGIN;
PFont SCREEN_PFront;

void Screen_settings() {
// This is for automatic screen locating with ratio.
/*
  //println("getContentPane()=", getJFrame(surface).getContentPane());
  // Defines the dimension of the display window width and height in units of pixels.
  SCREEN_x = int(displayWidth * SCREEN_x_ratio) + SCREEN_X_OFFSET;
  //if(SCREEN_x >= SCREEN_BORDER_WIDTH) SCREEN_x += SCREEN_BORDER_WIDTH;
  SCREEN_y = int(displayHeight * SCREEN_y_ratio) + SCREEN_Y_OFFSET;
  //if(SCREEN_y >= SCREEN_TITLE_HEIGHT)  SCREEN_y += SCREEN_TITLE_HEIGHT/2;
  SCREEN_width = int(displayWidth * SCREEN_width_ratio) - SCREEN_BORDER_WIDTH * 2;
  SCREEN_height = int(displayHeight * SCREEN_height_ratio) - (SCREEN_TITLE_HEIGHT + SCREEN_BORDER_WIDTH);
*/
  if(PRINT_SCREENFUNC_ALL_DBG || PRINT_SCREENFUNC_SETTINGS_DBG) println("Screen_settings():Enter");
  if(PRINT_SCREENFUNC_ALL_DBG || PRINT_SCREENFUNC_SETTINGS_DBG) println("Screen_settings():displayWidth="+displayWidth+",displayHeight="+displayHeight);
  if(PRINT_SCREENFUNC_ALL_DBG || PRINT_SCREENFUNC_SETTINGS_DBG) println("Screen_settings():SCREEN_x="+SCREEN_x+",SCREEN_y="+SCREEN_y+",SCREEN_width="+SCREEN_width+",SCREEN_height="+SCREEN_height);

  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    ROTATE_FACTOR[i] = -1;
    SCREEN_OFFSET_X[i] = 0;
    SCREEN_OFFSET_Y[i] = 0;
  }

  size(SCREEN_width, SCREEN_height);
}

/*
boolean SCREEN_surface_set = false; // Needs to set one time.
*/
void Screen_setup()
{
  if(PRINT_SCREENFUNC_ALL_DBG || PRINT_SCREENFUNC_SETUP_DBG) println("Screen_setup():Enter");

/*
  if(!SCREEN_surface_set)
  {
    // This is only pertains to the desktop version of Processing (not JavaScript or Android),
    //  because it's the only one to use windows and frames.
    // It's possible to make the window resizable.
    surface.setResizable(true);
    surface.setLocation(SCREEN_x, SCREEN_y);
    SCREEN_surface_set = true;
  }
*/

  Screen_update_offsets();

  // Set text margin to follow min(Width, Height) of screen.
  TEXT_MARGIN = (SCREEN_width < SCREEN_height) ? ((SCREEN_width / 200) + 1) / 2 * 2 : ((SCREEN_height / 200) + 1) / 2 * 2;
  if (PRINT_SCREENFUNC_ALL_DBG) println("Screen_setup():TEXT_MARGIN=" + TEXT_MARGIN);
  //println("Screen_setup():TEXT_MARGIN=" + TEXT_MARGIN);

  // Set font height of text to follow min(Width, Height) of screen.
  FONT_HEIGHT = (SCREEN_width < SCREEN_height) ? ((SCREEN_width / 30) + 1) / 2 * 2 : ((SCREEN_height / 30) + 1) / 2 * 2;
  if (FONT_HEIGHT > 16) FONT_HEIGHT = 16;
  if (FONT_HEIGHT < 10) FONT_HEIGHT = 10;
  if (PRINT_SCREENFUNC_ALL_DBG) println("Screen_setup():FONT_HEIGHT=" + FONT_HEIGHT);
  //println("Screen_setup():FONT_HEIGHT=" + FONT_HEIGHT);
  textSize(FONT_HEIGHT);
}

void Screen_update_offsets()
{
  for(int i = 0; i < PS_INSTANCE_MAX; i ++)
  {
    if (ROTATE_FACTOR[i] == 315)
    {
      if (MIRROR_ENABLE[i])
      {
        DRAW_OFFSET_X[i] = SCREEN_OFFSET_X[i] + 544;
        DRAW_OFFSET_Y[i] = SCREEN_OFFSET_Y[i] - 250;
      }
      else
      {
        DRAW_OFFSET_X[i] = SCREEN_OFFSET_X[i] + 544;
        DRAW_OFFSET_Y[i] = SCREEN_OFFSET_Y[i] + 250;
      }
    }
    else if (ROTATE_FACTOR[i] == 45)
    {
      if (MIRROR_ENABLE[i])
      {
        DRAW_OFFSET_X[i] = SCREEN_OFFSET_X[i] - 44;
        DRAW_OFFSET_Y[i] = SCREEN_OFFSET_Y[i] + 38;
      }
      else
      {
        DRAW_OFFSET_X[i] = SCREEN_OFFSET_X[i] + 44;
        DRAW_OFFSET_Y[i] = SCREEN_OFFSET_Y[i] + 38;
      }
    }
    else if (ROTATE_FACTOR[i] == 135)
    {
      if (MIRROR_ENABLE[i])
      {
        DRAW_OFFSET_X[i] = SCREEN_OFFSET_X[i] - 544;
        DRAW_OFFSET_Y[i] = SCREEN_OFFSET_Y[i] + 250;
      }
      else
      {
        DRAW_OFFSET_X[i] = SCREEN_OFFSET_X[i] - 544;
        DRAW_OFFSET_Y[i] = SCREEN_OFFSET_Y[i] - 250;
      }
    }
    else /*if (ROTATE_FACTOR[i] == 225)*/
    {
      if (MIRROR_ENABLE[i])
      {
        DRAW_OFFSET_X[i] = SCREEN_OFFSET_X[i] + 44;
        DRAW_OFFSET_Y[i] = SCREEN_OFFSET_Y[i] - 38;
      }
      else
      {
        DRAW_OFFSET_X[i] = SCREEN_OFFSET_X[i] - 44;
        DRAW_OFFSET_Y[i] = SCREEN_OFFSET_Y[i] - 38;
      }
    }
  }
}

/*
static final javax.swing.JFrame getJFrame(final PSurface surf) {
  return
    (javax.swing.JFrame)
    ((processing.awt.PSurfaceAWT.SmoothCanvas)
    surf.getNative()).getFrame();
}
*/

boolean Screen_check_update()
{
  if(PRINT_SCREENFUNC_ALL_DBG) println("Screen_check_update():");

  boolean updated = false;

  //println("frameRate = " + frameRate);
/*
  javax.swing.JFrame f;
  
  f = getJFrame(surface);
  //f.pack();
  // This is not the actual-sized frame. get the actual size
  //Dimension actualSize = getJFrame(getSurface()).getContentPane().getSize();
  Dimension actualSize = f.getContentPane().getSize();
  //Dimension actualSize = frame.getContentPane().getSize();
  
  //println("border=" + SCREEN_width, actualSize.width + "," + SCREEN_height, actualSize.height);
*/
/*
  int new_x = 0, new_y = 0;
  new_x = getJFrame(surface).getX();
  new_y = getJFrame(surface).getY();
  //new_x = getJFrame(getSurface()).getX();
  //new_y = getJFrame(getSurface()).getY();
  //new_x = surface.getLocation();
  //new_y = surface.getLocation();
  //new_x = frame.getX();
  //new_y = frame.getY();
  //new_x = surface.getNative().getFrame().getX();
  //new_y = surface.getLocationOnScreen().y;
  //if(PRINT_SCREENFUNC_ALL_DBG) println("screen pos xy saved(" + SCREEN_x + ",y=" + SCREEN_y + ") new(" + new_x + ",y=" + new_y + ")");
  if(PRINT_SCREENFUNC_ALL_DBG) println("display wh(" + displayWidth + ",y=" + displayHeight + ")");
  // Check screen position x or y changed.
  if(new_x != SCREEN_x || new_y != SCREEN_y) {
    if(new_x < 0 || new_y < 0) {
      if(new_x < 0) new_x = 0;
      if(new_y < 0) new_y = 0;
      surface.setLocation(new_x, new_y);
    }
    SCREEN_x = new_x;
    SCREEN_y = new_y;

    updated = true;
  }
*/

  int new_width, new_height;
  if(PRINT_SCREENFUNC_ALL_DBG) println("Screen_check_update():screen size width=" + width + ", height=" + height);
  // Check screen size changed.
  if (SCREEN_width != width || SCREEN_height != height) {
    new_width = width;
    new_height = height;
    if (PRINT_SCREENFUNC_ALL_DBG) println("Screen_check_update():screen size changed! width " + SCREEN_width + "->" + new_width + ", height " + SCREEN_height + "->" + new_height);

    // Check screen size too small.
    if (new_width < MIN_SCREEN_WIDTH || new_height < MIN_SCREEN_HEIGHT) {
      if (PRINT_SCREENFUNC_ALL_DBG) println("Screen_check_update():screen size changed too small! width " + new_width + ", height " + new_height);
      
      if (new_width < MIN_SCREEN_WIDTH && new_height < MIN_SCREEN_HEIGHT) {
        new_width = MIN_SCREEN_WIDTH;
        new_height = MIN_SCREEN_HEIGHT;
      }
      else if (new_width < MIN_SCREEN_WIDTH) {
        new_width = MIN_SCREEN_WIDTH;
      }
      else if (new_height < MIN_SCREEN_HEIGHT) {
        new_height = MIN_SCREEN_HEIGHT;
      }
      if(PRINT_SCREENFUNC_ALL_DBG) println("Screen_check_update():surface.setSize(new_width=" + new_width + ", new_height=" + new_height + ")");
      surface.setSize(new_width, new_height);
    }
  
    //println("old DRAW_OFFSET_X[0]=" + DRAW_OFFSET_X[0] + ", DRAW_OFFSET_Y[0]=" + DRAW_OFFSET_Y[0]);
    if (ROTATE_FACTOR[0] == 315)
    { // OK
      DRAW_OFFSET_X[0] = int(DRAW_OFFSET_X[0] - (float(SCREEN_width)  / 2.0) + (float(new_width)  / 2.0));
    }
    else if (ROTATE_FACTOR[0] == 45)
    { // OK
      DRAW_OFFSET_Y[0] = int(DRAW_OFFSET_Y[0] - (float(SCREEN_height) / 2.0) + (float(new_height) / 2.0));
    }
    else if (ROTATE_FACTOR[0] == 135)
    { // OK
      DRAW_OFFSET_X[0] = int(DRAW_OFFSET_X[0] + (float(SCREEN_width)  / 2.0) - (float(new_width)  / 2.0));
    }
    else //if (ROTATE_FACTOR[0] == 225)
    { // OK
      DRAW_OFFSET_Y[0] = int(DRAW_OFFSET_Y[0] + (float(SCREEN_height) / 2.0) - (float(new_height) / 2.0));
    }
    //println("new DRAW_OFFSET_X[0]=" + DRAW_OFFSET_X[0] + ", DRAW_OFFSET_Y[0]=" + DRAW_OFFSET_Y[0]);
    SCREEN_width = new_width;
    SCREEN_height = new_height;

    updated = true;
  }
/*
  if(updated) {
    //Screen_update_variable();
  }
*/

  if(PRINT_SCREENFUNC_ALL_DBG) println("Screen_check_update():return=" + updated);
  return updated;
}

void Screen_update_variable()
{
  if(PRINT_SCREENFUNC_ALL_DBG) println("Screen_update_variable():");
  //Screen_update_offsets();
  Grid_update();
  PS_Image_update();
  Regions_update();
  //Config_update();
}
