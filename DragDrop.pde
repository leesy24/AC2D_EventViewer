import drop.*;

import java.awt.dnd.DropTargetDropEvent;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.util.Iterator;

static SDrop DragDrop_handle;
static boolean DEBUG;

void DragDrop_setup() {
  DragDrop_handle = new SDrop(this);
  DEBUG = false;
  //DEBUG = true;
}

void dropEvent(DropEvent theDropEvent) {
  DropTargetDropEvent event = theDropEvent.dropTargetDropEvent();
  Transferable transferable = event.getTransferable();
  DataFlavor[] flavors = transferable.getTransferDataFlavors();
  
  for (DataFlavor d: flavors) {
    if(DEBUG) {
      println("\t\tMIME " + d.getMimeType());
      println("\t\tfilelist ? " + d.isFlavorJavaFileListType());
    }
    
    // does the following block work with linux? 
    if (d.isFlavorJavaFileListType() == true) {
      try {
        //println(transferable.getTransferData(d));
        java.util.List fileList = (java.util.List) transferable.getTransferData(d);
        Iterator iterator = fileList.iterator();
        while (iterator.hasNext()) {
          File event_full_name_handle = (File) iterator.next();
          String event_full_name = event_full_name_handle.toString();
          println("we got a event:"+event_full_name);
          if (event_full_name_handle.isDirectory()) {
            String dir_name = event_full_name_handle.getName();
            println("event_full_name="+event_full_name);
            println("dir_name="+dir_name);
            if (dir_name.length() != 21
                ||
                !dir_name.substring(dir_name.length() - 2, dir_name.length() - 1).equals("_")) {
              continue;
            }
            //println("sub dir_name="+dir_name.substring(dir_name.length() - 1, dir_name.length()));
            int instance = -1;
            try {
              instance = Integer.parseInt(dir_name.substring(dir_name.length() - 1, dir_name.length()));
            }
            catch (NumberFormatException e) {
            }
            //println("instance="+instance);
            if (instance == -1) {
              continue;
            }
            for (int i = 0; i < PS_INSTANCE_MAX; i ++) {
              if (i == instance) {
                PS_Interface[i] = PS_Interface_FILE;
                FILE_name[i] = event_full_name;
              }
              else {
                PS_Interface[i] = PS_Interface_None;
                FILE_name[i] = "";
              }
            }
            DATA_DIR_FULL_NAME = event_full_name + "\\";
            println("DATA_DIR_FULL_NAME="+DATA_DIR_FULL_NAME);
            // To restart program set frameCount to -1, this wiil call setup() of main.
            frameCount = -1;
            break;
          }
          else {
            String file_name = event_full_name_handle.getName();
            println("event_full_name="+event_full_name);
            println("file_name="+file_name);
            //println("sub file_name="+file_name.substring(file_name.length() - 4, file_name.length()));
            if (!file_name.substring(file_name.length() - 4, file_name.length()).equals(".dat")
                ||
                !file_name.substring(1, 2).equals("_")
                ) {
              continue;
            }
            //println("sub file_name="+file_name.substring(0, 1));
            int instance_file = -1;
            try {
              instance_file = Integer.parseInt(file_name.substring(0, 1));
            }
            catch (NumberFormatException e) {
            }
            //println("instance_file="+instance_file);
            if (instance_file == -1) {
              continue;
            }
            for (int i = 0; i < PS_INSTANCE_MAX; i ++) {
              if (i == instance_file) {
                PS_Interface[i] = PS_Interface_FILE;
                FILE_name[i] = event_full_name;
              }
              else {
                PS_Interface[i] = PS_Interface_None;
                FILE_name[i] = "";
              }
            }
            DATA_DIR_FULL_NAME = event_full_name_handle.getParent() + "\\";
            println("DATA_DIR_FULL_NAME="+DATA_DIR_FULL_NAME);
            // To restart program set frameCount to -1, this wiil call setup() of main.
            frameCount = -1;
            break;
          }
        } // End of while (iterator.hasNext())
      }
      catch(Exception e) {
        println("Error: " + e + "\n");
      }
    }
  }
}
 
