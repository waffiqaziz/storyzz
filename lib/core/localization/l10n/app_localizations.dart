import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @home.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get home;

  /// No description provided for @upload.
  ///
  /// In id, this message translates to:
  /// **'Unggah'**
  String get upload;

  /// No description provided for @settings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settings;

  /// No description provided for @map.
  ///
  /// In id, this message translates to:
  /// **'Peta'**
  String get map;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @refresh.
  ///
  /// In id, this message translates to:
  /// **'Muat ulang'**
  String get refresh;

  /// No description provided for @change_map_type.
  ///
  /// In id, this message translates to:
  /// **'Ganti tema peta'**
  String get change_map_type;

  /// No description provided for @direct_story_access_not_support.
  ///
  /// In id, this message translates to:
  /// **'Akses langsung ke cerita tidak didukung. Dialihkan ke beranda.'**
  String get direct_story_access_not_support;

  /// No description provided for @welcome_back.
  ///
  /// In id, this message translates to:
  /// **'Selamat Datang Kembali'**
  String get welcome_back;

  /// No description provided for @sign_in_to_continue.
  ///
  /// In id, this message translates to:
  /// **'Silakan masuk untuk melanjutkan'**
  String get sign_in_to_continue;

  /// No description provided for @email.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @email_form.
  ///
  /// In id, this message translates to:
  /// **'Kolom email'**
  String get email_form;

  /// No description provided for @enter_email.
  ///
  /// In id, this message translates to:
  /// **'Mohon masukkan alamat email Anda'**
  String get enter_email;

  /// No description provided for @enter_valid_email.
  ///
  /// In id, this message translates to:
  /// **'Mohon masukkan alamat email yang valid'**
  String get enter_valid_email;

  /// No description provided for @password.
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi'**
  String get password;

  /// No description provided for @password_form.
  ///
  /// In id, this message translates to:
  /// **'Kolom kata sandi'**
  String get password_form;

  /// No description provided for @enter_password.
  ///
  /// In id, this message translates to:
  /// **'Mohon masukkan kata sandi Anda'**
  String get enter_password;

  /// No description provided for @password_minimum.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi harus terdiri dari minimal 8 karakter'**
  String get password_minimum;

  /// No description provided for @forgot_password.
  ///
  /// In id, this message translates to:
  /// **'Lupa Kata Sandi?'**
  String get forgot_password;

  /// No description provided for @login_upper.
  ///
  /// In id, this message translates to:
  /// **'MASUK'**
  String get login_upper;

  /// No description provided for @login_lower.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get login_lower;

  /// No description provided for @dont_have_account.
  ///
  /// In id, this message translates to:
  /// **'Belum memiliki akun?'**
  String get dont_have_account;

  /// No description provided for @register_lower.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get register_lower;

  /// No description provided for @register_upper.
  ///
  /// In id, this message translates to:
  /// **'DAFTAR'**
  String get register_upper;

  /// No description provided for @register_success.
  ///
  /// In id, this message translates to:
  /// **'Pendaftaran berhasil'**
  String get register_success;

  /// No description provided for @register_failed.
  ///
  /// In id, this message translates to:
  /// **'Pendaftaran gagal'**
  String get register_failed;

  /// No description provided for @only_for_ui.
  ///
  /// In id, this message translates to:
  /// **'Fitur ini hanya untuk tampilan antarmuka'**
  String get only_for_ui;

  /// No description provided for @create_account.
  ///
  /// In id, this message translates to:
  /// **'Buat Akun'**
  String get create_account;

  /// No description provided for @sign_up_to_get_started.
  ///
  /// In id, this message translates to:
  /// **'Daftar untuk memulai'**
  String get sign_up_to_get_started;

  /// No description provided for @full_name.
  ///
  /// In id, this message translates to:
  /// **'Nama Lengkap'**
  String get full_name;

  /// No description provided for @enter_full_name.
  ///
  /// In id, this message translates to:
  /// **'Mohon masukkan nama lengkap Anda'**
  String get enter_full_name;

  /// No description provided for @confirm_password.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Kata Sandi'**
  String get confirm_password;

  /// No description provided for @confirm_your_password.
  ///
  /// In id, this message translates to:
  /// **'Mohon konfirmasi kata sandi Anda'**
  String get confirm_your_password;

  /// No description provided for @password_is_not_same.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi tidak sesuai'**
  String get password_is_not_same;

  /// No description provided for @already_have_account.
  ///
  /// In id, this message translates to:
  /// **'Sudah memiliki akun?'**
  String get already_have_account;

  /// No description provided for @dark_theme.
  ///
  /// In id, this message translates to:
  /// **'Tema Gelap'**
  String get dark_theme;

  /// No description provided for @language.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get language;

  /// No description provided for @view_source_code.
  ///
  /// In id, this message translates to:
  /// **'Lihat Kode Sumber'**
  String get view_source_code;

  /// No description provided for @english.
  ///
  /// In id, this message translates to:
  /// **'Inggris'**
  String get english;

  /// No description provided for @indonesian.
  ///
  /// In id, this message translates to:
  /// **'Indonesia'**
  String get indonesian;

  /// No description provided for @story_details.
  ///
  /// In id, this message translates to:
  /// **'Detail Cerita'**
  String get story_details;

  /// No description provided for @location.
  ///
  /// In id, this message translates to:
  /// **'Lokasi'**
  String get location;

  /// No description provided for @location_available.
  ///
  /// In id, this message translates to:
  /// **'Lokasi tersedia'**
  String get location_available;

  /// No description provided for @latitude.
  ///
  /// In id, this message translates to:
  /// **'Garis Lintang'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In id, this message translates to:
  /// **'Garis Bujur'**
  String get longitude;

  /// No description provided for @map_view.
  ///
  /// In id, this message translates to:
  /// **'Tampilan Peta'**
  String get map_view;

  /// No description provided for @loading_address.
  ///
  /// In id, this message translates to:
  /// **'Memuat alamat'**
  String get loading_address;

  /// No description provided for @address_not_available.
  ///
  /// In id, this message translates to:
  /// **'Alamat tidak tersedia'**
  String get address_not_available;

  /// No description provided for @show_more.
  ///
  /// In id, this message translates to:
  /// **'Lihat Selengkapnya'**
  String get show_more;

  /// No description provided for @show_less.
  ///
  /// In id, this message translates to:
  /// **'Sembunyikan'**
  String get show_less;

  /// No description provided for @no_user_data.
  ///
  /// In id, this message translates to:
  /// **'Data pengguna tidak tersedia'**
  String get no_user_data;

  /// No description provided for @error_loading_stories.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan saat memuat cerita:'**
  String get error_loading_stories;

  /// No description provided for @no_stories.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada cerita yang tersedia'**
  String get no_stories;

  /// No description provided for @pull_to_refresh.
  ///
  /// In id, this message translates to:
  /// **'Tarik ke bawah untuk menyegarkan atau ketuk tombol + untuk menambahkan cerita baru'**
  String get pull_to_refresh;

  /// No description provided for @logout_success.
  ///
  /// In id, this message translates to:
  /// **'Berhasil keluar'**
  String get logout_success;

  /// No description provided for @retry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get retry;

  /// No description provided for @logout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logout;

  /// No description provided for @login_succes.
  ///
  /// In id, this message translates to:
  /// **'Berhasil masuk'**
  String get login_succes;

  /// No description provided for @login_failed.
  ///
  /// In id, this message translates to:
  /// **'Gagal masuk. Silakan coba kembali.'**
  String get login_failed;

  /// No description provided for @language_updated.
  ///
  /// In id, this message translates to:
  /// **'Bahasa berhasil diperbarui'**
  String get language_updated;

  /// No description provided for @just_now.
  ///
  /// In id, this message translates to:
  /// **'Baru saja'**
  String get just_now;

  /// No description provided for @d_ago_singular.
  ///
  /// In id, this message translates to:
  /// **'hari yang lalu'**
  String get d_ago_singular;

  /// No description provided for @d_ago_plural.
  ///
  /// In id, this message translates to:
  /// **'hari yang lalu'**
  String get d_ago_plural;

  /// No description provided for @h_ago_singular.
  ///
  /// In id, this message translates to:
  /// **'jam yang lalu'**
  String get h_ago_singular;

  /// No description provided for @h_ago_plural.
  ///
  /// In id, this message translates to:
  /// **'jam yang lalu'**
  String get h_ago_plural;

  /// No description provided for @m_ago_singular.
  ///
  /// In id, this message translates to:
  /// **'menit yang lalu'**
  String get m_ago_singular;

  /// No description provided for @m_ago_plural.
  ///
  /// In id, this message translates to:
  /// **'menit yang lalu'**
  String get m_ago_plural;

  /// No description provided for @upload_story.
  ///
  /// In id, this message translates to:
  /// **'Unggah Cerita'**
  String get upload_story;

  /// No description provided for @camera.
  ///
  /// In id, this message translates to:
  /// **'Kamera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In id, this message translates to:
  /// **'Galeri'**
  String get gallery;

  /// No description provided for @change_image.
  ///
  /// In id, this message translates to:
  /// **'Ganti Gambar'**
  String get change_image;

  /// No description provided for @image_too_large.
  ///
  /// In id, this message translates to:
  /// **'Ukuran gambar terlalu besar. Ukuran maksimum adalah 1MB.'**
  String get image_too_large;

  /// No description provided for @error_taking_picture.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan saat mengambil gambar:'**
  String get error_taking_picture;

  /// No description provided for @error_picking_image.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan saat memilih gambar:'**
  String get error_picking_image;

  /// No description provided for @error_accessing_camera.
  ///
  /// In id, this message translates to:
  /// **'Akses kamera ditolak'**
  String get error_accessing_camera;

  /// No description provided for @error_initializing_camera.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan saat menyiapkan kamera:'**
  String get error_initializing_camera;

  /// No description provided for @error_switching_camera.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan saat mengganti kamera:'**
  String get error_switching_camera;

  /// No description provided for @camera_access_denied.
  ///
  /// In id, this message translates to:
  /// **'Akses ke kamera ditolak:'**
  String get camera_access_denied;

  /// No description provided for @camera_used_by_other.
  ///
  /// In id, this message translates to:
  /// **'Kamera sedang digunakan oleh aplikasi atau tab lain. Silakan tutup aplikasi kamera lainnya dan coba kembali.'**
  String get camera_used_by_other;

  /// No description provided for @please_select_image.
  ///
  /// In id, this message translates to:
  /// **'Mohon pilih gambar terlebih dahulu'**
  String get please_select_image;

  /// No description provided for @please_write_caption.
  ///
  /// In id, this message translates to:
  /// **'Mohon isi keterangan terlebih dahulu'**
  String get please_write_caption;

  /// No description provided for @story_upload_success.
  ///
  /// In id, this message translates to:
  /// **'Cerita berhasil diunggah'**
  String get story_upload_success;

  /// No description provided for @request_camera_permission.
  ///
  /// In id, this message translates to:
  /// **'Meminta izin akses kamera...'**
  String get request_camera_permission;

  /// No description provided for @initializing_camera.
  ///
  /// In id, this message translates to:
  /// **'Menyiapkan kamera...'**
  String get initializing_camera;

  /// No description provided for @write_a_caption.
  ///
  /// In id, this message translates to:
  /// **'Tulis keterangan...'**
  String get write_a_caption;

  /// No description provided for @uploading_story.
  ///
  /// In id, this message translates to:
  /// **'Sedang mengunggah cerita...'**
  String get uploading_story;

  /// No description provided for @tap_to_select_location.
  ///
  /// In id, this message translates to:
  /// **'Ketuk pada peta untuk memilih lokasi Anda'**
  String get tap_to_select_location;

  /// No description provided for @use_current_location.
  ///
  /// In id, this message translates to:
  /// **'Gunakan saat ini'**
  String get use_current_location;

  /// No description provided for @location_error.
  ///
  /// In id, this message translates to:
  /// **'Tidak dapat mengakses lokasi Anda. Silakan periksa izin Anda.'**
  String get location_error;

  /// No description provided for @location_services_disabled.
  ///
  /// In id, this message translates to:
  /// **'Layanan lokasi dinonaktifkan.'**
  String get location_services_disabled;

  /// No description provided for @location_permissions_denied.
  ///
  /// In id, this message translates to:
  /// **'Izin lokasi ditolak.'**
  String get location_permissions_denied;

  /// No description provided for @location_permissions_permanently_denied.
  ///
  /// In id, this message translates to:
  /// **'Izin lokasi ditolak secara permanen. Harap aktifkan di pengaturan perangkat Anda. Atau anda bisa menentukan lokasi secara manual'**
  String get location_permissions_permanently_denied;

  /// No description provided for @premium_feature.
  ///
  /// In id, this message translates to:
  /// **'Fitur Premium'**
  String get premium_feature;

  /// No description provided for @upgrade_to_add_location.
  ///
  /// In id, this message translates to:
  /// **'Tingkatkan ke Premium untuk menambahkan lokasi ke cerita Anda'**
  String get upgrade_to_add_location;

  /// No description provided for @upgrade_now.
  ///
  /// In id, this message translates to:
  /// **'Tingkatkan Sekarang'**
  String get upgrade_now;

  /// No description provided for @get_premium.
  ///
  /// In id, this message translates to:
  /// **'Dapatkan Fitur Premium'**
  String get get_premium;

  /// No description provided for @premium_benefits_description.
  ///
  /// In id, this message translates to:
  /// **'Tingkatkan ke Storyzz Premium untuk menikmati fitur tambahan menambahkan lokasi ke cerita Anda!'**
  String get premium_benefits_description;

  /// No description provided for @upgrade.
  ///
  /// In id, this message translates to:
  /// **'Tingkatkan'**
  String get upgrade;

  /// No description provided for @close.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get close;

  /// No description provided for @coming_soon.
  ///
  /// In id, this message translates to:
  /// **'Fitur Premium segera hadir!'**
  String get coming_soon;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
