using Diva;
using Scan;

namespace SlideArchiver
{
    public int main(string[] args)
    {
        var builder = new ContainerBuilder();
        builder.register<Archiver>();
        builder.register<DefaultScannerSelector>().as<IScannerSelector>();
        builder.register<FixedFormatDetector>().as<IFormatDetector>();
        builder.register<PictureDataGatherer>().as<IPictureDataGatherer>();
        builder.register<UiPictureDataGatherer>().as<IPictureDataGatherer>();
        builder.register<FrameScanner>().as<IFrameScanner>();
        builder.register<PicturesFolderFrameStorage>().as<IFrameStorage>();
        builder.register<FolderFilmStore>().as<FilmStorage>();
        builder.register<PixbufCreator>();
        builder.register_module(new Ui.UiModule());

        builder.register<ScanContext>().single_instance();

        var container = builder.build();

        Gtk.init(ref args);

        try
        {
            var window = container.resolve<Ui.PreviewWindow>();
            window.destroy.connect(() => Gtk.main_quit());
            window.show_all();
            Gtk.main();
        }
        catch(ResolveError e)
        {
            stderr.printf(@"Unable to properly run the archiver: $(e.message)\n");
            return -1;
        }

        return 0;
    }
}
