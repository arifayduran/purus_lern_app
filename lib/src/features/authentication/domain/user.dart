class User {
  int id;
  String username;
  String firstname;
  String lastname;
  String fullname;
  String email;
  String department;
  int firstaccess;
  int lastaccess;
  String auth;
  bool suspended;
  bool confirmed;
  String lang;
  String theme;
  String timezone;
  int mailformat;
  String description;
  int descriptionformat;
  String city;
  String country;
  String profileImageUrlSmall;
  String profileImageUrl;
  List<CustomField> customFields;
  List<Preference> preferences;

  User({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.fullname,
    required this.email,
    required this.department,
    required this.firstaccess,
    required this.lastaccess,
    required this.auth,
    required this.suspended,
    required this.confirmed,
    required this.lang,
    required this.theme,
    required this.timezone,
    required this.mailformat,
    required this.description,
    required this.descriptionformat,
    required this.city,
    required this.country,
    required this.profileImageUrlSmall,
    required this.profileImageUrl,
    required this.customFields,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      fullname: json['fullname'],
      email: json['email'],
      department: json['department'] ?? '',
      firstaccess: json['firstaccess'] ?? 0,
      lastaccess: json['lastaccess'] ?? 0,
      auth: json['auth'],
      suspended: json['suspended'] ?? false,
      confirmed: json['confirmed'] ?? false,
      lang: json['lang'] ?? 'de',
      theme: json['theme'] ?? '',
      timezone: json['timezone'] ?? '99',
      mailformat: json['mailformat'] ?? 1,
      description: json['description'] ?? '',
      descriptionformat: json['descriptionformat'] ?? 1,
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      profileImageUrlSmall: json['profileimageurlsmall'] ?? '',
      profileImageUrl: json['profileimageurl'] ?? '',
      customFields: (json['customfields'] as List<dynamic>?)
              ?.map((field) => CustomField.fromJson(field))
              .toList() ??
          [], // Leere Liste als Fallback
      preferences: (json['preferences'] as List<dynamic>?)
              ?.map((pref) => Preference.fromJson(pref))
              .toList() ??
          [], // Leere Liste als Fallback
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'fullname': fullname,
      'email': email,
      'department': department,
      'firstaccess': firstaccess,
      'lastaccess': lastaccess,
      'auth': auth,
      'suspended': suspended,
      'confirmed': confirmed,
      'lang': lang,
      'theme': theme,
      'timezone': timezone,
      'mailformat': mailformat,
      'description': description,
      'descriptionformat': descriptionformat,
      'city': city,
      'country': country,
      'profileimageurlsmall': profileImageUrlSmall,
      'profileimageurl': profileImageUrl,
      'customfields': customFields.map((i) => i.toJson()).toList(),
      'preferences': preferences.map((i) => i.toJson()).toList(),
    };
  }
}

class CustomField {
  String type;
  String value;
  String name;
  String shortname;

  CustomField({
    required this.type,
    required this.value,
    required this.name,
    required this.shortname,
  });

  factory CustomField.fromJson(Map<String, dynamic> json) {
    return CustomField(
      type: json['type'],
      value: json['value'],
      name: json['name'],
      shortname: json['shortname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'name': name,
      'shortname': shortname,
    };
  }
}

class Preference {
  String name;
  String value;

  Preference({
    required this.name,
    required this.value,
  });

  factory Preference.fromJson(Map<String, dynamic> json) {
    return Preference(
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}
