// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../customization/calendar_builders.dart';
import '../customization/calendar_style.dart';
import 'package:hijri/digits_converter.dart';
import 'package:hijri/hijri_array.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:flutter/material.dart';


class CellContent extends StatelessWidget {
  final DateTime day;
  final DateTime focusedDay;
  final dynamic locale;
  final bool isTodayHighlighted;
  final bool isToday;
  final bool isSelected;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isWithinRange;
  final bool isOutside;
  final bool isDisabled;
  final bool isHoliday;
  final bool isWeekend;
  final CalendarStyle calendarStyle;
  final CalendarBuilders calendarBuilders;

  const CellContent({
    Key? key,
    required this.day,
    required this.focusedDay,
    required this.calendarStyle,
    required this.calendarBuilders,
    required this.isTodayHighlighted,
    required this.isToday,
    required this.isSelected,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isWithinRange,
    required this.isOutside,
    required this.isDisabled,
    required this.isHoliday,
    required this.isWeekend,
    this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dowLabel = DateFormat.EEEE(locale).format(day);
    final dayLabel = DateFormat.yMMMMd(locale).format(day);
    final semanticsLabel = '$dowLabel, $dayLabel';

    Widget? cell =
    calendarBuilders.prioritizedBuilder?.call(context, day, focusedDay);

    if (cell != null) {
      return Semantics(
        label: semanticsLabel,
        excludeSemantics: true,
        child: cell,
      );
    }

    final text = '${day.day}';
    final margin = calendarStyle.cellMargin;
    final padding = calendarStyle.cellPadding;
    final alignment = calendarStyle.cellAlignment;
    final duration = const Duration(milliseconds: 250);

    if (isDisabled) {
      cell = calendarBuilders.disabledBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.disabledDecoration,
            alignment: alignment,
            child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(text, style: calendarStyle.disabledTextStyle),
                    ),
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Divider(
                      color: Color(0xffE9E9E9),
                    ),
                  ),
                  Expanded(
                    child: Text(HijriCalendar
                        .fromDate(day)
                        .hDay
                        .toString(), style:calendarStyle.hijriTextStyle),
                  )
                ]
            ),
          );
    } else if (isSelected) {
      cell = calendarBuilders.selectedBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.selectedDecoration,
            alignment: alignment,
            child:Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(text, style: calendarStyle.selectedTextStyle),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Divider(
                            color: Color(0xffE9E9E9),
                          ),
                        ),
                        Expanded(
                          child:Align(
                            alignment: Alignment.center,
                            child: Text(HijriCalendar
                                .fromDate(day)
                                .hDay
                                .toString(), style: calendarStyle.hijriTextStyle) ,
                          ),
                        )
                      ]
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: checkIfEvent(day)?Center(
                    child: Icon(Icons.circle,size: 10,color: Color(0xffC99960),),
                  ):SizedBox(height: 0,),
                )
              ],
            ),
          );
    } else if (isRangeStart) {
      cell =
          calendarBuilders.rangeStartBuilder?.call(context, day, focusedDay) ??
              AnimatedContainer(
                duration: duration,
                margin: margin,
                padding: padding,
                decoration: calendarStyle.rangeStartDecoration,
                alignment: alignment,
                child: Stack(
                  children: [
                   Positioned(
                     top: 0,
                     left: 0,
                     right: 0,
                     bottom: 0,
                     child:  Column(
                         children: [
                           Expanded(
                             child: Align(
                               alignment: Alignment.center,
                               child: Text(
                                   text, style: calendarStyle.rangeStartTextStyle),
                             ),
                           ),
                           const Padding(
                             padding: EdgeInsets.symmetric(horizontal: 5),
                             child: Divider(
                               color: Color(0xffE9E9E9),
                             ),
                           ),
                           Expanded(
                             child: Align(
                               alignment: Alignment.center,
                               child: Text(HijriCalendar
                                   .fromDate(day)
                                   .hDay
                                   .toString(),
                                   style: calendarStyle.hijriTextStyle),
                             ),
                           )
                         ]
                     ),
                   ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: checkIfEvent(day)?Center(
                        child: Icon(Icons.circle,size: 10,color: Color(0xffC99960),),
                      ):SizedBox(height: 0,),
                    )
                  ],
                ),
              );
    } else if (isRangeEnd) {
      cell = calendarBuilders.rangeEndBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.rangeEndDecoration,
            alignment: alignment,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(text, style: calendarStyle.rangeEndTextStyle),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Divider(
                            color: Color(0xffE9E9E9),
                          ),
                        ),
                        Expanded(
                          child:Align(
                            alignment: Alignment.center,
                            child: Text(HijriCalendar
                                .fromDate(day)
                                .hDay
                                .toString(), style: calendarStyle.hijriTextStyle) ,
                          ),
                        )
                      ]
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: checkIfEvent(day)?Center(
                    child: Icon(Icons.circle,size: 10,color: Color(0xffC99960),),
                  ):SizedBox(height: 0,),
                )
              ],
            ),
          );
    } else if (isToday && isTodayHighlighted) {
      cell = calendarBuilders.todayBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.todayDecoration,
            alignment: alignment,
            child:Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(text, style: calendarStyle.todayTextStyle),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Divider(
                            color: Color(0xffE9E9E9),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(HijriCalendar
                                .fromDate(day)
                                .hDay
                                .toString(), style: calendarStyle.hijriTextStyle),
                          ),
                        )
                      ]
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: checkIfEvent(day)?Center(
                    child: Icon(Icons.circle,size: 10,color: Color(0xffC99960),),
                  ):SizedBox(height: 0,),
                ),
              ],
            ),
          );
    } else if (isHoliday) {
      cell = calendarBuilders.holidayBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.holidayDecoration,
            alignment: alignment,
            child: Stack(
              children: [
               Positioned(
                 top: 0,
                 left: 0,
                 right: 0,
                 bottom: 0,
                 child:  Column(
                     children: [
                       Expanded(
                         child: Align(
                           alignment: Alignment.center,
                           child: Text(text, style: calendarStyle.holidayTextStyle),
                         ),
                       ),
                       const Padding(
                         padding: EdgeInsets.symmetric(horizontal: 5),
                         child: Divider(
                           color: Color(0xffE9E9E9),
                         ),
                       ),
                       Expanded(
                         child: Align(
                           alignment: Alignment.center,
                           child: Text(HijriCalendar
                               .fromDate(day)
                               .hDay
                               .toString(), style: calendarStyle.hijriTextStyle),
                         ),
                       )
                     ]
                 ),
               ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: checkIfEvent(day)?Center(
                    child: Icon(Icons.circle,size: 10,color: Color(0xffC99960),),
                  ):SizedBox(height: 0,),
                )
              ],
            )
          );
    } else if (isWithinRange) {
      cell =
          calendarBuilders.withinRangeBuilder?.call(context, day, focusedDay) ??
              AnimatedContainer(
                duration: duration,
                margin: margin,
                padding: padding,
                decoration: calendarStyle.withinRangeDecoration,
                alignment: alignment,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                    text, style: calendarStyle.withinRangeTextStyle),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Divider(
                                color: Color(0xffE9E9E9),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(HijriCalendar
                                    .fromDate(day)
                                    .hDay
                                    .toString(),
                                    style: calendarStyle.hijriTextStyle),
                              ),
                            )
                          ]
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: checkIfEvent(day)?Center(
                        child: Icon(Icons.circle,size: 10,color: Color(0xffC99960),),
                      ):SizedBox(height: 0,),
                    )
                  ],
                )
              );
    } else if (isOutside) {
      cell = calendarBuilders.outsideBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.outsideDecoration,
            alignment: alignment,
            child: Stack(
              children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child:  Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(text, style: calendarStyle.outsideTextStyle),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Divider(
                          color: Color(0xffE9E9E9),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(HijriCalendar
                              .fromDate(day)
                              .hDay
                              .toString(), style: calendarStyle.hijriTextStyle),
                        ),
                      ),
                    ]
                ),
              ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: checkIfEvent(day)?Center(
                    child: Icon(Icons.circle,size: 10,color: Color(0xffC99960),),
                  ):SizedBox(height: 0,),
                )
              ],
            )
          );
    }
    else {
      cell = calendarBuilders.defaultBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
              duration: duration,
              margin: margin,
              padding: padding,
              decoration: isWeekend
                  ? calendarStyle.weekendDecoration
                  : calendarStyle.defaultDecoration,
              alignment: alignment,
              child: Stack(

                children:[
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Column(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(text,
                                style: isWeekend
                                    ? calendarStyle.weekendTextStyle
                                    : calendarStyle.defaultTextStyle,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Divider(
                              color: Color(0xffE9E9E9),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(HijriCalendar
                                  .fromDate(day)
                                  .hDay
                                  .toString(),
                                style: calendarStyle.hijriTextStyle,
                              ),
                            ),
                          )
                        ]
                    ),
                    ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: checkIfEvent(day)?Center(
                      child: Icon(Icons.circle,size: 10,color: Color(0xffC99960),),
                    ):SizedBox(height: 0,),
                  )
              ]
              )
          );
    }

    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child:cell,
    );
  }

   List<EventsModel1> getEvents(DateTime dateTime)
  {
    int hijriYear=HijriCalendar.fromDate(dateTime).hYear;
    List<EventsModel1> hijriEvents=[

      EventsModel1(title: "Eid ul Adha", date:HijriCalendar()..hYear=hijriYear..hMonth=12..hDay=10,),
      EventsModel1(title: "Waqf al Arafa(Hajj)", date:HijriCalendar()..hYear=hijriYear..hMonth=12..hDay=9,),
      EventsModel1(title: "Eid ul Fitr", date:HijriCalendar()..hYear=hijriYear..hMonth=10..hDay=1,),
      EventsModel1(title: "Laylat al Qadr", date:HijriCalendar()..hYear=hijriYear..hMonth=9..hDay=27,),
      EventsModel1(title: "Ramadan", date:HijriCalendar()..hYear=hijriYear..hMonth=9..hDay=1,),
      EventsModel1(title: "Shab e Barat", date:HijriCalendar()..hYear=hijriYear..hMonth=8..hDay=15,),
      EventsModel1(title: "Shab e Miraj", date:HijriCalendar()..hYear=hijriYear..hMonth=7..hDay=27,),
      EventsModel1(title: "Youm e Ali", date:HijriCalendar()..hYear=hijriYear..hMonth=7..hDay=13,),
      EventsModel1(title: "Gyarvi Sharif", date:HijriCalendar()..hYear=hijriYear..hMonth=4..hDay=11,),
      EventsModel1(title: "12 Rabi ul Awwal", date:HijriCalendar()..hYear=hijriYear..hMonth=3..hDay=12,),
      EventsModel1(title: "Arbaeen", date:HijriCalendar()..hYear=hijriYear..hMonth=2..hDay=20,),
      EventsModel1(title: "Ashura", date:HijriCalendar()..hYear=hijriYear..hMonth=1..hDay=10,),
      EventsModel1(title: "Ashura", date:HijriCalendar()..hYear=hijriYear..hMonth=1..hDay=9,),
      EventsModel1(title: "1st Muharram", date:HijriCalendar()..hYear=hijriYear..hMonth=1..hDay=1,),
    ];
    return hijriEvents;
  }

 bool checkIfEvent(DateTime dateTime)
  {
    for(var d in getEvents(dateTime))
      {

        if(d.date.toString()==HijriCalendar.fromDate(dateTime).toString())
          {
            print("${d.date} : ${HijriCalendar.fromDate(dateTime)}");
            return true;
          }
      }
    return false;
  }
}



class EventsModel1
{
  String title;
  HijriCalendar date;

  EventsModel1({required this.title, required this.date});
}