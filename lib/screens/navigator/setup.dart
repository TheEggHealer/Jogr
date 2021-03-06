import 'package:flutter/material.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:provider/provider.dart';

class Setup extends StatefulWidget {
  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  String name, date;
  String weight;
  List<bool> isSelected = [true, false];

  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1930),
        lastDate: DateTime.now());
    if(picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    DatabaseService db = DatabaseService(uid: user.uid);

    return Scaffold(
        backgroundColor: color_dark_background,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Center(
                    child: Text(
                      'First time setup',
                      style: textStyleHeaderLarge,
                    ),
                  ),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '• NAME',
                                style: textStyleDark
                            ),
                            SizedBox(height: 5,),
                            TextFormField(
                              validator: (val) => val.length > 20 ? 'Name too long.' : (val.isEmpty ? 'Enter your name.' : null),
                              onChanged: (val) {
                                setState(() {
                                  name = val;
                                });
                              },
                              cursorColor: color_dark_text_highlight,
                              decoration: InputDecoration(
                                filled: false,
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_dark)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_highlight)),
                                border: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_dark)),
                              ),
                              style: textStyleDarkLight,
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '• BIRTHDATE',
                                style: textStyleDark
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                OutlineButton(
                                  onPressed: () async {
                                    await _selectDate(context);
                                    date = selectedDate.toString().split(' ')[0];
                                  },
                                  child: Text('CHANGE'),
                                  color: color_dark_text_highlight,
                                  splashColor: color_dark_text_highlight,
                                  highlightColor: color_dark_text_highlight,
                                  focusColor: color_dark_text_highlight,
                                  textColor: color_dark_text_dark,
                                  borderSide: BorderSide(color: color_dark_text_highlight),
                                  highlightedBorderColor: color_dark_text_highlight,
                                ),
                                SizedBox(width: 30),
                                Text(
                                  selectedDate.toString().split(' ')[0],
                                  style: textStyleDarkLight,
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '• WEIGHT',
                                style: textStyleDark
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: TextFormField(
                                    onChanged: (val) {
                                      weight = val;
                                    },
                                    validator: weightValidator,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      filled: false,
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_dark)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_highlight)),
                                      border: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_dark)),
                                    ),
                                    style: textStyleDarkLight
                                  ),
                                ),
                                SizedBox(width: 30),
                                ToggleButtons(
                                  isSelected: isSelected,
                                  borderRadius: BorderRadius.circular(5),
                                  selectedColor: color_dark_text_highlight,
                                  disabledColor: color_dark_text_dark,
                                  highlightColor: color_dark_text_dark,
                                  borderColor: color_dark_text_dark,
                                  color: color_dark_text_dark,
                                  fillColor: Colors.transparent,
                                  onPressed: (selected) {
                                    setState(() {
                                      for (int i = 0; i < isSelected.length; i++) {
                                        isSelected[i] = i == selected;
                                      }
                                    });
                                  },
                                  selectedBorderColor: color_dark_text_highlight,
                                  borderWidth: 1,
                                  children: [
                                    Text('KG'),
                                    Text('LBS'),
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: OutlineButton(
                          onPressed: () async {
                            if(_formKey.currentState.validate()) {
                              double weight = double.parse(this.weight);
                              name = name.replaceRange(0, 1, name[0].toUpperCase());
                              await db.mergeUserDataFields({
                                'name': name,
                                'date_of_birth': date,
                                'weight': weight,
                                'kg': isSelected[0],
                                'setup': true,
                                'previous_runs': <String, dynamic>{},
                                'saved_routes': <String, dynamic>{},
                              });
                            }
                          },
                          child: Text(
                              'CONTINUE',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  color: color_dark_text_dark
                              )
                          ),
                          disabledBorderColor: color_dark_text_dark,
                          color: color_dark_text_highlight,
                          splashColor: color_dark_text_highlight,
                          highlightColor: color_dark_text_highlight,
                          focusColor: color_dark_text_highlight,
                          textColor: color_dark_text_dark,
                          borderSide: BorderSide(color: color_dark_text_highlight),
                          highlightedBorderColor: color_dark_text_highlight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  String weightValidator(String input) {
    input = input.replaceAll(',', '.').replaceAll(' ', '');
    return (input.isNotEmpty && !input.contains('-') && !input.contains(' ') && input.split('.').length <= 2 && double.parse(input) > 0 && double.parse(input) < 1000) ? null : 'Enter your weight.';
  }

}
