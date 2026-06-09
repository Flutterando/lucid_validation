/// Simulates a remote data source (database / API) so we can demonstrate
/// asynchronous validation (`mustAsync` + `validateAsync`).
class UserRepository {
  final Set<String> _takenEmails = {'taken@email.com', 'admin@email.com'};

  /// Simulates a network/database lookup to check if an e-mail is already in use.
  Future<bool> emailTaken(String email) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _takenEmails.contains(email.trim().toLowerCase());
  }
}
