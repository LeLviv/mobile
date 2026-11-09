import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';

const outageGroups = [
  '1.1', '1.2', '2.1', '2.2', '3.1', '3.2',
  '4.1', '4.2', '5.1', '5.2',
];

Future<String?> showEditSheet(
    BuildContext context, {
      required String title,
      required String initial,
      TextInputType keyboard = TextInputType.text,
      String? Function(String?)? validator,
    }) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.homeCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => _EditSheet(
      title: title,
      initial: initial,
      keyboard: keyboard,
      validator: validator,
    ),
  );
}

class _EditSheet extends StatefulWidget {
  const _EditSheet({
    required this.title,
    required this.initial,
    required this.keyboard,
    required this.validator,
  });

  final String title;
  final String initial;
  final TextInputType keyboard;
  final String? Function(String?)? validator;

  @override
  State<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<_EditSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller =
  TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 22,
                color: AppColors.loginAccent,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _controller,
              autofocus: true,
              keyboardType: widget.keyboard,
              validator: widget.validator,
              onFieldSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text(AppStrings.save),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.loginAccent,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> showGroupSheet(BuildContext context, String current) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.homeCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final group in outageGroups)
              GestureDetector(
                onTap: () => Navigator.pop(context, group),
                child: Container(
                  width: 72,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: group == current
                        ? AppColors.loginAccent
                        : AppColors.fieldSolid,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: AppColors.loginAccent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    group,
                    style: TextStyle(
                      fontSize: 20,
                      color: group == current
                          ? Colors.white
                          : AppColors.loginAccent,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

Future<bool> showConfirmDialog(
    BuildContext context, {
      required String title,
      String? text,
    }) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.homeCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.loginAccent),
      ),
      content: text == null
          ? null
          : Text(text, style: const TextStyle(color: Colors.black)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            AppStrings.cancel,
            style: TextStyle(color: AppColors.loginAccent),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            AppStrings.confirm,
            style: TextStyle(
              color: AppColors.loginAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}