//
//  ScrollViewExtension.swift
//  Weibo
//
//  Created by Yiming on 15/7/9.
//  Copyright (c) 2015年 Yiming. All rights reserved.
//

import UIKit
import ObjectiveC

var associatedObjectHandle: UInt8 = 0

extension UIScrollView{
    var headerView: YMRefreshView?{
        get{
            var optionalObject:AnyObject? = objc_getAssociatedObject(self, &associatedObjectHandle)
            return optionalObject as? YMRefreshView
        }
        set{
            objc_setAssociatedObject(self, &associatedObjectHandle, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            
            if (headerView != nil){
                self.addSubview(self.headerView!)
            }
        }
    }
}
