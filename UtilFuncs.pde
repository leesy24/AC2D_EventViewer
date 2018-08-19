// CRC table with POLYNOMIAL 0x04c11db7
int[] CRC32_table = {
  0x00000000, 0x77073096, 0xee0e612c, 0x990951ba, 0x076dc419, 0x706af48f, 0xe963a535, 0x9e6495a3,
  0x0edb8832, 0x79dcb8a4, 0xe0d5e91e, 0x97d2d988, 0x09b64c2b, 0x7eb17cbd, 0xe7b82d07, 0x90bf1d91,
  0x1db71064, 0x6ab020f2, 0xf3b97148, 0x84be41de, 0x1adad47d, 0x6ddde4eb, 0xf4d4b551, 0x83d385c7,
  0x136c9856, 0x646ba8c0, 0xfd62f97a, 0x8a65c9ec, 0x14015c4f, 0x63066cd9, 0xfa0f3d63, 0x8d080df5,
  0x3b6e20c8, 0x4c69105e, 0xd56041e4, 0xa2677172, 0x3c03e4d1, 0x4b04d447, 0xd20d85fd, 0xa50ab56b,
  0x35b5a8fa, 0x42b2986c, 0xdbbbc9d6, 0xacbcf940, 0x32d86ce3, 0x45df5c75, 0xdcd60dcf, 0xabd13d59,
  0x26d930ac, 0x51de003a, 0xc8d75180, 0xbfd06116, 0x21b4f4b5, 0x56b3c423, 0xcfba9599, 0xb8bda50f,
  0x2802b89e, 0x5f058808, 0xc60cd9b2, 0xb10be924, 0x2f6f7c87, 0x58684c11, 0xc1611dab, 0xb6662d3d,
  0x76dc4190, 0x01db7106, 0x98d220bc, 0xefd5102a, 0x71b18589, 0x06b6b51f, 0x9fbfe4a5, 0xe8b8d433,
  0x7807c9a2, 0x0f00f934, 0x9609a88e, 0xe10e9818, 0x7f6a0dbb, 0x086d3d2d, 0x91646c97, 0xe6635c01,
  0x6b6b51f4, 0x1c6c6162, 0x856530d8, 0xf262004e, 0x6c0695ed, 0x1b01a57b, 0x8208f4c1, 0xf50fc457,
  0x65b0d9c6, 0x12b7e950, 0x8bbeb8ea, 0xfcb9887c, 0x62dd1ddf, 0x15da2d49, 0x8cd37cf3, 0xfbd44c65,
  0x4db26158, 0x3ab551ce, 0xa3bc0074, 0xd4bb30e2, 0x4adfa541, 0x3dd895d7, 0xa4d1c46d, 0xd3d6f4fb,
  0x4369e96a, 0x346ed9fc, 0xad678846, 0xda60b8d0, 0x44042d73, 0x33031de5, 0xaa0a4c5f, 0xdd0d7cc9,
  0x5005713c, 0x270241aa, 0xbe0b1010, 0xc90c2086, 0x5768b525, 0x206f85b3, 0xb966d409, 0xce61e49f,
  0x5edef90e, 0x29d9c998, 0xb0d09822, 0xc7d7a8b4, 0x59b33d17, 0x2eb40d81, 0xb7bd5c3b, 0xc0ba6cad,
  0xedb88320, 0x9abfb3b6, 0x03b6e20c, 0x74b1d29a, 0xead54739, 0x9dd277af, 0x04db2615, 0x73dc1683,
  0xe3630b12, 0x94643b84, 0x0d6d6a3e, 0x7a6a5aa8, 0xe40ecf0b, 0x9309ff9d, 0x0a00ae27, 0x7d079eb1,
  0xf00f9344, 0x8708a3d2, 0x1e01f268, 0x6906c2fe, 0xf762575d, 0x806567cb, 0x196c3671, 0x6e6b06e7,
  0xfed41b76, 0x89d32be0, 0x10da7a5a, 0x67dd4acc, 0xf9b9df6f, 0x8ebeeff9, 0x17b7be43, 0x60b08ed5,
  0xd6d6a3e8, 0xa1d1937e, 0x38d8c2c4, 0x4fdff252, 0xd1bb67f1, 0xa6bc5767, 0x3fb506dd, 0x48b2364b,
  0xd80d2bda, 0xaf0a1b4c, 0x36034af6, 0x41047a60, 0xdf60efc3, 0xa867df55, 0x316e8eef, 0x4669be79,
  0xcb61b38c, 0xbc66831a, 0x256fd2a0, 0x5268e236, 0xcc0c7795, 0xbb0b4703, 0x220216b9, 0x5505262f,
  0xc5ba3bbe, 0xb2bd0b28, 0x2bb45a92, 0x5cb36a04, 0xc2d7ffa7, 0xb5d0cf31, 0x2cd99e8b, 0x5bdeae1d,
  0x9b64c2b0, 0xec63f226, 0x756aa39c, 0x026d930a, 0x9c0906a9, 0xeb0e363f, 0x72076785, 0x05005713,
  0x95bf4a82, 0xe2b87a14, 0x7bb12bae, 0x0cb61b38, 0x92d28e9b, 0xe5d5be0d, 0x7cdcefb7, 0x0bdbdf21,
  0x86d3d2d4, 0xf1d4e242, 0x68ddb3f8, 0x1fda836e, 0x81be16cd, 0xf6b9265b, 0x6fb077e1, 0x18b74777,
  0x88085ae6, 0xff0f6a70, 0x66063bca, 0x11010b5c, 0x8f659eff, 0xf862ae69, 0x616bffd3, 0x166ccf45,
  0xa00ae278, 0xd70dd2ee, 0x4e048354, 0x3903b3c2, 0xa7672661, 0xd06016f7, 0x4969474d, 0x3e6e77db,
  0xaed16a4a, 0xd9d65adc, 0x40df0b66, 0x37d83bf0, 0xa9bcae53, 0xdebb9ec5, 0x47b2cf7f, 0x30b5ffe9,
  0xbdbdf21c, 0xcabac28a, 0x53b39330, 0x24b4a3a6, 0xbad03605, 0xcdd70693, 0x54de5729, 0x23d967bf,
  0xb3667a2e, 0xc4614ab8, 0x5d681b02, 0x2a6f2b94, 0xb40bbe37, 0xc30c8ea1, 0x5a05df1b, 0x2d02ef8d 
};

