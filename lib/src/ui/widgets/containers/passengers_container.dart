import 'package:flutter/material.dart';
import 'package:qadam/src/model/passenger_model.dart';
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/dialogs/bottom_dialog.dart';
import 'package:qadam/src/ui/widgets/texts/text_14h_400w.dart';

class PassengersContainer extends StatefulWidget {
  const PassengersContainer({
    super.key,
    required this.passenger,
    required this.onEdit,
    required this.onDelete,
  });

  final PassengerModel passenger;
  final Function(PassengerModel data) onEdit;
  final Function() onDelete;

  @override
  State<PassengersContainer> createState() => _PassengersContainerState();
}

class _PassengersContainerState extends State<PassengersContainer> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 270,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.light,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 24,
                    color: AppTheme.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text14h400w(title: widget.passenger.fullName)),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: (){
                    widget.onDelete();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 24,
                      color: AppTheme.red,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isTapped = !isTapped;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      isTapped == false ? Icons.keyboard_arrow_down_outlined: Icons.keyboard_arrow_up_outlined,
                      size: 24,
                      color: AppTheme.black,
                    ),
                  ),
                ),
              ],
            ),
            isTapped == true
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Text14h400w(
                              title: widget.passenger.email,
                              color: AppTheme.gray,
                            ),
                            const SizedBox(height: 8),
                            Text14h400w(
                              title: widget.passenger.phoneNumber,
                              color: AppTheme.gray,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          BottomDialog.showAddPassenger(
                            context,
                            widget.passenger,
                            (data) {
                              widget.onEdit(data);
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.mode_edit_outline,
                            size: 24,
                            color: AppTheme.black,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
