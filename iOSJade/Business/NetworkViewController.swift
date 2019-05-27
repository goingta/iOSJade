//
//  NetworkViewController.swift
//  iOSJade
//
//  Created by goingta on 2019/5/27.
//  Copyright © 2019 goingta. All rights reserved.
//

import UIKit
import Alamofire

class NetworkViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = Alamofire.request("http://www.httpbin.org/get", method: .get, parameters: ["name":"goingta","age":28], encoding: URLEncoding.queryString, headers: nil).responseJSON { (response) in
            print(response)
        }
    }

}


