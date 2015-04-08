import processing.core.PApplet;


public class MainClient extends PApplet{
	TCPClient ppiSocket;
	public void setup(){
		ppiSocket = new TCPClient("127.0.0.1", 24124);
		
	}
	
	public void draw(){
		
		
	
		
	}
	
	public void keyPressed(){
		System.out.println("send 123");
		ppiSocket.send("123");
	}

}
