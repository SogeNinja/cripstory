import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    Key? key,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.search),
            hintText: widget.hintText,
            border: InputBorder.none,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
