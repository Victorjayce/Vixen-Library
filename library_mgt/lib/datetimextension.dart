extension DateTimeExtension on DateTime {
  String get timeAgo {
    final difference = DateTime.now().difference(this);

    if (difference.inSeconds < 60) {
      return 'Less than a minute ago';
    }

    if (difference.inMinutes == 1) {
      return '1 minute ago';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    }

    if (difference.inHours == 1) {
      return '1 hour ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }

    if (difference.inDays < 14) {
      return 'Last week';
    }

    if (difference.inDays < 21) {
      return '2 weeks ago';
    }

    if (difference.inDays < 28) {
      return '3 weeks ago';
    }

    if (difference.inDays < 60) {
      return 'Last month';
    }

    if (difference.inDays < 90) {
      return '2 months ago';
    }

    return '3 months ago';
  }
}
