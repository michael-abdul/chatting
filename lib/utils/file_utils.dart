String getMimeType(String fileName) {
  if (fileName.endsWith('.pdf')) return 'application/pdf';
  if (fileName.endsWith('.jpg') ||
      fileName.endsWith('.jpeg') ||
      fileName.endsWith('.png')) {
    return 'image';
  }
  if (fileName.endsWith('.mp4') || fileName.endsWith('.mov')) return 'video';
  return 'unknown';
}
