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
            onTap: () {
              _showFullScreenImage(context, attachmentPath!);
            },
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // Aligns "own" messages to the right
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // More vertical spacing for chat bubbles
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Generous padding inside the bubble
          constraints: const BoxConstraints(maxWidth: 250), // Prevents overly wide bubbles
          decoration: BoxDecoration(
            color: const Color(0xffe1ffc7), // Original "own message" background
            borderRadius: const BorderRadius.only(
              // Typical chat bubble shape for "sent" messages (right-aligned)
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(0),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          // Replace Stack with Column for simpler, reliable layout
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // Aligns content (text/attachments) to the right
            children: [
              _buildAttachment(context), // Show attachment first (if any)
              
              // Show message text (if not empty)
              if (message != null && message!.isNotEmpty)
                Text(
                  message!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              
              // Show timestamp (only if time is provided)
              if (time != null && time!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4), // Space between message and timestamp
                  child: Text(
                    time!,
                    style: TextStyle(
                      fontSize: 11, // Small, unobtrusive size
                      color: Colors.grey[700], // Subtle color (doesn't clash)
                      fontWeight: FontWeight.normal, // Remove bold for natural look
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