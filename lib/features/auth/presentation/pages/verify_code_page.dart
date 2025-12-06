import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warshasy/core/errors/errors.dart';
import 'package:warshasy/core/presentation/pages/loading_page.dart';
import 'package:warshasy/core/utils/snackbar_utils.dart';
import 'package:warshasy/features/auth/auth.dart';

class VerifyCodePage extends StatefulWidget {
  final String phoneNumber;
  const VerifyCodePage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  Timer? _resendTimer; // <— keep reference to the timer

  bool _isResendEnabled = false;
  int _resendCountdown = 60;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel(); // cancel any existing timer

    setState(() {
      _isResendEnabled = false;
      _resendCountdown = 60;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
        setState(() => _isResendEnabled = true);
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field, unfocus and verify
        _focusNodes[index].unfocus();
        _verifyOtp();
      }
    }
  }

  void _onOtpKeyEvent(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_otpControllers[index].text.isEmpty && index > 0) {
          // Move to previous field on backspace if current is empty
          _focusNodes[index - 1].requestFocus();
        }
      }
    }
  }

  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _verifyOtp() {
    final code = _getOtpCode();
    if (code.length == 4) {
      context.read<AuthBloc>().add(
        SignInRequested(phone: widget.phoneNumber, code: code),
      );
    } else {
      context.showErrorSnackBar('الرجاء إدخال رمز التحقق كاملاً');
    }
  }

  void _resendCode() {
    if (_isResendEnabled) {
      context.read<AuthBloc>().add(
        SendVerificationCodeRequested(phone: widget.phoneNumber),
      );
      _startResendTimer();
      context.showSuccessSnackBar('تم إعادة إرسال الرمز');
    }
  }

  void _clearOtp() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text('التحقق من الرمز'),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailureState) {
              _clearOtp();
              context.showErrorSnackBar(state.message);
            } else if (state is Authenticated) {
              _resendTimer?.cancel(); // stop timer
              context.go('/home');
              // Navigate to home or main screen
              // context.go('/home');
            } else if (state is VerificationCodeSent) {
              _clearOtp();
              context.showSuccessSnackBar('تم إرسال الرمز بنجاح');
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            if (isLoading) return const LoadingPage();

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // WhatsApp Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        size: 60,
                        color: Color(0xFF25D366),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'تحقق من رسالة واتساب',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Description
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: 'أرسلنا لك رمز التحقق عبر '),
                          TextSpan(
                            text: 'واتساب',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF25D366),
                            ),
                          ),
                          const TextSpan(text: ' على الرقم\n'),
                          TextSpan(
                            text: widget.phoneNumber,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // OTP Input Fields
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) => Container(
                            width: 50,
                            margin: EdgeInsets.symmetric(
                              horizontal: index == 2 ? 8 : 4,
                            ),
                            child: RawKeyboardListener(
                              focusNode: FocusNode(),
                              onKey: (event) => _onOtpKeyEvent(event, index),
                              child: TextField(
                                controller: _otpControllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                onChanged:
                                    (value) => _onOtpChanged(value, index),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Clear button
                    TextButton.icon(
                      onPressed: _clearOtp,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('مسح الرمز'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Verify Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _verifyOtp,
                        child: const Text(
                          'تحقق من الرمز',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'لم تستلم الرمز؟',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Resend Code Button
                    OutlinedButton.icon(
                      onPressed: _isResendEnabled ? _resendCode : null,
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        _isResendEnabled
                            ? 'إعادة إرسال الرمز'
                            : 'إعادة الإرسال بعد $_resendCountdown ثانية',
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color:
                              _isResendEnabled
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300]!,
                        ),
                        foregroundColor:
                            _isResendEnabled
                                ? Theme.of(context).primaryColor
                                : Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // WhatsApp Help
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF25D366).withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xFF25D366),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'تأكد من فتح تطبيق واتساب للحصول على رمز التحقق',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Change Number
                    TextButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('تغيير رقم الهاتف'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
