package com.tpt.java_socket;

import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class ServerSocketMain {

	public static void main(String[] args) throws IOException, InterruptedException {
		ServerSocket serverScoket = new ServerSocket(8888);
		Socket clientSocket = serverScoket.accept();
		System.out.println("Client Connected: "+clientSocket.getInetAddress()+clientSocket.getLocalPort());
		InputStream is = clientSocket.getInputStream();
		int readByte=-1;
		while(true) {
			if((readByte=is.read())>-1) {
			System.out.println(readByte);
		}else {
			System.out.println("listening ...");
			Thread.sleep(5000);
		} 
		}
	}
	
}
