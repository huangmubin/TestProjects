//
//  ViewController.swift
//  Prompt
//
//  Created by 黄穆斌 on 2017/1/1.
//  Copyright © 2017年 MuBinHuang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var slider: UISlider!
    var text: String? {
        if slider.value == 0 {
            return nil
        }
        var s = ""
        for _ in 0 ..< Int(slider.value) {
            s += "xxx"
        }
        return s
    }
    
    @IBAction func success(_ sender: UIButton) {
        
    }
    @IBAction func error(_ sender: UIButton) {
        
    }
    @IBAction func loading(_ sender: UIButton) {
        
    }
    @IBAction func text(_ sender: UIButton) {
        Prompt.show(view: view, type: PromptType.text(text), time: 2, finish: {
            
        })
    }
    @IBAction func dismiss(_ sender: UIButton) {
        
    }
    
}

