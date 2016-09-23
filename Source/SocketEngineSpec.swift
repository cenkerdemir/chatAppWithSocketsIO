//
//  SocketEngineSpec.swift
//  Socket.IO-Client-Swift
//
//  Created by Erik Little on 10/7/15.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

@objc public protocol SocketEngineSpec {
    weak var client: SocketEngineClient? { get set }
    var closed: Bool { get }
    var connected: Bool { get }
    var connectParams: [String: AnyObject]? { get set }
    var cookies: [HTTPCookie]? { get }
    var extraHeaders: [String: String]? { get }
    var fastUpgrade: Bool { get }
    var forcePolling: Bool { get }
    var forceWebsockets: Bool { get }
    var parseQueue: DispatchQueue! { get }
    var pingTimer: Timer? { get }
    var polling: Bool { get }
    var probing: Bool { get }
    var emitQueue: DispatchQueue! { get }
    var handleQueue: DispatchQueue! { get }
    var sid: String { get }
    var socketPath: String { get }
    var urlPolling: URL { get }
    var urlWebSocket: URL { get }
    var websocket: Bool { get }
    
    init(client: SocketEngineClient, url: URL, options: NSDictionary?)
    
    func close(_ reason: String)
    func didError(_ error: String)
    func doFastUpgrade()
    func flushWaitingForPostToWebSocket()
    func open()
    func parseEngineData(_ data: Data)
    func parseEngineMessage(_ message: String, fromPolling: Bool)
    func write(_ msg: String, withType type: SocketEnginePacketType, withData data: [Data])
}

extension SocketEngineSpec {
    var urlPollingWithSid: URL {
        var com = URLComponents(url: urlPolling, resolvingAgainstBaseURL: false)!
        com.query = com.query! + "&sid=\(sid)"
        
        return com.url!
    }
    
    func createBinaryDataForSend(_ data: Data) -> Either<Data, String> {
        if websocket {
            var byteArray = [UInt8](repeating: 0x4, count: 1)
            let mutData = NSMutableData(bytes: &byteArray, length: 1)
            
            mutData.append(data)
            
            return .left(mutData)
        } else {
            let str = "b4" + data.base64EncodedString(options: .lineLength64Characters)
            
            return .right(str)
        }
    }
    
    /// Send an engine message (4)
    func send(_ msg: String, withData datas: [Data]) {
        write(msg, withType: .message, withData: datas)
    }
}
