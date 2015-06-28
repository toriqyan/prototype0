using System;
using System.Speech.Recognition; // Microsoft.Speech.dll at C:\Program Files (x86)\Microsoft SDKs\Speech\v11.0\Assembly
using System.Speech.Synthesis;
using System.Globalization; // recognition
using System.Runtime.InteropServices;
using System.IO;

namespace ConsoleSpeech
{

    class ConsoleSpeechProgram
    {
        static SpeechSynthesizer ss = new SpeechSynthesizer();
        static SpeechRecognitionEngine sre;
        static bool done = false;
        static bool speechOn = true;
        //static WaveIn s_WaveIn;

        [DllImport("winmm.dll", EntryPoint = "mciSendStringA", CharSet = CharSet.Ansi, SetLastError = true, ExactSpelling = true)]
        private static extern int mciSendString(string lpstrCommand, string lpstrReturnString, int uReturnLength, int hwndCallback);
        
        static void Main(string[] args)
        {
            try
            {
                ss.SetOutputToDefaultAudioDevice();
                Console.WriteLine("\n(Speaking: I am awake)");
                ss.Speak("I am awake");

                CultureInfo ci = new CultureInfo("en-us");
                sre = new SpeechRecognitionEngine(ci);
                sre.SetInputToDefaultAudioDevice();
                sre.SpeechRecognized += sre_SpeechRecognized;

                Choices ch_StartStopCommands = new Choices();
                ch_StartStopCommands.Add("Alexa record");
                ch_StartStopCommands.Add("speech off");
                ch_StartStopCommands.Add("klatu barada nikto");
                GrammarBuilder gb_StartStop = new GrammarBuilder();
                gb_StartStop.Append(ch_StartStopCommands);
                Grammar g_StartStop = new Grammar(gb_StartStop);
           
             
                sre.LoadGrammarAsync(g_StartStop);
                sre.RecognizeAsync(RecognizeMode.Multiple); // multiple grammars

                while (done == false) { ; }

                Console.WriteLine("\nHit <enter> to close shell\n");
                Console.ReadLine();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Console.ReadLine();
            }

        } // Main

        static void sre_SpeechRecognized(object sender, SpeechRecognizedEventArgs e)
        {
            string txt = e.Result.Text;
            float confidence = e.Result.Confidence; // consider implicit cast to double
            Console.WriteLine("\nRecognized: " + txt);

            if (confidence < 0.60) return;

            if (txt.IndexOf("Alexa record") >= 0)
            {
                ss.Speak("start now");
                Console.WriteLine("Speech is now ON");
                speechOn = true;

                mciSendString("open new Type waveaudio Alias recsound", "", 0, 0);
                mciSendString("record recsound", "", 0, 0);

                System.Threading.Thread.Sleep(5000);

                mciSendString("save recsound C:\\Users\\Chris\\hangelhack\\hangelhack\\Code\\test.wav", "", 0, 0);
                mciSendString("close recsound ", "", 0, 0);
                                
            }

            if (txt.IndexOf("speech off") >= 0)
            {
                ss.Speak("Speech is now OFF");
                Console.WriteLine("Speech is now OFF");
                speechOn = false;

                File.Delete(@"C:\\Users\\Chris\\hangelhack\\hangelhack\\Code\\test.wav");
               
            }

            if (speechOn == false) return;

        } // sre_SpeechRecognized

    } // Program

} // ns
