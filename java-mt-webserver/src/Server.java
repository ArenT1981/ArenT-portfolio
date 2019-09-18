/*  Filename: 	Server.java
 *  Author: 	Aren Tyr
 *  Date:	18/11/01
 *
 *  Description:
 *
 *  This program implements a fully mulithreaded webserver capable of serving
 *  up HTML pages and any other arbitrary MIME types over the HTTP protocol.
 *
 *  The MIME-type string definitions simply need to be added for them to be
 *  served - e.g. "video/mpeg".
 *
 */

//import the necessary Java packages
import java.net.*;
import java.io.*;
import java.util.*;

//Main program class
//*****************************************************************************
public class Server
{
	//number of current connections to server
	private static int noOfConnections = 0;

	//increment connections
	static void incConnections()
	{
		noOfConnections++;
	}

	//decrement connections
	static void decConnections()
	{
		noOfConnections--;
	}

	//return the number of active connections
	static int retConnections()
	{
		return noOfConnections;
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
//*****************************************************************************
class listenManager extends Thread
{
	private ServerSocket localSock = null;

	private Socket mSocket = null;

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
				Server.incConnections();

				int connections = Server.retConnections();

				//give the current connection a unique name
				String conS = String.valueOf(connections);
				String r = "Connection" + conS;

				//create a connectionManager thread
				acceptConnection connectionManager = new acceptConnection(mSocket, r);
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
 * the requested file back to the client
 */
//*****************************************************************************
class acceptConnection extends Thread
{

	// *** Create the necessary network objects ***

	// ------------  Output  ----------------------
	private Socket opSocket;
	private OutputStream mainOutput;
	private DataOutputStream sendOutput;
	private PrintStream printHTML;

	//------------  Input  ------------------------
	private InputStream iS;
	private BufferedInputStream bIS;
	private DataInputStream diS;
	private File dataToServe;

	// ********************************************

	// flow control booleans

	private boolean matchedPage = false;
	private boolean dataLeft = true;
	private boolean headerControl = false;
	// Strings used for processing requests

	private String connectionName;
	private String pageRequest = "";
	private String pageRoot = "./html/";

	// *** HTTP Protocol Header strings **********
	// Request OK:
	private String headerOK = "HTTP/1.1 200";
	// The MIME type to send to the browser
	private String headerTYPE = "Content-type:";
	// Encoding format (chunked allows dynamic length)
	private String headerENC =  "Content-Encoding:chunked";

	// MIME type (e.g. text/html) string
	private String mtype = "";

	//This creates the CRLF (carriage return line feed) termination
	//symbol needed by the HTTP protocol
	private static final byte[] LINETERM = {(byte)'\r', (byte)'\n' };

	// *******************************************

	// Byte arrays for storing requests & sending data

	private byte buffer[] = new byte[4096]; //4k buffer for reading request into
	private byte webpage[] = new byte[4096]; //4k pipe for transmitting data

	private static final int MAXFILELENGTH = 256;

	//lookup table for MIME types for use in the "Content-type" field
	private static final String[] MIMEtypes = {"text/html", "image/jpeg", "image/gif",
					"image/png", "text/plain", "unknown/unknown"};


	// other instance variables
	private int useIndex = 0;
	private int readBytes = 0;
	private int j = 1;
	private int readData = 0;

	public acceptConnection(Socket socketConnection, String conName )
	{
		opSocket = socketConnection;
		connectionName = conName;
	}

	void obtainStreams()
	{
		try
		{
			//attempt to get the input stream for the socket
			iS = opSocket.getInputStream();
			mainOutput = opSocket.getOutputStream();

			//output the connection name on STD I/O
			System.out.println("Got connection : " + connectionName);

			//create a new printStream object for writing
			printHTML = new PrintStream(mainOutput);

			//read the browser's request - we don't actually
			//do anything with it
			readBytes = iS.read(buffer);

		}
		catch (IOException e)
		{
			System.out.println("Transfer attempt failed.");
		}
		catch (Exception e) {};
	}

	void acceptConnection()
	{

			for(int i=0; i < readBytes; i++)
			{
				char p = (char)buffer[i];
				//check to see if we have a GET request...
				if((p == 'G' || p == 'E' || p == 'T' || p == ' ') && headerControl == false)
					continue;

				//determine the requested file
				else if(p == '/' && headerControl == false)
				{
					headerControl = true;

					//the case where nothing (i.e. the server root) was requested
					if((char)buffer[i+j] == ' ')
					{
						pageRequest = "index.html";
						mtype = "html";
						matchedPage = true;
						break;
					}


					//parse the input until we either have a space (bad)
					//or a period, signifying that we should look at the
					//file extension
					while(((char)buffer[i+j] != ' ') && ((char)buffer[i+j] != '.'))
					{
						pageRequest += (char)buffer[i+j];
						j++;

						if(j > MAXFILELENGTH)
						{
							System.out.println("Filename request is too large.");
						}

					}

					//parse the file extension to determine the MIME type
					if(((char)buffer[i+j] == '.') && (readBytes > (buffer[i+j]+5)))
					{
						while((char)buffer[i+j] != ' ')
						{
							if((char)buffer[i+j] != '.')
								mtype = mtype + (char)buffer[i+j];

							pageRequest = pageRequest + (char)buffer[i+j];
							j++;
							matchedPage = true;
						}

					}
				}

			}

	}

	void determineMIMEtype()
	{
			//determine which "Content-type: <MIME type>" string to use.
			//useIndex is an index into our MIMEtypes lookup table
			if(mtype.equalsIgnoreCase("html") || mtype.equalsIgnoreCase("htm"))
					useIndex = 0;
			else if(mtype.equalsIgnoreCase("jpeg") || mtype.equalsIgnoreCase("jpg"))
					useIndex = 1;
			else if(mtype.equalsIgnoreCase("gif"))
					useIndex = 2;
			else if(mtype.equalsIgnoreCase("png"))
					useIndex = 3;
			else if(mtype.equalsIgnoreCase("txt"))
					useIndex = 4;
			else
				useIndex = 5;
	}


	void printHTTPheader()
	{
		try
		{
			//send the HTTP header to the browser
			// *** HTTP HEADER ****
			printHTML.print(headerOK);
			printHTML.write(LINETERM);
			printHTML.print(headerTYPE + MIMEtypes[useIndex]);
			printHTML.write(LINETERM);
			printHTML.print(headerENC);
			printHTML.write(LINETERM);
			printHTML.write(LINETERM);
			// ********************
		}
		catch(IOException e)
		{
			System.out.println("An error whilst sending the HTTP header.");
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}


	void sendData()
	{

		try
		{

			//try to read the requested file
			diS = new DataInputStream(new BufferedInputStream(new FileInputStream(dataToServe)));
			do
			{
				/*
				 * Create a data pipeline.
				 *
				 * Read up to 4k of the file in at a time before sending
				 * it until the file is completely read.
				 */

				readData = diS.read(webpage, 0, webpage.length);

				if(readData != -1)
				{
					for(int k = 0; k < readData; k++)
					printHTML.write(webpage[k]);
				}

				//file has been completely read...
				if(readData == -1)
				{
					dataLeft = false;
					printHTML.write(LINETERM);
				}


			} while (dataLeft == true);


		}
		catch(IOException e)
		{
			System.out.println("Error reading webpage file.");
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}


	void serveRequest()
	{
		//attempt to obtain a file descriptor for the given request
		dataToServe = new File(pageRoot + pageRequest);

		//does the requested page exist? If yes...
		if(dataToServe.exists() == true)
		{
			System.out.println("	-> MIME type requested: " + MIMEtypes[useIndex]);
			System.out.println("	-> Item " + pageRequest + " requested - serving...");
			printHTTPheader();
			sendData();


		}
		//page doesn't exist, so output error.html to browser
		else
		{
			System.out.println("Request for non-existant page.");
			dataToServe = new File(pageRoot + "error.html");
			useIndex = 0;
			printHTTPheader();
			sendData();
		}
	}

	void closeStreams()
	{
		//tidy up
		try
		{
			printHTML.close();
			iS.close();
			mainOutput.close();
			opSocket.close();
		}
		catch(IOException e)
		{
			System.out.println("Closing streams cleanly failed.");
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}

	void negotiateTransfer()
	{

		obtainStreams();
		acceptConnection();
		determineMIMEtype();
		serveRequest();
		closeStreams();

		//decrement the number of active connections
		Server.decConnections();
	}


	public void run()
	{

		// MAIN THREAD EXECUTION STARTUP
		//attempt to service the connection request
		negotiateTransfer();

	}
}
