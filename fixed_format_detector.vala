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
            format.Frames.add(Get135SlideFrame(0));
            format.Frames.add(Get135SlideFrame(1));
            format.Frames.add(Get135SlideFrame(2));
            format.Frames.add(Get135SlideFrame(3));
            return format;
        }

        private FrameData Get135SlideFrame(int i)
        {
            const double left = 90.700;
            const double width = 35.019;
            const double top = 39.222;
            const double height = 23.112;

            const double spacing = 55.680;

            return (FrameData)Object.new(typeof(FrameData),
                Top: top + i * spacing,
                Bottom: top + height + i * spacing,
                Left: left,
                Right: left + width
                );
        }
    }
}
