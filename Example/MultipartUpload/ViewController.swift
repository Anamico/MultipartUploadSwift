//
//  ViewController.swift
//  MultipartUpload
//
//  Created by macinspak on 02/21/2018.
//  Copyright (c) 2018 macinspak. All rights reserved.
//

import UIKit
import MultipartUpload

// NOTE: This needs to be your server side implementing the Multipart Upload using the same protocol:
// This example is using https://github.com/Anamico/S3StreamThru

let endpoint = "http://localhost:3000/upload"

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func upload() {
        let fileUrl = Bundle.main.url(forResource: "test_image", withExtension: "jpg")!
        
        MultipartUpload(
            fileUrl: fileUrl,
            withNameFile: "test_image.jpg",
            toUrl: URL(string: endpoint)!).start()
    }
    
}
