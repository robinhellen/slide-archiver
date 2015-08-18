

namespace SlideArchiver
{
    public class PictureDataGatherer : Object, IPictureDataGatherer
    {
        public FilmStorage FilmStore {construct; private get;}

        public PictureData GetPictureData(Scan.Scanner scanner, FilmFormat format)
        {
            var newFilm = true;
            if(newFilm)
            {
                var filmRoll = (FilmRoll)Object.new(typeof(FilmRoll));
                FilmStore.StoreNewRoll(filmRoll);
                return (PictureData)Object.new(typeof(PictureData), FilmRoll: filmRoll, StartingFrameNumber: 0);
            }
            else
            {
                var filmRoll = FilmStore.GetFilmById(0);
                return (PictureData)Object.new(typeof(PictureData), FilmRoll: filmRoll, StartingFrameNumber: filmRoll.NextFrame);
            }
        }
    }

    public interface FilmStorage : Object
    {
        public abstract FilmRoll? GetFilmById(int id);
        public abstract void StoreNewRoll(FilmRoll roll);
    }
}
