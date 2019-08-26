//
//  GCDDemo.swift
//  iOSJade
//
//  Created by goingta on 2019/6/4.
//  Copyright © 2019 goingta. All rights reserved.
//

import UIKit

class GCDDemo: NSObject {
    override init() {
        super.init()
//        self.test()
//        self.test1()
        self.test2()
//        self.callNsthread()
//        self.callGCD()
//        self.callGCDQueue()
//        let mainQueue = DispatchQueue.main
//        mainQueue.async {
//            print("造成当前线程：\(Thread.current)死锁")
//        }

//        for i in 1...10 {
//            DispatchQueue.global().async {
//                //全局并发同步
//                Thread.sleep(forTimeInterval: 2)
//                NSLog("线程\(Thread.current)正在执行\(i)号任务")
//            }
//        }
//        self.callGCDGroup()
//        self.semaphore()
//self.operation()
//        self.blockOperation()
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5000)) {
//            NSLog("延迟执行")
//        }
    }
    
    func test() {
        //同步并发队列，一个一个执行
        print("1")
        DispatchQueue.global().sync {
            print("2")
            DispatchQueue.global().sync {
                print("3")
            }
            print("4")
        }
        print("5")
    }
    
    func test1() {
        //异步会开线程，并行执行
        NSLog("1")
        DispatchQueue.global().async {
            NSLog("2")
            DispatchQueue.global().sync {
                NSLog("3")
            }
            NSLog("4")
        }
        NSLog("5")
    }
    
    func test2() {
        //异步会开线程，并行执行
        let que = DispatchQueue.init(label: "com.gointa.serial")
        NSLog("1")
        que.async {
            NSLog("2")
            DispatchQueue.global().sync {
                NSLog("3")
            }
            NSLog("4")
        }
        NSLog("5")
    }
    
    func callNsthread() {
        NSLog("我在主线程!!!")
        let t = Thread(target: self, selector: #selector(printBythread), object: nil)
        t.name = "goingta.thread"
        t.start()
        //        let t1 = Thread.init {
        //            NSLog("我在子线程执行!!!")
        //        }
        //        t1.start()
        //        self.performSelector(inBackground: #selector(printBythread), with: nil)
    }
    
    @objc func printBythread() {
        NSLog("我在子线程执行!!!")
    }
    
    func callGCD() {
        NSLog("我在主线程!!!")
        DispatchQueue.global(qos:.default).async {
            NSLog("1我在子线程执行!!!")
        }
        
        DispatchQueue.global(qos:.userInitiated).async {
            NSLog("2我在子线程执行!!!")
        }
        
        DispatchQueue.global(qos:.background).async {
            NSLog("3我在子线程执行!!!")
        }
        
        DispatchQueue.global(qos:.unspecified).async {
            NSLog("4我在子线程执行!!!")
        }
        
        DispatchQueue.global(qos:.userInteractive).async {
            NSLog("5我在子线程执行!!!")
        }
        
        DispatchQueue.global(qos:.utility).async {
            NSLog("6我在子线程执行!!!")
        }
        
        
        //        DispatchQueue.main.async {
        //            NSLog("我在主线程!!!")
        //        }
    }
    
    func callGCDQueue() {
        NSLog("我在主线程!!!")
        // 获取系统队列
        let mainQueue = DispatchQueue.main
        let globalQueue = DispatchQueue.global()
        let globalQueueWithQos = DispatchQueue.global(qos: .userInitiated)
        
        // 创建串行队列
        //        let serialQueue = DispatchQueue(label: "com.goingta.queue")
        //        serialQueue.async {
        //            NSLog("A:我在子线程!!!")
        //            sleep(1)
        //        }
        //        serialQueue.async {
        //            NSLog("B:我在子线程!!!")
        //            sleep(1)
        //        }
        //        serialQueue.async {
        //            NSLog("C:我在子线程!!!")
        //            sleep(1)
        //        }
        // 创建并行队列
        //        let concurrentQueue = DispatchQueue(label: "com.goingta.queue",attributes:.concurrent)
        //        concurrentQueue.async {
        //            NSLog("A:我在子线程!!!")
        //            sleep(1)
        //        }
        //        concurrentQueue.async {
        //            NSLog("B:我在子线程!!!")
        //            sleep(1)
        //        }
        //        concurrentQueue.async {
        //            NSLog("C:我在子线程!!!")
        //            sleep(1)
        //        }
        // 创建并行队列，并手动触发
        let concurrentQueue2 = DispatchQueue(label: "com.goingta.queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        concurrentQueue2.async {
            NSLog("concurrentQueue2 A:我在子线程!!!")
            sleep(1)
        }
        concurrentQueue2.async {
            NSLog("concurrentQueue2 B:我在子线程!!!")
            sleep(1)
        }
        concurrentQueue2.async {
            NSLog("concurrentQueue2 C:我在子线程!!!")
            sleep(1)
        }
        
        NSLog("我回到了主线程!!!")
    }
    
    func callGCDGroup() {
        NSLog("我在主线程!!!")
        let group = DispatchGroup()
        let queue1 = DispatchQueue(label: "com.goingta.queue1",attributes:.concurrent)
        let queue2 = DispatchQueue(label: "com.goingta.queue2")
        let queue3 = DispatchQueue(label: "com.goingta.queue3")
        
        queue1.async(group:group) {
            NSLog("queue1: 我在子线程!!!")
            sleep(1)
        }
        
        //        queue1.async(group:group) {
        //            NSLog("发网络请求")
        //            group.enter()
        //            self.sendRequest {
        //                NSLog("网络请求完毕")
        //                group.leave()
        //            }
        //        }
        
        NSLog("发网络请求")
        group.enter()
        self.sendRequest {
            NSLog("网络请求完毕")
            group.leave()
        }
        
        
        
        //        queue1.async(group:group) {
        //            NSLog("queue2: 我在子线程!!!")
        //            sleep(2)
        //            NSLog("queue2: 我好了!!!")
        //        }
        //
        //        queue1.async(group:group) {
        //            NSLog("queue3: 我在子线程!!!")
        //            sleep(4)
        //        }
        
        group.notify(queue: DispatchQueue.global()) {
            NSLog("他们都做完了，我回到了主线程!!!")
        }
        
        
    }
    
    func sendRequest(block:@escaping ()->()) {
        NSLog("这里是一个异步网络请求")
        DispatchQueue.global().async {
            sleep(2)
            DispatchQueue.main.async {
                NSLog("回主线程c刷新UI")
                block()
            }
        }
    }
    
    func semaphore() {
        let semaphore = DispatchSemaphore(value: 1)
        let queue = DispatchQueue(label: "com.goingta.writefile", qos: .utility, attributes: .concurrent)
        let fileManager = FileManager.default
        let path = NSHomeDirectory() + "test1.txt"
        print(path)
        
        fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        
        for i in 0..<5 {
            //            if semaphore.wait(wallTimeout: .distantFuture) == .success {
            queue.async {
                do {
                    print(i)
                    try "test\(i)".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    print(error)
                }
                semaphore.signal()
            }
            //            }
        }
    }
    
    func operation() {
        NSLog("线程前")
        //        let op = Operation()
        //        op.completionBlock = {
        //            NSLog("Operation执行的线程")
        //        }
        let cop = CustomOperation()
        cop.opName = "cop"
        let cop1 = CustomOperation()
        cop1.opName = "cop1"
        let cop2 = CustomOperation()
        cop2.opName = "cop2"
        let cop3 = CustomOperation()
        cop3.opName = "cop3"
        
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = 4
        //        opQueue.addOperation(op)
        cop3.addDependency(cop)
        cop.addDependency(cop2)
        cop2.addDependency(cop1)
        
        
        opQueue.addOperation(cop)
        opQueue.addOperation(cop1)
        opQueue.addOperation(cop2)
        opQueue.addOperation(cop3)
        
        
        NSLog("线程后")
    }
    
    func blockOperation() {
        NSLog("线程前")
        let op = BlockOperation.init {
            NSLog("BlockOperation执行的任务")
        }
        NSLog("线程后")
        op.start()
    }
}
