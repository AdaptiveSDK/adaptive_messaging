/// Thrown when the Adaptive Messaging SDK encounters a platform-level error.
class AdaptiveMessagingException implements Exception {
  final String code;
  final String message;

  const AdaptiveMessagingException({
    required this.code,
    required this.message,
  });

  @override
  String toString() => 'AdaptiveMessagingException[$code]: $message';
}
