package com.tpt.java_socket;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;

public class TCPClient {

	public static void main(String[] args) throws UnknownHostException, IOException, InterruptedException {
	Socket socket = new Socket(InetAddress.getLocalHost(), 8888);
	OutputStream out = socket.getOutputStream();
	System.out.println(socket.getLocalPort());
	byte[] data = "New MS Component Data".getBytes();
	out.write(data);
	InputStream is = socket.getInputStream();
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
