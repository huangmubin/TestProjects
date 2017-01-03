//
//  main.swift
//  OSTestProject
//
//  Created by 黄穆斌 on 16/11/1.
//  Copyright © 2016年 Myron. All rights reserved.
//

import Foundation


let network = Network()

network.get(url: "https://raw.githubusercontent.com/huangmubin/MUTool-Files/master/UpdateNew", receiveComplete: {
    (rep, error) in
    print("err = \(error), \(rep["url"])")
})


while true {
    Thread.sleep(forTimeInterval: 1)
    print(".")
}
