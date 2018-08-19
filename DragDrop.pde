import drop.*;

import java.awt.dnd.DropTargetDropEvent;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.util.Iterator;

static SDrop DragDrop_handle;
static boolean DEBUG;

void DragDrop_setup() {
  DragDrop_handle = new SDrop(this);
  //DEBUG = false;
  DEBUG = true;
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
        println(transferable.getTransferData(d));
        java.util.List fileList = (java.util.List) transferable.getTransferData(d);
        Iterator iterator = fileList.iterator();
        while (iterator.hasNext()) {
          File event_full_name_handle = (File) iterator.next();
          String event_full_name = event_full_name_handle.toString();
          println("we got a file:"+event_full_name_handle);
          String file_name = event_full_name_handle.getName();
          println("event_full_name="+event_full_name);
          println("file_name="+file_name);
          if (file_name.length() != 21) {
            continue;
          }
          println("sub file_name="+file_name.substring(file_name.length() - 1, file_name.length()));
          int instance = -1;
          try {
            instance = Integer.parseInt(file_name.substring(file_name.length() - 1, file_name.length()));
          }
          catch (NumberFormatException e) {
          }
          println("instance="+instance);
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
          // To restart program set frameCount to -1, this wiil call setup() of main.
          frameCount = -1;
          break;
        }
      }
      catch(Exception e) {
        println("Error: " + e + "\n");
      }
    }
  }
}
 
