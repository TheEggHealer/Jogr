import 'package:flutter/material.dart';
import 'package:jogr/screens/home/statistics/previous_run_widget.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/models/run.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class PreviousRuns extends StatefulWidget {

  User _user;
  UserData _userData;

  PreviousRuns(User user, UserData userData) {
    this._user = user;
    this._userData = userData;
  }

  @override
  _PreviousRunsState createState() => _PreviousRunsState();
}

class _PreviousRunsState extends State<PreviousRuns> {

  String dateFilter = '';


  @override
  Widget build(BuildContext context) {

    print(dateFilter);

    List<Widget> entries = [FilterSelect(parent: this, dateString: dateFilter.isEmpty ? DateTime.now().toString().split(' ')[0].substring(0,7) : dateFilter.replaceRange(4, 5, '-${dateFilter.substring(4,5)}'),)];
    entries.addAll(widget._userData.runs.where((e) => e.date.startsWith(dateFilter)).map((e) => PreviousRunWidget(e)).toList().reversed);

    return Scaffold(
      backgroundColor: color_background,
      body: Container(
        padding: EdgeInsets.only(top:40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Center(
                  child: Text(
                    'All previous runs',
                    style: textStyleHeader,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IconButton(
                    icon: Icon(CustomIcons.back, size: 30, color: color_text_highlight),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height:30),
            Divider(
              color: Color(0xff555555),
              endIndent: 20,
              indent: 20,
              height: 0,
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                        entries
                    )
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}












class FilterSelect extends StatefulWidget {

  final _PreviousRunsState parent;
  String dateString;

  FilterSelect({ this.parent, this.dateString });

  @override
  _FilterSelectState createState() => _FilterSelectState();
}

class _FilterSelectState extends State<FilterSelect> {

  DateTime selectedDate = DateTime.now();


  @override
  Widget build(BuildContext context) {
    String dateString = widget.dateString;

    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Showing $dateString', style: textStyleHeaderSmall,),
            OutlineButton(
              onPressed: () async {
                DateTime date = await showMonthPicker(context: context, initialDate: selectedDate);
                if(date != null) {
                  setState(() {
                    selectedDate = date;
                    dateString = date.toString().split(' ')[0].substring(0,7);
                  });
                  widget.parent.setState(() {
                    widget.parent.dateFilter = dateString.replaceAll('-', '');
                  });
                }
              },
              child: Text('CHANGE'),
              color: color_text_highlight,
              highlightColor: color_text_highlight,
              highlightedBorderColor: color_text_highlight,
              focusColor: color_text_highlight,
              hoverColor: color_text_highlight,
              textColor: color_text_dark,
              splashColor: color_text_highlight,
              borderSide: BorderSide(color: color_text_highlight),
            ),
          ]

      ),
    );
  }
}

