import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URL;
import java.util.zip.GZIPInputStream;


public class MainActivity {
	public static void main(String[] args) throws Exception {
		URL u = new URL("http://dumps.wikimedia.org/other/pagecounts-raw/2014/2014-09/pagecounts-20140928-180000.gz");
        InputStream fileStream = u.openStream();
        InputStream gzipStream = new GZIPInputStream(fileStream);
        Reader decoder = new InputStreamReader(gzipStream, "UTF-8");
        BufferedReader buffered = new BufferedReader(decoder);
        
        String line = null;
        while((line = buffered.readLine()) != null){
        	System.out.println(line);
        }
	}

}
