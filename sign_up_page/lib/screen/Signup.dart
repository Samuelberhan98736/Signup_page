import 'package:flutter/material.dart';
import 'success.dart'; // Import for navigation

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String _selectedAvatar = '😊';
  final List<String> _avatars = ['😊', '🚀', '🎨', '🎮', '⚡'];

  // Validity + animations
  bool _nameValid = false;
  bool _emailValid = false;
  bool _passwordValid = false;
  bool _confirmValid = false;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  late final AnimationController _nameCheckCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  late final AnimationController _emailCheckCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  late final AnimationController _passwordCheckCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  late final AnimationController _confirmCheckCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

  final _nameShakeKey = GlobalKey<ShakeWidgetState>();
  final _emailShakeKey = GlobalKey<ShakeWidgetState>();
  final _passwordShakeKey = GlobalKey<ShakeWidgetState>();
  final _confirmShakeKey = GlobalKey<ShakeWidgetState>();

  final _nameTipKey = GlobalKey<TooltipState>();
  final _emailTipKey = GlobalKey<TooltipState>();
  final _passwordTipKey = GlobalKey<TooltipState>();
  final _confirmTipKey = GlobalKey<TooltipState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameCheckCtrl.dispose();
    _emailCheckCtrl.dispose();
    _passwordCheckCtrl.dispose();
    _confirmCheckCtrl.dispose();
    super.dispose();
  }

  void _submitForm() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (valid) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(
            userName: _nameController.text,
            avatar: _selectedAvatar,
          ),
        ),
      );
    } else {
      // Trigger shakes and tooltips for invalid fields
      if (!_nameValid) {
        _nameShakeKey.currentState?.shake();
        _nameTipKey.currentState?.ensureTooltipVisible();
      }
      if (!_emailValid) {
        _emailShakeKey.currentState?.shake();
        _emailTipKey.currentState?.ensureTooltipVisible();
      }
      if (!_passwordValid) {
        _passwordShakeKey.currentState?.shake();
        _passwordTipKey.currentState?.ensureTooltipVisible();
      }
      if (!_confirmValid) {
        _confirmShakeKey.currentState?.shake();
        _confirmTipKey.currentState?.ensureTooltipVisible();
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your name';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!value.contains('@')) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Choose Your Avatar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _avatars.map((avatar) {
                  final isSelected = _selectedAvatar == avatar;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAvatar = avatar),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.deepPurple : Colors.grey,
                          width: isSelected ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(avatar, style: const TextStyle(fontSize: 32)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ShakeWidget(
                key: _nameShakeKey,
                child: Tooltip(
                  key: _nameTipKey,
                  message: _nameError ?? 'Please enter your name',
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                      suffixIcon: ScaleTransition(
                        scale: CurvedAnimation(
                          parent: _nameCheckCtrl,
                          curve: Curves.elasticOut,
                        ),
                        child: const Icon(Icons.check_circle, color: Colors.green),
                      ),
                    ),
                    validator: (v) => _validateName(v),
                    onChanged: (v) {
                      final err = _validateName(v);
                      final isValid = err == null;
                      if (isValid && !_nameValid) {
                        _nameCheckCtrl.forward(from: 0.0);
                      }
                      setState(() {
                        _nameValid = isValid;
                        _nameError = err;
                        if (!isValid) _nameCheckCtrl.value = 0.0;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ShakeWidget(
                key: _emailShakeKey,
                child: Tooltip(
                  key: _emailTipKey,
                  message: _emailError ?? 'Please enter a valid email',
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.email),
                      border: const OutlineInputBorder(),
                      suffixIcon: ScaleTransition(
                        scale: CurvedAnimation(
                          parent: _emailCheckCtrl,
                          curve: Curves.elasticOut,
                        ),
                        child: const Icon(Icons.check_circle, color: Colors.green),
                      ),
                    ),
                    validator: (v) => _validateEmail(v),
                    onChanged: (v) {
                      final err = _validateEmail(v);
                      final isValid = err == null;
                      if (isValid && !_emailValid) {
                        _emailCheckCtrl.forward(from: 0.0);
                      }
                      setState(() {
                        _emailValid = isValid;
                        _emailError = err;
                        if (!isValid) _emailCheckCtrl.value = 0.0;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ShakeWidget(
                key: _passwordShakeKey,
                child: Tooltip(
                  key: _passwordTipKey,
                  message: _passwordError ?? 'Enter a valid password',
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          ScaleTransition(
                            scale: CurvedAnimation(
                              parent: _passwordCheckCtrl,
                              curve: Curves.elasticOut,
                            ),
                            child: const Icon(Icons.check_circle, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    validator: (v) => _validatePassword(v),
                    onChanged: (v) {
                      final err = _validatePassword(v);
                      final isValid = err == null;
                      if (isValid && !_passwordValid) {
                        _passwordCheckCtrl.forward(from: 0.0);
                      }
                      // Update confirm field validity too
                      final confirmErr = _validateConfirm(_confirmController.text);
                      final confirmValid = confirmErr == null;
                      if (confirmValid && !_confirmValid) {
                        _confirmCheckCtrl.forward(from: 0.0);
                      }
                      setState(() {
                        _passwordValid = isValid;
                        _passwordError = err;
                        if (!isValid) _passwordCheckCtrl.value = 0.0;
                        _confirmValid = confirmValid;
                        _confirmError = confirmErr;
                        if (!confirmValid) _confirmCheckCtrl.value = 0.0;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ShakeWidget(
                key: _confirmShakeKey,
                child: Tooltip(
                  key: _confirmTipKey,
                  message: _confirmError ?? 'Passwords must match',
                  child: TextFormField(
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                          ScaleTransition(
                            scale: CurvedAnimation(
                              parent: _confirmCheckCtrl,
                              curve: Curves.elasticOut,
                            ),
                            child: const Icon(Icons.check_circle, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    validator: (v) => _validateConfirm(v),
                    onChanged: (v) {
                      final err = _validateConfirm(v);
                      final isValid = err == null;
                      if (isValid && !_confirmValid) {
                        _confirmCheckCtrl.forward(from: 0.0);
                      }
                      setState(() {
                        _confirmValid = isValid;
                        _confirmError = err;
                        if (!isValid) _confirmCheckCtrl.value = 0.0;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Create Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double delta;

  const ShakeWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.delta = 12,
  });

  @override
  State<ShakeWidget> createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -1.0, end: 1.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: -1.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -1.0, end: 1.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void shake() {
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value * widget.delta, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
