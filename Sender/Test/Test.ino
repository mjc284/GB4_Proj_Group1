void setup() {
  // put your setup code here, to run once:
  pinMode(13, OUTPUT);
  pinMode(12, INPUT_PULLUP);
  digitalWrite(13, LOW);
  
}

void loop() {
  // put your main code here, to run repeatedly:
  while (1) {
    delay(10);
    if(digitalRead(12) == 0)
      goto redo;
  }
  redo:
  delay(8000);
  digitalWrite(13, HIGH);
  delay(100);
  digitalWrite(13, LOW);

  delay(50);

  digitalWrite(13, HIGH);
  delay(50);
  digitalWrite(13, LOW);
  goto redo;
}
