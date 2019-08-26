//
//  CustomOperation.swift
//  SwiftDemo
//
//  Created by goingta on 2019/3/25.
//  Copyright © 2019 goingta. All rights reserved.
//

import Foundation

class CustomOperation: Operation {
    var opName: String = ""
    var isOver: Bool = false
    
    override func main() {
//        for i in 0...3 {
//            sleep(3)
//            NSLog("CustomOperation \(opName): \(i)")
//        }
        DispatchQueue.global().async {
            if self.isCancelled {
                return
            }
            NSLog("CustomOperation \(self.opName)")
            self.isOver = true
        }
        
        while !self.isOver && !self.isCancelled {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }
    }
}
