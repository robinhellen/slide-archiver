using Gdk;
using Gtk;

using Scan;

namespace SlideArchiver.Ui
{
    public class GridImagePreview : Grid, ImagePreview
    {
        public IScannerSelector ScannerSelector {construct; private get;}
        public SourceSelector SourceSelector {construct; private get;}
        public FrameScanner FrameScanner {construct; private get;}
        public PixbufCreator PixbufCreator {construct; private get;}

        public bool PreviewsAvailable {get; protected set;}

        construct
        {
            PreviewsAvailable = false;
            row_spacing = 2;
            GetPreviews.begin();
        }

        private async void GetPreviews()
        {
            var scanner = ScannerSelector.GetScanner();
            var f = SourceSelector.Format.Frames.to_array();
            var bars = new ProgressBar[f.length];
            var reporters = new ProgressReporter[f.length];

            for(int i = 0; i < f.length; i++)
            {
                bars[i] = new ProgressBar();
                bars[i].set_fraction(0);
                bars[i].text = "Waiting for scanner to be ready.";
                bars[i].show_text = true;
                reporters[i] = (ProgressReporter) Object.new(typeof(BarUpdaterProgress), Bar: bars[i]);
                attach(bars[i], 0, 2 * i + 1, 1, 1);
            }

            var s = yield FrameScanner.ScanFramesAsync(scanner, SourceSelector.Format.Frames, 300, reporters[0]);

            var scannedFrames = s.to_array();

            for(int i = 0; i < f.length; i++)
            {
                var frame = f[i];
                bars[i].text = "Scanning";
                var scanned = scannedFrames[i];
                bars[i].set_fraction(1);
                var pixbuf = PixbufCreator.CreateScaledPixbufFromScannedFrame(scanned, 200);

                var image = new Image.from_pixbuf(pixbuf);
                remove(bars[i]);
                attach(image, 0, 2*i, 1, 2);
                image.show();
                var tags = new FrameTags(frame);
                attach(tags, 1, 2*i, 1, 1);
                tags.show_all();
            }
            PreviewsAvailable = true;
        }
    }

    private class BarUpdaterProgress : ProgressReporter, Object
    {
        public ProgressBar Bar {construct; private get;}

        public void report(double progress)
        {
            Bar.set_fraction(progress);
        }
    }
}
