void setup() {
  Serial.begin(115200);
}

void loop() {
  int v = analogRead(A0);    //0-1023
  uint8_t out = v >> 2;      //Shrink to 0-255
  Serial.write(out);         //Send in 1 byte
}
