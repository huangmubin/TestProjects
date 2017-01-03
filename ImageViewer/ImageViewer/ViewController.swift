//
//  ViewController.swift
//  ImageViewer
//
//  Created by 黄穆斌 on 2016/12/2.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class Model {
    var image: UIImage?
    var select = false
}

class ViewController: UIViewController {

    var images = [[Model]]()
    
    let viewer = ImageViewer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0 ..< 10 {
            images.append([])
            for j in 0 ..< 22 {
                let m = Model()
                m.image = UIImage(named: "\(j%5)")
                images[i].append(m)
            }
        }
        
        
        viewer.delegate = self
        view.addSubview(viewer)
        Layouter(superview: view, view: viewer).edges()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
}

extension ViewController: ImageViewerDelegate {
    
    func imageViewer(numberOfCollectionSection viewer: ImageViewer) -> Int {
        return images.count
    }
    func imageViewer(_ viewer: ImageViewer, rowsInCollectionSection section: Int) -> Int {
        return images[section].count
    }
    
    func imageViewer(_ viewer: ImageViewer, imageAtCollection index: IndexPath) -> UIImage? {
        return images[index.section][index.row].image
    }
    func imageViewer(_ viewer: ImageViewer, selectAtCollection index: IndexPath) -> UIImage? {
        return images[index.section][index.row].select ? UIImage(named: "Selected") : nil
    }
    
    func imageViewer(_ viewer: ImageViewer, headerText atSection: Int) -> String? {
        return "headerText at \(atSection)"
    }
    
    func imageViewer(_ viewer: ImageViewer, selectedCollectionItem index: IndexPath) -> UIImage? {
        images[index.section][index.row].select = !images[index.section][index.row].select
        return images[index.section][index.row].select ? UIImage(named: "Selected") : nil
    }
    
    
    func imageViewer(numberOfImages viewer: ImageViewer) -> Int {
        var x = 0
        for image in images {
            x += image.count
        }
        return x
    }
    func imageViewer(_ viewer: ImageViewer, image at: Int) -> UIImage? {
        var i = at
        var s = 0
        for image in images {
            if i > image.count {
                i -= image.count
                s += 1
            } else {
                return images[s][i].image
            }
        }
        return nil
    }
    
    func imageViewer(_ viewer: ImageViewer, indexChangedToInt index: IndexPath) -> Int {
        var r = 0
        for i in 0 ..< index.section {
            r += images[i].count
        }
        return r + index.row
    }
    
    func imageViewer(_ viewer: ImageViewer, indexChangedToIndex index: Int) -> IndexPath {
        var s = 0
        var i = index
        for image in images {
            if i > image.count {
                i -= image.count
                s += 1
            } else {
                return IndexPath(row: i, section: s)
            }
        }
        return IndexPath(row: 0, section: 0)
    }
    
    func imageViewer(selectCollectionItems viewer: ImageViewer) -> [IndexPath] {
        var indexs = [IndexPath]()
        for s in 0 ..< images.count {
            for r in 0 ..< images[s].count {
                if images[s][r].select {
                    indexs.append(IndexPath(row: r, section: s))
                }
            }
        }
        return indexs
    }
}
