import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_strings.dart';
import '../../core/profile/profile_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_scale.dart';
import '../../core/widgets/edit_sheets.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../core/constants/app_routes.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final _picker = ImagePicker();
  final _profile = ProfileController.instance;

  bool _airAlert = true;
  bool _outages = true;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _phoneRegex = RegExp(r'^\d{12}$');

  Future<void> _pickAvatar() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 85,
    );
    if (picked == null) return;
    _profile.setAvatar(File(picked.path));
  }

  Future<void> _editName() async {
    final result = await showEditSheet(
      context,
      title: AppStrings.settingsEditName,
      initial: _profile.name,
      validator: (v) =>
      (v ?? '').trim().length < 2 ? AppStrings.usernameTooShort : null,
    );
    if (result != null) _profile.setName(result);
  }

  Future<void> _editPhone() async {
    final result = await showEditSheet(
      context,
      title: AppStrings.settingsPhone,
      initial: _profile.phone,
      keyboard: TextInputType.phone,
      validator: (v) {
        final text = (v ?? '').trim();
        if (text.isEmpty || _phoneRegex.hasMatch(text)) return null;
        return AppStrings.phoneOptionalInvalid;
      },
    );
    if (result != null) _profile.setPhone(result);
  }

  Future<void> _editEmail() async {
    final result = await showEditSheet(
      context,
      title: AppStrings.settingsEmail,
      initial: _profile.email,
      keyboard: TextInputType.emailAddress,
      validator: (v) => _emailRegex.hasMatch((v ?? '').trim())
          ? null
          : AppStrings.emailInvalid,
    );
    if (result != null) _profile.setEmail(result);
  }

  Future<void> _logout() async {
    final ok = await showConfirmDialog(
      context,
      title: AppStrings.settingsLogoutConfirm,
    );
    if (!ok || !mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
          (route) => false,
    );
  }

  Future<void> _deleteAccount() async {
    final ok = await showConfirmDialog(
      context,
      title: AppStrings.settingsDeleteConfirmTitle,
      text: AppStrings.settingsDeleteConfirmText,
    );
    if (!ok || !mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
          (route) => false,
    );
  }

  Future<void> _editGroup() async {
    final result = await showGroupSheet(context, _profile.outageGroup);
    if (result != null) _profile.setOutageGroup(result);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScale(context);
    final avatarSize = s.w(0.46);

    return Scaffold(
      backgroundColor: AppColors.fieldSolid,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: s.w(0.07)),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ListenableBuilder(
                listenable: _profile,
                builder: (context, _) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.loginAccent,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: avatarSize,
                        height: avatarSize,
                        child: Stack(
                          children: [
                            ProfileAvatar(size: avatarSize, shadow: true),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: _pickAvatar,
                                child: Container(
                                  width: avatarSize * 0.26,
                                  height: avatarSize * 0.26,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.loginAccent,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.photo_camera_outlined,
                                    size: avatarSize * 0.13,
                                    color: AppColors.loginAccent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: s.w(0.03)),
                      GestureDetector(
                        onTap: _editName,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                _profile.name.isEmpty
                                    ? AppStrings.settingsDefaultName
                                    : _profile.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: s.font(0.075),
                                  color: AppColors.loginAccent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: AppColors.loginAccent,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: s.w(0.06)),
                      _Card(
                        child: Column(
                          children: [
                            _InfoRow(
                              label: AppStrings.settingsPhone,
                              value: _profile.phone.isEmpty
                                  ? AppStrings.settingsAddPhone
                                  : _profile.phone,
                              muted: _profile.phone.isEmpty,
                              fontScale: s,
                              onTap: _editPhone,
                            ),
                            _InfoRow(
                              label: AppStrings.settingsEmail,
                              value: _profile.email.isEmpty
                                  ? AppStrings.settingsAddEmail
                                  : _profile.email,
                              muted: _profile.email.isEmpty,
                              fontScale: s,
                              onTap: _editEmail,
                            ),
                            _InfoRow(
                              label: AppStrings.settingsOutageGroup,
                              value: _profile.outageGroup.isEmpty
                                  ? AppStrings.settingsChooseGroup
                                  : _profile.outageGroup,
                              muted: _profile.outageGroup.isEmpty,
                              fontScale: s,
                              onTap: _editGroup,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: s.w(0.07)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.settingsNotifications,
                          style: TextStyle(
                            fontSize: s.font(0.065),
                            color: AppColors.loginAccent,
                          ),
                        ),
                      ),
                      SizedBox(height: s.w(0.025)),
                      _Card(
                        child: Column(
                          children: [
                            _SwitchRow(
                              label: AppStrings.settingsAirAlert,
                              value: _airAlert,
                              fontScale: s,
                              onChanged: (v) => setState(() => _airAlert = v),
                            ),
                            _SwitchRow(
                              label: AppStrings.settingsOutages,
                              value: _outages,
                              fontScale: s,
                              onChanged: (v) => setState(() => _outages = v),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: s.w(0.07)),
                      SizedBox(
                        width: double.infinity,
                        height: s.w(0.13),
                        child: OutlinedButton(
                          onPressed: _logout,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.fieldSolid,
                            foregroundColor: AppColors.loginAccent,
                            shape: const StadiumBorder(),
                            side: const BorderSide(
                              color: AppColors.loginAccent,
                              width: 2,
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              AppStrings.settingsLogout,
                              style: TextStyle(fontSize: s.font(0.055)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: s.w(0.03)),
                      SizedBox(
                        width: double.infinity,
                        height: s.w(0.13),
                        child: ElevatedButton(
                          onPressed: _deleteAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.loginAccent,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              AppStrings.settingsDeleteAccount,
                              style: TextStyle(fontSize: s.font(0.055)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: s.w(0.08)),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.homeCard,
        borderRadius: BorderRadius.circular(28),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.fontScale,
    required this.onTap,
    this.muted = false,
  });

  final String label;
  final String value;
  final AppScale fontScale;
  final VoidCallback onTap;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: fontScale.font(0.035),
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: fontScale.font(0.055),
                      color: muted
                          ? AppColors.loginAccent.withValues(alpha: 0.5)
                          : AppColors.loginAccent,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.fontScale,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final AppScale fontScale;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontScale.font(0.055),
                color: AppColors.loginAccent,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.loginAccent,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.fieldSolid,
            trackOutlineColor: const WidgetStatePropertyAll(
              AppColors.loginAccent,
            ),
          ),
        ],
      ),
    );
  }
}