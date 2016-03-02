//
//  HandwriteViewController.swift
//  HandWriteSignature
//
//  Created by ChenDanny on 2016/3/1.
//  Copyright © 2016年 ChenDanny. All rights reserved.
//

import Foundation
import UIKit

protocol HandwriteViewControllerDelegate {
    // protocol definition goes here
    func saveSignature(image:UIImage)
}

class HandwriteViewController: UIViewController {
    var mouseSwiped = false
    var lastPoint = CGPoint(x: 0, y: 0)
    var delegate: HandwriteViewControllerDelegate?

    @IBOutlet weak var drawImage: UIImageView!

    @IBAction func saveSignature(sender: AnyObject) {
        delegate?.saveSignature(drawImage.image!)
        
        if ((self.presentingViewController) != nil){
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
            })
        }
    }
    
    @IBAction func clearSignature(sender: AnyObject) {
        drawImage.image = nil
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        mouseSwiped = false
        let touch = touches.first
        
        lastPoint = (touch?.locationInView(self.view))!
        lastPoint.y -= 20
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        mouseSwiped = true
        
        let touch = touches.first
        var currentPoint = (touch?.locationInView(self.view))!
        currentPoint.y -= 20
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        drawImage.image?.drawInRect(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0)
        CGContextBeginPath(UIGraphicsGetCurrentContext())
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y)
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        lastPoint = currentPoint
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if (!mouseSwiped){
            UIGraphicsBeginImageContext(self.view.frame.size)
            drawImage.image?.drawInRect(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0)
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0)
            CGContextBeginPath(UIGraphicsGetCurrentContext())
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
            CGContextStrokePath(UIGraphicsGetCurrentContext())
            
            drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
        }
    }

}