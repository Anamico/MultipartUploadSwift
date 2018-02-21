//
//  ViewController.swift
//  MultipartUpload
//
//  Created by macinspak on 02/21/2018.
//  Copyright (c) 2018 macinspak. All rights reserved.
//

import UIKit
import MultipartUpload

//let endpoint = "http://nextvetApi-staging-env.ap-southeast-2.elasticbeanstalk.com/api/v1/attachment/stream"
let endpoint = "http://localhost:3000/upload"
//let endpoint = "http://nextvetapi-staging-env.ap-southeast-2.elasticbeanstalk.com:9000/stream/"


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func upload() {
        let fileUrl = Bundle.main.url(forResource: "Docker", withExtension: "zip")!
        
        MultipartUpload(
            fileUrl: fileUrl,
            withNameFile: "Docker.zip",
            toUrl: URL(string: endpoint)!).start()
    }
    
}
