import 'package:usb_serial/usb_serial.dart';

class LinkManager {
  // Used when running on the MK32 (Android)
  static UsbDevice? selectedUsbDevice;

  // Used when running on Windows or Ubuntu
  static String? selectedDesktopPort;

  static int selectedBaudRate = 57600;

  // Helper method to clear both
  static void clearConnection() {
    selectedUsbDevice = null;
    selectedDesktopPort = null;
  }
}