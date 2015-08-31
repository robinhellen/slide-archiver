using Gee;
using Gtk;

namespace SlideArchiver.Ui
{
    public class PreviewWindow : Window
    {
        public FilmSelector FilmSelector {construct; private get;}
        public SourceSelector SourceSelector {construct; private get;}

        public ImagePreview ImagePreview {construct; private get;}
        public IScannerSelector ScannerSelector {construct; private get;}
        public IFrameStorage FrameStorage {construct; private get;}
        public IFrameScanner FrameScanner {construct; private get;}

        construct
        {
            var box = new Box(Orientation.VERTICAL, 0);

            var topBox = new Box(Orientation.HORIZONTAL, 0);
            topBox.pack_start(SourceSelector, true, true);
            topBox.pack_start(FilmSelector, true, true);
            box.pack_start(topBox, false);

            box.pack_start(ImagePreview, true, false);

            var buttons = new ButtonBox(Orientation.HORIZONTAL);
            box.pack_start(buttons, false);
            var save = new Button.with_label("Save");
            buttons.pack_end(save);
            save.sensitive = false;
            save.clicked.connect(SaveClicked);

            add(box);
            ImagePreview.notify["PreviewsAvailable"].connect(() => save.sensitive = ImagePreview.PreviewsAvailable);
        }

        private async void SaveClicked()
        {
            var scanner = ScannerSelector.GetScanner();
            var film = FilmSelector.Film;
            var pictureData = (PictureData)Object.new(typeof(PictureData), FilmRoll: film, StartingFrameNumber: film.NextFrame);
            int i = 0;
            var scannedFrames = yield FrameScanner.ScanFramesAsync(scanner, SourceSelector.Format.Frames, 300);
            foreach(var frame in scannedFrames)
            {
                FrameStorage.Store(frame, pictureData, i++);
            }
        }
    }

    public interface FilmSelector : Widget
    {
        public abstract FilmRoll Film {get; protected set;}
    }
    public interface SourceSelector : Widget
    {
        public abstract FilmFormat Format {get; protected set;}
    }

    public interface ImagePreview : Widget
    {
        public abstract bool PreviewsAvailable {get; protected set;}
    }

    public class FixedFilmSelector : FilmSelector, Label
    {
        public FilmRoll Film {get; protected set;}
        public FilmStorage Storage {construct; private get;}

        construct
        {
            Film = Storage.GetFilmById(1);
            set_label("Film Id 1");
        }
    }

    public class LastOrNewFilmSelector : FilmSelector, Box
    {
        public FilmRoll Film {get; protected set;}
        public FilmStorage Storage {construct; private get;}

        private Label filmName;

        construct
        {
            orientation = Orientation.HORIZONTAL;
            homogeneous = false;
            spacing = 3;

            Film = Storage.GetLastRoll();
            filmName = new Label(@"Film Id $(Film.Id)");
            pack_start(filmName, false);

            var create = new Button.with_label("New");
            create.clicked.connect(() =>
            {
                Film = (FilmRoll)Object.new(typeof(FilmRoll), Tags: Collection.empty<string>(), NextFrame: 0);
                Storage.StoreNewRoll(Film);
                filmName.set_label(@"Film Id $(Film.Id)");
            });
            pack_start(create, false);
        }
    }

    public class FixedSourceSelector : SourceSelector, Label
    {
        public FilmFormat Format {get; protected set;}

        construct
        {
            Format = Canon9000Slides135();
            set_label("135 film mounted slides");
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

    public class UiModule : Diva.Module
    {
        public override void load(Diva.ContainerBuilder builder)
        {
            builder.register<PreviewWindow>()
                .ignore_property("transient-for")
                .ignore_property("attached-to")
                .ignore_property("type");
            builder.register<LastOrNewFilmSelector>().as<FilmSelector>();
            builder.register<FixedSourceSelector>().as<SourceSelector>();
            builder.register<GridImagePreview>().as<ImagePreview>();
        }
    }
}

