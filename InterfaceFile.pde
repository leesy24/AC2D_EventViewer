//final static boolean PRINT_INTERFACES_FILE_ALL_DBG = true;
final static boolean PRINT_INTERFACES_FILE_ALL_DBG = false;
final static boolean PRINT_INTERFACES_FILE_ALL_ERR = true;
//final static boolean PRINT_INTERFACES_FILE_ALL_ERR = false;

//final static boolean PRINT_INTERFACES_FILE_NAME_DBG = true; 
final static boolean PRINT_INTERFACES_FILE_NAME_DBG = false;

//final static boolean PRINT_INTERFACES_FILE_SETUP_DBG = true; 
final static boolean PRINT_INTERFACES_FILE_SETUP_DBG = false;
//final static boolean PRINT_INTERFACES_FILE_SETUP_ERR = true; 
final static boolean PRINT_INTERFACES_FILE_SETUP_ERR = false;

//final static boolean PRINT_INTERFACES_FILE_RESET_DBG = true; 
final static boolean PRINT_INTERFACES_FILE_RESET_DBG = false;
//final static boolean PRINT_INTERFACES_FILE_RESET_ERR = true; 
final static boolean PRINT_INTERFACES_FILE_RESET_ERR = false;

//final static boolean PRINT_INTERFACES_FILE_OPEN_DBG = true; 
final static boolean PRINT_INTERFACES_FILE_OPEN_DBG = false;
//final static boolean PRINT_INTERFACES_FILE_OPEN_ERR = true; 
final static boolean PRINT_INTERFACES_FILE_OPEN_ERR = false;

//final static boolean PRINT_INTERFACES_FILE_CLOSE_DBG = true; 
final static boolean PRINT_INTERFACES_FILE_CLOSE_DBG = false;
//final static boolean PRINT_INTERFACES_FILE_CLOSE_ERR = true; 
final static boolean PRINT_INTERFACES_FILE_CLOSE_ERR = false;

//final static boolean PRINT_INTERFACES_FILE_LOAD_DBG = true; 
final static boolean PRINT_INTERFACES_FILE_LOAD_DBG = false;
//final static boolean PRINT_INTERFACES_FILE_LOAD_ERR = true; 
final static boolean PRINT_INTERFACES_FILE_LOAD_ERR = false;

//final static boolean PRINT_INTERFACES_FILE_GET_DBG = true; 
final static boolean PRINT_INTERFACES_FILE_GET_DBG = false;
//final static boolean PRINT_INTERFACES_FILE_GET_ERR = true; 
final static boolean PRINT_INTERFACES_FILE_GET_ERR = false;

static Interfaces_File Interfaces_File_handle = null;

void Interfaces_File_setup()
{
  if(PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_SETUP_DBG) println("Interfaces_File_setup():Enter");

  if(Interfaces_File_handle != null)
  {
    if(PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_SETUP_DBG) println("Interfaces_File_setup():Interfaces_File_handle already setup.");
    return;
  }

/*
  //Title += "(" + UDP_remote_ip + ":" + UDP_remote_port;
  Title += ":" + local_port;
  Title += ")";
*/

  if (Interfaces_File_handle != null)
  {
    for (int i = 0; i < PS_INSTANCE_MAX; i ++)
    {
      Interfaces_File_handle.close(i);
    }
    Interfaces_File_handle = null;
  }

  Interfaces_File_handle = new Interfaces_File();
  if(Interfaces_File_handle == null)
  {
    if(PRINT_INTERFACES_FILE_SETUP_ERR) println("Interfaces_File_setup():Interfaces_File_handle=null");
    return;
  }
}

void Interfaces_File_reset()
{
  if(PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_RESET_DBG) println("Interfaces_File_reset():");

  if(Interfaces_File_handle == null)
  {
    if(PRINT_INTERFACES_FILE_RESET_ERR) println("Interfaces_File_reset():Interfaces_File_handle already reset.");
    return;
  }
  Interfaces_File_handle = null;
}

