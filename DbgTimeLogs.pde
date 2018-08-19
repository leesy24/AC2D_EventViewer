Dbg_Time_logs Dbg_Time_logs_handle = new Dbg_Time_logs();

class Dbg_Time_logs {
  private ArrayList<Dbg_Time_log> time_logs = new ArrayList<Dbg_Time_log>();
  private String str;
  private int start_millis;
  private int start_millis_diff;
  private int limit_millis;
  private int last_millis_diff;
  private int add_millis_diff;
  private boolean stop;
  private boolean stop_print;

  Dbg_Time_logs() {}

  void start(String str, int limit_millis, boolean stop) {
    this.str = str;
    this.limit_millis = limit_millis;
    this.stop = stop;

    this.time_logs.clear();
    this.start_millis = millis();
    this.last_millis_diff = 0;
    this.stop_print = false;
  }

  int get_start_millis_diff() {
    return start_millis_diff;
  }

  int get_add_millis_diff() {
    return add_millis_diff;
  }

  void add(String str) {
    start_millis_diff = get_millis_diff(start_millis);
    add_millis_diff = start_millis_diff - last_millis_diff;
    time_logs.add(new Dbg_Time_log(start_millis_diff, add_millis_diff, str));
    last_millis_diff = start_millis_diff;
    if (start_millis_diff > limit_millis) {
      if (!stop_print) print();
      if (stop) stop_print = true;
    }
  }

  void print() {
    println(str);
    SYSTEM_logger.warning(str);  
    for (Dbg_Time_log time_log:time_logs) {
      println("\t"+time_log.str+":"+time_log.time+","+time_log.start_millis_diff);
      SYSTEM_logger.warning("\t"+time_log.str+":"+time_log.time+","+time_log.start_millis_diff);  
    }
  }
}

class Dbg_Time_log {
  int time, start_millis_diff;
  String str;
  Dbg_Time_log(int time, int start_millis_diff, String str) {
    this.time = time;
    this.start_millis_diff = start_millis_diff;
    this.str = str;
  }
}
