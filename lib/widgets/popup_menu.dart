import 'package:flutter/material.dart';

/// The values that a PopupMenuItem can use for this app
enum PopupItem { delete, duplicate, addGripType, editGripTypes }

/// The details used to create a single PopupMenuItem
class PopupItemDetail {
  /// The text to display for this item
  final String itemText;

  /// The icon to display after the text
  final IconData iconData;

  /// The function to execute when the item is tapped
  final VoidCallback onTap;

  /// The PopupItem value
  final PopupItem popupItemType;

  PopupItemDetail(
      {required this.iconData,
      required this.onTap,
      required this.popupItemType,
      required this.itemText});
}

/// A Popup Menu dynamically created using the given list of popup item details
class PopupMenu extends StatelessWidget {
  final List<PopupItemDetail> popupItemDetails;

  const PopupMenu({super.key, required this.popupItemDetails});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (BuildContext context) => popupItemDetails
            .map((item) => PopupMenuItem<PopupItem>(
                  value: item.popupItemType,
                  onTap: item.onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 150,
                          child: Text(item.itemText,
                              style: const TextStyle(fontSize: 20.0))),
                      Icon(
                        item.iconData,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ))
            .toList());
  }
}