class Interfaces_File {
  String[] str_err_last = new String[PS_INSTANCE_MAX];
  boolean[] instance_opened = new boolean[PS_INSTANCE_MAX];
  String[][] file_name_list = new String[PS_INSTANCE_MAX][];
  int[] file_name_index = new int[PS_INSTANCE_MAX];
  String[] dir_name = new String[PS_INSTANCE_MAX];
  String[] load_file_name = new String[PS_INSTANCE_MAX];
  long[] file_time_stamp = new long[PS_INSTANCE_MAX];
  long[] base_time_stamp = new long[PS_INSTANCE_MAX];
  boolean[] reached_eofl = new boolean[PS_INSTANCE_MAX];
  int[] eofl_reset_count = new int[PS_INSTANCE_MAX];

  Interfaces_File()
  {
    // Init. handle_opened arrary.
    for (int i = 0; i < PS_INSTANCE_MAX; i++)
    {
      str_err_last[i] = null;
      instance_opened[i] = false;
      eofl_reset_count[i] = -1;
      reached_eofl[i] = false;
    }
  }

  public int open(int instance, String target_name)
  {
    if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_OPEN_DBG) println("Interfaces_File:open("+instance+"):target_name="+target_name);
    if (instance >= PS_INSTANCE_MAX)
    {
      if (PRINT_INTERFACES_FILE_ALL_ERR || PRINT_INTERFACES_FILE_OPEN_ERR) println("Interfaces_File:open("+instance+"):instance exceed MAX.");
      SYSTEM_logger.severe("Interfaces_File:open("+instance+"):instance exceed MAX.");
      return -1;
    }
    if (instance_opened[instance] != false)
    {
      if (PRINT_INTERFACES_FILE_ALL_ERR || PRINT_INTERFACES_FILE_OPEN_ERR) println("Interfaces_File:open("+instance+"):instance already opended.");
      SYSTEM_logger.severe("Interfaces_File:open("+instance+"):instance already opended.");
      return -1;
    }

