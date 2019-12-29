/*  Filename: 	simpleServer.java
 *  Author: 	Aren Tyr
 *  Date:	23/09/19
 *  
 *  A simple multithreaded server that listens for requests 
 *  and then spawns a new thread to service the request.
 */
 

import java.net.*;
import java.io.*;
import java.util.*;

//Main program class
public class simpleServer 
{
	
	//number of active connections to our server
	static int numberOfConnections = 0;
	
	//increment connections
	static void incConnections()
	{
		++numberOfConnections;
	}

	//decrement connections
	static void decConnections()
	{
		--numberOfConnections;
	}

	//return the number of active connections
	static int retConnections()
	{
		return numberOfConnections;
	}
	
	public static void main(String[] args)
	{
	
		//create a ServerSocket object
		ServerSocket servSocket = null;
		int portConnect = 0;
				
		System.out.println("Attempting to start server...");
		
		// Attempt to determine to port to start the server on 
		try 
		{
			portConnect = Integer.parseInt(args[0]);
		} 
		catch(NumberFormatException e)
		{
			System.out.println("Invalid value specified for port.");
			System.exit(1);
		}
		
		// Attempt to create a system socket on the given port
		try
		{
			servSocket = new ServerSocket(portConnect);
		}
		catch(IOException e)
		{
			System.out.println("Unable to initialize port. Is the port restricted?");
			System.exit(1);
		}
		
		
		//main program execution
		
		listenManager p1 = new listenManager(servSocket);
		listenManager p2 = new listenManager(servSocket);

		/* fire off two threads, each listening - 
		 * the aim is to allow the server to maximize
		 * the number of possible simulateous connections. */
		p1.start();
		p2.start();

		System.out.println("Server started. Listening on port: " + Integer.parseInt(args[0]));
		
	}
}

/* This class listens for requests and spawns off 
 * threads accordingly to deal with the request.
 */
class listenManager extends Thread
{
	ServerSocket localSock = null;
		
	Socket mSocket = null;
		
	public listenManager(ServerSocket sS)
	{
		localSock = sS;
	}
		
	public void run()
	{
		for(;;)
		{
			try
			{
				//accept the connection attempt on the socket
				mSocket = localSock.accept();
				
				//increment the number of active connections
				simpleServer.incConnections();
				
				//give the current connection a unique name
				System.out.println("Got connection: " + simpleServer.retConnections());
				
				//create a connectionManager thread
				acceptConnection connectionManager = new acceptConnection(mSocket);
				//now deal with the request	
				connectionManager.start();
			}
			catch(IOException e)
			{
				System.out.println(e.getMessage());
			}
		}
	}
}

/* This class actually services the request by sending
 * the HTML code back to the client
 */
class acceptConnection extends Thread
{
	//create the necessary network objects	
	Socket opSocket;
	OutputStream mainOutput;
	DataOutputStream sendOutput;
				
	public acceptConnection(Socket socketConnection)
	{
		opSocket = socketConnection;
	}
		
	void negotiateTransfer()
	{

		try
		{		
			
			//delay for an random amount of time to test
			//that the mulithreading is actually working
			Thread.sleep((int)Math.random() * 1000);
			mainOutput = opSocket.getOutputStream();
			sendOutput = new DataOutputStream(mainOutput);

			//output OK & the current timestamp
			sendOutput.writeUTF("OK" + (new Date()).toString());

			sendOutput.close();
			mainOutput.close();
			opSocket.close();

			//decrement the number of active connections

			simpleServer.decConnections();
		}
		catch (IOException e) 
		{ 
			System.out.println("Transfer attempt failed.");
		}
		catch (Exception e) {};	
			
	}
		
			
	public void run()
	{
			
		//attempt to service the connection request	
		negotiateTransfer();	

	}
}	
	
