import matlabcontrol.MatlabConnectionException;
import matlabcontrol.MatlabInvocationException;
import matlabcontrol.MatlabProxy;
import matlabcontrol.MatlabProxyFactory;


public class Main {

	public static void main(String[] args) throws MatlabConnectionException, MatlabInvocationException
	{
	    //Create a proxy, which we will use to control MATLAB
	    MatlabProxyFactory factory = new MatlabProxyFactory();
	    MatlabProxy proxy = factory.getProxy();

	    //Set a variable, add to it, retrieve it, and print the result
	    proxy.eval("disp('Socket successfully established!')");
	    System.out.println("Socket successfully established!");
	    proxy.eval("addpath(genpath('ECTSimv2_Matlab'))");
	    //proxy.eval("run imageReconstruction.m");
	    proxy.eval("pixel = imageRec()");
	    
	    double result;
	    
	    /*
	    for(int i = 0; i < 1024; i++){
	    	result = ((double[]) proxy.getVariable("pixel"))[i];
	    	System.out.print(result + " ");
	    	if((i + 1)%32 == 0){
	    		System.out.println("");
	    	}
	    }
	    System.out.println(" ");*/
	    
	    System.out.println("done!");
	    proxy.eval("pixel = imageRec()");
	    System.out.println("done!");
	    proxy.eval("pixel = imageRec()");
	    System.out.println("done!");
	    proxy.eval("pixel = imageRec()");
	    System.out.println("done!");
	    proxy.eval("pixel = imageRec()");
	    System.out.println("done!");
	    

	    //Disconnect the proxy from MATLAB
	    proxy.disconnect();
	}

}
