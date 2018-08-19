class Points_Data {
  public int length;
  public int mi_x[], mi_y[];
  public int w[];
  public color c[];
  public int scr_x[], scr_y[];
  
  Points_Data (int n) {
    length = n;
    mi_x = new int[n];
    mi_y = new int[n];
    w = new int[n];
    c = new color[n];
    scr_x = new int[n];
    scr_y = new int[n];
  }

  void set_point_mi(int index, int mi_x, int mi_y, color c, int w) {
    if (index < 0 || index > this.length) return;
    this.mi_x[index] = mi_x;
    this.mi_y[index] = mi_y;
    this.c[index] = c;
    this.w[index] = w;
  }

  void set_point_scr(int index, int scr_x, int scr_y) {
    if (index < 0 || index > this.length) return;
    this.scr_x[index] = scr_x;
    this.scr_y[index] = scr_y;
  }

}
