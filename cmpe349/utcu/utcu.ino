/*
 *
 *   File Name:    utcu.ino
 *   Date Created: Fri Apr 28 2023
 *   Author:       Cole Cavanagh
 *   Description:  CMPE 349 MLS UTCU Sim Code
 *
 */


// DEFINE GLOBALS
// enum function names
enum funcName {	
    EMPTY,
	EL,
	AZ,
	BAZ
};

// enum states
enum state {   
    seqCheck,
    funCheck,
    loadBit
};

// function structure for sequence array
struct function {
    funcName name;
    int startTime;
};

// AZ Function [time. Outcode]
// (on/off, dpsk, to/fro, sbstart, antcode [2:0], antsel)
int AZlen = 23;
int AZtimes[23][2] =    {{0, 10000001}, // preamble
	          {832, 11000000}, // barker code
            {896, 11000000},
            {960, 11000000},
            {1024, 10000000},
            {1088, 11000000},
            {1152, 10000000}, // function ID 0011001
            {1216, 10000000},
            {1280, 11000000},
            {1344, 11000000},
            {1408, 10000000},
            {1472, 10000000},
            {1536, 11000000},
            {1600, 00000000}, // end preamble
            {2048, 10000011}, // rear oci
            {2176, 10000101}, // left oci
            {2304, 10000111}, // right oci
            {2432, 00000000}, // to test
            {2560, 10111011}, // to scan
            {8760, 00000000}, // pause
            {9360, 10010000}, // fro scan
            {15560, 00000000},
            {15900, 00000000}};  // end fro

//pg 6 annex 10
// BAZ Function 1001001
int BAZlen = 23;
int BAZtimes[23][2] = {{0, 10000001}, // preamble
          {832, 11000000}, // barker code
          {896, 11000000},
          {960, 11000000},
          {1024, 10000000},
          {1088, 11000000},
          {1152, 11000000}, // function ID 1001001
          {1216, 10000000},
          {1280, 10000000},
          {1344, 11000000},
          {1408, 10000000},
          {1472, 10000000},
          {1536, 11000000},
          {1600, 00000000}, // end preamble
          {2048, 10000011}, // rear oci
          {2176, 10000101}, // left oci
          {2304, 10000111}, // right oci
          {2432, 00000000}, // to test
          {2560, 10111011}, // to scan
          {6760, 00000000}, // pause
          {7360, 10010000}, // fro scan
          {11560, 00000000},
          {11688, 00000000}};  // end fro

// EL Function 1100001
int ELlen = 19;
int ELtimes[19][2] = {{0, 10000001}, // preamble
	        {832, 11000000}, // barker code
	        {896, 11000000},
        	{960, 11000000},
        	{1024, 10000000},
        	{1088, 11000000},
        	{1152, 11000000}, // function ID 1100001
        	{1216, 11000000},
        	{1280, 10000000},
        	{1344, 10000000},
        	{1408, 10000000},
        	{1472, 10000000},
        	{1536, 11000000},
          {1600, 00000000}, // end preamble
          {1728, 10000011}, //OCI
          {1856, 10111011}, // TO scan
          {3406, 00000000}, //Pause
          {3806, 10010000}, // FRO scan
          {5356, 00000000}};  // End function ground

// define seq1
function seq1[] = {{EL, 0},
                  {EMPTY, 5600},
                  {AZ, 10900},
                  {EMPTY, 26800},
                  {EL, 32100},
                  {BAZ, 37700}, // 49600
                  {EL, 55800},
                  {EMPTY, 61400}};

// define seq2
function seq2[] = {{EL, 0},
                  {EMPTY, 5600},
                  {AZ, 10900},
                  {EMPTY, 26800},
                  {EL, 32100},
                  {EMPTY, 37700}, // add data word
                  {EL, 55800},
                  {EMPTY, 61400}};

// define whole sequence
function* seq[] = {seq1, seq2};
int seqstart[] = {10, 67710};



 // START CODE

unsigned long startMillis;
unsigned long currentMillis;
int clk = 9;                  // set clock pin
int data = 10;                // set data out pin
int en = 11;                  // set enable data pin
funcName station = AZ;        // station id global
int seq_num = 0;              // sequence id global
state curr_state;             // current output state
state next_state;             // next output state
int clk_count;                // current clock cycle counter
int seq_count;                // subsequence counter
int fun_count;                // subfunction counter
int ser_count;                // bit output counter
int currStartTime;            // start of current function
int* currFuncTime;            // array of function timing
int currFunLen;               // len of current function
String dataString;            // current output string
char dpsk;

