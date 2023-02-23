import 'dart:isolate';

void separatedLoop(SendPort sendPort) async {
  var j = 0;
  for (int i = 0; i < 1000000000; i++) {
    j += i;
  }
  sendPort.send(j);
}

int computerLoop(int val) {
  var j = 0;
  for (int i = 0; i < val; i++) {
    j += i;
  }
  return j;
}
