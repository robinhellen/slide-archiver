using Diva;

namespace SlideArchiver
{
    public int main(string[] args)
    {
        var builder = new ContainerBuilder();
        builder.Register<Archiver>();

        var container = builder.Build();

        var archiver = container.Resolve<Archiver>();

        archiver.Run();

        return 0;
    }
}
