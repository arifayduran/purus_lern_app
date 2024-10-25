class User {
  String id;
  String username;
  String firstname;
  String lastname;
  String fullname;
  String email;
  String department;
  String firstAccess;
  String lastAccess;
  String auth;
  String suspended;
  String confirmed;
  String lang;
  String theme;
  String timezone;
  String mailFormat;
  String description;
  String descriptionFormat;
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
    required this.firstAccess,
    required this.lastAccess,
    required this.auth,
    required this.suspended,
    required this.confirmed,
    required this.lang,
    required this.theme,
    required this.timezone,
    required this.mailFormat,
    required this.description,
    required this.descriptionFormat,
    required this.city,
    required this.country,
    required this.profileImageUrlSmall,
    required this.profileImageUrl,
    required this.customFields,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      fullname: json['fullname'],
      email: json['email'],
      department: json['department'] ?? '',
      firstAccess: json['firstaccess'].toString(),
      lastAccess: json['lastaccess'].toString(),
      auth: json['auth'],
      suspended: json['suspended'].toString(),
      confirmed: json['confirmed'].toString(),
      lang: json['lang'],
      theme: json['theme'] ?? '',
      timezone: json['timezone'] ?? '',
      mailFormat: json['mailformat'].toString(),
      description: json['description'] ?? '',
      descriptionFormat: json['descriptionformat'].toString(),
      city: json['city'],
      country: json['country'],
      profileImageUrlSmall: json['profileimageurlsmall'],
      profileImageUrl: json['profileimageurl'],
      customFields: (json['customfields'] as List)
          .map((item) => CustomField.fromJson(item))
          .toList(),
      preferences: (json['preferences'] as List)
          .map((item) => Preference.fromJson(item))
          .toList(),
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
      'firstaccess': firstAccess,
      'lastaccess': lastAccess,
      'auth': auth,
      'suspended': suspended,
      'confirmed': confirmed,
      'lang': lang,
      'theme': theme,
      'timezone': timezone,
      'mailformat': mailFormat,
      'description': description,
      'descriptionformat': descriptionFormat,
      'city': city,
      'country': country,
      'profileimageurlsmall': profileImageUrlSmall,
      'profileimageurl': profileImageUrl,
      'customfields': customFields.map((field) => field.toJson()).toList(),
      'preferences': preferences.map((pref) => pref.toJson()).toList(),
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
      value: json['value'].toString(),
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
      value: json['value'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}
