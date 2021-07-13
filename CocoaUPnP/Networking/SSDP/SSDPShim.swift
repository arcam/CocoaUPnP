// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

import Foundation
import Socket

enum UDPSocketError: Error {
    case addressCreationFailure
    case writeError(underlayingError: Error)
    case readError(underlayingError: Error)
}

protocol UDPSocketProtocol {
    func write(_ string: String, to host: String, on port: UInt) throws
    func readDatagram(into data: inout Data) throws
    func close()
}

extension Socket: UDPSocketProtocol {
    func write(_ string: String, to host: String, on port: UInt) throws {
        guard let signature = self.signature, signature.socketType == .datagram, signature.proto == .udp else {
            fatalError("Only UDP sockets can use this method")
        }

        guard let address = Socket.createAddress(for: host, on: Int32(port)) else {
            throw(UDPSocketError.addressCreationFailure)
        }
        do {
            try write(from: string, to: address)
        } catch {
            throw(UDPSocketError.writeError(underlayingError: error))
        }
    }

    func readDatagram(into data: inout Data) throws {
        guard let signature = self.signature, signature.socketType == .datagram, signature.proto == .udp else {
            fatalError("Only UDP sockets can use this method")
        }

        do {
            let (_,_) = try readDatagram(into: &data)
        } catch {
            throw(UDPSocketError.readError(underlayingError: error))
        }
    }
}

extension Socket {
    static func createUDPSocket() throws -> UDPSocketProtocol {
        return try Socket.create(type: .datagram, proto: .udp)
    }
}

enum SocketState {
    case ready
    case active
    case closed

    var isReady: Bool {
        self == .ready
    }

    var isActive: Bool {
        self == .active
    }

    var isClosed: Bool {
        self == .closed
    }
}

@objc public class SocketAdapter: NSObject {
    private let host: String
    private let port: UInt
    private let socket: UDPSocketProtocol
    private var state: SocketState = .ready

    private let writeQueue = DispatchQueue(
        label: "com.harman.udpsocket.write.queue",
        attributes: .concurrent
    )

    private let readQueue = DispatchQueue(
        label: "com.harman.udpsocket.listen.queue",
        attributes: .concurrent
    )

    @objc public weak var delegate: SocketAdapterDelegate?

    @objc public init?(host: String, port: UInt) {
        guard let socket = try? Socket.createUDPSocket() else { return nil }
        self.socket = socket
        self.host = host
        self.port = port
    }

    @objc public func send(message: String) {
        guard !state.isClosed else {
            return
        }

        let shouldStartListening = state.isReady
        state = .active

        if shouldStartListening {
            startListening(on: readQueue)
        }

        writeQueue.async {
            do {
                try self.socket.write(message, to: self.host, on: self.port)
            } catch {
                self.closeAndReportError(error)
            }
        }
    }

    @objc public func close() {
        state = .closed
        socket.close()
    }

    private func closeAndReportError(_ error: Error) {
        close()
        delegate?.socket(self, didCloseWith: error)
    }

    private func startListening(on queue: DispatchQueue) {
        queue.async {
            do {
                repeat {
                    var data = Data()
                    try self.socket.readDatagram(into: &data)
                    self.reportResponseReceived(data)
                } while self.state.isActive
            } catch {
                if self.state.isActive {
                    self.closeAndReportError(error)
                }
            }
        }
    }

    private func reportResponseReceived(_ data: Data) {
        delegate?.socket(self, didReceive: data)
    }
}

@objc public protocol SocketAdapterDelegate {
    @objc func socket(_ socket: SocketAdapter, didCloseWith error: Error)
    @objc func socket(_ socket: SocketAdapter, didReceive data: Data)
}
