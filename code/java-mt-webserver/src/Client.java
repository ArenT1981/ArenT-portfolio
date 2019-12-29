/* Filename:	Client.java
 * Author:	Aren Tyr
 * Date:	24/09/19
 * 
 * An extremely simple client that simply reads a 
 * String from the Server. */

import java.net.*;
import java.io.*;
import java.util.*;



public class Client
{
	public static void main(String[] args)
	{
		Socket sockConnect;
		int portOpen = 0;
		InputStream inputData;
		DataInputStream recieveData;
		
		try
		{
			portOpen = Integer.parseInt(args[1]);
		}
		catch(NumberFormatException e)
		{
			System.out.println(e.getMessage());
			System.exit(1);
		}
		
		try
		{
			
			sockConnect = new Socket(args[0], portOpen);
			System.out.println("Got connection.");
			
			inputData = sockConnect.getInputStream();
			recieveData = new DataInputStream(inputData);
			
			//read data from Server
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
