void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(13, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  while (Serial.available() > 0) {
    char c = Serial.read();
    char mode = 1;
    if(mode == 0)
    {
      if(c == 'u')
      {
        digitalWrite(13, HIGH);
        delay(100);
        digitalWrite(13, LOW);
        delay(300);
        digitalWrite(13, HIGH);
        delay(100);
        digitalWrite(13, LOW);
        delay(300);
        digitalWrite(13, HIGH);
        delay(100);
        digitalWrite(13, LOW);
        delay(300);
        digitalWrite(13, HIGH);
        delay(100);
        digitalWrite(13, LOW);
      }
      else if(c == 'd')
      {
        digitalWrite(13, HIGH);
        delay(100);
        digitalWrite(13, LOW);
        delay(600);
        digitalWrite(13, HIGH);
        delay(100);
        digitalWrite(13, LOW);
      }
    }
    else if(mode == 1)
    {
      if(c == 'u')
      {
        digitalWrite(13, HIGH);
        delay(100);
        digitalWrite(13, LOW);
        delay(200);
        digitalWrite(13, HIGH);
        delay(100);
        digitalWrite(13, LOW);
      }
      else if(c == 'd')
      {
        digitalWrite(13, HIGH);
        delay(100);
        digitalWrite(13, LOW);
        delay(600);
        digitalWrite(13, HIGH);
        delay(100);
        digitalWrite(13, LOW);
      }
    }
  }
  delay(10);
}
