abstract final class AppConfig {
  static const appName = 'Linghe Mobile Template';

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://example.com/api',
  );

  static const storageContainerName = 'linghe_mobile_template';
}
