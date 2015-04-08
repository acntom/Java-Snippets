//TCPServer.java

import java.io.*;
import java.net.*;

interface SocketConnection
{
	void clientDataReceived(String s);
}

public class TCPServer 
{
   
	int serverPort = 31337;
	public SocketConnection delegate;
	ServerSocket server;
	PrintWriter client;
	
	public TCPServer(int sPort)
	{
		try {
			 server = new ServerSocket (sPort);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        System.out.println ("TCPServer Waiting for client on port: "+sPort);
	}
		
	public void runServer() throws Exception
	{
		String fromclient;

        while(true) 
        {
           Socket connected = server.accept();
           System.out.println( " THE CLIENT"+" "+connected.getInetAddress() +":"+connected.getPort()+" IS CONNECTED ");

           BufferedReader inFromClient = new BufferedReader(new InputStreamReader(connected.getInputStream()));
           PrintWriter outToClient = new PrintWriter(connected.getOutputStream(),true);
           client = outToClient;
           //outToClient.write("Hello There!\n");

           while ( true )
           {           	
	           fromclient = inFromClient.readLine();	
               if ( fromclient.equals("q") || fromclient.equals("Q") ) {
               		connected.close();
               		break;
               } else {
            	   delegate.clientDataReceived(fromclient);
		       }
               Thread.sleep(1);
			}  
         }
	}
	
	public void disconnectAllClients()
	{
		
	}

}