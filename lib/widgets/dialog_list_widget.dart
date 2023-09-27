  import 'package:flutter/material.dart';

class DialogList extends StatefulWidget {
  final String title;
  final String value;
  final List<String> lista;

  const DialogList({super.key, required this.lista, required this.value, required this.title});

  @override
  State<DialogList> createState() => _DialogListState();
}

class _DialogListState extends State<DialogList> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.title),
          content: SingleChildScrollView(
            child: Column(
              children: widget.lista.map((opcion) {
                return ListTile(
                  title: Text(opcion),
                  onTap: () {
                    setState(() {
                      selectedValue = opcion;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDialog(context);
      },
      child: Text("Exchange: $selectedValue"),
    );
  }
}
