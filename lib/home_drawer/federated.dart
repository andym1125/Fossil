import 'package:flutter/material.dart';

const List<String> list = <String>['Federated', 'Local', 'Global'];

class ViewList extends StatefulWidget{
  const ViewList({super.key});

  @override
  State<ViewList> createState() => _ViewListState();
}

class _ViewListState extends State<ViewList> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward_outlined),
      elevation: 50,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(right: 150.0),
            child: Row(
              children: [
                const Icon(
                  Icons.public, 
                  color: Color(0xFF8134AF)
                ),
                SizedBox(width: 8),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF8134AF)
                  )
                )
              ],
            ),
          )
        );
      }).toList()
    );
  }
}