void setup() {
    pinMode(clk, OUTPUT);
    pinMode(data, OUTPUT);
    pinMode(en, OUTPUT);
    clk_count = 0;          // init clock counter
    seq_count = 0;            // init sequence counter
    fun_count = 0;            // init funciton counter
    ser_count = 0;            // init serial counter
    curr_state = seqCheck;
    next_state = seqCheck;
    currStartTime = 0;
    dataString = "00000000";
    startMillis = millis();
    dpsk = '0';
    if (station == AZ) {
      currFuncTime = *AZtimes;
      currFunLen = AZlen;
    } else if (station == EL) {
      currFuncTime = *ELtimes;
      currFunLen = ELlen;
    } else if (station == BAZ) {
      currFuncTime = *BAZtimes;
      currFunLen = BAZlen;
    }
    Serial.begin(9600);
    delay(10000);
};

void loop() {
    // get current time
    currentMillis = millis();
    // state machine (segement setup, function setup, load data)
    if (curr_state == seqCheck) {
        // check if sequence is over
        if (seq_count < 8) {
            // find next valid function
            Serial.println(seq_count);
            if (seq[seq_num][seq_count].name == station) {
                // move to next state with assigned function
                currStartTime = seq[seq_num][seq_count].startTime + seqstart[seq_num];
                next_state = funCheck;
                seq_count = seq_count + 1;
            } else {
                // not found so check next
                seq_count = seq_count + 1;
            }
        } else {
            Serial.println("End");
            // end 
            exit(0);
        }
    } else if (curr_state == funCheck) {
        // check if function is over
        if (fun_count < (currFunLen * 2)) {
            // check if 9 before next function timing
            if (fun_count == 0) {
              if (clk_count == (currStartTime - 9)) {
                next_state = loadBit;
                Serial.print(clk_count - currStartTime);
                Serial.print(": ");
                Serial.println("Enable Out");
                digitalWrite(en, HIGH);
                if (currFuncTime[fun_count + 1] == 0) {
                  dataString = "00000000";
                } else {
                  dataString = String(currFuncTime[fun_count + 1]);
                };
                Serial.print(clk_count - currStartTime);
                Serial.print(": ");
                Serial.println(dataString.charAt(ser_count));
                if (dataString.charAt(ser_count) == '0') {
                  digitalWrite(data, LOW);
                } else {
                  digitalWrite(data, HIGH);
                };
                ser_count++;
              };
            } else if (clk_count == (currFuncTime[fun_count] + currStartTime - 9)) {
              next_state = loadBit;
              Serial.print(clk_count);
              Serial.print("(");
              Serial.print(clk_count - currStartTime);
              Serial.print(")");
              Serial.print(": ");
              Serial.println("Enable Out");
              digitalWrite(en, HIGH);
              if (currFuncTime[fun_count + 1] == 0) {
                dataString = "00000000";
              } else {
                dataString = String(currFuncTime[fun_count + 1]);
              };
              Serial.print(clk_count);
              Serial.print("(");
              Serial.print(clk_count - currStartTime);
              Serial.print(")");
              Serial.print(": ");
              Serial.println(dataString.charAt(ser_count));
              if (dataString.charAt(ser_count) == '0') {
                digitalWrite(data, LOW);
              } else {
                digitalWrite(data, HIGH);
              };
              ser_count++;
            };
        } else {
          // return to seq_check
          fun_count = 0;
          next_state = seqCheck;
        };
    } else if (curr_state == loadBit) {
        if (ser_count == 8) {
            // return to funCheck and increment function
            ser_count = 0;
            Serial.print(clk_count);
            Serial.print("(");
            Serial.print(clk_count - currStartTime);
            Serial.print(")");
            Serial.print(": ");
            Serial.println("End Out");
            digitalWrite(en, LOW);
            fun_count = fun_count + 2;
            next_state = funCheck;
        } else {
            // check for dpsk
            if (ser_count == 1) { // dpsk
              // output current bit
              Serial.print(clk_count);
              Serial.print("(");
              Serial.print(clk_count - currStartTime);
              Serial.print(")");
              Serial.print(": ");
              if (dataString.charAt(ser_count) == dpsk) {
                digitalWrite(data, LOW);
                Serial.println(0);
              } else {
                digitalWrite(data, HIGH);
                Serial.println(1);
              };
              dpsk = dataString.charAt(ser_count);
              ser_count++;
            } else { // normal
              // output current bit
              Serial.print(clk_count);
              Serial.print("(");
              Serial.print(clk_count - currStartTime);
              Serial.print(")");
              Serial.print(": ");
              Serial.println(dataString.charAt(ser_count));
              if (dataString.charAt(ser_count) == '0') {
                digitalWrite(data, LOW);
              } else {
                digitalWrite(data, HIGH);
              };
              ser_count++;
            };
        }
    }

    // invert clock output every 10 us (period of 20 us), update clk count progress state machine
    do
    {
        delayMicroseconds(1);
        currentMillis = millis();
    } while (currentMillis - startMillis < .02);
    startMillis = currentMillis;
    digitalWrite(clk, HIGH);
    delayMicroseconds(10);
    digitalWrite(clk, LOW);
    clk_count++;
    curr_state = next_state;
}