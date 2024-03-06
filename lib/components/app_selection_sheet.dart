import 'package:flutter/material.dart';

import '../screens/pin_screen.dart';

showSelectionSheet(
  BuildContext context, {
  String? title,
  List<SelectionData>? data,
  OnChanged<SelectionData>? onSelect,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SelectionBottomSheet(
        title: title!,
        onSelect: onSelect!,
        items: data!,
      );
    },
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}

typedef OnChanged<T> = void Function(T value);

class SelectionBottomSheet<T> extends StatelessWidget {
  final OnChanged<T> onSelect;
  final String? title;

  final List<SelectionData> items;

  const SelectionBottomSheet({
    super.key,
    this.title,
    required this.onSelect,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .35,
      maxChildSize: .4,
      minChildSize: .2,
      builder: (context, _) {
        return Builder(
          builder: (context) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    40,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 34),
                  Text(
                    title ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xff058B42),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Color(0xff939393), height: 2),
                  Expanded(
                    child: Container(
                      color: const Color(0xffB11226).withOpacity(0.05),
                      child: ListView.separated(
                        controller: _,
                        itemBuilder: (_, idx) {
                          final item = items[idx];
                          return ListTile(
                            onTap: () {
                              onSelect(item as T);
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PinScreen(),
                                ),
                              );
                            },
                            leading: item.data != null ? Icon(item.data) : null,
                            dense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            title: Text(
                              item.title!,
                              style: const TextStyle(
                                color: Color(0xff2B2B2B),
                                fontSize: 16.0,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) {
                          return const Divider(
                            color: Color(0xff939393),
                            height: 2,
                          );
                        },
                        itemCount: items.length,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class SelectionData<T> {
  T? selection;
  String? title;
  IconData? data;
  String? icon;

  SelectionData({
    required this.selection,
    required this.title,
    this.data,
    this.icon,
  })  : assert(selection != null),
        assert(title != null);
}
