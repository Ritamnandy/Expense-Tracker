import 'package:expense_tracker/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_kit/flutter_otp_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              15.w,
              0,
              15.w,
              MediaQuery.viewInsetsOf(context).bottom + 24.h,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      _BackButton(),
                      SizedBox(height: 10.h),
                      const _Header(email: "user@example.com"),
                      SizedBox(height: 56.h),
                      OtpKit(
                        subtitle: 'Enter the 6-digit code sent to your email',
                        fieldCount: 6,
                        securityConfig: OtpSecurityConfig(
                          enableRateLimiting: true,
                          maxAttemptsPerMinute: 3,
                          maxAttemptsPerHour: 15,
                          lockoutDuration: const Duration(minutes: 10),
                          enableBiometricIntegration: true,
                          enableAuditLogging: true,
                        ),
                        fieldConfig: OtpFieldConfig(
                          showPlaceholder: true,
                          cursorColor: Theme.of(context).colorScheme.primary,
                          fieldWidth: 44.w,
                          fieldHeight: 56.h,
                          borderRadius: 16.r,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.96),
                          borderWidth: 1.8,
                          fieldShape: OtpFieldShape.rectangle,
                          fieldShapeConfig: OtpFieldShapeConfig(
                            borderStyle: OtpBorderStyle.solid,
                          ),
                          enableShadow: true,
                          shadowColor: Colors.black.withValues(alpha: 0.08),
                          shadowBlurRadius: 14,
                          fieldFontSize: 23.sp,
                          fieldFontWeight: FontWeight.w800,
                        ),
                        buttonWidget: Container(
                          // height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: TextButton(
                              onPressed: () {
                                _onVerifyOtp("2767");
                                print("Custom Verify Button Pressed");
                              },
                              child: Text(
                                'Verify',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.sp,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        animationConfig: OtpAnimationConfig(
                          enableAnimation: true,
                          fieldFillAnimationType: FieldFillAnimationType.scale,
                          errorFieldAnimationType:
                              ErrorFieldAnimationType.shake,
                        ),
                        primaryColor: Theme.of(context).colorScheme.primary,
                        successColor: Theme.of(context).colorScheme.primary,
                        errorColor: Colors.redAccent,
                        onVerify: (otp) => _onVerifyOtp(otp),
                        performanceConfig: OtpPerformanceConfig(
                          enableLazyLoading: true,
                          enableMemoryOptimization: true,
                          enableAnimationPooling: true,
                          enablePerformanceMonitoring: true,
                        ),
                        errorConfig: OtpErrorConfig(
                          maxErrorRetries: 3,
                          enableFieldLockout: true,
                          clearFieldsOnError: true,
                          enableHapticFeedbackOnError: true,
                        ),
                        onResend: () {
                          FocusScope.of(context).unfocus();
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.25),
                              content: Text(
                                'A fresh verification code has been sent.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 82.h),
                      _TrustNote(),
                    ],
                  ).animate().fadeIn(
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 360),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  _onVerifyOtp(String otp) async {}
}

class _Header extends StatelessWidget {
  final String email;
  const _Header({required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Text(
          "Verify your email",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: 30.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "We sent a one-time code to confirm it is really you.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 15.sp,
            height: 1.45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Registerscreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
          (route) => false,
        );
      },
      icon: Icon(
        Icons.arrow_back,
        size: 26.sp,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _TrustNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline_rounded,
            color: Theme.of(context).colorScheme.secondary,
            size: 22.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "Your code expires soon. Never share it with anyone.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
