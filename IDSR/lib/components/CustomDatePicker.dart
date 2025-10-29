import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;

  const CustomDatePicker({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    onDateSelected(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pickDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(   
          selectedDate != null
              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
              : 'Select Date',
          style: TextStyle(
            color: selectedDate != null ? Colors.black : Colors.grey[600],
          ),
        ),  
      ),
    );
  }
}
