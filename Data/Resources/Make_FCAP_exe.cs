// Credit: https://stackoverflow.com/a/54706445

// To Create .exe from .bat file:
// FIRST: Move this script to the ROOT of the FCapture hierarchy (as in, where the .exe file would reasonably be expected to go)
// In command prompt, navigate to the FCapture root folder on your computer.
// Enter the following command (may have to alter for your machine):
// C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\csc.exe /target:winexe /win32icon:Data\Resources\FCAP.ico Make_FCAP_exe.cs

using System;
using System.Diagnostics;
using System.Windows.Forms;
using System.IO;

class BatCaller {
    static void Main() {
        var batFile = System.Reflection.Assembly.GetEntryAssembly().Location.Replace("F-Capture.exe", "Data\\F-Capture.bat");
        if (!File.Exists(batFile)) {
            MessageBox.Show("The launch script could not be found." + batFile, "Critical error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            System.Environment.Exit(42);
        }
        var processInfo = new ProcessStartInfo("cmd.exe", "/c \"" + batFile + "\"");
        processInfo.CreateNoWindow = true;
        processInfo.UseShellExecute = false;
        processInfo.RedirectStandardError = true;
        processInfo.RedirectStandardOutput = true;

        var process = Process.Start(processInfo);

        process.OutputDataReceived += (object sender, DataReceivedEventArgs e) => Console.WriteLine("output>>" + e.Data);
        process.BeginOutputReadLine();

        process.ErrorDataReceived += (object sender, DataReceivedEventArgs e) => Console.WriteLine("error>>" + e.Data);
        process.BeginErrorReadLine();

        process.WaitForExit();

        Console.WriteLine("ExitCode: {0}", process.ExitCode);
        process.Close();
    }
}