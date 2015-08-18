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

        public void Store(Frame frame, PictureData data, int sequenceNo)
        {
            stderr.printf(@"Storing frame: lines:$(frame.Lines), pixelsPerLine:$(frame.PixelsPerLine).\n");
            // take every other byte from the data
            var newDataLength = frame.data.length / 2;
            var eightBitData = new uint8[newDataLength];
            for(int i = 0; i < newDataLength; i++)
            {
                eightBitData[i] = frame.data[i * 2 + 1];
            }

            var pixbuf = new Pixbuf.from_data(eightBitData, Colorspace.RGB, false, 8, frame.PixelsPerLine, frame.Lines, frame.BytesPerLine / 2);
            pixbuf.save(@"/home/robin/Pictures/foo$(index++).bmp", "bmp");
        }
    }
}