int get_crc32(byte[] buf, int offset, int length)
{
    int crc = 0xffffffff;

    // Divide the message by the polynomial, a byte at time.
    for (int i = 0; i < length; i ++)
    {
        crc = (crc >>> 8) ^ CRC32_table[(crc ^ buf[offset + i]) & 0xff];
    }

    return (crc ^ 0xFFFFFFFF);
}

// Get 32bits data by network byte order(big-endian) to int type
int get_int32_bytes(byte[] buf, int offset)
{
  return ((buf[offset + 0] & 0xff) << 24) +
    ((buf[offset + 1] & 0xff) << 16) +
    ((buf[offset + 2] & 0xff) << 8) +
    ((buf[offset + 3] & 0xff) << 0);
}

// Get 32bits data by network byte order(big-endian) to long type
long get_long32_bytes(byte[] buf, int offset)
{
  return ((buf[offset + 0] & 0xff) << 24) +
    ((buf[offset + 1] & 0xff) << 16) +
    ((buf[offset + 2] & 0xff) << 8) +
    ((buf[offset + 3] & 0xff) << 0);
}

// Get string by network byte order(big-endian)
String get_str_bytes(byte[] buf, int offset, int length)
{
  String string = new String(buf, offset, length);
  return string;
}

// Set 32bits data from int32 by network byte order(big-endian)
void set_int32_bytes(byte[] buf, int offset, int data)
{
  buf[offset + 0] = byte(data >> 24 & 0xff);
  buf[offset + 1] = byte(data >> 16 & 0xff);
  buf[offset + 2] = byte(data >> 8 & 0xff);
  buf[offset + 3] = byte(data & 0xff);
}

