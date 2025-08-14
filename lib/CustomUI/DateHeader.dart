import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHeader extends StatelessWidget {
  final String date;

  const DateHeader({Key? key, required this.date}) : super(key: key);

  String _getRelativeDate(String dateString) {
    try {
      DateTime messageDate = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime messageDay = DateTime(messageDate.year, messageDate.month, messageDate.day);
      
      int difference = today.difference(messageDay).inDays;
      
      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Yesterday';
      } else if (difference < 7) {
        return '${difference} days ago';
      } else {
        // After one week, show the full date format
        return _formatFullDate(messageDate);
      }
    } catch (e) {
      // If date parsing fails, return the original date string
      return dateString;
    }
  }

  String _formatFullDate(DateTime date) {
    // Format: "January 15, 2024" or "Jan 15, 2024"
    List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    String month = months[date.month - 1];
    String day = date.day.toString();
    String year = date.year.toString();
    
    return '$month $day, $year';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getRelativeDate(date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
