

namespace SlideArchiver
{
    public class PictureDataGatherer : Object, IPictureDataGatherer
    {
        public PictureData GetPictureData(Scan.Scanner scanner)
        {
            var result = new PictureData();
            result.Resolution = 300;
            return result;
        }
    }
}
