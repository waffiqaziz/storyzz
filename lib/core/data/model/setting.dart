class Setting {
  final bool isDark;
  final String locale;

  Setting({required this.isDark, required this.locale});

  Setting copyWith({bool? isDark, String? locale}) {
    return Setting(
      isDark: isDark ?? this.isDark,
      locale: locale ?? this.locale,
    );
  }
}
