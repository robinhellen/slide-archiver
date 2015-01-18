using Diva;

namespace SlideArchiver
{
    public int main(string[] args)
    {
        var builder = new ContainerBuilder();
        builder.Register<Archiver>();

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
