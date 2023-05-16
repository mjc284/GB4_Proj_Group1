void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(13, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  while (Serial.available() > 0) {
    char c = Serial.read();
    if(c == 'u')
    {
      digitalWrite(13, HIGH);
      delay(300);
      digitalWrite(13, LOW);
      delay(300);
      digitalWrite(13, HIGH);
      delay(300);
      digitalWrite(13, LOW);
    }
    else if(c == 'd')
    {
      digitalWrite(13, HIGH);
      delay(1000);
      digitalWrite(13, LOW);
    }
  }
  delay(10);
}
