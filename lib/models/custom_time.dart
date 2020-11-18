class CustomTime {
  int days;
  int hours;
  int minutes;
  int seconds;

  CustomTime({this.days, this.hours, this.minutes, this.seconds});

  toString() {
    String hours = this.hours.toString();
    String minutes = this.minutes.toString();
    String seconds = this.seconds.toString();

    if (hours.length == 1) {
      hours = "0" + hours;
    }
    if (minutes.length == 1) {
      minutes = "0" + minutes;
    }

    if (seconds.length == 1) {
      seconds = "0" + seconds;
    }

    return hours + ":" + minutes + ":" + seconds;
  }
}
