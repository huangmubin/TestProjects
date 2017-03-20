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
            for sub in view.subviews {
                if let pro = sub as? Prompt {
                    pro.dismiss()
                }
            }
            
            let prompt = Prompt()
            view.addSubview(prompt)
            prompt.type = type
            prompt.time = time
            prompt.finish = finish
            prompt.deploy()
        }
    }
    
    // MARK: - Init
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.showView?.stop()
            self.timer?.cancel()
            self.timer = nil
            self.removeFromSuperview()
        })
    }
    
    // MARK: - Deploy
    
    fileprivate func deploy() {
        // Self
        self.layer.cornerRadius = 6
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        
        // Label
        label.numberOfLines = 0
        
        switch type {
        case .text(let note):
            textDeploy(note: note)
        case .success(let view, let note):
            successDeploy(show: view, note: note)
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
        
        addSubview(label)
        Layouter(superview: self, view: label).center().size(w: label.bounds.width, h: label.bounds.height)
        Layouter(superview: view, view: self).center().size(w: label.bounds.width + 20, h: label.bounds.height + 20).constrants(block: { (objects) in
            self.layoutW = objects[2]
            self.layoutH = objects[3]
        })
    }
    
    fileprivate func successDeploy(show: PromptShowView, note: String?) {
        let view = superview!
        let big = view.bounds.width / 2 - 20
        
        if note == nil {
            addSubview(show as! UIView)
            Layouter(superview: self, view: show as! UIView).size(w: 30, h: 30).center()
            
            Layouter(superview: view, view: self).center().size(w: 50, h: 50).constrants(block: { (objects) in
                self.layoutW = objects[2]
                self.layoutH = objects[3]
            })
        } else {
            label.frame = CGRect(x: 0, y: 0, width: big, height: 10000)
            label.text = note
            label.sizeToFit()
            addSubview(show as! UIView)
            addSubview(label)
            
            let size = CGSize(width: label.bounds.width, height: label.bounds.height + 38)
            Layouter(superview: self, view: show as! UIView).center(x: 0, y: -(size.height / 2 - 15)).size(w: 30, h: 30)
            Layouter(superview: self, view: label).size(w: label.bounds.width, h: label.bounds.height).center(x: 0, y: 17)
            
            Layouter(superview: view, view: self).center().size(w: size.width + 20, h: size.height + 20).constrants(block: { (objects) in
                self.layoutW = objects[2]
                self.layoutH = objects[3]
            })
        }
        
        showView = show
        show.play()
    }
    
    // MARK: - Data
    
    var type: PromptType = .text("")
    var finish: (() -> Void)? = nil
    var time: TimeInterval = 2
    
    var timer: DispatchSourceTimer?
    
    func run() {
        guard time > 0 && timer == nil else { return }
        timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 1), queue: DispatchQueue.main)
        timer?.scheduleRepeating(wallDeadline: DispatchWallTime.now(), interval: DispatchTimeInterval.seconds(1))
        timer?.setEventHandler(handler: {
            if self.time <= 0 {
                self.finish?()
                self.timer?.cancel()
                self.timer = nil
            } else {
                self.time -= 1
            }
        })
        timer?.resume()
    }
    
    // MARK: - view
    
    var showView: PromptShowView!
    
    // MARK: - Text
    
    let label = UILabel()
    
    // MARK: Layout
    
    var layoutH: NSLayoutConstraint!
    var layoutW: NSLayoutConstraint!
    
}


// MARK: - Prompt Show View Success

class PromptShowSuccess: UIView, PromptShowView {
    
    // MARK: - Init
    
    func play() {
        
    }
    
    func stop() {
        
    }
    
    // MARK: - Init
    
    required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        deploy()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        deploy()
    }
    
    func deploy() {
        self.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let path = UIBezierPath(ovalIn: self.frame)
        round.fillColor = UIColor.clear.cgColor
        round.lineWidth = 1
        round.strokeColor = UIColor.black.cgColor
        round.path = path.cgPath
        layer.addSublayer(round)
    }
    
    // MARK: - Layer
    
    var round: CAShapeLayer = CAShapeLayer()
    
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
