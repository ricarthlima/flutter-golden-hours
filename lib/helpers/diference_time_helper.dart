import 'package:time_counter/models/custom_time.dart';

CustomTime getDifferenceTime(Duration dif) {
  int totalSeconds = dif.inSeconds.abs();

  //Dias
  int days = totalSeconds ~/ 86400;
  totalSeconds = totalSeconds - (days * 86400);

  //Horas
  int hours = totalSeconds ~/ 3600;
  totalSeconds = totalSeconds - (hours * 3600);

  //Minutos
  int minutes = totalSeconds ~/ 60;
  totalSeconds = totalSeconds - (minutes * 60);

  return CustomTime(
      days: days, hours: hours, minutes: minutes, seconds: totalSeconds);
}

String toAmericanDate(String date) {
  List<String> lista = date.split("/");
  return lista[2] + "-" + lista[1] + "-" + lista[0];
}
