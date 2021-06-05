import "dart:async";

class BaseModel{
  StreamController fetchSmsController = new StreamController.broadcast();
  fetch(){
    fetchSmsController.add("stuff");
  }
  Stream get fetchSms => fetchSmsController.stream;
}