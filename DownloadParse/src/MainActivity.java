import java.io.FileOutputStream;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;


public class MainActivity {
	public static void main(String[] args) throws Exception {
		URL website = new URL("http://dumps.wikimedia.org/other/pagecounts-raw/2014/2014-09/pagecounts-20140928-180000.gz");
		ReadableByteChannel rbc = Channels.newChannel(website.openStream());
		FileOutputStream fos = new FileOutputStream("/Users/zhangyang/Desktop/pagecounts-20140928-180000.gz");
		fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
		System.out.println("ready");
	}

}
