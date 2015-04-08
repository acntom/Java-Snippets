import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;


public class TCPClient {
	Socket client;
	PrintWriter out;
	BufferedReader in; 
	
	public TCPClient(String h, int p)
	{
		try {
			client = new Socket(h, p);
			out = new PrintWriter(client.getOutputStream(), true);
			in =  new BufferedReader(new InputStreamReader(client.getInputStream()));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void send(String s)
	{
		out.println(s);
	}
	
}
