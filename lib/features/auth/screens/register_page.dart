import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spines/core/bloc/session/session_cubit.dart';
import 'package:spines/core/bloc/session/session_state.dart';
import 'package:spines/core/localization/s.dart';
import 'package:spines/core/navigation/app_routes.dart';
import 'package:spines/core/theme/app_colors.dart';
import 'package:spines/features/auth/widgets/auth_header.dart';
import 'package:spines/features/auth/widgets/auth_field.dart';
import 'package:spines/features/auth/widgets/auth_button.dart';
import 'package:spines/features/auth/widgets/auth_divider.dart';
import 'package:spines/features/auth/widgets/auth_page_wrapper.dart';
import 'package:spines/features/shared/widgets/loading_view.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SessionCubit>().register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          debugPrint('✅ Registration successful, navigating to home');
          context.go(AppRoutes.home.path);
        } else if (state.error != null && state.error!.isNotEmpty) {
          debugPrint('❌ Registration failed: ${state.error}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.error!)),
                ],
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      child: AuthPageWrapper(
        title: context.tr.registration,
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.welcome.path);
          }
        },
        child: BlocBuilder<SessionCubit, SessionState>(
          builder: (context, state) {
            if (state.isLoading) {
              return LoadingView(message: context.tr.registering);
            }

            return SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthHeader(
                          title: context.tr.createAccount,
                          subtitle: context.tr.joinReaders,
                        ),

                        const SizedBox(height: 48),

                        AuthField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'example@mail.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr.enterEmail;
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return context.tr.validEmail;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        AuthField(
                          controller: _passwordController,
                          label: context.tr.password,
                          hint: '••••••••',
                          prefixIcon: Icons.lock_outline_rounded,
                          isPassword: true,
                          isObscured: !_isPasswordVisible,
                          onVisibilityToggle: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr.enterPassword;
                            }
                            if (value.length < 6) {
                              return context.tr.passwordMinLength;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        AuthField(
                          controller: _confirmPasswordController,
                          label: context.tr.confirmPassword,
                          hint: '••••••••',
                          prefixIcon: Icons.lock_outline_rounded,
                          isPassword: true,
                          isObscured: !_isConfirmVisible,
                          onVisibilityToggle: () {
                            setState(() {
                              _isConfirmVisible = !_isConfirmVisible;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr.confirmPassword;
                            }
                            if (value != _passwordController.text) {
                              return context.tr.passwordsNotMatch;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 32),

                        AuthButton.primary(
                          text: context.tr.signUp,
                          onPressed: _onRegister,
                        ),

                        const SizedBox(height: 16),

                        AuthDivider(text: context.tr.or),

                        const SizedBox(height: 16),

                        AuthButton.outlined(
                          text: context.tr.hasAccount,
                          onPressed: () {
                            context.go(AppRoutes.login.path);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
