//
//  ViewController.swift
//  iOSTestProject
//
//  Created by 黄穆斌 on 16/10/31.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceOrientationDidChange, object: nil, queue: OperationQueue.main, using: { (ob) in
//            print("1 = \(UIDevice.current.orientation) \(UIScreen.main.bounds)")
//            self.orientation(tag: "11")
//            OperationQueue.main.addOperation {
//                print("2 = \(UIDevice.current.orientation) \(UIScreen.main.bounds)")
//                self.orientation(tag: "12")
//            }
//        })
        let tag = 1
        print("\(tag): faceDown \(UIDevice.current.orientation.rawValue)")
        print("\(tag): faceUp \(UIDevice.current.orientation.rawValue)")
        print("\(tag): landscapeLeft \(UIDevice.current.orientation.rawValue)")
        print("\(tag): landscapeRight \(UIDevice.current.orientation.rawValue)")
        print("\(tag): portrait \(UIDevice.current.orientation.rawValue)")
        print("\(tag): portraitUpsideDown \(UIDevice.current.orientation.rawValue)")
        print("\(tag): unknown \(UIDevice.current.orientation.rawValue)")
        
    }
    
    
    func orientation(tag: String) {
        switch UIDevice.current.orientation {
        case .faceDown:
            print("\(tag): faceDown \(UIDevice.current.orientation.rawValue)")
        case .faceUp:
            print("\(tag): faceUp \(UIDevice.current.orientation.rawValue)")
        case .landscapeLeft:
            print("\(tag): landscapeLeft \(UIDevice.current.orientation.rawValue)")
        case .landscapeRight:
            print("\(tag): landscapeRight \(UIDevice.current.orientation.rawValue)")
        case .portrait:
            print("\(tag): portrait \(UIDevice.current.orientation.rawValue)")
        case .portraitUpsideDown:
            print("\(tag): portraitUpsideDown \(UIDevice.current.orientation.rawValue)")
        case .unknown:
            print("\(tag): unknown \(UIDevice.current.orientation.rawValue)")
        }
    }
}

