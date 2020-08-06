import 'package:flutter/material.dart';
import 'package:jogr/screens/navigator/goals/goal_widget.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/custom_widgets/data_display.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';



class HomeWidget extends StatefulWidget {

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  Widget goalsBuilder(BuildContext context, int index) {

    List<Goal> goals = [
      Goal(
        header: 'THIS WEEK • RUN SOME DISTANCE',
        fraction: true,
        a: DataDisplay(data: '3.5', label: 'km',),
        b: DataDisplay(data: '10', label: 'km'),
      ),
      Goal(
        header: 'THIS MONTH • RUN SOME DISTANCE',
        fraction: true,
        a: DataDisplay(data: '17.4', label: 'km',),
        b: DataDisplay(data: '40', label: 'km'),
      ),
      Goal(
        header: 'THIS WEEK • BURN SOME CALORIES',
        fraction: true,
        a: DataDisplay(data: '2150', label: 'cal',),
        b: DataDisplay(data: '2000', label: 'cal'),
        completed: true,
      ),
      Goal(
        header: 'THIS MONTH • REACH SOME PACE',
        content: DataDisplay(data: '7.1', label: 'm/s'),
      ),
      Goal(
        header: 'THIS WEEK • RUN SOME DISTANCE',
        fraction: true,
        a: DataDisplay(data: '3.5', label: 'km',),
        b: DataDisplay(data: '10', label: 'km'),
        post: 'ran',
      ),

    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Card(
        elevation: 5,
        color: color_dark_card,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: goals[index]),

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    UserData userData = Provider.of<UserData>(context);

    PageController controller = PageController(initialPage: 0);

    return  Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '• LAST RUN',
              style: textStyleDark
          ),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DataDisplay(
                icon: CustomIcons.distance,
                data: userData.runs.length > 0 ? userData.lastRun.distanceString : '--',
                label: 'km',
              ),
              DataDisplay(
                icon: CustomIcons.timer,
                data: userData.runs.length > 0 ? userData.lastRun.timeString : '--:--',
                label: userData.runs.length > 0 ? (userData.lastRun.timeString.split(':').length > 2 ? 'hh:mm:ss' : 'mm:ss') : 'mm:ss',
              ),
              DataDisplay(
                icon: CustomIcons.burn,
                data: userData.runs.length > 0 ? userData.lastRun.calories.toString() : '--',
                label: 'cal',
              )
            ],
          ),

          SizedBox(height: 30),

          Text(
              '• GOALS',
              style: textStyleDark
          ),

          SizedBox(height: 10),

          Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: double.infinity,
                  maxHeight: 100,
                ),
                child: PageView.builder(
                  controller: controller,
                  itemBuilder: goalsBuilder,
                  itemCount: 5,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 5,
                  effect: ExpandingDotsEffect(
                      dotColor: color_dark_text_dark,
                      activeDotColor: color_dark_text_highlight,
                      dotWidth: 6,
                      dotHeight: 6,
                      spacing: 3,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 1
                  ),
                ),
              )
            ],
          ),

          /**
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: double.infinity,
              maxHeight: 160,
            ),
            child: Swiper(
              itemBuilder: goalsBuilder,
              itemCount: 5,
              layout: SwiperLayout.DEFAULT,
              loop: true,
              pagination: SwiperCustomPagination(
                builder: (context, config) {
                  Widget circle = Container(
                    margin: EdgeInsets.all(2),
                    width: 7.0,
                    height: 7.0,
                    decoration: BoxDecoration(
                      color: color_text_dark,
                      shape: BoxShape.circle,
                    ),
                  );

                  Widget selected = Container(
                    margin: EdgeInsets.all(2),
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: color_text_highlight,
                      shape: BoxShape.circle,
                    ),
                  );

                  List<Widget> dots = [];
                  for(int i = 0; i < config.itemCount; i++) {
                    if(i == config.activeIndex) dots.add(selected);
                    else dots.add(circle);
                  }

                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: dots,
                    ),
                  );
                }

              ),

            ),
          ),
           */
        ]
      ),
    );
  }
}
