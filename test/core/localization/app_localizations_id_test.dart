import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/localization/l10n/app_localizations_id.dart';

void main() {
  group('AppLocalizationsId', () {
    late AppLocalizationsId appLocalizations;

    setUp(() {
      appLocalizations = AppLocalizationsId();
    });

    test('home should return "Beranda"', () {
      expect(appLocalizations.home, 'Beranda');
    });

    test('upload should return "Unggah"', () {
      expect(appLocalizations.upload, 'Unggah');
    });

    test('settings should return "Pengaturan"', () {
      expect(appLocalizations.settings, 'Pengaturan');
    });

    test('map should return "Peta"', () {
      expect(appLocalizations.map, 'Peta');
    });

    test('cancel should return "Batal"', () {
      expect(appLocalizations.cancel, 'Batal');
    });

    test('refresh should return "Muat ulang"', () {
      expect(appLocalizations.refresh, 'Muat ulang');
    });

    test('change_map_type should return "Ganti tema peta"', () {
      expect(appLocalizations.change_map_type, 'Ganti tema peta');
    });

    test(
      'direct_story_access_not_support should return "Akses langsung ke cerita tidak didukung. Dialihkan ke beranda."',
      () {
        expect(
          appLocalizations.direct_story_access_not_support,
          'Akses langsung ke cerita tidak didukung. Dialihkan ke beranda.',
        );
      },
    );

    test('welcome_back should return "Selamat Datang Kembali"', () {
      expect(appLocalizations.welcome_back, 'Selamat Datang Kembali');
    });

    test(
      'sign_in_to_continue should return "Silakan masuk untuk melanjutkan"',
      () {
        expect(
          appLocalizations.sign_in_to_continue,
          'Silakan masuk untuk melanjutkan',
        );
      },
    );

    test('email should return "Email"', () {
      expect(appLocalizations.email, 'Email');
    });

    test('email_form should return "Kolom email"', () {
      expect(appLocalizations.email_form, 'Kolom email');
    });

    test('enter_email should return "Mohon masukkan alamat email Anda"', () {
      expect(appLocalizations.enter_email, 'Mohon masukkan alamat email Anda');
    });

    test(
      'enter_valid_email should return "Mohon masukkan alamat email yang valid"',
      () {
        expect(
          appLocalizations.enter_valid_email,
          'Mohon masukkan alamat email yang valid',
        );
      },
    );

    test('password should return "Kata Sandi"', () {
      expect(appLocalizations.password, 'Kata Sandi');
    });

    test('password_form should return "Kolom kata sandi"', () {
      expect(appLocalizations.password_form, 'Kolom kata sandi');
    });

    test('enter_password should return "Mohon masukkan kata sandi Anda"', () {
      expect(appLocalizations.enter_password, 'Mohon masukkan kata sandi Anda');
    });

    test(
      'password_minimum should return "Kata sandi harus terdiri dari minimal 8 karakter"',
      () {
        expect(
          appLocalizations.password_minimum,
          'Kata sandi harus terdiri dari minimal 8 karakter',
        );
      },
    );

    test('forgot_password should return "Lupa Kata Sandi?"', () {
      expect(appLocalizations.forgot_password, 'Lupa Kata Sandi?');
    });

    test('login_upper should return "MASUK"', () {
      expect(appLocalizations.login_upper, 'MASUK');
    });

    test('login_lower should return "Masuk"', () {
      expect(appLocalizations.login_lower, 'Masuk');
    });

    test('dont_have_account should return "Belum memiliki akun?"', () {
      expect(appLocalizations.dont_have_account, 'Belum memiliki akun?');
    });

    test('register_lower should return "Daftar"', () {
      expect(appLocalizations.register_lower, 'Daftar');
    });

    test('register_upper should return "DAFTAR"', () {
      expect(appLocalizations.register_upper, 'DAFTAR');
    });

    test('register_success should return "Pendaftaran berhasil"', () {
      expect(appLocalizations.register_success, 'Pendaftaran berhasil');
    });

    test('register_failed should return "Pendaftaran gagal"', () {
      expect(appLocalizations.register_failed, 'Pendaftaran gagal');
    });

    test(
      'only_for_ui should return "Fitur ini hanya untuk tampilan antarmuka"',
      () {
        expect(
          appLocalizations.only_for_ui,
          'Fitur ini hanya untuk tampilan antarmuka',
        );
      },
    );

    test('create_account should return "Buat Akun"', () {
      expect(appLocalizations.create_account, 'Buat Akun');
    });

    test('sign_up_to_get_started should return "Daftar untuk memulai"', () {
      expect(appLocalizations.sign_up_to_get_started, 'Daftar untuk memulai');
    });

    test('full_name should return "Nama Lengkap"', () {
      expect(appLocalizations.full_name, 'Nama Lengkap');
    });

    test(
      'enter_full_name should return "Mohon masukkan nama lengkap Anda"',
      () {
        expect(
          appLocalizations.enter_full_name,
          'Mohon masukkan nama lengkap Anda',
        );
      },
    );

    test('confirm_password should return "Konfirmasi Kata Sandi"', () {
      expect(appLocalizations.confirm_password, 'Konfirmasi Kata Sandi');
    });

    test(
      'confirm_your_password should return "Mohon konfirmasi kata sandi Anda"',
      () {
        expect(
          appLocalizations.confirm_your_password,
          'Mohon konfirmasi kata sandi Anda',
        );
      },
    );

    test('password_is_not_same should return "Kata sandi tidak sesuai"', () {
      expect(appLocalizations.password_is_not_same, 'Kata sandi tidak sesuai');
    });

    test('already_have_account should return "Sudah memiliki akun?"', () {
      expect(appLocalizations.already_have_account, 'Sudah memiliki akun?');
    });

    test('dark_theme should return "Tema Gelap"', () {
      expect(appLocalizations.dark_theme, 'Tema Gelap');
    });

    test('language should return "Bahasa"', () {
      expect(appLocalizations.language, 'Bahasa');
    });

    test('view_source_code should return "Sumber Kode"', () {
      expect(appLocalizations.view_source_code, 'Sumber Kode');
    });

    test('view_on_github should return "Buka Repositori GitHub"', () {
      expect(appLocalizations.view_on_github, 'Buka Repositori GitHub');
    });

    test('build_with_flutter should return "Dikembangkan dengan Flutter"', () {
      expect(
        appLocalizations.build_with_flutter,
        'Dikembangkan dengan Flutter',
      );
    });

    test(
      'learn_flutter should return "Pelajari lebih lanjut tentang Flutter"',
      () {
        expect(
          appLocalizations.learn_flutter,
          'Pelajari lebih lanjut tentang Flutter',
        );
      },
    );

    test('english should return "Inggris"', () {
      expect(appLocalizations.english, 'Inggris');
    });

    test('indonesian should return "Indonesia"', () {
      expect(appLocalizations.indonesian, 'Indonesia');
    });

    test('story_details should return "Detail Cerita"', () {
      expect(appLocalizations.story_details, 'Detail Cerita');
    });

    test('location should return "Lokasi"', () {
      expect(appLocalizations.location, 'Lokasi');
    });

    test('location_available should return "Lokasi tersedia"', () {
      expect(appLocalizations.location_available, 'Lokasi tersedia');
    });

    test('latitude should return "Garis Lintang"', () {
      expect(appLocalizations.latitude, 'Garis Lintang');
    });

    test('longitude should return "Garis Bujur"', () {
      expect(appLocalizations.longitude, 'Garis Bujur');
    });

    test('map_view should return "Tampilan Peta"', () {
      expect(appLocalizations.map_view, 'Tampilan Peta');
    });

    test('loading_address should return "Memuat alamat"', () {
      expect(appLocalizations.loading_address, 'Memuat alamat');
    });

    test('address_not_available should return "Alamat tidak tersedia"', () {
      expect(appLocalizations.address_not_available, 'Alamat tidak tersedia');
    });

    test('show_more should return "Lihat Selengkapnya"', () {
      expect(appLocalizations.show_more, 'Lihat Selengkapnya');
    });

    test('show_less should return "Sembunyikan"', () {
      expect(appLocalizations.show_less, 'Sembunyikan');
    });

    test('no_user_data should return "Data pengguna tidak tersedia"', () {
      expect(appLocalizations.no_user_data, 'Data pengguna tidak tersedia');
    });

    test(
      'error_loading_stories should return "Terjadi kesalahan saat memuat cerita:"',
      () {
        expect(
          appLocalizations.error_loading_stories,
          'Terjadi kesalahan saat memuat cerita:',
        );
      },
    );

    test('no_stories should return "Tidak ada cerita yang tersedia"', () {
      expect(appLocalizations.no_stories, 'Tidak ada cerita yang tersedia');
    });

    test(
      'pull_to_refresh should return "Tarik ke bawah untuk menyegarkan atau ketuk tombol + untuk menambahkan cerita baru"',
      () {
        expect(
          appLocalizations.pull_to_refresh,
          'Tarik ke bawah untuk menyegarkan atau ketuk tombol + untuk menambahkan cerita baru',
        );
      },
    );

    test('logout_success should return "Berhasil keluar"', () {
      expect(appLocalizations.logout_success, 'Berhasil keluar');
    });

    test('retry should return "Coba Lagi"', () {
      expect(appLocalizations.retry, 'Coba Lagi');
    });

    test('logout should return "Keluar"', () {
      expect(appLocalizations.logout, 'Keluar');
    });

    test('logout_description  returns correct value', () {
      expect(appLocalizations.logout_description, 'Keluar dari akun Anda');
    });

    test('logout_confirmation should return "Konfirmasi keluar"', () {
      expect(appLocalizations.logout_confirmation, 'Konfirmasi keluar');
    });

    test(
      'logout_confirmation_msg should return "Apakah Anda yakin ingin keluar?"',
      () {
        expect(
          appLocalizations.logout_confirmation_msg,
          'Apakah Anda yakin ingin keluar?',
        );
      },
    );

    test('login_succes should return "Berhasil masuk"', () {
      expect(appLocalizations.login_succes, 'Berhasil masuk');
    });

    test('login_failed should return "Gagal masuk. Silakan coba kembali."', () {
      expect(
        appLocalizations.login_failed,
        'Gagal masuk. Silakan coba kembali.',
      );
    });

    test('language_updated should return "Bahasa berhasil diperbarui"', () {
      expect(appLocalizations.language_updated, 'Bahasa berhasil diperbarui');
    });

    test('just_now should return "Baru saja"', () {
      expect(appLocalizations.just_now, 'Baru saja');
    });

    test('yesterday returns correct value', () {
      expect(appLocalizations.yesterday, 'Kemarin');
    });

    test('d_ago_singular should return "hari yang lalu"', () {
      expect(appLocalizations.d_ago_singular, 'hari yang lalu');
    });

    test('d_ago_plural should return "hari yang lalu"', () {
      expect(appLocalizations.d_ago_plural, 'hari yang lalu');
    });

    test('h_ago_singular should return "jam yang lalu"', () {
      expect(appLocalizations.h_ago_singular, 'jam yang lalu');
    });

    test('h_ago_plural should return "jam yang lalu"', () {
      expect(appLocalizations.h_ago_plural, 'jam yang lalu');
    });

    test('m_ago_singular should return "menit yang lalu"', () {
      expect(appLocalizations.m_ago_singular, 'menit yang lalu');
    });

    test('m_ago_plural should return "menit yang lalu"', () {
      expect(appLocalizations.m_ago_plural, 'menit yang lalu');
    });

    test('upload_story should return "Unggah Cerita"', () {
      expect(appLocalizations.upload_story, 'Unggah Cerita');
    });

    test('camera should return "Kamera"', () {
      expect(appLocalizations.camera, 'Kamera');
    });

    test('gallery should return "Galeri"', () {
      expect(appLocalizations.gallery, 'Galeri');
    });

    test('change_image should return "Ganti Gambar"', () {
      expect(appLocalizations.change_image, 'Ganti Gambar');
    });

    test(
      'image_too_large should return "Ukuran gambar terlalu besar. Ukuran maksimum adalah 1MB."',
      () {
        expect(
          appLocalizations.image_too_large,
          'Ukuran gambar terlalu besar. Ukuran maksimum adalah 1MB.',
        );
      },
    );

    test(
      'error_taking_picture should return "Terjadi kesalahan saat mengambil gambar:"',
      () {
        expect(
          appLocalizations.error_taking_picture,
          'Terjadi kesalahan saat mengambil gambar:',
        );
      },
    );

    test(
      'error_picking_image should return "Terjadi kesalahan saat memilih gambar:"',
      () {
        expect(
          appLocalizations.error_picking_image,
          'Terjadi kesalahan saat memilih gambar:',
        );
      },
    );

    test('error_accessing_camera should return "Akses kamera ditolak"', () {
      expect(appLocalizations.error_accessing_camera, 'Akses kamera ditolak');
    });

    test(
      'error_initializing_camera should return "Terjadi kesalahan saat menyiapkan kamera:"',
      () {
        expect(
          appLocalizations.error_initializing_camera,
          'Terjadi kesalahan saat menyiapkan kamera:',
        );
      },
    );

    test(
      'error_switching_camera should return "Terjadi kesalahan saat mengganti kamera:"',
      () {
        expect(
          appLocalizations.error_switching_camera,
          'Terjadi kesalahan saat mengganti kamera:',
        );
      },
    );

    test('camera_access_denied should return "Akses ke kamera ditolak:"', () {
      expect(appLocalizations.camera_access_denied, 'Akses ke kamera ditolak:');
    });

    test(
      'camera_used_by_other should return "Kamera sedang digunakan oleh aplikasi atau tab lain. Silakan tutup aplikasi kamera lainnya dan coba kembali."',
      () {
        expect(
          appLocalizations.camera_used_by_other,
          'Kamera sedang digunakan oleh aplikasi atau tab lain. Silakan tutup aplikasi kamera lainnya dan coba kembali.',
        );
      },
    );

    test(
      'please_select_image should return "Mohon pilih gambar terlebih dahulu"',
      () {
        expect(
          appLocalizations.please_select_image,
          'Mohon pilih gambar terlebih dahulu',
        );
      },
    );

    test(
      'please_write_caption should return "Mohon isi keterangan terlebih dahulu"',
      () {
        expect(
          appLocalizations.please_write_caption,
          'Mohon isi keterangan terlebih dahulu',
        );
      },
    );

    test('story_upload_success should return "Cerita berhasil diunggah"', () {
      expect(appLocalizations.story_upload_success, 'Cerita berhasil diunggah');
    });

    test(
      'request_camera_permission should return "Meminta izin akses kamera..."',
      () {
        expect(
          appLocalizations.request_camera_permission,
          'Meminta izin akses kamera...',
        );
      },
    );

    test('initializing_camera should return "Menyiapkan kamera..."', () {
      expect(appLocalizations.initializing_camera, 'Menyiapkan kamera...');
    });

    test('write_a_caption should return "Tulis keterangan..."', () {
      expect(appLocalizations.write_a_caption, 'Tulis keterangan...');
    });

    test('uploading_story should return "Sedang mengunggah cerita..."', () {
      expect(appLocalizations.uploading_story, 'Sedang mengunggah cerita...');
    });

    test('center_map should return "Pusatkan peta"', () {
      expect(appLocalizations.center_map, 'Pusatkan peta');
    });

    test(
      'tap_to_select_location should return "Ketuk untuk menentukan lokasi"',
      () {
        expect(
          appLocalizations.tap_to_select_location,
          'Ketuk untuk menentukan lokasi',
        );
      },
    );

    test('use_current_location should return "Gunakan saat ini"', () {
      expect(appLocalizations.use_current_location, 'Gunakan saat ini');
    });

    test(
      'location_error should return "Tidak dapat mengakses lokasi Anda. Silakan periksa izin Anda."',
      () {
        expect(
          appLocalizations.location_error,
          'Tidak dapat mengakses lokasi Anda. Silakan periksa izin Anda.',
        );
      },
    );

    test(
      'location_services_disabled should return "Layanan lokasi dinonaktifkan."',
      () {
        expect(
          appLocalizations.location_services_disabled,
          'Layanan lokasi dinonaktifkan.',
        );
      },
    );

    test(
      'location_permissions_denied should return "Izin lokasi ditolak."',
      () {
        expect(
          appLocalizations.location_permissions_denied,
          'Izin lokasi ditolak.',
        );
      },
    );

    test(
      'location_permissions_permanently_denied should return "Izin lokasi ditolak secara permanen. Harap aktifkan di pengaturan perangkat Anda. Atau anda bisa menentukan lokasi secara manual"',
      () {
        expect(
          appLocalizations.location_permissions_permanently_denied,
          'Izin lokasi ditolak secara permanen. Harap aktifkan di pengaturan perangkat Anda. Atau anda bisa menentukan lokasi secara manual',
        );
      },
    );

    test('premium_feature should return "Fitur Premium"', () {
      expect(appLocalizations.premium_feature, 'Fitur Premium');
    });

    test(
      'upgrade_to_add_location should return "Tingkatkan ke Premium untuk menambahkan lokasi ke cerita Anda"',
      () {
        expect(
          appLocalizations.upgrade_to_add_location,
          'Tingkatkan ke Premium untuk menambahkan lokasi ke cerita Anda',
        );
      },
    );

    test('upgrade_now should return "Tingkatkan Sekarang"', () {
      expect(appLocalizations.upgrade_now, 'Tingkatkan Sekarang');
    });

    test('get_premium should return "Dapatkan Fitur Premium"', () {
      expect(appLocalizations.get_premium, 'Dapatkan Fitur Premium');
    });

    test(
      'premium_benefits_description should return "Tingkatkan ke Storyzz Premium untuk menikmati fitur tambahan menambahkan lokasi ke cerita Anda!"',
      () {
        expect(
          appLocalizations.premium_benefits_description,
          'Tingkatkan ke Storyzz Premium untuk menikmati fitur tambahan menambahkan lokasi ke cerita Anda!',
        );
      },
    );

    test('upgrade should return "Tingkatkan"', () {
      expect(appLocalizations.upgrade, 'Tingkatkan');
    });

    test('close should return "Tutup"', () {
      expect(appLocalizations.close, 'Tutup');
    });

    
    test('open_full_screen  returns correct "Buka Layar Penuh"', () {
      expect(appLocalizations.open_full_screen , 'Buka Layar Penuh');
    });

    test('coming_soon should return "Fitur Premium segera hadir!"', () {
      expect(appLocalizations.coming_soon, 'Fitur Premium segera hadir!');
    });

    test('story_not_found should return "Postingan Tidak Ditemukan"', () {
      expect(appLocalizations.story_not_found, 'Postingan Tidak Ditemukan');
    });

    test('page_not_found should return "Halaman Tidak Ditemukan"', () {
      expect(appLocalizations.page_not_found, 'Halaman Tidak Ditemukan');
    });

    test(
      'page_not_found_description should return "Halaman yang Anda cari tidak ada atau telah dipindahkan."',
      () {
        expect(
          appLocalizations.page_not_found_description,
          'Halaman yang Anda cari tidak ada atau telah dipindahkan.',
        );
      },
    );

    test('go_to_home should return "Kembali ke Beranda"', () {
      expect(appLocalizations.go_to_home, 'Kembali ke Beranda');
    });

    test('account returns correct value', () {
      expect(appLocalizations.account, 'Akun');
    });

    test('appearance returns correct value', () {
      expect(appLocalizations.appearance, 'Tampilan');
    });

    test('about returns correct value', () {
      expect(appLocalizations.about, 'Tentang Aplikasi');
    });

    test('version returns correct value', () {
      expect(appLocalizations.version, 'Versi: ');
    });

    test('last_update returns correct value', () {
      expect(appLocalizations.last_update, 'Terakhir diperbaharui: ');
    });
  });
}
