//
//  XRZAlertControl.swift
//  XianRenZhang
//
//  Created by 廖先龙 on 15/11/19.
//  Copyright © 2015年 廖先龙. All rights reserved.
//

import UIKit

class XRZAlertControl: UIView {
    
    /// 定制的内容View
    var contentView: UIView!
    
    var touchDismiss: Bool = false {
        didSet{
            if touchDismiss {
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismiss"))
                self.backgroundView.addGestureRecognizer(tap)
            }
        }
    }
    
    /// 背景View，半透明背景
    lazy var backgroundView: UIView = {
        let _backgroundView = UIView(frame: self.bounds)
        _backgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        self.addSubview(_backgroundView)
        self.sendSubviewToBack(_backgroundView)
        return _backgroundView
    }()
    
    /**
     初始化函数
     
     - parameter contentView: 定义好的内容模板
     
     - returns: 当前对象
     */
    init(contentView: UIView) {
        super.init(frame: appDelegate().window.bounds)
        appDelegate().window.addSubview(self)
        self.contentView = contentView
        self.addSubview(self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.left = (self.width - self.contentView.width) / 2
    }
    
    
    func show() {
        
        self.showAnimation()
    }
    
    func dismiss() {
        
        self.hideAnimation()
    }
    
    private func showAnimation() {
        
        self.contentView.top = (self.bounds.height - self.contentView.height) / 2 - 15
        self.backgroundView.alpha = 0
        self.contentView.alpha = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            self.contentView.top = (self.bounds.height - self.contentView.height) / 2
            self.backgroundView.alpha = 1
            self.contentView.alpha = 1
        }
        
    }
    
    private func hideAnimation() {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.contentView.top = (self.bounds.height - self.contentView.height) / 2 - 15
            self.backgroundView.alpha = 0
            self.contentView.alpha = 0
            })
            { (complation:Bool) -> Void in
                self.clearSelf()
        }
    }
    
    private func clearSelf() {
        
        self.removeFromSuperview()
    }
    
    deinit {
        
        NSLog("< !!! 当前提醒已经释放！>")
    }
}
