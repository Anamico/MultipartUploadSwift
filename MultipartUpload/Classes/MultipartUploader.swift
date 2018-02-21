import Foundation
//
//  MultiUploadHelper.swift
//  MultipartUpload
//
//  Created by Andrew on 14/2/18.
//  Copyright © 2018 Anamico. All rights reserved.
//

import UIKit

class MultipartUploader : NSObject, URLSessionDataDelegate {
    
    static public let shared = MultipartUploader()
    private override init() {} //This prevents others from using the default '()' initializer for this class.
    
    private var _session : URLSession?
    public var session : URLSession? {
        set {
            if _session == nil {
                _session = newValue
            }
        }
        get {
            return _session
        }
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uuid = task.currentRequest?.value(forHTTPHeaderField: "uuid") ?? "unknown"
        let part = task.currentRequest?.value(forHTTPHeaderField: "part") ?? "?"
        print("*** \(uuid) part \(part) didSendBodyData: \(bytesSent), totalBytesSent: \(totalBytesSent), totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let uuid = task.currentRequest?.value(forHTTPHeaderField: "uuid") ?? "unknown"
        let part = task.currentRequest?.value(forHTTPHeaderField: "part") ?? "?"
        print("*** \(uuid) part \(part) urlSessionError \(String(describing: error))")
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("*** urlSessionDidFinishEvents")
    }
}
