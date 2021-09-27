import 'package:flutter/material.dart';
import 'package:hotelproject/api.dart';
import 'package:hotelproject/main.dart';

class Reservation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReservationState();
  }
}

class ReservationState extends State<Reservation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ApiService apiService;
  String _title = '';
  String input;
  String _msk;
  @override
  void initState() {
    apiService = new ApiService();
  }

  String _priority;

  final List<String> _room = [
    'single',
    'double',
    'triple',
  ];

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_title, $_priority $input');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('make a reservation'),
        ),
        body: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 40.0),
                    child: DropdownButtonFormField(
                      icon: Icon(Icons.arrow_drop_down_circle),
                      iconSize: 22.0,
                      items: _room.map((String msk) {
                        return DropdownMenuItem(
                          value: msk,
                          child: Text(
                            msk,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        );
                      }).toList(),
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(labelText: 'type of room'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (input) => _msk = input,
                      onChanged: (value) {
                        setState(() {
                          _msk = value;
                        });
                      },
                      value: _msk,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              height: 45.0,
              width: 210.0,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(
                    30.0,
                  )),
              child: TextButton(
                child: Text(
                  'submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  _submit();
                  print(_msk);
                  setState(() {
                    apiService.getHotels();
                  });
                  print(apiService.getHotels());
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MapScreen()));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('you made a reservation'),
                    duration: const Duration(seconds: 1),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {},
                    ),
                  ));
                },
              ),
            ),
          ],
        ));
  }
}
