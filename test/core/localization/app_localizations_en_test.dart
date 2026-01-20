import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/localization/l10n/app_localizations_en.dart';

void main() {
  group('AppLocalizationsEn', () {
    late AppLocalizationsEn appLocalizationsEn;

    setUp(() {
      appLocalizationsEn = AppLocalizationsEn();
    });

    test('home returns correct value', () {
      expect(appLocalizationsEn.home, 'Home');
    });

    test('upload returns correct value', () {
      expect(appLocalizationsEn.upload, 'Upload');
    });

    test('settings returns correct value', () {
      expect(appLocalizationsEn.settings, 'Settings');
    });

    test('map returns correct value', () {
      expect(appLocalizationsEn.map, 'Map');
    });

    test('cancel returns correct value', () {
      expect(appLocalizationsEn.cancel, 'Cancel');
    });

    test('refresh returns correct value', () {
      expect(appLocalizationsEn.refresh, 'Refresh');
    });

    test('change_map_type returns correct value', () {
      expect(appLocalizationsEn.change_map_type, 'Change map type');
    });

    test('direct_story_access_not_support returns correct value', () {
      expect(
        appLocalizationsEn.direct_story_access_not_support,
        'Direct story access not supported. Redirect to home.',
      );
    });

    test('welcome_back returns correct value', () {
      expect(appLocalizationsEn.welcome_back, 'Welcome Back');
    });

    test('sign_in_to_continue returns correct value', () {
      expect(appLocalizationsEn.sign_in_to_continue, 'Sign in to continue');
    });

    test('email returns correct value', () {
      expect(appLocalizationsEn.email, 'Email');
    });

    test('email_form returns correct value', () {
      expect(appLocalizationsEn.email_form, 'Email form');
    });

    test('enter_email returns correct value', () {
      expect(appLocalizationsEn.enter_email, 'Please enter your email');
    });

    test('enter_valid_email returns correct value', () {
      expect(
        appLocalizationsEn.enter_valid_email,
        'Please enter a valid email',
      );
    });

    test('password returns correct value', () {
      expect(appLocalizationsEn.password, 'Password');
    });

    test('password_form returns correct value', () {
      expect(appLocalizationsEn.password_form, 'Password form');
    });

    test('enter_password returns correct value', () {
      expect(appLocalizationsEn.enter_password, 'Please enter your password');
    });

    test('password_minimum returns correct value', () {
      expect(
        appLocalizationsEn.password_minimum,
        'Password must be at least 8 characters long',
      );
    });

    test('forgot_password returns correct value', () {
      expect(appLocalizationsEn.forgot_password, 'Forgot Password?');
    });

    test('login_upper returns correct value', () {
      expect(appLocalizationsEn.login_upper, 'LOGIN');
    });

    test('login_lower returns correct value', () {
      expect(appLocalizationsEn.login_lower, 'Login');
    });

    test('dont_have_account returns correct value', () {
      expect(appLocalizationsEn.dont_have_account, 'Don\'t have an account?');
    });

    test('register_lower returns correct value', () {
      expect(appLocalizationsEn.register_lower, 'Register');
    });

    test('register_upper returns correct value', () {
      expect(appLocalizationsEn.register_upper, 'REGISTER');
    });

    test('register_success returns correct value', () {
      expect(appLocalizationsEn.register_success, 'Register success');
    });

    test('register_failed returns correct value', () {
      expect(appLocalizationsEn.register_failed, 'Register gailed');
    });

    test('only_for_ui returns correct value', () {
      expect(
        appLocalizationsEn.only_for_ui,
        'This feature only for user interface (UI).',
      );
    });

    test('create_account returns correct value', () {
      expect(appLocalizationsEn.create_account, 'Create Account');
    });

    test('sign_up_to_get_started returns correct value', () {
      expect(
        appLocalizationsEn.sign_up_to_get_started,
        'Sign up to get started',
      );
    });

    test('full_name returns correct value', () {
      expect(appLocalizationsEn.full_name, 'Full Name');
    });

    test('enter_full_name returns correct value', () {
      expect(appLocalizationsEn.enter_full_name, 'Please enter your name');
    });

    test('confirm_password returns correct value', () {
      expect(appLocalizationsEn.confirm_password, 'Confirm Password');
    });

    test('confirm_your_password returns correct value', () {
      expect(
        appLocalizationsEn.confirm_your_password,
        'Please confirm your password',
      );
    });

    test('password_is_not_same returns correct value', () {
      expect(appLocalizationsEn.password_is_not_same, 'Passwords do not match');
    });

    test('already_have_account returns correct value', () {
      expect(
        appLocalizationsEn.already_have_account,
        'Already have an account?',
      );
    });

    test('dark_theme returns correct value', () {
      expect(appLocalizationsEn.dark_theme, 'Dark Theme');
    });

    test('language returns correct value', () {
      expect(appLocalizationsEn.language, 'Language');
    });

    test('view_source_code returns correct value', () {
      expect(appLocalizationsEn.view_source_code, 'Source Code');
    });

    test('view_on_github should  returns correct value', () {
      expect(appLocalizationsEn.view_on_github, 'Open GitHub Repository');
    });

    test('build_with_flutter should  returns correct value', () {
      expect(appLocalizationsEn.build_with_flutter, 'Built with Flutter');
    });

    test('learn_flutter should  returns correct value', () {
      expect(appLocalizationsEn.learn_flutter, 'Learn more about Flutter');
    });

    test('english returns correct value', () {
      expect(appLocalizationsEn.english, 'English');
    });

    test('indonesian returns correct value', () {
      expect(appLocalizationsEn.indonesian, 'Indonesian');
    });

    test('story_details returns correct value', () {
      expect(appLocalizationsEn.story_details, 'Story Details');
    });

    test('location returns correct value', () {
      expect(appLocalizationsEn.location, 'Location');
    });

    test('location_available returns correct value', () {
      expect(appLocalizationsEn.location_available, 'Location available');
    });

    test('latitude returns correct value', () {
      expect(appLocalizationsEn.latitude, 'Latitude');
    });

    test('longitude returns correct value', () {
      expect(appLocalizationsEn.longitude, 'Longitude');
    });

    test('map_view returns correct value', () {
      expect(appLocalizationsEn.map_view, 'Map view would appear here');
    });

    test('loading_address returns correct value', () {
      expect(appLocalizationsEn.loading_address, 'Loading address');
    });

    test('address_not_available returns correct value', () {
      expect(appLocalizationsEn.address_not_available, 'Address not available');
    });

    test('show_more returns correct value', () {
      expect(appLocalizationsEn.show_more, 'Show more');
    });

    test('show_less returns correct value', () {
      expect(appLocalizationsEn.show_less, 'Show less');
    });

    test('no_user_data returns correct value', () {
      expect(appLocalizationsEn.no_user_data, 'User data not available');
    });

    test('error_loading_stories returns correct value', () {
      expect(
        appLocalizationsEn.error_loading_stories,
        'Error loading stories: ',
      );
    });

    test('no_stories returns correct value', () {
      expect(appLocalizationsEn.no_stories, 'No stories available');
    });

    test('pull_to_refresh returns correct value', () {
      expect(
        appLocalizationsEn.pull_to_refresh,
        'Pull down to refresh or tap + to add a new story',
      );
    });

    test('logout_success returns correct value', () {
      expect(appLocalizationsEn.logout_success, 'Logout success');
    });

    test('retry returns correct value', () {
      expect(appLocalizationsEn.retry, 'Retry');
    });

    test('logout returns correct value', () {
      expect(appLocalizationsEn.logout, 'Logout');
    });

    test('logout_description  returns correct value', () {
      expect(appLocalizationsEn.logout_description, 'Logout of your account');
    });

    test('logout_confirmation returns correct value', () {
      expect(appLocalizationsEn.logout_confirmation, 'Logout Confirmation');
    });

    test('logout_confirmation_msg returns correct value', () {
      expect(
        appLocalizationsEn.logout_confirmation_msg,
        'Are you sure you want to logout?',
      );
    });

    test('login_succes returns correct value', () {
      expect(appLocalizationsEn.login_succes, 'Login success!');
    });

    test('login_failed returns correct value', () {
      expect(
        appLocalizationsEn.login_failed,
        'Login failed. Please try again.',
      );
    });

    test('language_updated returns correct value', () {
      expect(
        appLocalizationsEn.language_updated,
        'Language successfully updated',
      );
    });

    test('just_now returns correct value', () {
      expect(appLocalizationsEn.just_now, 'Just now');
    });

    test('yesterday returns correct value', () {
      expect(appLocalizationsEn.yesterday, 'Yesterday');
    });

    test('d_ago_singular returns correct value', () {
      expect(appLocalizationsEn.d_ago_singular, 'day ago');
    });

    test('d_ago_plural returns correct value', () {
      expect(appLocalizationsEn.d_ago_plural, 'days ago');
    });

    test('h_ago_singular returns correct value', () {
      expect(appLocalizationsEn.h_ago_singular, 'hour ago');
    });

    test('h_ago_plural returns correct value', () {
      expect(appLocalizationsEn.h_ago_plural, 'hours ago');
    });

    test('m_ago_singular returns correct value', () {
      expect(appLocalizationsEn.m_ago_singular, 'minute ago');
    });

    test('m_ago_plural returns correct value', () {
      expect(appLocalizationsEn.m_ago_plural, 'minutes ago');
    });

    test('upload_story returns correct value', () {
      expect(appLocalizationsEn.upload_story, 'Upload Story');
    });

    test('camera returns correct value', () {
      expect(appLocalizationsEn.camera, 'Camera');
    });

    test('gallery returns correct value', () {
      expect(appLocalizationsEn.gallery, 'Gallery');
    });

    test('change_image returns correct value', () {
      expect(appLocalizationsEn.change_image, 'Change Image');
    });

    test('image_too_large returns correct value', () {
      expect(
        appLocalizationsEn.image_too_large,
        'Image is too large. Maximum size is 1MB.',
      );
    });

    test('error_taking_picture returns correct value', () {
      expect(appLocalizationsEn.error_taking_picture, 'Error taking picture:');
    });

    test('error_picking_image returns correct value', () {
      expect(appLocalizationsEn.error_picking_image, 'Error picking image:');
    });

    test('error_accessing_camera returns correct value', () {
      expect(
        appLocalizationsEn.error_accessing_camera,
        'Error accessing camera:',
      );
    });

    test('error_initializing_camera returns correct value', () {
      expect(
        appLocalizationsEn.error_initializing_camera,
        'Error initializing camera:',
      );
    });

    test('error_switching_camera returns correct value', () {
      expect(
        appLocalizationsEn.error_switching_camera,
        'Error switching camera:',
      );
    });

    test('camera_access_denied returns correct value', () {
      expect(appLocalizationsEn.camera_access_denied, 'Camera access denied');
    });

    test('camera_used_by_other returns correct value', () {
      expect(
        appLocalizationsEn.camera_used_by_other,
        'Camera is in use by another app or tab. Please close other camera apps and try again.',
      );
    });

    test('please_select_image returns correct value', () {
      expect(
        appLocalizationsEn.please_select_image,
        'Please select an image first!',
      );
    });

    test('please_write_caption returns correct value', () {
      expect(
        appLocalizationsEn.please_write_caption,
        'Sorry, caption cannot be empty',
      );
    });

    test('story_upload_success returns correct value', () {
      expect(
        appLocalizationsEn.story_upload_success,
        'Story uploaded successfully!',
      );
    });

    test('request_camera_permission returns correct value', () {
      expect(
        appLocalizationsEn.request_camera_permission,
        'Requesting camera permission...',
      );
    });

    test('initializing_camera returns correct value', () {
      expect(appLocalizationsEn.initializing_camera, 'Initializing camera...');
    });

    test('write_a_caption returns correct value', () {
      expect(appLocalizationsEn.write_a_caption, 'Write a caption...');
    });

    test('uploading_story returns correct value', () {
      expect(appLocalizationsEn.uploading_story, 'Uploading story...');
    });

    test('center_map returns correct value', () {
      expect(appLocalizationsEn.center_map, 'Center map');
    });

    test('tap_to_select_location returns correct value', () {
      expect(
        appLocalizationsEn.tap_to_select_location,
        'Tap to select location',
      );
    });

    test('use_current_location returns correct value', () {
      expect(appLocalizationsEn.use_current_location, 'Use current');
    });

    test('location_error returns correct value', () {
      expect(
        appLocalizationsEn.location_error,
        'Unable to access your location. Please check your permissions.',
      );
    });

    test('location_services_disabled returns correct value', () {
      expect(
        appLocalizationsEn.location_services_disabled,
        'Location services are disabled.',
      );
    });

    test('location_permissions_denied returns correct value', () {
      expect(
        appLocalizationsEn.location_permissions_denied,
        'Location permissions are denied.',
      );
    });

    test('location_permissions_permanently_denied returns correct value', () {
      expect(
        appLocalizationsEn.location_permissions_permanently_denied,
        'Location permissions are permanently denied. Please enable them in your device settings. Or you can select location manually',
      );
    });

    test('premium_feature returns correct value', () {
      expect(appLocalizationsEn.premium_feature, 'Premium Feature');
    });

    test('upgrade_to_add_location returns correct value', () {
      expect(
        appLocalizationsEn.upgrade_to_add_location,
        'Upgrade to Premium to add location to your stories',
      );
    });

    test('upgrade_now returns correct value', () {
      expect(appLocalizationsEn.upgrade_now, 'Upgrade Now');
    });

    test('get_premium returns correct value', () {
      expect(appLocalizationsEn.get_premium, 'Get Premium');
    });

    test('premium_benefits_description returns correct value', () {
      expect(
        appLocalizationsEn.premium_benefits_description,
        'Upgrade to Storyzz Premium to enjoy additional features  adding location to your stories!',
      );
    });

    test('upgrade returns correct value', () {
      expect(appLocalizationsEn.upgrade, 'Upgrade');
    });

    test('close returns correct value', () {
      expect(appLocalizationsEn.close, 'Close');
    });

    test('open_full_screen  returns correct value', () {
      expect(appLocalizationsEn.open_full_screen, 'Open Full Screen');
    });

    test('coming_soon returns correct value', () {
      expect(appLocalizationsEn.coming_soon, 'Upgrade feature coming soon!');
    });

    test('story_not_found returns correct value', () {
      expect(appLocalizationsEn.story_not_found, 'Story Not Found');
    });

    test('page_not_found returns correct value', () {
      expect(appLocalizationsEn.page_not_found, 'Page Not Found');
    });

    test('page_not_found_description returns correct value', () {
      expect(
        appLocalizationsEn.page_not_found_description,
        'The page you\'re looking for doesn\'t exist or has been moved.',
      );
    });

    test('go_to_home returns correct value', () {
      expect(appLocalizationsEn.go_to_home, 'Go to Home');
    });

    test('account returns correct value', () {
      expect(appLocalizationsEn.account, 'Account');
    });

    test('appearance returns correct value', () {
      expect(appLocalizationsEn.appearance, 'Appearance');
    });

    test('about returns correct value', () {
      expect(appLocalizationsEn.about, 'About Us');
    });

    test('version returns correct value', () {
      expect(appLocalizationsEn.version, 'Version: ');
    });

    test('last_update returns correct value', () {
      expect(appLocalizationsEn.last_update, 'Last updated: ');
    });
  });
}
