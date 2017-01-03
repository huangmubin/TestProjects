//
//  Prompt.swift
//  Prompt
//
//  Created by 黄穆斌 on 2017/1/1.
//  Copyright © 2017年 MuBinHuang. All rights reserved.
//

import UIKit

// MARK: - Interface

protocol PromptView {
    func show(view: UIView?)
}

protocol PromptShowView {
    init()
    func play()
    func stop()
}

// MARK: - Type

enum PromptType {
    case success(PromptShowView, String?)
    case error(PromptShowView, String?)
    case loading(PromptShowView, String?)
    case text(String?)
}

// MARK: - Prompt

class Prompt: UIView {
    
    // MARK: - Interface
    
    class func show(view: UIView?, type: PromptType, time: TimeInterval, finish: (() -> Void)?) {
        if let view = view {
            let prompt = Prompt()
            view.addSubview(prompt)
            prompt.type = type
            prompt.time = time
            prompt.finish = finish
            prompt.deploy()
        }
    }
    
    class func dismiss() {
        
    }
    
    // MARK: - Init
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func deploy() {
        // Self
        self.layer.cornerRadius = 6
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        
        let _ = Layouter(superview: superview!, view: self).center()
        
        //
        
        label.numberOfLines = 0
        
        switch type {
        case .text(let note):
            textDeploy(note: note)
        default:
            break
        }
    }
    
    fileprivate func textDeploy(note: String?) {
        let view = superview!
        let big = view.bounds.width / 2 - 20
        
        label.frame = CGRect(x: 0, y: 0, width: big, height: 10000)
        label.text = note
        label.sizeToFit()
        
        print(label.frame)
        
        addSubview(label)
        let _ = Layouter(superview: self, view: label).center().size(w: label.bounds.width, h: label.bounds.height).edges(top: 20, bottom: -20, leading: 20, trailing: -20)
    }
    
    // MARK: - Data
    
    var type: PromptType = .text("")
    var finish: (() -> Void)? = nil
    var time: TimeInterval = 2
    
    var timer: DispatchSourceTimer?
    
    func run() {
    }
    
    // MARK: - view
    
    var showView: PromptShowView!
    
    // MARK: - Text
    
    let label = UILabel()
    
    
    
}


// MARK: - Prompt Show View Success

class PromptShowSuccess: UIView, PromptShowView {
    
    // MARK: - Init
    
    func play() {
        
    }
    
    func stop() {
        
    }
    
    required init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
}

// MARK: - Prompt Show View Success

class PromptShowError: UIView, PromptShowView {
    
    // MARK: - Init
    
    func play() {
        
    }
    
    func stop() {
        
    }
    
    required init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
}

// MARK: - Prompt Show View Success

class PromptShowLoading: UIView, PromptShowView {
    
    // MARK: - Init
    
    func play() {
        
    }
    
    func stop() {
        
    }
    
    required init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
}
