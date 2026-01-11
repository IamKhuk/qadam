import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/widgets/buttons/primary_button.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';

class VerifyCardDialog extends StatefulWidget {
  final Function(String) onVerify;

  const VerifyCardDialog({
    Key? key,
    required this.onVerify,
  }) : super(key: key);

  @override
  State<VerifyCardDialog> createState() => _VerifyCardDialogState();
}

class _VerifyCardDialogState extends State<VerifyCardDialog> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text16h500w(
              title: translate("auth.enter_code"),
              color: AppTheme.black,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: "123456",
                hintStyle: TextStyle(
                  color: AppTheme.gray.withOpacity(0.5),
                  fontSize: 24,
                  letterSpacing: 4,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.purple),
                ),
              ),
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                if (_codeController.text.isNotEmpty) {
                  widget.onVerify(_codeController.text);
                }
              },
              child: PrimaryButton(
                title: translate("auth.verify"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
