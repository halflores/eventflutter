import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventflutter/bloc/date_time/date_time_bloc.dart';
import 'package:eventflutter/modelo/evento_date_time.dart';
import 'package:eventflutter/theme/color.dart' as color;
import 'package:eventflutter/widgets/setting_item.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({Key? key}) : super(key: key);

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final dateTimeBloc = BlocProvider.of<DateTimeBloc>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('es', ''), // Spanish, no country code
      ],
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocBuilder<DateTimeBloc, DateTimeState>(
            builder: (dateTimeContext, state) {
          return Stack(
            children: [
              Positioned(
                top: 40.0,
                left: 10.0,
                child: FloatingActionButton(
                  heroTag: Icons.arrow_back.codePoint,
                  onPressed: () async {
                    dateTimeBloc.add(ResetDateTime());
                    Navigator.of(context).pop();
                  },
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: color.appBgColor,
                  child: const Icon(Icons.arrow_back, color: color.mainColor),
                ),
              ),
              Positioned(
                top: 40.0,
                right: 10.0,
                //left: 100.0,
                child: TextButton(
                  child: const Text(
                    'Aceptar fecha',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color.mainColor),
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: color.appBarColor,
                    //onPrimary: Colors.white,
                    side: const BorderSide(color: color.orangeDark, width: 2.0),
                  ),
                  onPressed: () {
                    debugPrint('Pressed');
                    /*        setState(() {
                      _isInAsyncCall = true;
                    }); */
                    _onSaveMap(state, dateTimeContext, context);
                  },
                ),
              ),
              const DateTimePickerChoise()
            ],
          );
        }),
      ),
    );
  }

  _onSaveMap(DateTimeState fechas, BuildContext dateTimeContext,
      BuildContext context) async {
    DateTime fechaInicial = fechas.fechaInicial ?? DateTime.now();
    DateTime? fechaFinal = fechas.fechaFinal;

    DateTime fechaHoy = DateTime.now();
    if (fechaInicial.isBefore(fechaHoy)) {
      //la fecha es anterior a la fecha actual
      ScaffoldMessenger.of(dateTimeContext).showSnackBar(const SnackBar(
          content: Text('La fecha de inicio debe ser posterior a la actual!')));
    } else if (fechaFinal != null) {
      if (fechaFinal.isBefore(fechaHoy)) {
        //la fecha es anterior a la fecha actual
        ScaffoldMessenger.of(dateTimeContext).showSnackBar(const SnackBar(
            content: Text('La fecha final debe ser posterior a la actual!')));
      } else {
        Navigator.of(context).pop();
      }
    } else {
      Navigator.of(context).pop();
    }
  }
}

