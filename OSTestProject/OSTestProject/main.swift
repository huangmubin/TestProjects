//
//  main.swift
//  OSTestProject
//
//  Created by 黄穆斌 on 16/11/1.
//  Copyright © 2016年 Myron. All rights reserved.
//

import Foundation


let s = 10000.0
let x = 1.1
var v = s
for y in 1 ..< 101 {
//    for m in 0 ..< 12 {
//        for d in 0 ..< 30 {
            v *= x
//        }
//    }
    print("第 \(y) 年: \(v)")
}
