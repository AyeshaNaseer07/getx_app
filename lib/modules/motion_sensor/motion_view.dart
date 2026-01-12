// import 'dart:io';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:mygetx_app/modules/take_selfie/home_view_screen.dart';
// import 'package:mygetx_app/modules/take_selfie/lock_screen.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:mygetx_app/modules/clap_detect/alarm_service.dart';

// class MotionSensorView extends StatefulWidget {
//   const MotionSensorView({super.key});

//   @override
//   State<MotionSensorView> createState() => _MotionSensorViewState();
// }

// class _MotionSensorViewState extends State<MotionSensorView> {
//   late StreamSubscription _accelSub;
//   static const iosAlarmChannel = MethodChannel("ios_alarm");

//   bool isArmed = false;
//   bool alarmTriggered = false;

//   double x = 0.0, y = 0.0, z = 0.0;
//   double baseX = 0.0, baseY = 0.0, baseZ = 0.0;

//   final double thresholdX = 10.0;
//   final double thresholdY = 10.0;
//   final double thresholdZ = 10.0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAlarmService();
//     _setupMotionListener();
//   }

//   Future<void> _initializeAlarmService() async {
//     await AlarmService().init();
//   }

//   void _setupMotionListener() {
//     // iOS background motion trigger listener
//     iosAlarmChannel.setMethodCallHandler((call) async {
//       if (call.method == "motionDetected" && isArmed && !alarmTriggered) {
//         _triggerMotionAlarm();
//       }
//     });

//     // Foreground motion detection using sensors_plus
//     // ignore: deprecated_member_use
//     _accelSub = accelerometerEvents.listen((event) {
//       setState(() {
//         x = event.x;
//         y = event.y;
//         z = event.z;
//       });

//       if (!isArmed || alarmTriggered) return;

//       double dx = (x - baseX).abs();
//       double dy = (y - baseY).abs();
//       double dz = (z - baseZ).abs();

//       if (dx > thresholdX || dy > thresholdY || dz > thresholdZ) {
//         _triggerMotionAlarm();
//       }
//     });
//   }

//   void _triggerMotionAlarm() {
//     setState(() {
//       alarmTriggered = true;
//     });

//     AlarmService().playAlarm();

//     // Show lock screen on iOS when alarm triggers
//     if (Platform.isIOS) {
//       Future.delayed(const Duration(milliseconds: 500), () {
//         if (mounted) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   const AlarmTriggeredLockScreen(alarmType: 'Motion'),
//             ),
//           );
//         }
//       });
//     }
//   }

//   void _toggleAlarm() async {
//     setState(() {
//       isArmed = !isArmed;
//       alarmTriggered = false;
//     });

//     if (isArmed) {
//       // Set baseline values
//       baseX = x;
//       baseY = y;
//       baseZ = z;

//       // Call iOS to start background monitoring
//       if (Platform.isIOS) {
//         await iosAlarmChannel.invokeMethod("startAlarmService");
//       }
//     } else {
//       AlarmService().stopAlarm();
//       if (Platform.isIOS) {
//         await iosAlarmChannel.invokeMethod("stopAlarmService");
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _accelSub.cancel();
//     iosAlarmChannel.invokeMethod("stopAlarmService");
//     AlarmService().stopAlarm();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Motion Sensor Alarm"),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//         elevation: 0,
//       ),
//       backgroundColor: const Color(0xFF0F172A),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
//           child: Column(
//             children: [
//               // ========== MAIN STATUS CARD ==========
//               _buildMainCard(),
//               SizedBox(height: 40.h),

//               // ========== MOTION VALUES ==========
//               _buildMotionValuesSection(),
//               SizedBox(height: 30.h),

//               // ========== ARM/DISARM BUTTON ==========
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: _toggleAlarm,
//                   icon: Icon(
//                     isArmed ? Icons.stop : Icons.play_arrow,
//                     size: 28.sp,
//                   ),
//                   label: Text(
//                     isArmed ? 'DISARM' : 'ARM',
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: isArmed ? Colors.red : Colors.green,
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(vertical: 16.h),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15.r),
//                     ),
//                     elevation: 8,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 40.h),

