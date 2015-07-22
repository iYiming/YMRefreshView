//
//  RereshView.swift
//  Weibo
//
//  Created by Yiming on 15/7/4.
//  Copyright (c) 2015年 Yiming. All rights reserved.
//
import UIKit

class YMRefreshView: UIView {
    var topLayer: CALayer?
    var middleLayer: CALayer?
    var bottomLayer: CALayer?
    var textLayer: CATextLayer?
    
    var showingBottomLayer:Bool = false
    var closingBottomLayer:Bool = false
    var showingMiddleLayer:Bool = false
    var closingMiddleLayer:Bool = false
    var showingTopLayer:Bool = false
    var closingTopLayer:Bool = false
    
    var showingRefreshAnimation:Bool = false
    
    var scrollView: UIScrollView?
    
    let lightGrayColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
    let darkGrayColor = UIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1.0)
    let redColor = UIColor(red: 227/255.0, green: 47/255.0, blue: 34/255.0, alpha: 1.0)
    
    var refreshBlock:((Void) -> (Void))?
    
    class func refreshWithBlock(block:Void -> Void) -> YMRefreshView{
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        
        var refreshView = YMRefreshView(frame: CGRectMake((screenWidth - 200)/2.0, -46, 200, 72))
        refreshView.refreshBlock = block
        return refreshView;
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()//设置
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()//设置
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        superview?.willMoveToSuperview(newSuperview)
        
        scrollView = newSuperview as? UIScrollView
        
        if scrollView!.isKindOfClass(UIScrollView){
            //removeObservers()
            addObservers()
        }
    }
    
    //MARK: 自定义方法
    
    /**
    设置
    */
    func setup(){
        //顶层Layer
        topLayer = CALayer()
        topLayer!.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0).CGColor
        topLayer!.frame = CGRectMake(98, 0, 4, 4)
        topLayer!.cornerRadius = 2
        self.layer.addSublayer(topLayer)
        
        //中间层Layer
        middleLayer = CALayer()
        middleLayer!.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0).CGColor
        middleLayer!.frame = CGRectMake(98, 14, 4, 4)
        middleLayer!.cornerRadius = 2
        self.layer.addSublayer(middleLayer)
        
        //底层Layer
        bottomLayer = CALayer()
        bottomLayer!.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0).CGColor
        bottomLayer!.frame = CGRectMake(98, 28, 4, 4)
        bottomLayer!.cornerRadius = 2
        self.layer.addSublayer(bottomLayer)
        
        //刷新文本
        textLayer = CATextLayer()
        textLayer!.foregroundColor = UIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1.0).CGColor
        textLayer!.fontSize = 10
        textLayer!.contentsScale = UIScreen.mainScreen().scale
        textLayer!.string = "REFRESH"
        textLayer!.frame = CGRectMake(75, 52, 50, 20)
        self.layer.addSublayer(textLayer)
    }
    
    /**
    停止刷新
    */
    func stopRefresh(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.scrollView!.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            }, completion: { (finished) -> Void in
                if finished{
                    self.showingRefreshAnimation = false
                    self.topLayer?.removeAllAnimations()
                    self.middleLayer?.removeAllAnimations()
                    self.bottomLayer?.removeAllAnimations()
                    
                    self.topLayer!.frame = CGRectMake(98, 0, 4, 4)
                    self.middleLayer!.frame = CGRectMake(98, 14, 4, 4)
                    self.bottomLayer!.frame = CGRectMake(98, 28, 4, 4)
                    
                    self.textLayer?.foregroundColor = UIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1.0).CGColor
                }
        })
    }
    
    /**
    添加监听
    */
    func addObservers(){
        var options = NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old
        
        self.scrollView!.addObserver(self, forKeyPath: "contentOffset", options: options, context: nil)
    }
    
    /**
    移除监听
    */
    func removeObservers(){
        self.scrollView!.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    /**
    监听
    */
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset"{
            scrollViewContentOffsetDidChange(change)
        }
    }
    
    /**
    展开动画
    
    :param: animationLayer 动画Layer
    */
    func spreadLayerAnimation(animationLayer: CALayer){
        animationLayer.removeAllAnimations()
        layerWidthAnimation(animationLayer, width: 100, animationTypeStr: "Spread", animationIndexStr: "1")
    }
    
    /**
    关闭动画
    
    :param: animationLayer 关闭Layer
    */
    func closeLayerAnimation(animationLayer: CALayer){
        animationLayer.removeAllAnimations()
        layerWidthAnimation(animationLayer, width: 0, animationTypeStr: "Close", animationIndexStr: "1")
    }
    
    /**
    刷新动画
    */
    func refreshingAnimation(){
        topLayer?.removeAllAnimations()
        middleLayer?.removeAllAnimations()
        bottomLayer?.removeAllAnimations()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.topLayer?.frame = CGRectMake(98, 0, 4, 4);
        self.middleLayer?.frame = CGRectMake(98, 14, 4, 4);
        self.bottomLayer?.frame = CGRectMake(98, 28, 4, 4);
        self.textLayer?.opacity = 0
        CATransaction.commit()
        
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        var animation1 = CAKeyframeAnimation(keyPath: "position")
        animation1.delegate = self
        animation1.duration = CFTimeInterval(0.3)
        animation1.path = UIBezierPath(arcCenter: CGPoint(x:98 + 2, y: 14 + 2),radius: CGFloat(30), startAngle:CGFloat(-M_PI_2), endAngle: CGFloat(0), clockwise: true).CGPath
        animation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation1.setValue("", forKey: "AnimationType")
        self.topLayer?.addAnimation(animation1, forKey: "groupAnimation")
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.topLayer?.position = CGPoint(x: 98 + 2 + 30, y: 14 + 2)
        CATransaction.commit()
        
        var animation3 = CAKeyframeAnimation(keyPath: "position")
        animation3.delegate = self
        animation3.duration = CFTimeInterval(0.3)
        animation3.path = UIBezierPath(arcCenter: CGPoint(x:98 + 2, y: 14 + 2),radius: CGFloat(30), startAngle:CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: true).CGPath
        animation3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation3.setValue("RefreshAnimationBegin", forKey: "AnimationType")
        //animation3.setValue(animationLayerStr, forKey: "AnimationLayer")
        self.bottomLayer?.addAnimation(animation3, forKey: "groupAnimation")
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.bottomLayer?.position = CGPoint(x: 98 + 2 - 30, y: 14 + 2)
        CATransaction.commit()
    }
    
    /**
    添加图层动画
    
    :param: layer       图层
    :param: layerTagStr 图层Tag
    */
    func refreshingLayerAnimation(animationLayer: CALayer){
        var animationIndexStr = "1"
        if animationLayer.isEqual(topLayer){
            animationIndexStr = "3"
        }else if animationLayer.isEqual(middleLayer){
            animationIndexStr = "2"
        }else if animationLayer.isEqual(bottomLayer){
            animationIndexStr = "1"
        }
        
        var scaleKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        
        var t1 = CATransform3DMakeScale(1.0, 1.0, 0)
        var t2 = CATransform3DMakeScale(2.0, 2.0, 0)
        var t3 = CATransform3DMakeScale(1.0, 1.0, 0)
        
        scaleKeyframeAnimation.values = [NSValue(CATransform3D:t1),NSValue(CATransform3D:t2),NSValue(CATransform3D:t3)]
        scaleKeyframeAnimation.keyTimes = [0,0.5,1]
        
        let normalCGColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0).CGColor
        var highlightedColor = UIColor(red: 60/255.0, green: 60/255.0, blue: 60/255.0, alpha: 1.0).CGColor
        var colorKeyframeAnimation = CAKeyframeAnimation(keyPath: "backgroundColor")
        colorKeyframeAnimation.values = [normalCGColor,highlightedColor,normalCGColor]
        colorKeyframeAnimation.keyTimes = [0,0.5,1]
        
        var groupAnimation = CAAnimationGroup()
        groupAnimation.duration = CFTimeInterval(0.35)
        groupAnimation.animations = [scaleKeyframeAnimation,colorKeyframeAnimation]
        groupAnimation.removedOnCompletion = true
        groupAnimation.setValue("RefreshAnimationRefreshing", forKey: "AnimationType")
        groupAnimation.setValue(animationIndexStr, forKey: "AnimationIndex")
        groupAnimation.delegate = self
        
        animationLayer.addAnimation(groupAnimation, forKey: "scaleKeyframeAnimation")
    }
    
    /**
    宽度动画
    
    :param: animationLayer    动画层
    :param: width             宽度
    :param: animationTypeStr  动画类型 展开或关闭
    :param: animationIndexStr 动画索引
    */
    func layerWidthAnimation(animationLayer: CALayer,width: CGFloat,animationTypeStr: String,animationIndexStr: String){
        var animationLayerStr = "topLayer"
        if animationLayer.isEqual(topLayer){
            animationLayerStr = "topLayer"
        }else if animationLayer.isEqual(middleLayer){
            animationLayerStr = "middleLayer"
        }else if animationLayer.isEqual(bottomLayer){
            animationLayerStr = "bottomLayer"
        }
        
        let screenWidth: CGFloat = 200 //CGRectGetWidth(UIScreen.mainScreen().bounds)
        
        var animation = CABasicAnimation(keyPath: "bounds.size.width")
        animation.duration = 0.13
        animation.delegate = self
        animation.toValue = NSNumber(float: 20)
        animation.setValue(animationLayerStr, forKey: "AnimationLayer")
        animation.setValue(animationTypeStr, forKey: "AnimationType")
        animation.setValue(animationIndexStr, forKey: "AnimationIndex")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animationLayer.addAnimation(animation, forKey: "animation")
        animationLayer.frame = CGRect(x: (screenWidth - width)/2.0, y: animationLayer.frame.origin.y, width: CGFloat(width), height: animationLayer.frame.size.height)
    }
    
    //MARK 动画结束
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        
        let animationTypeStr = anim.valueForKey("AnimationType") as! String
        
        if animationTypeStr == "Spread"{
            if self.showingRefreshAnimation{
                return
            }
            
            let animationLayerStr = anim.valueForKey("AnimationLayer") as! String
            let animationIndexStr = anim.valueForKey("AnimationIndex") as! String
            
            var shapeLayer = CALayer()
            if animationLayerStr == "topLayer"{
                shapeLayer = topLayer
            }else if animationLayerStr == "middleLayer"{
                shapeLayer = middleLayer
            }else if animationLayerStr == "bottomLayer"{
                shapeLayer = bottomLayer
            }
            
            var width:CGFloat = 0
            if animationIndexStr == "1"{
                width = 20
            }else if animationIndexStr == "2"{
                width = 80
            }else if animationIndexStr == "3"{
                width = 40
            }else if animationIndexStr == "4"{
                width = 60
            }else{
                return
            }
            
            layerWidthAnimation(shapeLayer, width: width, animationTypeStr: animationTypeStr, animationIndexStr:String(animationIndexStr.toInt()! + 1))
        }else if animationTypeStr == "Close"{
            if self.showingRefreshAnimation{
                return
            }
            
            let animationLayerStr = anim.valueForKey("AnimationLayer") as! String
            let animationIndexStr = anim.valueForKey("AnimationIndex") as! String
            
            var shapeLayer = CALayer()
            if animationLayerStr == "topLayer"{
                shapeLayer = topLayer
            }else if animationLayerStr == "middleLayer"{
                shapeLayer = middleLayer
            }else if animationLayerStr == "bottomLayer"{
                shapeLayer = bottomLayer
            }
            
            var width:CGFloat = 0
            if animationIndexStr == "1"{
                width = 20
            }else if animationIndexStr == "2"{
                width = 4
            }else if animationIndexStr == "3"{
                return
            }
            
            layerWidthAnimation(shapeLayer, width: width, animationTypeStr: animationTypeStr, animationIndexStr:String(animationIndexStr.toInt()! + 1))
            
        }else if animationTypeStr == "RefreshAnimationBegin"{
            //let animationLayerStr = anim.valueForKey("AnimationLayer") as! String
            
            /*
            self.topLayer?.frame = CGRectMake(121, 14, 4, 4);
            self.middleLayer?.frame = CGRectMake(98, 14, 4, 4);
            self.bottomLayer?.frame = CGRectMake(75, 14, 4, 4);
            self.textLayer?.opacity = 0
            */
            
            //if animationLayerStr == "topLayer"{
            
            refreshingLayerAnimation(bottomLayer!)
            //}
        }else if animationTypeStr == "RefreshAnimationRefreshing"{
            let animationIndexStr = anim.valueForKey("AnimationIndex") as! String
            
            if self.showingRefreshAnimation{
                if animationIndexStr == "1"{
                    refreshingLayerAnimation(middleLayer!)
                }else if animationIndexStr == "2"{
                    refreshingLayerAnimation(topLayer!)
                }else if animationIndexStr == "3"{
                    refreshingLayerAnimation(bottomLayer!)
                }
            }
        }
    }
    
    
    func scrollViewContentOffsetDidChange(change: [NSObject : AnyObject]){
        if showingRefreshAnimation{
            return
        }
        
        var contentOffsetY = self.scrollView!.contentOffset.y
        
        println("contentOffsetY:\(contentOffsetY)")
        
        if !self.scrollView!.dragging{
            if contentOffsetY <= -50{//刷新
                if !showingRefreshAnimation{
                    showingRefreshAnimation = true
                    
                    showingTopLayer = false
                    closingTopLayer = false
                    
                    showingMiddleLayer = false
                    closingMiddleLayer = false
                    
                    showingTopLayer = false
                    closingTopLayer = false
                    
                    
                    topLayer?.backgroundColor = lightGrayColor.CGColor
                    middleLayer?.backgroundColor = lightGrayColor.CGColor
                    bottomLayer?.backgroundColor = lightGrayColor.CGColor
                    textLayer?.foregroundColor = darkGrayColor.CGColor
                    
                    self.refreshingAnimation()
                    
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        self.scrollView!.contentInset = UIEdgeInsetsMake(72.0, 0.0, 0.0, 0.0)
                        }, completion: { (finished) -> Void in
                            self.refreshBlock!()
                    })
                    
                    return
                }
            }
        }
        
        if contentOffsetY < 0{
            if contentOffsetY > -50{
                self.textLayer?.opacity = -Float(contentOffsetY)/50.0
            }
            
            if contentOffsetY < -22{
                if !showingBottomLayer{
                    spreadLayerAnimation(bottomLayer!)
                    bottomLayer?.backgroundColor = darkGrayColor.CGColor
                    showingBottomLayer = true
                    closingBottomLayer = false
                }
                
                if contentOffsetY < -34{
                    if !showingMiddleLayer{
                        spreadLayerAnimation(middleLayer!)
                        middleLayer?.backgroundColor = darkGrayColor.CGColor
                        showingMiddleLayer = true
                        closingMiddleLayer = false
                    }
                    
                    if contentOffsetY < -50{
                        if !showingTopLayer{
                            spreadLayerAnimation(topLayer!)
                            
                            topLayer?.backgroundColor = redColor.CGColor
                            middleLayer?.backgroundColor = redColor.CGColor
                            bottomLayer?.backgroundColor = redColor.CGColor
                            textLayer?.foregroundColor = redColor.CGColor
                            
                            showingTopLayer = true
                            closingTopLayer = false
                        }
                    }else{
                        if !closingTopLayer{
                            closeLayerAnimation(topLayer!)
                            topLayer?.backgroundColor = lightGrayColor.CGColor
                            middleLayer?.backgroundColor = darkGrayColor.CGColor
                            bottomLayer?.backgroundColor = darkGrayColor.CGColor
                            textLayer?.foregroundColor = darkGrayColor.CGColor
                            closingTopLayer = true
                            showingTopLayer = false
                        }
                    }
                }else{
                    if !closingMiddleLayer{
                        closeLayerAnimation(middleLayer!)
                        middleLayer?.backgroundColor = lightGrayColor.CGColor
                        closingMiddleLayer = true
                        showingMiddleLayer = false
                    }
                }
            }else{
                if !closingBottomLayer{
                    closeLayerAnimation(bottomLayer!)
                    bottomLayer?.backgroundColor = lightGrayColor.CGColor
                    closingBottomLayer = true
                    showingBottomLayer = false
                }
            }
        }else{
            self.textLayer?.opacity = 0
        }
    }
}