class DateTimePickerChoise extends StatefulWidget {
  const DateTimePickerChoise({Key? key}) : super(key: key);

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePickerChoise> {
  late String _setTimeIni, _setDateIni;
  late String _setTimeFin, _setDateFin;
  late String _hour, _minute, _time;
  late String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  bool verFechaFinal = false;
  late EventoDateTime fechaEvento;

  Future<void> _selectDate(BuildContext context, String opc) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        locale: const Locale("es"),
        firstDate: DateTime(2022),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        var outputFormatDate = DateFormat('dd/MM/yyyy');

        if (opc == 'INI') {
          _setDateIni = outputFormatDate.format(picked);
          fechaEvento = EventoDateTime(
            fechaInicial: picked,
            diaIni: picked.day.toString(),
            mesIni: picked.month.toString(),
            anioIni: picked.year.toString(),
            fechaFinal: fechaEvento.fechaFinal,
            diaFin: fechaEvento.diaFin,
            mesFin: fechaEvento.mesFin,
            anioFin: fechaEvento.anioFin,
            horaIni: fechaEvento.horaIni,
            horaFin: fechaEvento.horaFin,
          );
        } else {
          _setDateFin = outputFormatDate.format(picked);
          fechaEvento = EventoDateTime(
            fechaInicial: fechaEvento.fechaInicial,
            diaIni: fechaEvento.diaIni,
            mesIni: fechaEvento.mesIni,
            anioIni: fechaEvento.anioIni,
            fechaFinal: picked,
            diaFin: picked.day.toString(),
            mesFin: picked.month.toString(),
            anioFin: picked.year.toString(),
            horaIni: fechaEvento.horaIni,
            horaFin: fechaEvento.horaFin,
          );
        }
      });
      final dateTimeBloc = BlocProvider.of<DateTimeBloc>(context);
      dateTimeBloc.add(SetDateTime(fechaEvento));
    }
  }

  Future<void> _selectTime(BuildContext context, String opc) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      confirmText: "ACEPTAR",
      cancelText: "CANCELAR",
      helpText: "SELECCIONAR HORA",
    );
    if (picked != null) {
      var outputFormatTime = DateFormat('HH:mm');

      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;

        String _Hora = outputFormatTime.format(
            DateTime(1900, 01, 01, selectedTime.hour, selectedTime.minute));
        if (opc == 'INI') {
          _setTimeIni = _Hora;
          fechaEvento = EventoDateTime(
            fechaInicial: fechaEvento.fechaInicial,
            diaIni: fechaEvento.diaIni,
            mesIni: fechaEvento.mesIni,
            anioIni: fechaEvento.anioIni,
            fechaFinal: fechaEvento.fechaFinal,
            diaFin: fechaEvento.diaIni,
            mesFin: fechaEvento.mesIni,
            anioFin: fechaEvento.anioIni,
            horaIni: _Hora,
            horaFin: fechaEvento.horaFin,
          );
        } else {
          _setTimeFin = _Hora;
          fechaEvento = EventoDateTime(
            fechaInicial: fechaEvento.fechaInicial,
            diaIni: fechaEvento.diaIni,
            mesIni: fechaEvento.mesIni,
            anioIni: fechaEvento.anioIni,
            fechaFinal: fechaEvento.fechaFinal,
            diaFin: fechaEvento.diaFin,
            mesFin: fechaEvento.mesFin,
            anioFin: fechaEvento.anioFin,
            horaIni: fechaEvento.horaIni,
            horaFin: _Hora,
          );
        }
      });
      final dateTimeBloc = BlocProvider.of<DateTimeBloc>(context);
      dateTimeBloc.add(SetDateTime(fechaEvento));
    }
  }

  @override
  void initState() {
    var localDate = DateTime.parse(DateTime.now().toString()).toLocal();
    var outputFormatDate = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormatDate.format(localDate);

    var outputFormatTime = DateFormat('HH:mm');
    var outputTime = outputFormatTime.format(localDate);

    _setDateIni = outputDate;
    _setTimeIni = outputTime;

    _setDateFin = outputDate;
    _setTimeFin = outputTime;

    fechaEvento = EventoDateTime(
        fechaInicial: null,
        horaIni: _setTimeIni,
        fechaFinal: null,
        horaFin: _setTimeFin);
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final dateTimeBloc = BlocProvider.of<DateTimeBloc>(context);
    // dateTimeBloc.add(SetDateTime(fechaEvento));
    return Padding(
      padding: const EdgeInsets.only(top: 90),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          children: [
            const Text(
              "Elegir fecha de inicio",
              style: TextStyle(
                  color: color.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            SettingItem(
                title: _setDateIni,
                leadingIcon: Icons.date_range,
                leadingIconColor: color.blue,
                onTap: () {
                  _selectDate(context, 'INI');
                }),
            const SizedBox(height: 10),
            SettingItem(
                title: _setTimeIni,
                leadingIcon: Icons.access_time,
                leadingIconColor: color.green,
                onTap: () {
                  _selectTime(context, 'INI');
                }),
            const SizedBox(height: 10),
            !verFechaFinal
                ? TextButton.icon(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(color: color.blue),
                      backgroundColor: color.appBgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    onPressed: () => {
                      setState(() {
                        verFechaFinal = true;
                        var localDate =
                            DateTime.parse(DateTime.now().toString()).toLocal();
                        var outputFormatDate = DateFormat('dd/MM/yyyy');
                        var outputDate = outputFormatDate.format(localDate);

                        var outputFormatTime = DateFormat('HH:mm');
                        var outputTime = outputFormatTime.format(localDate);

                        _setDateFin = outputDate;
                        _setTimeFin = outputTime;
                      })
                    },
                    icon: const Icon(
                      Icons.add,
                    ),
                    label: const Text(
                      'Elegir fecha final',
                    ),
                  )
                : Column(children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(color: color.blue),
                        backgroundColor: color.appBgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      onPressed: () => {
                        setState(() {
                          verFechaFinal = false;
                          fechaEvento = EventoDateTime(
                            fechaInicial: fechaEvento.fechaInicial,
                            diaIni: fechaEvento.diaIni,
                            mesIni: fechaEvento.mesIni,
                            anioIni: fechaEvento.anioIni,
                            fechaFinal: null,
                            diaFin: '',
                            mesFin: '',
                            anioFin: '',
                            horaIni: fechaEvento.horaIni,
                            horaFin: fechaEvento.horaFin,
                          );
                          /*               final dateTimeBloc =
                              BlocProvider.of<DateTimeBloc>(context); */
                          dateTimeBloc.add(CopyDateTime(fechaEvento));
                        })
                      },
                      icon: const Icon(
                        Icons.remove,
                      ),
                      label: const Text(
                        'Elegir fecha final',
                      ),
                    ),
                    SettingItem(
                        title: _setDateFin,
                        leadingIcon: Icons.date_range,
                        leadingIconColor: color.blue,
                        onTap: () {
                          _selectDate(context, 'FIN');
                        }),
                    const SizedBox(height: 10),
                    SettingItem(
                        title: _setTimeFin,
                        leadingIcon: Icons.access_time,
                        leadingIconColor: color.green,
                        onTap: () {
                          _selectTime(context, 'FIN');
                        }),
                    const SizedBox(height: 10)
                  ]),
          ],
        ),
      ),
    );
  }
}
