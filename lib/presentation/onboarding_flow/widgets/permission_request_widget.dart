import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionRequestWidget extends StatefulWidget {
  final VoidCallback onPermissionsGranted;

  const PermissionRequestWidget({
    Key? key,
    required this.onPermissionsGranted,
  }) : super(key: key);

  @override
  State<PermissionRequestWidget> createState() =>
      _PermissionRequestWidgetState();
}

class _PermissionRequestWidgetState extends State<PermissionRequestWidget> {
  bool _cameraGranted = false;
  bool _notificationGranted = false;
  bool _calendarGranted = false;
  bool _isRequesting = false;

  final List<Map<String, dynamic>> _permissions = [
    {
      'title': 'Camera Access',
      'description': 'Scan barcodes to quickly add items to your inventory',
      'icon': 'camera_alt',
      'permission': Permission.camera,
      'required': true,
    },
    {
      'title': 'Notifications',
      'description': 'Get alerts for low stock items and meal reminders',
      'icon': 'notifications',
      'permission': Permission.notification,
      'required': true,
    },
    {
      'title': 'Calendar Integration',
      'description': 'Sync your meal plans with your device calendar',
      'icon': 'calendar_today',
      'permission': Permission.calendarFullAccess,
      'required': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          children: [
            // Header
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    size: 15.w,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Enable Essential Features',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Grant permissions to unlock the full potential of your kitchen management experience.',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Permission list
            Expanded(
              flex: 5,
              child: ListView.separated(
                itemCount: _permissions.length,
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  final permission = _permissions[index];
                  return _buildPermissionCard(permission);
                },
              ),
            ),

            SizedBox(height: 3.h),

            // Action buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _isRequesting ? null : _requestAllPermissions,
                    child: _isRequesting
                        ? SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text('Grant Permissions'),
                  ),
                ),
                SizedBox(height: 1.h),
                TextButton(
                  onPressed: _isRequesting ? null : widget.onPermissionsGranted,
                  child: Text('Skip for Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionCard(Map<String, dynamic> permission) {
    bool isGranted = _getPermissionStatus(permission['permission']);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: isGranted
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: isGranted
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: permission['icon'],
              size: 6.w,
              color: isGranted
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(width: 4.w),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        permission['title'],
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (permission['required'])
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                        child: Text(
                          'Required',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  permission['description'],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Status indicator
          if (isGranted)
            CustomIconWidget(
              iconName: 'check_circle',
              size: 6.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
        ],
      ),
    );
  }

  bool _getPermissionStatus(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return _cameraGranted;
      case Permission.notification:
        return _notificationGranted;
      case Permission.calendarFullAccess:
        return _calendarGranted;
      default:
        return false;
    }
  }

  Future<void> _requestAllPermissions() async {
    setState(() => _isRequesting = true);

    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();
      _cameraGranted = cameraStatus.isGranted;

      // Request notification permission
      final notificationStatus = await Permission.notification.request();
      _notificationGranted = notificationStatus.isGranted;

      // Request calendar permission (optional)
      final calendarStatus = await Permission.calendarFullAccess.request();
      _calendarGranted = calendarStatus.isGranted;

      setState(() {});

      // Check if required permissions are granted
      if (_cameraGranted && _notificationGranted) {
        widget.onPermissionsGranted();
      }
    } catch (e) {
      // Handle permission request errors gracefully
      widget.onPermissionsGranted();
    } finally {
      setState(() => _isRequesting = false);
    }
  }
}
