using Gdk;
using Gtk;

namespace SlideArchiver.Ui
{
    public class GridImagePreview : Grid, ImagePreview
    {
        public IScannerSelector ScannerSelector {construct; private get;}
        public SourceSelector SourceSelector {construct; private get;}
        public FrameScanner FrameScanner {construct; private get;}
        public PixbufCreator PixbufCreator {construct; private get;}

        construct
        {
            row_spacing = 2;
            GetPreviews.begin();
        }

        private async void GetPreviews()
        {
            var scanner = ScannerSelector.GetScanner();
            var f = SourceSelector.Format.Frames.to_array();

            for(int i = 0; i < f.length; i++)
            {
                var frame = f[i];
                var scanned = yield FrameScanner.ScanAsync(scanner, frame, 300);

                var pixbuf = PixbufCreator.CreateScaledPixbufFromScannedFrame(scanned, 200);

                var image = new Image.from_pixbuf(pixbuf);
                insert_row(2*i);
                insert_row(2 * i + 1);
                attach(image, 0, 2*i, 1, 2);
                image.show();
            }
        }
    }
}
