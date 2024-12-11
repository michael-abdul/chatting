class Message {
  final String text;
  final String? to;
  final String? from;
  final String event;
  final String? fileName; 
  final String? fileUrl; 

  Message({
    required this.text,
    required this.event,
    this.to,
    this.from,
    this.fileName,
    this.fileUrl,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'] as String? ?? 'No Text',
      event: json['event'] as String,
      to: json['to'] as String?,
      from: json['from'] as String?,
      fileName: json['fileName'] as String?, 
      fileUrl: json['fileUrl'] as String?, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'data': {
        'text': text,
        if (to != null) 'to': to,
        if (from != null) 'from': from,
        if (fileName != null) 'fileName': fileName, 
        if (fileUrl != null) 'fileUrl': fileUrl, 
      }
    };
  }
}
