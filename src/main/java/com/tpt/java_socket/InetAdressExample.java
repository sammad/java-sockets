package com.tpt.java_socket;

import java.io.IOException;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Enumeration;

public class InetAdressExample {

	public static void main(String[] args) throws IOException {
		try {
			Enumeration<NetworkInterface> networkInterfaces = NetworkInterface.getNetworkInterfaces();
			while(networkInterfaces.hasMoreElements()) {
				NetworkInterface networkInterface = networkInterfaces.nextElement();
				Enumeration<InetAddress> inetAddresses= networkInterface.getInetAddresses();
				while(inetAddresses.hasMoreElements()) {
					InetAddress inetAddress = inetAddresses.nextElement();
					System.out.print((inetAddress instanceof Inet4Address)?"V4-":"V6-");
					System.out.print(" "+inetAddress.getHostAddress());
					System.out.println("\tIsReacheable="+inetAddress.isReachable(20));
				}
			}
		} catch (SocketException e) {
			e.printStackTrace();
		}
		for(String arg:args) {
			try {
				InetAddress[] inetAddressList = Inet4Address.getAllByName(arg);
				for(InetAddress address:inetAddressList) {
					
					/*
					 * System.out.print((address instanceof Inet4Address)?"V4-":"V6-");
					 * System.out.print(" "+address.getHostAddress()+"-"+address.getHostName());
					 */
					System.out.println("\tIsReacheable="+address.isReachable(1));
					
				}
			} catch (UnknownHostException e) {
				e.printStackTrace();
			}
		}
	}

}