// Set 32bits data from string by network byte order(big-endian)
void set_str_bytes(byte[] buf, int offset, String str)
{
  for(int i = 0; i < str.length(); i ++) { 
    buf[offset + i] = byte(str.charAt(i));
  }
}

int get_points_diff(int point_a_x, int point_a_y, int point_b_x, int point_b_y)
{
  return abs(point_a_x - point_b_x) + abs(point_a_y - point_b_y);
}

int get_points_distance(int point_a_x, int point_a_y, int point_b_x, int point_b_y)
{
  return int(abs(sqrt(sq(point_a_x - point_b_x) + sq(point_a_y - point_b_y))));
}

/*
int get_points_distance(int point_a_x, int point_a_y, int point_b_x, int point_b_y)
{
  int distance = int(sqrt(sq(point_a_x - point_b_x) + sq(point_a_y - point_b_y)));
  // Distance value must be absolute value. Will not use abs() for performance.
  if (distance < 0) distance = -distance;

  return distance;
}
*/

int get_point_rotate_x(int point_x, int point_y, float degree)
{
  int point_rot_x;
  point_rot_x = int(point_x * cos(radians(degree)) - point_y * sin(radians(degree)));
  //println("get_point_rotate_x():"+"point_rot_x="+point_rot_x);
  return point_rot_x;
}

int get_point_rotate_y(int point_x, int point_y, float degree)
{
  int point_rot_y;
  point_rot_y = int(point_x * sin(radians(degree)) + point_y * cos(radians(degree)));
  //println("get_point_rotate_y():"+"point_rot_y="+point_rot_y);
  return point_rot_y;
}

int get_point_rotate_distance(int point_x, int point_y, float degree)
{
  int point_rot_x, point_rot_y;
  point_rot_x = int(point_x * cos(radians(degree)) - point_y * sin(radians(degree)));
  point_rot_y = int(point_x * sin(radians(degree)) + point_y * cos(radians(degree)));
  //println("get_point_rotate_distance():"+"distance="+distance);
  return get_points_distance(point_x, point_y, point_rot_x, point_rot_y);
}

boolean is_point_over_rect(int point_x, int point_y, int rect_x, int rect_y, int rect_w, int rect_h)
{
  if (
      point_x >= rect_x
      &&
      point_x <= rect_x + rect_w
      &&
      point_y >= rect_y
      &&
      point_y <= rect_y + rect_h
      )
  {
    return true;
  }

  return false;
}

import java.util.Arrays;

boolean is_files_equals(String file1, String file2)
{
  boolean ret;

  //println("is_files_equals():"+"file1="+file1);
  //println("is_files_equals():"+"file2="+file2);

  byte[] f1 = loadBytes(file1);
  byte[] f2 = loadBytes(file2);

  ret = Arrays.equals(f1, f2);

  //println("is_files_equals():"+file1+","+file2+"="+ret);
  //println("is_files_equals():"+"file1="+file1);
  //println("is_files_equals():"+"file2="+file2);
  //println("is_files_equals():"+"ret="+ret);
  return ret;
}

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.CopyOption;
import java.nio.file.StandardCopyOption;
//import java.nio.file.AtomicMoveNotSupportedException;
import java.io.IOException;
import java.io.FileOutputStream;

String write_file_error;
/*
boolean write_file(byte[] buff, String target_file)
{
  //println("write_file():"+"to   "+target_file);
  boolean ret = true;
  FileOutputStream fop = null;

  try {
    fop = new FileOutputStream(target_file);
    fop.write(buff);
    //fop.flush();
    fop.close();
  } catch (IOException e) {
    write_file_error = e.toString();
    //e.printStackTrace();
    ret = false;
  } finally {
    try {
      if (fop != null) {
        fop.close();
      }
    } catch (IOException e) {
      write_file_error = e.toString();
      ret = false;
    }
  }

  return ret;
}
*/
/**/
boolean write_file(byte[] buff, String target_file)
{
  //println("write_file():"+"to   "+target_file);
  try {
      Files.write(
        Paths.get(target_file),
        buff);
  } catch (IOException e) {
    write_file_error = e.toString();
    //e.printStackTrace();
    return false;
  }

  return true;
}
/**/
/*
boolean write_file(byte[] buff, String target_file)
{
  //println("write_file():"+"to   "+target_file);
  saveBytes(target_file, buff);

  return true;
}
*/

