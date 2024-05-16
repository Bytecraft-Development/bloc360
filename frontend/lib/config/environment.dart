class EnvironmentConfig {
  static const KEYCLOAK_LOGIN_URL = String.fromEnvironment('KEYCLOAK_LOGIN_URL');
  static const API_URL = String.fromEnvironment('API_URL');
  static const KEYCLOAK_CLIENT_ID = String.fromEnvironment('KEYCLOAK_CLIENT_ID');
}