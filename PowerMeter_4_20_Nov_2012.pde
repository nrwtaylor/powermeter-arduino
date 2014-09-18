 /*
    * Socket App
    *
    * A simple socket application example using the WiShield 1.0
    */

    #include <WiShield.h>
    #include "EmonLib.h"             // Include Emon Library
    EnergyMonitor emon1;             // Create an instance

    
    
//    #include <OneWire.h>
//#include <DallasTemperature.h>
    //#include <MsTimer2.h>
    //#include <SHT1x.h>
    //jonoxer SHT15 lib
    //http://github.com/practicalarduino/SHT1x/

    //-------------------------------------------------------------------------------------------------
    //
    // WiShield data
    //
    //-------------------------------------------------------------------------------------------------
    //Wireless configuration defines ----------------------------------------
    #define WIRELESS_MODE_INFRA   1
    #define WIRELESS_MODE_ADHOC   2
    //Wireless configuration parameters ----------------------------------------
    unsigned char local_ip[]       = {XXX,XXX,XXX,XXX};  // IP address of WiShield
    unsigned char gateway_ip[]     = {XXX,XXX,XXX,XXX};     // router or gateway IP address
    unsigned char subnet_mask[]    = {XXX,XXX,XXX,XXX}; // subnet mask for the local network
    const prog_char ssid[] PROGMEM = {"XXXXXXXX"};        // max 32 bytes
    unsigned char security_type    = 2;               // 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2
    // WPA/WPA2 passphrase
    const prog_char security_passphrase[] PROGMEM = {"XXXXXXXXXX"};   // max 64 characters
    // WEP 128-bit keys
    prog_uchar wep_keys[] PROGMEM = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // Key 0
                                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // Key 1
                                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // Key 2
                                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}; // Key 3
    // setup the wireless mode
    // infrastructure - connect to AP
    // adhoc - connect to another WiFi device
    unsigned char wireless_mode = WIRELESS_MODE_INFRA;
    unsigned char ssid_len;
    unsigned char security_passphrase_len;
    //---------------------------------------------------------------------------


    //-------------------------------------------------------------------------------------------------
    //
    //define(s), declaration(s) and global state data
    //
    //-------------------------------------------------------------------------------------------------
    
    //timer interrupt flag
    volatile boolean intTimer;
    //global temp (F) and humidity data
    extern char buffer[5];
    
    //float g_temperature;
    float realPower;
    float apparentPower;
    float powerFactor;
    float Vrms;
    float Irms;
    int x = 0;  
    //int furnace_state = 0;  
    //int g_humidity;
    int i = 0;
    
    char g_temperature_str[6];
    char response[5];
    
    char outBuffer[20], valor1;
int valor;

    

void clearInBuffer(){
memset(buffer, 0, sizeof(buffer)); // clears IN buffer

}

void clearOutBuffer(){
memset(outBuffer, 0, sizeof(outBuffer)); //clear OUT buffer
}

// Sensor
// pin connected to sensor
//int tempPin = 8;
// define the onewire obj needed for connecting to onewire components
//OneWire oneWire(tempPin);
// define dallas obj, makes it easier to read temp
//DallasTemperature tempSens(&oneWire);

   
void setup()
    {
    
    //#ifdef DEBUGPRINT
       //setup output for debugging...
       Serial.begin(57600);
    //#endif //DEBUGPRINT

       //set up global state data
       intTimer = false;
       //g_temperature = 0;
       //g_humidity = 0;

       //init the WiShield
       Serial.println("Start Wifi Initialization");
       WiFi.init();
       Serial.println("Power meter Initialiation");  
       
        emon1.voltage(2, 234.26, 1.7);  // Voltage: input pin, calibration, phase_shift
        emon1.current(1, 111.1);       // Current: input pin, calibration.


       
// Serial.println("Start Temperature Sensor initialization");

  //  tempSens.begin(); 
    Serial.println("Start loop");

    }
    //-------------------------------------------------------------------------------------------------
    //
    // Arduino loop() code
    //
    //-------------------------------------------------------------------------------------------------

void loop()
{

   i++;

   WiFi.run();
   

   if (i==1000)

     {
     i=0;
     emon1.calcVI(20,2000);         // Calculate all. No.of wavelengths, time-out
     emon1.serialprint();           // Print out all variables

     realPower = emon1.realPower;
     apparentPower = emon1.apparentPower;
     powerFactor = emon1.powerFactor;
     Vrms = emon1.Vrms;
     Irms = emon1.Irms;

     //dtostrf(0,10,2,outBuffer); 
   }

   if(strncmp(buffer,"V",1) == 0)
     {
     dtostrf(Vrms,10,2,outBuffer); 
   }

   if(strncmp(buffer,"I",1) == 0)
     {
     dtostrf(Irms,10,2,outBuffer); 
   }
   
      if(strncmp(buffer,"PF",2) == 0)
     {
     dtostrf(powerFactor,10,2,outBuffer); 
   }
   
      if(strncmp(buffer,"RP",2) == 0)
     {
     dtostrf(realPower,10,2,outBuffer); 
   }   
   
         if(strncmp(buffer,"AP",2) == 0)
     {
     dtostrf(apparentPower,10,2,outBuffer); 
   }   
   
   clearInBuffer();
 
}

    
