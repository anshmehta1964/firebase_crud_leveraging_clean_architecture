mixin AppLocale {
  static const String title = 'title';
  static const String signIn = 'signin';
  static const String logIn = 'login';
  static const String signUp = 'Signup';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String create = 'create';
  static const String read = 'read';
  static const String update = 'update';
  static const String appbar = 'appbar';
  static const String email = 'email';
  static const String pass = 'pass';
  static const String themebutton = 'themebutton';
  static const String emailerror = 'emailerror';
  static const String passerror = 'passerror';
  static const String dataerror = 'dataerror';
  static const String emailAndPassError = 'emailAndPassError';

  static const Map<String, dynamic> EN = {
    title: 'Welcome',
    signIn: 'Sign in',
    signUp: 'Signup',
    logIn: 'Login',
    name: 'Name',
    phone: 'Phone',
    email: 'Email',
    pass: 'Password',
    create: 'Create',
    read: 'Read',
    update: 'Update',
    appbar: 'Firebase Crud',
    themebutton: 'Change theme',
    emailerror: 'Please enter a valid mail',
    passerror : 'Please enter a valid password',
    dataerror: 'Data is not valid',
    emailAndPassError: 'Email or password is not valid'
  };
  static const Map<String, dynamic> HI = {
    title: 'नमस्ते',
    signIn: 'साइन इन',
    signUp: 'साइन अप',
    logIn: 'लॉग इन',
    name: 'नाम',
    email: 'ईमेल',
    pass: 'पासवर्ड',
    phone: 'फ़ोन',
    create: 'बनाये',
    read: 'पढ़े',
    update: 'बदले',
    appbar: 'फायरबेस क्रूड',
    themebutton: 'थीम बदलना',
    emailerror: 'कृपया एक मान्य ईमेल दर्ज करें',
    passerror : 'कृपया एक वैध पासवर्ड दर्ज करें',
    dataerror: 'डेटा मान्य नहीं है',
    emailAndPassError: 'ईमेल या पासवर्ड मान्य नहीं है'
  };
  static const Map<String, dynamic> GR = {
    title: 'Willkommen',
    signIn: 'anmelden',
    signUp: 'Melden Sie sich an',
    logIn: 'Einloggen',
    name: 'Name',
    email: 'E-Mail',
    pass: 'Passwort',
    phone: 'Telefon',
    create: 'Erstellen',
    read: 'Lesen',
    update: 'Aktualisieren',
    appbar: 'Firebase Crud',
    themebutton: 'Themenschaltfläche',
    emailerror: 'Bitte geben Sie eine gültige E-Mail-Adresse ein',
    passerror : 'Bitte geben Sie ein gültiges Passwort ein',
    dataerror: 'Daten sind ungültig',
    emailAndPassError: 'E-Mail oder Passwort ist ungültig'
  };
}