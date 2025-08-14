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
            iconTheme: IconThemeData(color: Colors.white),
            title: Text('Image', style: TextStyle(color: Colors.white)),
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
                          SizedBox(height: 16),
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
      return SizedBox.shrink();
    }

    switch (attachmentType) {
      case 'image':
        return Container(
          margin: EdgeInsets.only(bottom: 8),
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
                    child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                  );
                },
              ),
            ),
          ),
        );
      
      case 'document':
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(Icons.insert_drive_file, color: Colors.blue, size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachmentName ?? 'Document',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(Icons.play_circle_filled, color: Colors.green, size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachmentName ?? 'Audio Message',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
        return SizedBox.shrink();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 1, horizontal: 8),
          padding: EdgeInsets.all(6),
          constraints: BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            color: Color(0xffe1ffc7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                                         _buildAttachment(context),
                    if (message != null && message!.isNotEmpty)
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            // Real message
                            TextSpan(
                              text: (message ?? '') + "    ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            // Fake timestamp as placeholder (invisible)
                            TextSpan(
                              text: time ?? '',
                              style: TextStyle(
                                color: Colors.transparent,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // Real timestamp positioned at bottom right
              Positioned(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time ?? '',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.done_all,
                      size: 14,
                      color: Colors.blue,
                    ),
                  ],
                ),
                right: -2.0,
                bottom: -0.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

