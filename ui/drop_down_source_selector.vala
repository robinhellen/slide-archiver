using Gee;
using Gtk;

namespace SlideArchiver.Ui
{
    public class DropDownSourceSelector : SourceSelector, Gtk.Frame
    {
        public FilmFormat Format {get; protected set;}

        private ComboBoxText chooser;

        construct
        {
            Format = Canon9000Negatives135(4,4);

            chooser = new ComboBoxText();
            add(chooser);

            chooser.append_text("135mm film mounted slides");
            chooser.append_text("135mm film negatives 4,4");
            chooser.set_active(1);

            chooser.changed.connect(() => Update());
        }

        private void Update()
        {
            switch(chooser.get_active())
            {
                case 0:
                    Format = Canon9000Slides135();
                    break;
                case 1:
                    Format = Canon9000Negatives135(4,4);
                    break;
            }
        }

        private FilmFormat Canon9000Slides135()
        {
            var format = new FilmFormat();

            format.Frames = new ArrayList<FrameData>();
            format.Frames.add(Get135SlideFrame(0));
            format.Frames.add(Get135SlideFrame(1));
            format.Frames.add(Get135SlideFrame(2));
            format.Frames.add(Get135SlideFrame(3));

            format.FilmTags = new ArrayList<string>();
            format.FilmTags.add("film-size-135");
            format.FilmTags.add("film-type-slide");

            return format;
        }

        private FilmFormat Canon9000Negatives135(int firstRow, int secondRow)
        {
            var format = new FilmFormat();

            format.Frames = new ArrayList<FrameData>();
            for(int i = 0; i < firstRow; i++)
            {
                format.Frames.add(Get135NegativeFrame(0, i));
            }
            for(int i = 0; i < secondRow; i++)
            {
                format.Frames.add(Get135NegativeFrame(1, i));
            }

            format.FilmTags = new ArrayList<string>();
            format.FilmTags.add("film-size-135");
            format.FilmTags.add("film-type-negative");

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
                Right: left + width,
                Rotations: 0,
                IsNegative: false
                );
        }

        private FrameData Get135NegativeFrame(int row, int i)
        {
            const double left = 76.876;
            const double width = 24.384;
            const double top = 25.042;
            const double height = 35.573;

            const double yspacing = 37.151;
            const double xspacing = 39.302;

            return (FrameData)Object.new(typeof(FrameData),
                Top: top + i * yspacing,
                Bottom: top + height + i * yspacing,
                Left: left + row * xspacing,
                Right: left + width + row * xspacing,
                Rotations: 1,
                IsNegative: true
                );
        }
    }
}
