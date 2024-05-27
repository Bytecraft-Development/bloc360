
import 'dart:html' as html;

class Logout {

  void logout() {
    html.window.localStorage.remove('access_token');
    html.window.localStorage.remove('refresh_token');
    html.window.location.href = '/login';
  }
}



