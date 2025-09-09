import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../widgets/texts/text_14h_500w.dart';

class CustomSnackBar{

  void showSnackBar(BuildContext context, String message,
      int status,) {
    Color color;
    if (status == 1) {
      color = AppTheme.green;
    }else if (status == 2) {
      color = AppTheme.yellow;
    }else{
      color = AppTheme.red;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        duration: const Duration(milliseconds: 3270),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.dark.withOpacity(0.08),
                spreadRadius: 4,
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Accent stripe
              Container(
                width: 5,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),

              // Message text
              Expanded(
                child: Text14h500w(
                  title: message,
                ),
              ),

              // Optional close button
              GestureDetector(
                onTap: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}