//
//  ImageViewer.swift
//  ImageViewer
//
//  Created by 黄穆斌 on 2016/12/2.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

// MARK: - Delegate

protocol ImageViewerDelegate: NSObjectProtocol {
    func imageViewer(numberOfCollectionSection viewer: ImageViewer) -> Int
    func imageViewer(_ viewer: ImageViewer, rowsInCollectionSection section: Int) -> Int
    
    func imageViewer(_ viewer: ImageViewer, imageAtCollection index: IndexPath) -> UIImage?
    func imageViewer(_ viewer: ImageViewer, selectAtCollection index: IndexPath) -> UIImage?
    
    func imageViewer(_ viewer: ImageViewer, headerText atSection: Int) -> String?
    
    func imageViewer(_ viewer: ImageViewer, selectedCollectionItem index: IndexPath) -> UIImage?
    
    func imageViewer(selectCollectionItems viewer: ImageViewer) -> [IndexPath]
    
    func imageViewer(numberOfImages viewer: ImageViewer) -> Int
    func imageViewer(_ viewer: ImageViewer, image at: Int) -> UIImage?
    
    
    func imageViewer(_ viewer: ImageViewer, indexChangedToInt index: IndexPath) -> Int
    func imageViewer(_ viewer: ImageViewer, indexChangedToIndex index: Int) -> IndexPath
    
}

// MARK: - Viewer

class ImageViewer: UIView {

    var collection = ImageViewerCollection()
    var viewer = ImageViewerBig()
    var animationImage = UIImageView()
    
    // MARK: - Data
    
    weak var delegate: ImageViewerDelegate? {
        didSet { collection.reload() }
    }
    
    var selectStyle = false
    
    // MARK: - Method
    
    func reload() {
        collection.reload()
        viewer.index = 0
        viewer.updateImages()
    }
    
    func delete() {
        if selectStyle {
            if let indexes = delegate?.imageViewer(selectCollectionItems: self) {
                collection.collection.deleteItems(at: indexes)
            }
        } else {
            if let index = delegate?.imageViewer(self, indexChangedToIndex: viewer.index) {
                if index.section >= 0 && index.section < collection.collection.numberOfSections && index.row >= 0 && index.row < collection.collection.numberOfItems(inSection: index.section) {
                    collection.collection.deleteItems(at: [index])
                }
            }
            viewer.deleteAnimation()
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDeploy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initDeploy()
    }
    
    private func initDeploy() {
        addSubview(collection)
        addSubview(viewer)
        
        collection.delegate = self
        viewer.delegate = self
        
        viewer.addGestures(view: self)
        
        Layouter(superview: self, view: collection).edges()
        Layouter(superview: self, view: viewer).center().width(related: .equal).aspect(multiplier: 16.0/9.0)
        
        viewer.isHidden = true
    }
    
}

// MARK: - Collection

extension ImageViewer: ImageViewerCollectionDelegate {
    
    func imageViewerCollection(numberOfSection collection: ImageViewerCollection) -> Int {
        return delegate?.imageViewer(numberOfCollectionSection: self) ?? 0
    }
    
    func imageViewerCollection(numberOfItem inSection: Int) -> Int {
        return delegate?.imageViewer(self, rowsInCollectionSection: inSection) ?? 0
    }
    
    func imageViewerCollection(cell: ImageViewerCollectionCell, at index: IndexPath) {
        cell.imageView.image = delegate?.imageViewer(self, imageAtCollection: index)
        cell.selectView.image = delegate?.imageViewer(self, selectAtCollection: index)
    }
    
    func imageViewerCollection(header: ImageViewerCollectionHeader, at index: Int) {
        header.label.text = delegate?.imageViewer(self, headerText: index)
    }
    
    func imageViewerCollection(select cell: ImageViewerCollectionCell, at: IndexPath) {
        if selectStyle {
            cell.selectView.image = delegate?.imageViewer(self, selectedCollectionItem: at)
        } else {
            animationImage.image = cell.imageView.image
            animationImage.frame = cell.frame.offsetBy(dx: 0, dy: -collection.collection.contentOffset.y)
            addSubview(animationImage)
            
            self.collection.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: { 
                self.animationImage.frame = self.viewer.frame
                self.collection.alpha = 0
            }, completion: { _ in
                self.viewer.index = self.delegate?.imageViewer(self, indexChangedToInt: at) ?? 0
                self.viewer.updateImages()
                self.viewer.isHidden = false
                self.animationImage.removeFromSuperview()
            })
        }
    }
    
}

// MARK: - Big

extension ImageViewer: ImageViewerBigDelegate {
    
    func imageViewerBig(image at: Int) -> UIImage? {
        return delegate?.imageViewer(self, image: at)
    }
    
    func imageViewerBig(forward at: Int) -> Bool {
        return at > 0
    }
    
    func imageViewerBig(backward at: Int) -> Bool {
        return at < (delegate?.imageViewer(numberOfImages: self) ?? 0)
    }
    
    func imageViewerBig(scaling: CGFloat) {
        viewer.alpha = 1 - scaling + 0.3
        collection.alpha = scaling - 0.3
    }
    
    func imageViewerBig(hidden: Bool) {
        if hidden {
            self.animationImage.image = viewer.imageCen.image
            self.animationImage.frame = viewer.imageCen.frame.offsetBy(dx: viewer.frame.origin.x, dy: viewer.frame.origin.y)
            self.animationImage.alpha = viewer.alpha
            addSubview(self.animationImage)
            
            var move = CGRect(origin: CGPoint.zero, size: collection.itemSize)
            if let index = delegate?.imageViewer(self, indexChangedToIndex: viewer.index) {
                if let cell = collection.collection.cellForItem(at: index) {
                    move = cell.frame
                }
            }
            UIView.animate(withDuration: 0.2, animations: { 
                self.animationImage.frame = move
                self.collection.alpha = 1
                self.viewer.isHidden = true
            }, completion: { _ in
                self.animationImage.removeFromSuperview()
                self.animationImage.alpha = 1
                
                self.viewer.relayout()
                self.viewer.alpha = 1
                self.collection.isUserInteractionEnabled = true
            })
        } else {
            UIView.animate(withDuration: 0.1, animations: { 
                self.viewer.alpha = 1
                self.collection.alpha = 0
            })
        }
    }
}
