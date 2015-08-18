using Gee;
using Scan;

namespace SlideArchiver
{
    public class Archiver : Object
    {
        public IScannerSelector scannerSelector {construct; private get;}
        public IFormatDetector formatDetector {construct; private get;}
        public IPictureDataGatherer dataGatherer {construct; private get;}
        public IFrameScanner frameScanner {construct; private get;}
        public IFrameStorage frameStorage {construct; private get;}

        public void Run()
        {
            var scanner = scannerSelector.GetScanner();
            if(scanner == null)
            {
                stderr.printf("Unable to find a suitable scanner.");
                return;
            }

            var format = formatDetector.GetFormat(scanner);

            var pictureData = dataGatherer.GetPictureData(scanner);

            int i = 0;
            foreach(var frame in format.Frames)
            {
                var capturedFrame = frameScanner.Scan(scanner, frame, pictureData.Resolution);
                frameStorage.Store(capturedFrame, pictureData, i);
            }
        }
    }

    public interface IScannerSelector : Object
    {
        public abstract Scan.Scanner? GetScanner();
    }

    public interface IFormatDetector : Object
    {
        public abstract FilmFormat GetFormat(Scan.Scanner scanner);
    }

    public interface IPictureDataGatherer : Object
    {
        public abstract PictureData GetPictureData(Scan.Scanner scanner);
    }

    public interface IFrameScanner : Object
    {
        public abstract Frame Scan(Scan.Scanner scanner, FrameData frameData, int resolution);
    }

    public interface IFrameStorage : Object
    {
        public abstract void Store(Frame frame, PictureData data, int sequenceNo);
    }

    public class Frame : Object
    {
        public int BytesPerLine;
        public int Depth;
        public int Lines;
        public int PixelsPerLine;
        public uint8[] data;
    }

    public class PictureData : Object
    {
        public int Resolution {get; set;}
    }
}
