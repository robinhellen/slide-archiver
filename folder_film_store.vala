using Gee;

namespace SlideArchiver
{
    public class FolderFilmStore : Object, FilmStorage
    {
        private File baseFolder;

        construct
        {
            baseFolder = File.new_for_path("/photos/films");
        }

        public FilmRoll? GetFilmById(int id)
        {
            var tryFolder = baseFolder.get_child(@"$id");
            if(!tryFolder.query_exists())
                return null;

            int lastId = 0;

            var enumerate = tryFolder.enumerate_children("standard::*", FileQueryInfoFlags.NONE);
            FileInfo info;
            while((info = enumerate.next_file()) != null)
            {
                var basename = info.get_name();
                var dotIndex = basename.index_of(".bmp");
                var x = int.parse(basename[4:dotIndex]);
                if(x > lastId)
                    lastId = x;
            }

            return (FilmRoll)Object.new(typeof(FilmRoll), Id: id, Tags: Collection.empty<string>(), NextFrame: lastId + 1, Folder: tryFolder);
        }

        public void StoreNewRoll(FilmRoll roll)
        {
            int id = 0;

            var enumerate = baseFolder.enumerate_children("standard::*", FileQueryInfoFlags.NONE);
            FileInfo info;
            while((info = enumerate.next_file()) != null)
            {
                var x = int.parse(info.get_name());
                if(x > id)
                    id = x;
            }
            id++;


            var tryFolder = baseFolder.get_child(@"$id");
            if(tryFolder.query_exists())
                return;

            tryFolder.make_directory();
            roll.Id = id;
            roll.Folder = tryFolder;
        }
    }
}
