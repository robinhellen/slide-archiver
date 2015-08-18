using Diva;
using Scan;

namespace SlideArchiver
{
    public int main(string[] args)
    {
        var builder = new ContainerBuilder();
        builder.Register<Archiver>();
        builder.Register<DefaultScannerSelector>().As<IScannerSelector>();
        builder.Register<FixedFormatDetector>().As<IFormatDetector>();
        builder.Register<PictureDataGatherer>().As<IPictureDataGatherer>();
        builder.Register<FrameScanner>().As<IFrameScanner>();
        builder.Register<PicturesFolderFrameStorage>().As<IFrameStorage>();
        builder.Register<FolderFilmStore>().As<FilmStorage>();

        builder.Register<ScanContext>().SingleInstance();

        var container = builder.Build();

        Archiver archiver;
        try
        {
            archiver = container.Resolve<Archiver>();
        }
        catch(ResolveError e)
        {
            stderr.printf(@"Unable to properly run the archiver: $(e.message)\n");
            return -1;
        }

        archiver.Run();

        return 0;
    }
}
