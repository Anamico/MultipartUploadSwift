//
//  MultipartUpload.swift
//  MultipartUpload
//
//  Created by Andrew on 13/2/18.
//  Copyright © 2018 Anamico. All rights reserved.
//

import Foundation

public class MultipartUpload {
    public let uuid = NSUUID()
    private var _fileUrl : URL
    private var _fileSize : Int = 0
    private var _fileName : String
    private var _toUrl : URL
    private var parts = [MultiPart]()
    
    public var fileUrl : URL {
        get {
            return _fileUrl
        }
    }
    public var fileName : String {
        get {
            return _fileName
        }
    }
    public var fileSize : Int {
        get {
            return _fileSize
        }
    }
    public var toUrl : URL {
        get {
            return _toUrl
        }
    }
    
    public init(fileUrl: URL, withNameFile name: String, toUrl: URL) {
        self._fileUrl = fileUrl
        self._fileName = name
        self._toUrl = toUrl
    }
    
    private func split(callback:()->Void) {
        do {
            let resourceValues = try fileUrl.resourceValues(forKeys: [.fileSizeKey])
            self._fileSize = Int(resourceValues.fileSize!)
        } catch { print(error) }
        
        // split the file into chunks
        let maxPartSize : Int = 5000000   // s3 has a minimum 5MB part size
        
        if self._fileSize < maxPartSize {
            self.parts = [MultiPart(url: fileUrl, size: self._fileSize)]  // todo: move this sideways to protect against failures
            callback()
            return
        }
        
        let totalParts = Int((Float(self._fileSize) / Float(maxPartSize)).rounded(.up))
        print("File size = \(ByteCountFormatter().string(fromByteCount: Int64(fileSize))) break into \(totalParts) parts")
        
        let srcFile: FileHandle? = try! FileHandle(forReadingFrom: fileUrl)
        let uuidString = self.uuid.uuidString
        let cacheURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        for partNumber in (0..<totalParts) {
            if let data = srcFile?.readData(ofLength: maxPartSize) {
                let partURL = cacheURL.appendingPathComponent("\(uuidString)_\(partNumber)", isDirectory: false)
                try! data.write(to: partURL, options: [])
                //let createdFile = FileManager.default.createFile(atPath: partURL.absoluteString, contents: data)
                //let partFile: FileHandle? = try! FileHandle(forWritingTo: partURL)
                //partFile?.write(data)
                //partFile?.closeFile()
                self.parts.append(MultiPart(url: partURL, size: data.count))
            }
        }
        srcFile?.closeFile()
        callback()
    }
    
    private func enqueue() {
        if self.parts.count < 2 {
            print("**** file too small, send as one file directly?")
            //return;
        }
        
        for partNumber in (0..<self.parts.count) {
            let part = parts[partNumber]
            var partSize : Int = 0
            do {
                let resourceValues = try part.url.resourceValues(forKeys: [.fileSizeKey])
                partSize = Int(resourceValues.fileSize!)
            } catch { print(error) }
            
            print("queuing part \(partNumber): \(ByteCountFormatter().string(fromByteCount: Int64(part.size))) / \(partSize) : \(part.url)")
            
            var request = URLRequest(url: self.toUrl);
            
            request.addValue("\(self.uuid.uuidString)_\(self.fileName)", forHTTPHeaderField: "filename")
            request.addValue(self.uuid.uuidString, forHTTPHeaderField: "fileuuid")
            request.addValue("\(self.parts.count)", forHTTPHeaderField: "totalparts")
            request.addValue("\(partNumber + 1)", forHTTPHeaderField: "part")
            request.addValue("\(partSize)", forHTTPHeaderField: "contentlength")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let uploadTask = MultipartUploader.shared.session?.uploadTask(with: request, fromFile:part.url)
            uploadTask?.resume();
        }
    }
    
    public func start() {
        DispatchQueue.global(qos: .background).async {
            self.split {
                self.enqueue()
            }
        }
    }
}

class MultiPart {
    public var url : URL
    public var size : Int
    
    init(url: URL, size: Int) {
        self.url = url
        self.size = size
    }
}

