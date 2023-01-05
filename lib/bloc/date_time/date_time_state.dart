part of 'date_time_bloc.dart';

class DateTimeState {
  final DateTime? fechaInicial;
  final String diaIni;
  final String mesIni;
  final String anioIni;
  final String horaIni;
  final String minutoIni;
  final DateTime? fechaFinal;
  final String diaFin;
  final String mesFin;
  final String anioFin;
  final String horaFin;
  final String minutoFin;

  const DateTimeState(
      {this.fechaInicial,
      this.diaIni = '',
      this.mesIni = '',
      this.anioIni = '',
      this.horaIni = '',
      this.minutoIni = '',
      this.fechaFinal,
      this.diaFin = '',
      this.mesFin = '',
      this.anioFin = '',
      this.horaFin = '',
      this.minutoFin = ''});

  DateTimeState copyDateTime(
          {DateTime? fechaInicial,
          String? diaIni,
          String? mesIni,
          String? anioIni,
          String? horaIni,
          String? minutoIni,
          DateTime? fechaFinal,
          String? diaFin,
          String? mesFin,
          String? anioFin,
          String? horaFin,
          String? minutoFin}) =>
      DateTimeState(
        fechaInicial: fechaInicial,
        diaIni: diaIni ?? this.diaIni,
        mesIni: mesIni ?? this.mesIni,
        anioIni: anioIni ?? this.anioIni,
        horaIni: horaIni ?? this.horaIni,
        minutoIni: minutoIni ?? this.minutoIni,
        fechaFinal: fechaFinal,
        diaFin: diaFin ?? this.diaFin,
        mesFin: mesFin ?? this.diaFin,
        anioFin: anioFin ?? this.anioFin,
        horaFin: horaFin ?? this.horaFin,
        minutoFin: minutoFin ?? this.horaFin,
      );

  DateTimeState resetDateTime() {
    return const DateTimeState(
        fechaInicial: null,
        diaIni: '',
        mesIni: '',
        anioIni: '',
        horaIni: '',
        minutoIni: '',
        fechaFinal: null,
        diaFin: '',
        mesFin: '',
        anioFin: '',
        horaFin: '',
        minutoFin: '');
  }
}