//               // ========== INFO CARD ==========
//               _buildInfoCard(),
//               ElevatedButton(
//                 onPressed: () {
//                   Get.to(() => HomeViewScreen());
//                 },
//                 child: Text('Unauthorized Selfies'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ========== MAIN STATUS CARD ==========
//   Widget _buildMainCard() {
//     return Container(
//       padding: EdgeInsets.all(30.w),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: isArmed
//               ? [const Color(0xFF10B981), const Color(0xFF059669)]
//               : [const Color(0xFF64748B), const Color(0xFF475569)],
//         ),
//         borderRadius: BorderRadius.circular(25.r),
//         boxShadow: [
//           BoxShadow(
//             color: isArmed
//                 ? const Color(0xFF10B981).withOpacity(0.3)
//                 : Colors.black26,
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(
//             isArmed ? Icons.vibration : Icons.visibility_off_outlined,
//             size: 80.sp,
//             color: Colors.white,
//           ),
//           SizedBox(height: 20.h),
//           Text(
//             isArmed
//                 ? (alarmTriggered ? '🚨 ALARM TRIGGERED!' : '🔒 ARMED')
//                 : '🔓 DISARMED',
//             style: TextStyle(
//               fontSize: 24.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 15.h),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Text(
//               isArmed ? 'Status: Monitoring Motion' : 'Status: Not Monitoring',
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 color: Colors.white.withOpacity(0.9),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ========== MOTION VALUES SECTION ==========
//   Widget _buildMotionValuesSection() {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(15.r),
//         border: Border.all(color: const Color(0xFF334155), width: 1.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Current Motion Values',
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 20.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildAxisDisplay('X', x, baseX, thresholdX, Colors.blue),
//               _buildAxisDisplay('Y', y, baseY, thresholdY, Colors.green),
//               _buildAxisDisplay('Z', z, baseZ, thresholdZ, Colors.red),
//             ],
//           ),
//           SizedBox(height: 20.h),
//           // Threshold Info
//           Container(
//             padding: EdgeInsets.all(12.w),
//             decoration: BoxDecoration(
//               color: Colors.orange.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10.r),
//               border: Border.all(color: Colors.orange.withOpacity(0.3)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '⚠️ Thresholds',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.orange,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   'X: ±$thresholdX  |  Y: ±$thresholdY  |  Z: ±$thresholdZ',
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     color: Colors.white.withOpacity(0.7),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ========== AXIS DISPLAY WIDGET ==========
//   Widget _buildAxisDisplay(
//     String axis,
//     double current,
//     double base,
//     double threshold,
//     Color color,
//   ) {
//     double delta = (current - base).abs();
//     bool isTriggered = delta > threshold;

//     return Column(
//       children: [
//         Text(
//           axis,
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         SizedBox(height: 8.h),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//           decoration: BoxDecoration(
//             color: isTriggered ? color.withOpacity(0.3) : Colors.transparent,
//             borderRadius: BorderRadius.circular(8.r),
//             border: Border.all(color: color.withOpacity(0.5)),
//           ),
//           child: Column(
//             children: [
//               Text(
//                 current.toStringAsFixed(2),
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//               Text(
//                 'Δ${delta.toStringAsFixed(2)}',
//                 style: TextStyle(
//                   fontSize: 11.sp,
//                   color: isTriggered
//                       ? Colors.red
//                       : Colors.white.withOpacity(0.6),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ========== INFO CARD ==========
//   Widget _buildInfoCard() {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(15.r),
//         border: Border.all(color: const Color(0xFF334155), width: 1.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'How it works:',
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           _infoRow('📍', 'Baseline', 'Motion baseline set when alarm is armed'),
//           SizedBox(height: 12.h),
//           _infoRow(
//             '📊',
//             'Delta Detection',
//             'Alarm triggers when motion exceeds threshold',
//           ),
//           SizedBox(height: 12.h),
//           _infoRow(
//             '🔔',
//             'Lock Screen',
//             'PIN required to deactivate alarm (iOS)',
//           ),
//           SizedBox(height: 12.h),
//           _infoRow('📸', 'Security', 'Unauthorized attempts are recorded'),
//         ],
//       ),
//     );
//   }

//   Widget _infoRow(String emoji, String title, String subtitle) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(emoji, style: TextStyle(fontSize: 20.sp)),
//         SizedBox(width: 15.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   color: Colors.white.withOpacity(0.6),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
