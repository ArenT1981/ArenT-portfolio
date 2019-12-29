/* Filename:	ClientThreadTest.java
 * Author:	Aren Tyr
 * Date: 	24/09/19
 * 
 * This is test program to exercise the multithreading capabilities
 * of the server by spawning off 100 threads all trying to obtain
 * data from the server. */

import java.net.*;
import java.io.*;
import java.util.*;

public class ClientThreadTest
{
	public static void main(String[] args)
	{
		//create an array of Threads
		Thread p[] = new makeRequest[100];
				
				
		try 
		{
			//fire off all the Threads
			for(int i=0; i<100; i++)
			{
				p[i] = new makeRequest();
			
				p[i].start();
			}
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
			e.printStackTrace();
		}
	}
}

class makeRequest extends Thread
{

	public void run()
	{
		Socket sockConnect;

		InputStream inputData;
		DataInputStream recieveData;
		
		String p = "localhost";

		
		try
		{
			
			sockConnect = new Socket(p, 8100);
			System.out.println("Got connection.");
			
			inputData = sockConnect.getInputStream();
			recieveData = new DataInputStream(inputData);
			
			//read the data from the server
			String message = recieveData.readUTF();
			System.out.println("Client recieved \"" + message + "\" from server.");
			
			recieveData.close();
			inputData.close();
			
			sockConnect.close();
			
		}
		catch(IOException e)
		{
			System.out.println(e.getMessage());
		}
	}
}
