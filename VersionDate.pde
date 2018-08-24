//static color C_VERSION_DATE_TEXT = 0xFFFFFFFF; // Black
static color C_VERSION_DATE_TEXT = 0xFF000000; // White

final static String VERSION_DATE_VERSION_STR = "1.00.16";
final static String VERSION_DATE_DATE_STR = "2018-08-24";

static String VERSION_DATE_VERSION_STR_live;
static int VERSION_DATE_VERSION_x;
static int VERSION_DATE_DATE_x;

void Version_Date_setup()
{
  println("Version for:" + VERSION_DATE_VERSION_STR + " Date:" + VERSION_DATE_DATE_STR);
  SYSTEM_logger.info("");
  SYSTEM_logger.info("Version for:" + VERSION_DATE_VERSION_STR + " Date:" + VERSION_DATE_DATE_STR);

  textSize(FONT_HEIGHT);
  VERSION_DATE_VERSION_STR_live = "Ver. for " + VERSION_DATE_VERSION_STR;
  VERSION_DATE_VERSION_x = int(SCREEN_width - TEXT_MARGIN - textWidth(VERSION_DATE_VERSION_STR_live));
  VERSION_DATE_DATE_x = int(SCREEN_width - TEXT_MARGIN - textWidth(VERSION_DATE_DATE_STR));
}

void Version_Date_draw()
{
  // Sets the color used to draw text and borders around shapes.
  fill(C_VERSION_DATE_TEXT);
  stroke(C_VERSION_DATE_TEXT);
  textSize(FONT_HEIGHT);
  textAlign(LEFT, TOP);

  text(
  	TITLE_COMPANY,
  	TEXT_MARGIN,
  	TEXT_MARGIN);
  text(
  	VERSION_DATE_VERSION_STR_live,
  	VERSION_DATE_VERSION_x,
  	TEXT_MARGIN);
  text(
  	VERSION_DATE_DATE_STR,
  	VERSION_DATE_DATE_x,
  	TEXT_MARGIN + FONT_HEIGHT + TEXT_MARGIN);

}