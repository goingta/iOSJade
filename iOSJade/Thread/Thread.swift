//
//  Thread.swift
//  SwiftDemo
//
//  Created by goingta on 2019/3/22.
//  Copyright © 2019 goingta. All rights reserved.
//

import Foundation
import UIKit

class ThreadTest: NSObject {
    static let sharedInstance = ThreadTest()
    
    func callNsthread() {
        NSLog("我在主线程!!!")
        print("")
        let t = Thread(target: self, selector: #selector(printBythread), object: nil)
        
//        t.perform(#selector(printBythread), with: nil)
        t.start()
    }
    
    @objc func printBythread() {
        NSLog("我在子线程执行!!!")
    }
}
