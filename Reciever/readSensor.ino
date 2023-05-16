void setup() {

  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:

  int val;
  int static_variable = 500;
  val = analogRead(0);
  Serial.println(val, DEC);
  Serial.print("Variable_1:");
  Serial.print(val);
  Serial.print(",");
  Serial.print("Variable_2:");
  Serial.println(static_variable)
}
