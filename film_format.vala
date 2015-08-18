using Gee;

namespace SlideArchiver
{
    public class FilmFormat : Object
    {
        public Collection<FrameData> Frames;
    }

    public class FrameData : Object
    {
        public double Top {get; construct;}
        public double Left {get; construct;}
        public double Right {get; construct;}
        public double Bottom {get; construct;}
    }
}
