using Gdk;

namespace SlideArchiver
{
    public class NullFrameStorage : Object, IFrameStorage
    {
        public void Store(Frame frame, PictureData data, int sequenceNo)
        {
        }
    }

    public class PicturesFolderFrameStorage : Object, IFrameStorage
    {
        static int index = 0;

        public PixbufCreator PixbufCreator {construct; private get;}

        public void Store(Frame frame, PictureData data, int sequenceNo)
        {
            stderr.printf(@"Storing frame: lines:$(frame.Lines), pixelsPerLine:$(frame.PixelsPerLine).\n");

            var pixbuf = PixbufCreator.CreatePixbufFromScannedFrame(frame);
            var saveFolder = data.FilmRoll.Folder;
            var saveFile = saveFolder.get_child(@"img_$(data.FilmRoll.NextFrame + sequenceNo).bmp");
            pixbuf.save(saveFile.get_path(), "bmp");
        }
    }
}
