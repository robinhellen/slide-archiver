using Gee;
using Scan;

namespace SlideArchiver
{
    public class FixedFormatDetector : Object, IFormatDetector
    {
        public FilmFormat GetFormat(Scan.Scanner scanner)
        {
            return Canon9000Slides135();
        }

        private FilmFormat Canon9000Slides135()
        {
            var format = new FilmFormat();
            format.Frames = new ArrayList<FrameData>();
            format.Frames.add(new FrameData());
            /*format.Frames.add(new FrameData());
            format.Frames.add(new FrameData());
            format.Frames.add(new FrameData());*/
            return format;
        }
    }
}
