import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../data/alert_repository.dart';
import '../models/alert_status.dart';
import 'alert_card.dart';

class AlertSection extends StatefulWidget {
  final AlertRepository? repository;

  const AlertSection({super.key, this.repository});

  @override
  State<AlertSection> createState() => _AlertSectionState();
}

class _AlertSectionState extends State<AlertSection>
    with WidgetsBindingObserver {
  static const Duration _refreshInterval = Duration(minutes: 1);

  late final AlertRepository _repository;
  Timer? _timer;
  AlertStatus? _status;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? AlertRepository();
    WidgetsBinding.instance.addObserver(this);
    _load();
    _timer = Timer.periodic(_refreshInterval, (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _load();
  }

  Future<void> _load() async {
    try {
      final status = await _repository.fetchStatus();
      if (!mounted) return;
      setState(() {
        _status = status;
        _failed = false;
      });
    } catch (e) {
      debugPrint('Alert error: $e');
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return AspectRatio(
        aspectRatio: AppDimens.homeAlertCardAspect,
        child: GestureDetector(
          onTap: _load,
          child: const AppCard(
            solid: true,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimens.homeAlertPadding),
                child: Text(
                  AppStrings.alertLoadError,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.homeWeatherAdvice,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final status = _status;
    if (status == null) {
      return const AspectRatio(
        aspectRatio: AppDimens.homeAlertCardAspect,
        child: AppCard(
          solid: true,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.homePrimary),
          ),
        ),
      );
    }

    return AlertCard(isActive: status.isAlarm);
  }
}