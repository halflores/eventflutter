import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:eventflutter/modelo/evento_date_time.dart';

part 'date_time_event.dart';
part 'date_time_state.dart';

class DateTimeBloc extends Bloc<DateTimeEvent, DateTimeState> {
  DateTimeBloc() : super(const DateTimeState()) {
    on<ResetDateTime>((event, emit) {
      try {
        emit(state.resetDateTime());
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    on<SetDateTime>((event, emit) {
      try {
        emit(_setDateTimeEvento(event.fechaEvento));
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    on<CopyDateTime>((event, emit) {
      try {
        emit(_setDateTimeEvento(event.fechaEvento));
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  _setDateTimeEvento(EventoDateTime fechaEvento) {
    return state.copyDateTime(
        fechaInicial: fechaEvento.fechaInicial,
        diaIni: fechaEvento.diaIni,
        mesIni: fechaEvento.mesIni,
        anioIni: fechaEvento.anioIni,
        horaIni: fechaEvento.horaIni,
        minutoIni: fechaEvento.minutoIni,
        fechaFinal: fechaEvento.fechaFinal,
        diaFin: fechaEvento.diaFin,
        mesFin: fechaEvento.mesFin,
        anioFin: fechaEvento.anioFin,
        horaFin: fechaEvento.horaFin,
        minutoFin: fechaEvento.minutoFin);
  }
}
