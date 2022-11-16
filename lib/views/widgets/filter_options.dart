import 'package:flutter/material.dart';

// Display options of selected filter category
class FilterOptions extends StatefulWidget {
  FilterOptions({
    Key? key,
    // Data of selected filter category
    required this.data,
    // current selected option
    required this.selection,
    // event when option is tapped
    required this.onTap,
  }) : super(key: key);

  final Map<String, String> data;
  String selection;
  final Function(String) onTap;

  @override
  State<FilterOptions> createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: widget.data.keys.map<Widget>((e) {
              bool isSelected = widget.selection == e;
              // using checkbox listtile to display current selected option in a clean way
              // puts normal CheckBox widget to the right of the ListTile
              return CheckboxListTile(
                value: isSelected,
                title: Text(
                  widget.data[e]!,
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).primaryColor : null,
                  ),
                ),
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: const BorderSide(width: 0.5),
                onChanged: (v) {
                  if (!isSelected) {
                    setState(() {
                      widget.selection = e;
                    });
                    widget.onTap(e);
                  } else {
                    setState(() {
                      widget.selection = '';
                    });
                    widget.onTap('');
                  }
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
