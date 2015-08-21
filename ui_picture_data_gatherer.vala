using Gdk;
using Gee;
using Gtk;

namespace SlideArchiver
{
    public class UiPictureDataGatherer : Object, IPictureDataGatherer
    {
        public FrameScanner Scanner {construct; private get;}
        public PictureDataGatherer Gatherer {construct; private get;}
        public PixbufCreator PixbufCreator {construct; private get;}

        private Image[] images;

        public PictureData GetPictureData(Scan.Scanner scanner, FilmFormat format)
        {
            var window = CreateWindow(scanner, format);
            window.show_all();
            window.destroy.connect(() => main_quit());
            Gtk.main();


            return Gatherer.GetPictureData(scanner, format);
        }


        private Gtk.Window CreateWindow(Scan.Scanner scanner, FilmFormat format)
        {
            var window = new Gtk.Window();
            var table = new Grid();

            int i = 0;
            images = new Image[format.Frames.size];
            foreach(var frame in format.Frames)
            {
                var image = new Image();
                table.attach(image, 0, 2*i, 1, 2);

                var buttonBox = new ButtonBox(Orientation.HORIZONTAL);
                buttonBox.pack_start(new Button());
                table.attach(buttonBox, 1, 2 * i + 1, 1, 1);
                images[i] = image;
                i++;
            }
            window.add(table);

            GetPreviewImages.begin(scanner, format.Frames.to_array());

            return window;
        }

        private async void GetPreviewImages(Scan.Scanner scanner, FrameData[] frames)
            requires(frames.length == images.length)
        {
            var f = frames;
            for(int i = 0; i < f.length; i++)
            {
                var frame = f[i];
                var scanned = yield Scanner.ScanAsync(scanner, frame, 300);

                var pixbuf = PixbufCreator.CreateScaledPixbufFromScannedFrame(scanned, 200);

                var image = images[i];
                image.set_from_pixbuf(pixbuf);
            }
        }
    }
}
