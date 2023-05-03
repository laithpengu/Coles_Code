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

function az1 = {AZ, 200};
function seq1[] = {az1};
function* seq[] = {seq1};




 // START CODE

unsigned long startMillis;
unsigned long currentMillis;
int clk = 9; // set clock pin
int data = 10; // set data out pin
int en = 11; // set enable data pin
funcName station = AZ;
int seq_num = 0;
state curr_state;
state next_state;
int clk_count;
int seq_count;
int fun_count;
int ser_count;
int currStartTime;
int* currFuncTime;
int currFunLen;
String val;

void setup() {
    clk_count = 0; // init clock counter
    seq_count = 0; // init sequence counter
    fun_count = 0; // init funciton counter
    ser_count = 0;
    curr_state = seqCheck;
    next_state = seqCheck;
    currStartTime = 0;
    startMillis = millis();
    if (station == AZ) {
      currFuncTime = *AZtimes;
      currFunLen = AZlen;
    }
    Serial.begin(9600);
}

void loop() {
    // get current time
    currentMillis = millis();
    // state machine (segement setup, function setup, load data)
    if (curr_state == seqCheck) {
        // check if sequence is over
        if (seq_count < sizeof(seq)/sizeof(seq[0])) {
            // find next valid function
            if (seq[seq_num][seq_count].name == station) {
                // move to next state with assigned function
                currStartTime = seq[seq_num][seq_count].startTime;
                next_state = funCheck;
            } else {
                // not found so check next
                seq_count++;
            }
        } else {
            // end 
        }
            
    } else if (curr_state == funCheck) {
        // check if function is over
        if (fun_count < (currFunLen * 2)) {
            // check if 9 before next function timing
            if (fun_count == 0 && clk_count == (currStartTime - 9)) {
                next_state = loadBit;
                Serial.println("Enable Out");
                digitalWrite(en, HIGH);
            } else if (clk_count == (currFuncTime[fun_count] + currStartTime - 9)) {
                next_state = loadBit;
                Serial.println("Enable Out");
                digitalWrite(en, HIGH);
            };
        } else {
            // return to seq_check
            next_state = seqCheck;
        };
    } else if (curr_state == loadBit) {
        if (ser_count == 8) {
            // return to funCheck and increment function
            ser_count = 0;
            Serial.println("End Out");
            digitalWrite(en, LOW);
            fun_count = fun_count + 2;
            next_state = funCheck;
        } else {
            // output current bit
            Serial.print(clk_count - currStartTime);
            Serial.print(": ");
            if (currFuncTime[fun_count + 1] == 0) {
              val = "00000000";
            } else {
              val = String(currFuncTime[fun_count + 1]);
            };
            Serial.println(val[ser_count]);
            if (val == "0") {
              digitalWrite(data, LOW);
            } else {
              digitalWrite(data, HIGH);
            };
            ser_count++;
        }
    }

    // invert clock output every 10 us (period of 20 us), update clk count progress state machine
    do
    {
        delayMicroseconds(1);
        currentMillis = millis();
    } while (currentMillis - startMillis < 10UL);
    digitalWrite(clk, !digitalRead(clk));
    clk_count++;
    curr_state = next_state;
    startMillis = currentMillis;
}