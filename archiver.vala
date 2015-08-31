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

            var pictureData = dataGatherer.GetPictureData(scanner, format);

            int i = 0;
            foreach(var frame in format.Frames)
            {
                var capturedFrame = frameScanner.Scan(scanner, frame, 300);
                frameStorage.Store(capturedFrame, pictureData, i++);
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
        public abstract PictureData GetPictureData(Scan.Scanner scanner, FilmFormat format);
    }

    public interface IFrameScanner : Object
    {
        public abstract Frame Scan(Scan.Scanner scanner, FrameData frameData, int resolution);
        public abstract async Frame ScanAsync(Scan.Scanner scanner, FrameData frame, int resolution, ProgressReporter? reporter = null);
        public abstract async Collection<Frame> ScanFramesAsync(Scan.Scanner scanner, Collection<FrameData> frames, int resolution, ProgressReporter? reporter = null);

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
        public FilmRoll FilmRoll {get; construct;}
        public int StartingFrameNumber {get; construct;}
    }

    public class FilmRoll : Object
    {
        public int Id {get; construct set;}
        public Collection<string> Tags {get; construct;}
        public int NextFrame {get; construct;}
        public File Folder {get; construct set;}
    }
}
