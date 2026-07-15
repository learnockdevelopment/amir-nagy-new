import 'dart:io';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:safe_device/safe_device.dart';

class SecurityService {
  static final _noScreenshot = NoScreenshot.instance;

  // Toggle this flag to bypass emulator, jailbreak, and developer option checks.
  // True: allow running on emulators/macOS/devices with developer options.
  // False: enforce full DRM checks and block execution on unsecured environments.
  static const bool bypassSecurityChecks = true; // CHANGE TO false TO ENABLE PROTECTION

  static Future<void> setupSecurity() async {
    await _noScreenshot.screenshotOff(); 
  }

  static bool? _isCachedSafe;

  static Future<bool> isDeviceSafe() async {
    if (bypassSecurityChecks) return true;
    if (_isCachedSafe != null) return _isCachedSafe!;
 
    // Block macOS (MacBooks)
    if (Platform.isMacOS) {
      _isCachedSafe = false;
      return false;
    }

    try {
      bool isReal = await SafeDevice.isRealDevice;
      bool isJailBroken = await SafeDevice.isJailBroken;
      bool isDeveloperOptionsEnabled = await SafeDevice.isDevelopmentModeEnable;

      if (!isReal) {
        _isCachedSafe = false;
        return false;
      }
      if (isJailBroken) {
        _isCachedSafe = false;
        return false;
      }
      if (isDeveloperOptionsEnabled && Platform.isAndroid) {
        _isCachedSafe = false;
        return false;
      }
      _isCachedSafe = true;
      return true;
    } catch (e) {
      _isCachedSafe = false;
      return false;
    }
  }
  static void exitApp() {
    exit(0);
  }
}
