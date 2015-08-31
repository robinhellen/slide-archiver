

namespace SlideArchiver
{
    public class TimingTest : Object
    {
        public IScannerSelector scannerSelector {construct; private get;}
        public IFormatDetector formatDetector {construct; private get;}
        public IFrameScanner frameScanner {construct; private get;}

        public async void Run(int resolution)
        {
            var scanner = scannerSelector.GetScanner();
            if(scanner == null)
            {
                stderr.printf("Unable to find a suitable scanner.");
                return;
            }

            var format = formatDetector.GetFormat(scanner);

            var timer = new Timer();
            // time for individual scans
            timer.start();
            foreach(var frame in format.Frames)
            {
                var capturedFrame = yield frameScanner.ScanAsync(scanner, frame, resolution);
            }
            timer.stop();
            stdout.printf(@"Individual scanning took $(timer.elapsed())s.\n");

            // time for combined scans
            timer.start();
            var result = yield frameScanner.ScanFramesAsync(scanner, format.Frames, resolution);
            timer.stop();
            stdout.printf(@"Combined scanning took $(timer.elapsed())s.\n");
        }
    }
}
