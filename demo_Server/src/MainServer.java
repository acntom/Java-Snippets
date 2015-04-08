import processing.core.PApplet;


public class MainServer extends PApplet implements SocketConnection{
	
	TCPServer tcpServer = new TCPServer(24124);

	public void setup(){
		tcpServer.delegate = this;
		Thread t = new Thread() {
		   public void run() {
			   while(true) {
				   try {
					tcpServer.runServer();
				} catch (Exception e) {
					e.printStackTrace();
				}
			   }
		  };
		};
		
		t.start();

	}
	
	public void draw(){

	}

	public void clientDataReceived(String s)
	{
		System.out.println("received");
		System.out.println(s);
	}

}
