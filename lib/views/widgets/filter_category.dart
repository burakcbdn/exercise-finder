import 'package:exercises_assistant_app/controllers/globals.dart';
import 'package:flutter/material.dart';

// Displays a filter category on filter drawer
class FilterCategory extends StatelessWidget {
  const FilterCategory({
    Key? key,
    // PageView controller
    required this.filterPageController,
    required this.index,
    // currently selected filter option
    required this.selection,
  }) : super(key: key);
  final int index;
  final PageController filterPageController;
  final String selection;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // go to selected filter category options
        filterPageController.jumpToPage(index);
      },
      title: Text(
        Globals.filterIndexData[index]!, // get filter category name
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: selection.isNotEmpty // show subtitle if any option is selected
          ? Text(
              selection,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Icon(
        Icons.chevron_right_outlined,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
