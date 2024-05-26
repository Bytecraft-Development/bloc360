class EnvironmentConfig {
  static const KEYCLOAK_LOGIN_URL = String.fromEnvironment('KEYCLOAK_LOGIN_URL');
  static const KEYCLOAK_BASE_URL = String.fromEnvironment('KEYCLOAK_BASE_URL');
  static const API_URL = String.fromEnvironment('API_URL');
  static const KEYCLOAK_CLIENT_ID = String.fromEnvironment('KEYCLOAK_CLIENT_ID');
  static const GOOGLE_LOGIN_URL = '${KEYCLOAK_BASE_URL}/protocol/openid-connect/auth?client_id=bloc360google&redirect_uri=https://bloc360.live/auth.html&response_type=code&scope=openid&kc_idp_hint=google';

}
