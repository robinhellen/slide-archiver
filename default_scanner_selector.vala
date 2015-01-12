using Scan;

namespace SlideArchiver
{
    public class DefaultScannerSelector : Object, IScannerSelector
    {
        public ScanContext Context {construct; private get;}

        public Scan.Scanner? GetScanner()
        {
            try
            {
                var allScanners = Context.get_devices(false);
                foreach(var scanner in allScanners)
                {
                    if(scanner.name.has_prefix("pixma"))
                        return scanner;
                }
            }
            catch(ScannerError e)
            {
                stderr.printf(@"Error while trying to discover scanners: $(e.message).");
            }
            return null;
        }
    }
}
