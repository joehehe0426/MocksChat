import 'package:flutter/material.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({
    Key? key,
    this.message,
    this.time,
    this.attachmentType,
    this.attachmentPath,
    this.attachmentName,
  }) : super(key: key);

  final String? message;
  final String? time;
  final String? attachmentType;
  final String? attachmentPath;
  final String? attachmentName;

  // ... (keep _showFullScreenImage and _buildAttachment unchanged)
  void _showFullScreenImage(BuildContext context, String imagePath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text('Image', style: TextStyle(color: Colors.white)),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[900],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 100, color: Colors.grey[600]),
                          const SizedBox(height: 16),
                          Text(
                            'Image not found',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachment(BuildContext context) {
    if (attachmentType == null || attachmentPath == null) {
      return const SizedBox.shrink();
    }

    switch (attachmentType) {
      case 'image':
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () => _showFullScreenImage(context, attachmentPath!),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                attachmentPath!,
                width: 200,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
        );

      case 'document':
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              const Icon(Icons.insert_drive_file, color: Colors.blue, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachmentName ?? 'Document',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'PDF Document',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 'audio':
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              const Icon(Icons.play_circle_filled, color: Colors.green, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachmentName ?? 'Audio Message',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      '0:30',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Critical debug: Verify if the widget is receiving the time value
    debugPrint('=== OwnMessageCard Debug ===');
    debugPrint('Time value passed: $time');
    debugPrint('Message present: ${message != null && message!.isNotEmpty}');
    debugPrint('Attachment type: $attachmentType');

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Add a border to the main container to check clipping
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          padding: const EdgeInsets.all(16), // Extra padding to prevent clipping
          constraints: const BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            color: const Color(0xffe1ffc7),
            border: Border.all(color: Colors.red, width: 1), // Debug border
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAttachment(context),
              
              if (message != null && message!.isNotEmpty)
                const SizedBox(height: 8),
              
              if (message != null && message!.isNotEmpty)
                Text(
                  message!,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              
              // Simple timestamp at bottom right
              Container(
                color: Colors.red, // Debug color to make it visible
                padding: const EdgeInsets.only(top: 4, right: 4),
                child: Text(
                  'TIME: ${time ?? 'NULL'}', // Debug text
                  style: const TextStyle(
                    fontSize: 14, // Larger for debugging
                    color: Colors.white, // White on red background
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
    