String copy_file_error;
/**/
boolean copy_file(String source_file, String target_file, CopyOption[] options)
{
  //println("copy_file():"+"from "+source_file);
  //println("copy_file():"+"to   "+target_file);
  try
  {
    Files.copy(
      Paths.get(source_file),
      Paths.get(target_file),
      options);
  }
  catch (IOException e)
  {
    copy_file_error = e.toString();
    //e.printStackTrace();
    return false;
  }

  return true;
}
/**/
/*
boolean copy_file(String source_file, String target_file)
{
  //println("copy_file():"+"from "+source_file);
  //println("copy_file():"+"to   "+target_file);
  CopyOption[] options = new CopyOption[] 
  {
    StandardCopyOption.REPLACE_EXISTING,
    StandardCopyOption.COPY_ATTRIBUTES
  };
  try
  {
    Files.copy(
      Paths.get(source_file),
      Paths.get(target_file),
      options);
  }
  catch (IOException e)
  {
    copy_file_error = e.toString();
    //e.printStackTrace();
    return false;
  }

  return true;
}
*/
/*
boolean copy_file(String source_file, String target_file)
{
  //println("copy_file():"+"from "+source_file);
  //println("copy_file():"+"to   "+target_file);
  try
  {
    Files.copy(
      Paths.get(source_file),
      Paths.get(target_file),
      StandardCopyOption.REPLACE_EXISTING);
  }
  catch (IOException e)
  {
    copy_file_error = e.toString();
    //e.printStackTrace();
    return false;
  }

  return true;
}
*/

String move_file_error;
boolean move_file(String source_file, String target_file)
{
  //println("move_file():"+"from "+source_file);
  //println("move_file():"+"to   "+target_file);
  try
  {
    Files.move(
      Paths.get(source_file),
      Paths.get(target_file),
      StandardCopyOption.REPLACE_EXISTING);
  }
  catch (IOException e)
  {
    move_file_error = e.toString();
    //e.printStackTrace();
    return false;
  }

  return true;
}

String move_file_atomic_error;
boolean move_file_atomic(String source_file, String target_file)
{
  boolean ret = true;
  //println("move_file_atomic():"+"from "+source_file);
  //println("move_file_atomic():"+"to   "+target_file);
  try
  {
    Files.move(
      Paths.get(source_file),
      Paths.get(target_file),
      StandardCopyOption.ATOMIC_MOVE);
  }
  catch (IOException e)
  {
    move_file_atomic_error = e.toString();
    //e.printStackTrace();
    ret = false;
  }
/*
  catch (AtomicMoveNotSupportedException e)
  {
    move_file_atomic_error = e.toString();
    //e.printStackTrace();
    ret = false;
  }
*/

  return ret;
}

String delete_file_error;
boolean delete_file(String target_file)
{
  //println("delete_file():"+"to   "+target_file);
  try
  {
    Files.delete(Paths.get(target_file));
  }
  catch (IOException e)
  {
    delete_file_error = e.toString();
    //e.printStackTrace();
    return false;
  }

  return true;
}

import net.lingala.zip4j.core.*;
import net.lingala.zip4j.crypto.*;
import net.lingala.zip4j.crypto.engine.*;
import net.lingala.zip4j.crypto.PBKDF2.*;
import net.lingala.zip4j.exception.*;
import net.lingala.zip4j.io.*;
import net.lingala.zip4j.model.*;
import net.lingala.zip4j.progress.*;
import net.lingala.zip4j.unzip.*;
import net.lingala.zip4j.util.*;
import net.lingala.zip4j.zip.*;

