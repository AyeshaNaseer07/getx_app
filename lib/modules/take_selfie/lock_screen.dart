import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mygetx_app/modules/take_selfie/unauthorized_attepmt.dart';
import 'package:path_provider/path_provider.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticating = false;
  int _failedAttempts = 0;
  DateTime? _lockedUntil;

  final int LOCK_DURATION_MINUTES = 1;
  final int MAX_FAILED_ATTEMPTS = 2;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), _authenticateUser);
  }

  Future<void> _authenticateUser() async {
    if (_lockedUntil != null && DateTime.now().isBefore(_lockedUntil!)) {
      _showLockedDialog();
      return;
    }

    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      final bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Unlock your app using biometric',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (authenticated) {
        _failedAttempts = 0;
        _lockedUntil = null;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _failedAttempts++;
        await _captureUnauthorizedSelfie(); // only once per fail

        if (_failedAttempts >= MAX_FAILED_ATTEMPTS) {
          _lockedUntil = DateTime.now().add(
            Duration(minutes: LOCK_DURATION_MINUTES),
          );
          _showLockedDialog();
        } else {
          setState(() {
            _isAuthenticating = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Auth error: $e');
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _showLockedDialog() {
    final remainingTime = _lockedUntil!.difference(DateTime.now());
    final minutes = remainingTime.inMinutes;
    final seconds = remainingTime.inSeconds % 60;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🔒 App Locked'),
        content: Text(
          'Too many failed attempts.\n\n'
          'Try again in: $minutes:${seconds.toString().padLeft(2, '0')} minutes',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _captureUnauthorizedSelfie() async {
    CameraController? cameraController;

    try {
      // iOS automatically grants Documents folder access
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(frontCamera, ResolutionPreset.high);

      await cameraController.initialize();

      // short delay to ensure camera ready
      await Future.delayed(const Duration(milliseconds: 500));

      final XFile image = await cameraController.takePicture();
      await _saveUnauthorizedAttempt(File(image.path));
    } catch (e) {
      debugPrint('❌ Selfie capture failed: $e');
    } finally {
      if (cameraController != null) {
        try {
          await cameraController.dispose();
        } catch (e) {
          debugPrint('❌ Camera dispose error: $e');
        }
      }
    }
  }

  Future<void> _saveUnauthorizedAttempt(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dirPath = '${appDir.path}/unauthorized_attempts';
      final dir = Directory(dirPath);
      if (!dir.existsSync()) dir.createSync(recursive: true);

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '$dirPath/unauthorized_$timestamp.jpg';

      await imageFile.copy(filePath);
      debugPrint('✅ Selfie saved: $filePath');
    } catch (e) {
      debugPrint('❌ Saving selfie failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade900,
              const Color.fromARGB(255, 101, 164, 219),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.white),
              const SizedBox(height: 30),
              const Text(
                'My App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter iPhone passcode or use biometric',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 50),
              if (_isAuthenticating)
                Column(
                  children: const [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Authenticating...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _authenticateUser,
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('Unlock'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                    ),
                    if (_failedAttempts > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Failed attempts: $_failedAttempts/$MAX_FAILED_ATTEMPTS',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Get.to(() => UnauthorizedAttemptsScreen());
                      },
                      child: const Text(
                        'View Unauthorized Attempts',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
