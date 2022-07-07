import 'package:care_giver/DatabaseHandler/DbHelper.dart';
import 'package:care_giver/constants/theme_data.dart';
import 'package:care_giver/models/alarm_model.dart';
import 'package:care_giver/utils/strings.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlarmView extends StatefulWidget {
  const AlarmView({Key? key}) : super(key: key);

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  late DateTime _alarmTime;
  late String _alarmTimeString;
  late DbHelper dbHelper;
  late Future<List<AlarmModel>> _alarms;
  late List<AlarmModel> _currentAlarms;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    dbHelper = DbHelper();
    loadAlarms();
    super.initState();
  }

  void loadAlarms() {
    setState(() {
      _alarms = dbHelper.getAlarms();
    });
  }

  void onSaveAlarm() {
    DateTime scheduleAlarmDateTime;
    if (_alarmTime.isAfter(DateTime.now())) {
      scheduleAlarmDateTime = _alarmTime;
    } else {
      scheduleAlarmDateTime = _alarmTime.add(const Duration(days: 1));
    }

    var alarmInfo = AlarmModel(
        alarmTitle: 'Alarm',
        alarmTime: scheduleAlarmDateTime,
        gradientColorIndex: _currentAlarms.length,
        flag: "ON");
    dbHelper.insertAlarm(alarmInfo);
    Navigator.pop(context);
    loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            STRINGS.alarm,
          ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: FutureBuilder<List<AlarmModel>>(
                    future: _alarms,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _currentAlarms = snapshot.data!;
                        return ListView(
                          children: snapshot.data!.map<Widget>((alarm) {
                            var alarmTime =
                                DateFormat('hh:mm aa').format(alarm.alarmTime!);
                            var gradientColor = GradientTemplate
                                .gradientTemplate[alarm.gradientColorIndex!]
                                .colors;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 32),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradientColor,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: gradientColor.last.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(4, 4),
                                  ),
                                ],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(24)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          const Icon(
                                            Icons.alarm,
                                            color: Colors.black,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            alarm.alarmTitle!,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Switch(
                                        value: true,
                                        onChanged: (bool value) {},
                                        activeColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    'Mon-Fri',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        alarmTime,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).followedBy([
                            if (_currentAlarms.length < 5)
                              DottedBorder(
                                strokeWidth: 2,
                                color: CustomColors.clockOutline,
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(24),
                                dashPattern: [5, 4],
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: CustomColors.clockBG,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24)),
                                  ),
                                  child: FlatButton(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16),
                                    onPressed: () {
                                      _alarmTimeString = DateFormat('HH:mm')
                                          .format(DateTime.now());
                                      showModalBottomSheet(
                                        useRootNavigator: true,
                                        context: context,
                                        clipBehavior: Clip.antiAlias,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24),
                                          ),
                                        ),
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, setModalState) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(32),
                                                child: Column(
                                                  children: [
                                                    FlatButton(
                                                      onPressed: () async {
                                                        var selectedTime =
                                                            await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                              TimeOfDay.now(),
                                                        );
                                                        if (selectedTime !=
                                                            null) {
                                                          final now =
                                                              DateTime.now();
                                                          var selectedDateTime =
                                                              DateTime(
                                                                  now.year,
                                                                  now.month,
                                                                  now.day,
                                                                  selectedTime
                                                                      .hour,
                                                                  selectedTime
                                                                      .minute);
                                                          _alarmTime =
                                                              selectedDateTime;
                                                          setModalState(() {
                                                            _alarmTimeString =
                                                                DateFormat(
                                                                        'HH:mm')
                                                                    .format(
                                                                        selectedDateTime);
                                                          });
                                                        }
                                                      },
                                                      child: Text(
                                                        _alarmTimeString,
                                                        style: const TextStyle(
                                                            fontSize: 32),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    FloatingActionButton
                                                        .extended(
                                                      onPressed: onSaveAlarm,
                                                      icon: const Icon(
                                                          Icons.alarm),
                                                      label: const Text('Save'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: const <Widget>[
                                        Text(
                                          'Add Alarm',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            else
                              const Center(
                                  child: Text(
                                'Only 5 alarms allowed!',
                                style: TextStyle(color: Colors.black),
                              )),
                          ]).toList(),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'Loading..',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
