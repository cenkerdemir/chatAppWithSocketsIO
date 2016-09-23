//
//  SocketFixUTF8.swift
//  Socket.IO-Client-Swift
//
//  Created by Erik Little on 3/16/15.
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

func fixDoubleUTF8(_ string: String) -> String {
    if let utf8 = string.data(using: String.Encoding.isoLatin1),
        let latin1 = NSString(data: utf8, encoding: String.Encoding.utf8.rawValue) {
            return latin1 as String
    } else {
        return string
    }
}

func doubleEncodeUTF8(_ string: String) -> String {
    if let latin1 = string.data(using: String.Encoding.utf8),
        let utf8 = NSString(data: latin1, encoding: String.Encoding.isoLatin1.rawValue) {
            return utf8 as String
    } else {
        return string
    }
}
