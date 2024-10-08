// ignore_for_file: public_member_api_docs, sort_constructors_first
class Culture {
  final String languageCode;
  final String countryCode;

  Culture(this.languageCode, [this.countryCode = '']);

  @override
  bool operator ==(covariant Culture other) {
    if (identical(this, other)) return true;

    return other.languageCode == languageCode &&
        other.countryCode == countryCode;
  }

  @override
  int get hashCode => languageCode.hashCode ^ countryCode.hashCode;
}
