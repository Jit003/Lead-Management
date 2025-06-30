String getFullAudioUrl(String path) {
  const baseUrl = 'https://crm.kredipal.com';

  if (path.isEmpty) return '';

  if (path.startsWith('http')) return path;

  // Ensure no double slashes
  return '$baseUrl/${path.startsWith('/') ? path.substring(1) : path}';
}
