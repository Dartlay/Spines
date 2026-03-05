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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
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
    _animationController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SessionCubit>().login(
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
          debugPrint('✅ Login successful, navigating to home');

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          context.go(AppRoutes.home.path);
          return;
        }

        if (!state.isAuthenticated &&
            state.error != null &&
            state.error!.isNotEmpty) {
          debugPrint('❌ Login failed: ${state.error}');
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
        title: context.tr.login1,
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
              return LoadingView(message: context.tr.login1);
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
                          title: context.tr.welcome,
                          subtitle: context.tr.loginSubtitle,
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
                              return context.tr.password;
                            }
                            if (value.length < 6) {
                              return context.tr.passwordMinLength;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                            ),
                            child: Text(context.tr.forgotPassword),
                          ),
                        ),

                        const SizedBox(height: 32),

                        AuthButton.primary(
                          text: context.tr.login,
                          onPressed: _onLogin,
                        ),

                        const SizedBox(height: 16),

                        AuthDivider(text: context.tr.or),

                        const SizedBox(height: 16),

                        AuthButton.outlined(
                          text: context.tr.noAccount,
                          onPressed: () {
                            debugPrint('👉 Navigating to register');
                            context.push(AppRoutes.register.path);
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