boolean unzip_check_password_protected(String zip_file_full_name)
{
  try
  {
    // Initiate ZipFile object with the path/name of the zip file.
    ZipFile zipFile = new ZipFile(zip_file_full_name);
    // Check to see if the zip file is password protected 
    if (zipFile.isEncrypted())
    {
      // if yes, then set the password for the zip file
      return true;
    }
  }
  catch (ZipException e)
  {
    e.printStackTrace();
  }
  return false;
}

int unzip_perform(String zip_file_full_name, String unzip_dir, String password)
{
  //println("unzip_perform():password ="+password); 
  try
  {
    // Initiate ZipFile object with the path/name of the zip file.
    ZipFile zipFile = new ZipFile(zip_file_full_name);
    // Check to see if the zip file is password protected 
    if (!zipFile.isEncrypted())
    {
      // Do not support non password protected zip file.
      return -1;
    }
    // set the password for the zip file
    zipFile.setPassword(password);

    List fileHeaderList = zipFile.getFileHeaders();

    for (int i = 0; i < fileHeaderList.size(); i++)
    {
      FileHeader fileHeader = (FileHeader) fileHeaderList.get(i);
      //Path where you want to Extract
      zipFile.extractFile(fileHeader, unzip_dir);
    }
    //println("Extracted");
  }
  catch (ZipException e)
  {
    e.printStackTrace();
    return -1;
  }

  return 0;
}

int get_millis_diff(int old_millis)
{
  int diff, new_millis;

  new_millis = millis();
  if (new_millis < old_millis) diff = MAX_INT - old_millis + new_millis - MIN_INT;
  else diff = new_millis - old_millis;

  return diff;
}

int get_int_diff(int new_val, int old_val)
{
  int diff;

  if (new_val < old_val) diff = MAX_INT - old_val + new_val - MIN_INT;
  else diff = new_val - old_val;

  return diff;
}

import java.awt.datatransfer.*;
import java.awt.Toolkit;

String get_clipboard_string()
{
  String result;
  Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
  //odd: the Object param of getContents is not currently used
  Transferable contents = clipboard.getContents(null);
  boolean hasTransferableText =
    (contents != null) &&
    contents.isDataFlavorSupported(DataFlavor.stringFlavor);

  if (!hasTransferableText) return null;

  try
  {
    result = (String)contents.getTransferData(DataFlavor.stringFlavor);
  }
  catch (UnsupportedFlavorException e)
  {
    println(e);
    e.printStackTrace();
    return null;
  }
  catch (IOException e)
  {
    println(e);
    e.printStackTrace();
    return null;
  }

  return result;
}

import java.util.logging.*;

Logger SYSTEM_logger;

void set_logger()
{
  FileHandler fh;

  SYSTEM_logger = Logger.getLogger("2D Anti-Collision Event Viewer log");
  SYSTEM_logger.setUseParentHandlers(false);
  try
  {
    // This block configure the SYSTEM_logger with handler and formatter  
    if (OS_is_Windows)
    {
      fh =
        new FileHandler(
              sketchPath() + "\\AC2D_EventViewer_%g.log",
              //1*1024, // 1KB
              1*1024*1024, // 1MB
              //10*1024*1024, // 10MB
              100, // file count
              true // append
              );
    }
    else
    {
      fh =
        new FileHandler(
              sketchPath() + "/AC2D_EventViewer_%g.log",
              //1*1024, // 1KB
              1*1024*1024, // 1MB
              //10*1024*1024, // 10MB
              100, // file count
              true // append
              );
    }
    SYSTEM_logger.addHandler(fh);
    SimpleFormatter formatter = new SimpleFormatter()
    {
      private static final String format = "[%1$tF %1$tT][%2$-7s]%3$s%n";
      //private static final String format = "[%1$tc]%2$s:%3$s%n";

      @Override
      public synchronized String format(LogRecord lr)
      {
        return String.format(
                format,
                new Date(lr.getMillis()),
                lr.getLevel().getName(),
                lr.getMessage());
      }
    };
    fh.setFormatter(formatter);
  }
  catch (SecurityException e)
  {
    e.printStackTrace();
  }
  catch (IOException e)
  {
    e.printStackTrace();
  }  
}
