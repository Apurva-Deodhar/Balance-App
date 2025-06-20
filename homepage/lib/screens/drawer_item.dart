import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final GestureTapCallback onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? textColor;
  final bool isSelected;

  const DrawerItem({
    super.key, 
    required this.icon, 
    required this.text, 
    required this.onTap,
    this.trailing,
    this.iconColor,
    this.textColor,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected 
            ? (isDarkMode ? theme.primaryColor.withOpacity(0.2) : theme.primaryColor.withOpacity(0.1))
            : Colors.transparent,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: iconColor ?? 
                 (isSelected 
                     ? theme.primaryColor 
                     : (isDarkMode ? Colors.white70 : Colors.black87)),
          size: 24,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: textColor ?? 
                   (isSelected 
                       ? theme.primaryColor 
                       : (isDarkMode ? Colors.white70 : Colors.black87)),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hoverColor: isDarkMode 
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        splashColor: theme.primaryColor.withOpacity(0.1),
      ),
    );
  }
}

// Specialized DrawerItem for theme toggle
class ThemeToggleDrawerItem extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggle;

  const ThemeToggleDrawerItem({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIsDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          isDarkMode ? Icons.wb_sunny : Icons.nights_stay,
          color: currentIsDarkMode ? Colors.white70 : Colors.black87,
          size: 24,
        ),
        title: Text(
          'Toggle Theme',
          style: TextStyle(
            color: currentIsDarkMode ? Colors.white70 : Colors.black87,
            fontSize: 16,
          ),
        ),
        trailing: Switch(
          value: isDarkMode,
          onChanged: onToggle,
          activeColor: theme.primaryColor,
          activeTrackColor: theme.primaryColor.withOpacity(0.3),
          inactiveThumbColor: currentIsDarkMode ? Colors.grey[400] : Colors.grey[600],
          inactiveTrackColor: currentIsDarkMode 
              ? Colors.grey[800] 
              : Colors.grey[300],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hoverColor: currentIsDarkMode 
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
      ),
    );
  }
}