    String target_full_name = sketchPath(target_name);
    if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_OPEN_DBG || PRINT_INTERFACES_FILE_NAME_DBG) println("Interfaces_File:open("+instance+")"+":target_name="+target_name);
    if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_OPEN_DBG || PRINT_INTERFACES_FILE_NAME_DBG) println("Interfaces_File:open("+instance+")"+":target_full_name="+target_full_name);
    // Check target name exists to avoid exception error on loadBytes().
    File target_handle = new File(target_full_name);

    if (target_handle.isDirectory()) {
      String[] target_files_list = target_handle.list();
      long file_time_stamp = -1;
      if (target_files_list != null && target_files_list.length > 0) {
        //println("target_files_list.length="+target_files_list.length);
        for (String target_file_name:target_files_list) {
          //println("target_file_name="+target_file_name);
          try {
            file_time_stamp = Long.parseLong(target_file_name.substring(2, target_file_name.length() - 4));
            break;
          }
          catch (NumberFormatException e) {
          }
        }
        this.file_time_stamp[instance] = file_time_stamp;
        this.base_time_stamp[instance] = file_time_stamp - millis();
        this.file_name_list[instance] = target_files_list;
        this.file_name_index[instance] = 0;
        this.dir_name[instance] = target_full_name;
        if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_OPEN_DBG) println("Interfaces_File:open("+instance+")"+":file_time_stamp="+this.file_time_stamp[instance]+",base_time_stamp="+this.base_time_stamp[instance]);
        //println("Interfaces_File:open("+instance+"):first file_time_stamp="+this.file_time_stamp[instance]+",base_time_stamp="+this.base_time_stamp[instance]);
      }
      else {
        this.file_time_stamp[instance] = -1;
        this.file_name_list[instance] = new String[1];
        this.file_name_list[instance][0] = target_name;
        this.file_name_index[instance] = 0;
        this.dir_name[instance] = target_full_name;
      }
    } // End of if (target_handle.isDirectory())
    else {
      this.file_time_stamp[instance] = -1;
      this.file_name_list[instance] = new String[1];
      this.file_name_list[instance][0] = target_name;
      this.file_name_index[instance] = 0;
      this.dir_name[instance] = sketchPath();
    }
    this.load_file_name[instance] = "";
    if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_OPEN_DBG || PRINT_INTERFACES_FILE_NAME_DBG) println("Interfaces_File:open("+instance+")"+":dir_name["+instance+"]="+dir_name[instance]);
    if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_OPEN_DBG || PRINT_INTERFACES_FILE_NAME_DBG) println("Interfaces_File:open("+instance+")"+":file_name_list["+instance+"][0]="+this.file_name_list[instance][0]);
    this.eofl_reset_count[instance] = -1;
    this.reached_eofl[instance] = false;

    this.instance_opened[instance] = true;

    return 0;
  }

  public int close(int instance)
  {
    if(PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_CLOSE_DBG) println("Interfaces_File:close("+instance+"):");
    if(instance >= PS_INSTANCE_MAX)
    {
      if (PRINT_INTERFACES_FILE_ALL_ERR || PRINT_INTERFACES_FILE_OPEN_ERR) println("Interfaces_File:close("+instance+"):instance exceed MAX.");
      SYSTEM_logger.severe("Interfaces_File:close("+instance+"):instance exceed MAX.");
      return -1;
    }
    if(instance_opened[instance] != true)
    {
      if (PRINT_INTERFACES_FILE_ALL_ERR || PRINT_INTERFACES_FILE_OPEN_ERR) println("Interfaces_File:close("+instance+"):instance already closed.");
      SYSTEM_logger.severe("Interfaces_File:close("+instance+"):instance already closed.");
      return -1;
    }

    file_name_list[instance] = null;
    instance_opened[instance] = false;
    return 0;
  }

  public String get_error(int instance)
  {
    if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_GET_DBG) println("Interfaces_File:get_error("+instance+"):str_err_last="+str_err_last[instance]);
    return str_err_last[instance];
  }

  public String get_file_name(int instance)
  {
    if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_GET_DBG) println("Interfaces_File:get_file_name("+instance+"):Enter");
    return load_file_name[instance];
  }

  public boolean load(int instance)
  {
    if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_LOAD_DBG) println("Interfaces_File:load("+instance+"):Enter");
    if(instance >= PS_INSTANCE_MAX)
    {
      if (PRINT_INTERFACES_FILE_ALL_ERR || PRINT_INTERFACES_FILE_OPEN_ERR) println("Interfaces_File:load("+instance+"):instance exceed MAX.");
      SYSTEM_logger.severe("Interfaces_File:close("+instance+"):instance exceed MAX.");
      return false;
    }
    if(instance_opened[instance] != true)
    {
      if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_LOAD_DBG) println("Interfaces_File:load("+instance+"):instance in closed.");
      return false;
    }

    if (file_time_stamp[instance] != -1
        &&
        file_time_stamp[instance] > base_time_stamp[instance] + millis())
      return false;
    if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_LOAD_DBG) println("Interfaces_File:load("+instance+"):file_time_stamp="+file_time_stamp[instance]+",base_time_stamp="+base_time_stamp[instance]);
    //println("Interfaces_File:load("+instance+"):current file_time_stamp="+file_time_stamp[instance]+",base_time_stamp="+base_time_stamp[instance]);

    if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_OPEN_DBG || PRINT_INTERFACES_FILE_NAME_DBG) println("Interfaces_File:load("+instance+")"+":dir_name["+instance+"]="+dir_name[instance]);
    if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_OPEN_DBG || PRINT_INTERFACES_FILE_NAME_DBG) println("Interfaces_File:load("+instance+")"+":file_name_list["+instance+"]["+file_name_index[instance]+"]="+file_name_list[instance][file_name_index[instance]]);

    String file_full_name;
    if (OS_is_Windows)
    {
      file_full_name = dir_name[instance]+"\\"+file_name_list[instance][file_name_index[instance]];
    }
    else
    {
      file_full_name = dir_name[instance]+"/"+file_name_list[instance][file_name_index[instance]];
    }
    if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_OPEN_DBG || PRINT_INTERFACES_FILE_NAME_DBG) println("Interfaces_File:load("+instance+")"+":file_full_name="+file_full_name);

    // Check file name exists to avoid exception error on loadBytes().
    File file_handle = new File(file_full_name);
    if (!file_handle.isFile()) {
      str_err_last[instance] = "Error: File not exist or Not a file! " + file_name_list[instance][file_name_index[instance]];
      if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_LOAD_DBG) println("Interfaces_File:load("+instance+")"+":"+str_err_last[instance]);
      return false;
    } // End of load()

    // Load binary buf.
    PS_Data_buf[instance] = loadBytes(file_full_name);
    if (PS_Data_buf[instance] == null) {
      str_err_last[instance] = "Error: loadBytes() return null! " + file_name_list[instance][file_name_index[instance]];
      if (PRINT_INTERFACES_FILE_ALL_ERR || PRINT_INTERFACES_FILE_LOAD_ERR) println("Interfaces_File:load("+instance+")"+":"+str_err_last[instance]);
      SYSTEM_logger.severe("Interfaces_File:load("+instance+")"+":"+str_err_last[instance]);
      return false;
    }
    load_file_name[instance] = file_name_list[instance][file_name_index[instance]];
    if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_LOAD_DBG) println("buf.length = " + PS_Data_buf[instance].length);
    // Check binary buf length is valid.
    // Must larger than Function code(4B) + Length(4B) + Number of parameters(4B) + Number of points(4B) + CRC(4B).
    if (PS_Data_buf[instance].length < 4 + 4 + 4 + 4 + 4) {
      str_err_last[instance] = "Error: File size is invalid! " + PS_Data_buf[instance].length;
      if (PRINT_INTERFACES_FILE_ALL_ERR || PRINT_INTERFACES_FILE_LOAD_ERR) println("Interfaces_File:load("+instance+")"+":"+str_err_last[instance]);
      SYSTEM_logger.severe("Interfaces_File:load("+instance+")"+":"+str_err_last[instance]);
      return false;
    }

    // Update time_last_modified
    //FILE_last_modified_time[instance] = file_handle.lastModified();
    str_err_last[instance] = null;

    // Find next file.
    int i;
    for (i = file_name_index[instance] + 1; i < file_name_list[instance].length; i ++) {
      try {
        file_time_stamp[instance] = Long.parseLong(file_name_list[instance][i].substring(2, file_name_list[instance][i].length() - 4));
        file_name_index[instance] = i;
        if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_LOAD_DBG) println("Interfaces_File:load("+instance+"):next file_time_stamp="+file_time_stamp[instance]+",base_time_stamp="+base_time_stamp[instance]);
        //println("Interfaces_File:load("+instance+"):next file_time_stamp="+file_time_stamp[instance]+",base_time_stamp="+base_time_stamp[instance]);
        //println("i="+i+":file_time_stamp["+instance+"]="+file_time_stamp[instance]);
        break;
      }
      catch (NumberFormatException e) {
        file_time_stamp[instance] = -1;
        //println("i="+i+":file_time_stamp["+instance+"]="+file_time_stamp[instance]);
      }
    }
    //println("i="+i+":file_name_list["+instance+"].length="+file_name_list[instance].length);
    // If can't find next file.
    if (i >= file_name_list[instance].length && file_name_list[instance].length > 1) {
      if (!reached_eofl[instance]) {
        reached_eofl[instance] = true;
      }
      else {
        str_err_last[instance] = "Notice: Reached end of file list. "+file_name_list[instance].length;
        if (eofl_reset_count[instance] == -1) {
          eofl_reset_count[instance] = FRAME_RATE; // It means 1 second.
        }
        else if (eofl_reset_count[instance] == 0) {
          reached_eofl[instance] = false;
          eofl_reset_count[instance] = -1;
          // Start from first file.
          for (String file_name:file_name_list[instance]) {
            //println("file_name="+file_name);
            try {
              file_time_stamp[instance] = Long.parseLong(file_name.substring(2, file_name.length() - 4));
              if (PRINT_INTERFACES_FILE_ALL_DBG || PRINT_INTERFACES_FILE_LOAD_DBG) println("Interfaces_File:load("+instance+"):wraped file_time_stamp="+file_time_stamp[instance]+",base_time_stamp="+base_time_stamp[instance]);
              //println("Interfaces_File:load("+instance+"):wraped file_time_stamp="+file_time_stamp[instance]+",base_time_stamp="+base_time_stamp[instance]);
              //println("file_time_stamp["+instance+"]="+file_time_stamp[instance]);
              break;
            }
            catch (NumberFormatException e) {
              file_time_stamp[instance] = -1;
              //println("i="+i+":file_time_stamp["+instance+"]="+file_time_stamp[instance]);
            }
          }
          file_name_index[instance] = 0;
          base_time_stamp[instance] = file_time_stamp[instance] - millis();
        }
        else {
          eofl_reset_count[instance] --;
        }

        return false;
      }
    }
    return true;
  }
}
