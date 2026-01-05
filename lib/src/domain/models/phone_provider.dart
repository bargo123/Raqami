enum PhoneProvider {
  du,
  etisalat,
  virgin,
}

extension PhoneProviderExtension on PhoneProvider {
  String get name {
    switch (this) {
      case PhoneProvider.du:
        return 'du';
      case PhoneProvider.etisalat:
        return 'etisalat';
      case PhoneProvider.virgin:
        return 'virgin';
    }
  }

  String get displayName {
    switch (this) {
      case PhoneProvider.du:
        return 'du';
      case PhoneProvider.etisalat:
        return 'Etisalat';
      case PhoneProvider.virgin:
        return 'Virgin Mobile';
    }
  }

  List<String> get validCodes {
    switch (this) {
      case PhoneProvider.du:
      case PhoneProvider.etisalat:
        return ['05x', '050', '052', '054', '055', '056', '058'];
      case PhoneProvider.virgin:
        return ['05x', '058'];
    }
  }
}

