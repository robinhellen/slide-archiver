using Gee;

namespace SlideArchiver
{
    public class FilmFormat : Object
    {
        public Collection<FrameData> Frames;
        public Collection<string> FilmTags;
    }

    public class FrameData : Object
    {
        construct
        {
            Tags = new LinkedList<string>();
        }

        public double Top {get; construct;}
        public double Left {get; construct;}
        public double Right {get; construct;}
        public double Bottom {get; construct;}

        public Collection<string> Tags {get; private set;}
    }
}
