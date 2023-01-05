part of 'date_time_bloc.dart';

abstract class DateTimeEvent {}

class ResetDateTime extends DateTimeEvent {}

class SetDateTime extends DateTimeEvent {
  final EventoDateTime fechaEvento;

  SetDateTime(this.fechaEvento);
}

class CopyDateTime extends DateTimeEvent {
  final EventoDateTime fechaEvento;

  CopyDateTime(this.fechaEvento);
}
