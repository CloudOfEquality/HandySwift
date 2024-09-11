//
//  UDPSocketClient.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/7/3.
//

import Foundation

class UDPSocketClient: NSObject, GCDAsyncUdpSocketDelegate {
    private var udpSocket: GCDAsyncUdpSocket

    override init() {
        udpSocket = GCDAsyncUdpSocket(delegate: nil, delegateQueue: DispatchQueue.main)
        super.init()

        udpSocket.setDelegate(self)
    }

    func sendString(_ string: String, toHost host: String, onPort port: UInt16) {
        guard let data = string.data(using: .utf8) else { return }
        udpSocket.send(data, toHost: host, port: port, withTimeout: -1, tag: 0)
    }

    // MARK: - GCDAsyncUdpSocketDelegate

    func udpSocket(_: GCDAsyncUdpSocket, didSendDataWithTag _: Int) {
        // Handle the event when data is successfully sent
    }

    func udpSocket(_: GCDAsyncUdpSocket, didNotSendDataWithTag _: Int, dueToError _: Error?) {
        // Handle the event when data sending fails
    }

    func udpSocket(_: GCDAsyncUdpSocket, didReceive _: Data, fromAddress _: Data, withFilterContext _: Any?) {
        // Handle the event when data is received
    }
}
