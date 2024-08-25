import 'package:flutter/material.dart';

class AlertDialogBuilder {
  final BuildContext context;
  String? title;
  String? message;
  String? posButtonTitle;
  String? negButtonTitle;
  String? neutralButtonTitle;
  VoidCallback? onPositiveButtonClick;
  VoidCallback? onNegativeButtonClick;
  VoidCallback? onNeutralButtonClick;
  List<String>? items;
  List<bool>? checkedItems;
  ValueChanged<List<bool>>? onItemsSelected;
  int selectedItemIndex = -1;
  ValueChanged<int>? onItemSelected;
  List<String>? reorderableItems;
  ValueChanged<List<String>>? onReorderedItems;
  bool isReorderableMultiSelectable = false;
  Widget? customView;
  VoidCallback? onShow;
  VoidCallback? attach;
  VoidCallback? onDismiss;
  VoidCallback? onCancel;
  bool cancelable = true;

  AlertDialogBuilder(this.context);

  AlertDialogBuilder setCancelable(bool cancelable) {
    this.cancelable = cancelable;
    return this;
  }

  AlertDialogBuilder setOnCancelListener(VoidCallback onCancel) {
    this.onCancel = onCancel;
    return this;
  }

  AlertDialogBuilder setOnShowListener(VoidCallback onShow) {
    this.onShow = onShow;
    return this;
  }

  AlertDialogBuilder setOnAttachListener(VoidCallback attach) {
    this.attach = attach;
    return this;
  }

  AlertDialogBuilder setOnDismissListener(VoidCallback onDismiss) {
    this.onDismiss = onDismiss;
    return this;
  }

  AlertDialogBuilder setTitle(String? title) {
    this.title = title;
    return this;
  }

  AlertDialogBuilder setMessage(String? message) {
    this.message = message;
    return this;
  }

  AlertDialogBuilder setCustomView(Widget customView) {
    this.customView = customView;
    return this;
  }

  AlertDialogBuilder setPosButton(String? title, VoidCallback? onClick) {
    posButtonTitle = title;
    onPositiveButtonClick = onClick;
    return this;
  }

  AlertDialogBuilder setNegButton(String? title, VoidCallback? onClick) {
    negButtonTitle = title;
    onNegativeButtonClick = onClick;
    return this;
  }

  AlertDialogBuilder setNeutralButton(String? title, VoidCallback? onClick) {
    neutralButtonTitle = title;
    onNeutralButtonClick = onClick;
    return this;
  }

  AlertDialogBuilder singleChoiceItems(List<String> items,
      int selectedItemIndex, ValueChanged<int> onItemSelected) {
    this.items = items;
    this.selectedItemIndex = selectedItemIndex;
    this.onItemSelected = onItemSelected;
    return this;
  }

  AlertDialogBuilder multiChoiceItems(List<String> items,
      List<bool>? checkedItems, ValueChanged<List<bool>> onItemsSelected) {
    this.items = items;
    this.checkedItems = checkedItems ?? List<bool>.filled(items.length, false);
    this.onItemsSelected = onItemsSelected;
    return this;
  }

  AlertDialogBuilder reorderableItem(
      List<String> items, ValueChanged<List<String>> onReorderedItems) {
    reorderableItems = items;
    this.onReorderedItems = onReorderedItems;
    return this;
  }

  AlertDialogBuilder reorderableMultiSelectableItems(
      List<String> items,
      List<bool>? checkedItems,
      ValueChanged<List<String>> onReorderedItems,
      ValueChanged<List<bool>> onReorderedItemsSelected) {
    reorderableItems = items;
    this.checkedItems =
        checkedItems ?? List<bool>.filled(items.length, false);
    this.onReorderedItems = onReorderedItems;
    onItemsSelected = onReorderedItemsSelected;
    isReorderableMultiSelectable = true;
    return this;
  }

  void show() {
    var theme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      barrierDismissible: cancelable,
      builder: (BuildContext context) {
        if (onShow != null) onShow!();
        return AlertDialog(
          title: Text(title ?? ''),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.primary,
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return _buildContent(setState);
            },
          ),
          actions: _buildActions(),
        );
      },
    ).then((_) {
      if (onDismiss != null) onDismiss!();
    });

    if (attach != null) {
      attach!();
    }
  }

  Widget _buildContent(StateSetter setState) {
    if (reorderableItems != null) {
      if (isReorderableMultiSelectable) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final items = List<String>.from(reorderableItems!);
                    final checkedStates = List<bool>.from(checkedItems!);
                    final item = items.removeAt(oldIndex);
                    final state = checkedStates.removeAt(oldIndex);
                    items.insert(newIndex, item);
                    checkedStates.insert(newIndex, state);

                    setState(() {
                      reorderableItems = items;
                      checkedItems = checkedStates;
                    });

                    if (onReorderedItems != null) onReorderedItems!(items);
                    if (onItemsSelected != null) onItemsSelected!(checkedStates);
                  },
                  children: reorderableItems!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return CheckboxListTile(
                      key: ValueKey(item),
                      title: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: checkedItems![index],
                      onChanged: (bool? value) {
                        setState(() {
                          checkedItems![index] = value!;
                        });
                        if (onItemsSelected != null) onItemsSelected!(checkedItems!);
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      } else {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              final items = List<String>.from(reorderableItems!);
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final item = items.removeAt(oldIndex);
              items.insert(newIndex, item);
              setState(() {
                reorderableItems = items;
              });
              if (onReorderedItems != null) onReorderedItems!(items);
            },
            children: reorderableItems!.map((String item) {
              return ListTile(
                key: ValueKey(item),
                title: Text(item),
              );
            }).toList(),
          ),
        );
      }
    } else if (items != null) {
      if (onItemSelected != null) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items!.map((String item) {
                return RadioListTile<int>(
                  title: Text(item),
                  value: items!.indexOf(item),
                  groupValue: selectedItemIndex,
                  onChanged: (int? value) {
                    selectedItemIndex = value!;
                    onItemSelected!(value);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      } else if (checkedItems != null && onItemsSelected != null) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items!.map((String item) {
                final index = items!.indexOf(item);
                return CheckboxListTile(
                  title: Text(
                    item,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  value: checkedItems![index],
                  onChanged: (bool? value) {
                    setState(() {
                      checkedItems![index] = value!;
                    });
                    onItemsSelected!(checkedItems!);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ),
          ),
        );
      }
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: customView ?? Text(message ?? ''),
    );
  }

  List<Widget> _buildActions() {
    var theme = Theme.of(context).colorScheme;
    final actions = <Widget>[];
    if (neutralButtonTitle != null) {
      actions.add(
        TextButton(
          onPressed: () {
            if (onNeutralButtonClick != null) onNeutralButtonClick!();
            Navigator.of(context).pop();
          },
          child: Text(
            neutralButtonTitle!,
            style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    if (negButtonTitle != null) {
      actions.add(
        TextButton(
          onPressed: () {
            if (onNegativeButtonClick != null) onNegativeButtonClick!();
            Navigator.of(context).pop();
          },
          child: Text(
            negButtonTitle!,
            style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    if (posButtonTitle != null) {
      actions.add(
        TextButton(
          onPressed: () {
            if (onPositiveButtonClick != null) onPositiveButtonClick!();
            Navigator.of(context).pop();
          },
          child: Text(
            posButtonTitle!,
            style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return actions;
  }
}

extension CustomAlertDialog on BuildContext {
  AlertDialogBuilder customAlertDialog() {
    return AlertDialogBuilder(this);
  }
}
