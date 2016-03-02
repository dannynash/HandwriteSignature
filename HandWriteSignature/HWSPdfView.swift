//
//  HWSPdfView.swift
//  HandWriteSignature
//
//  Created by ChenDanny on 2016/3/1.
//  Copyright © 2016年 ChenDanny. All rights reserved.
//

import Foundation
import UIKit

// http://www.graybirdsoftware.com/ios/pdf-file-rendering-with-ios/

class HWSPdfView: UIView {

    var pdfPage:CGPDFPage?
    
    func displayPdfFile(file:CGPDFPage?){
        pdfPage = file
        setNeedsDisplay()
    }
        
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetRGBFillColor(ctx, 255.0, 255.0, 255.0, 1.0)
        CGContextFillRect(ctx, rect)
        
        CGContextGetCTM(ctx)
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -rect.size.height);
        
        // get cropbox
        let cropRect = CGPDFPageGetBoxRect(pdfPage, CGPDFBox.CropBox);
        //scale to fit the entire page,
        CGContextScaleCTM(ctx, rect.size.width / cropRect.size.width,rect.size.height / cropRect.size.height);
        CGContextTranslateCTM(ctx, -cropRect.origin.x, -cropRect.origin.y);
        
        // draw PDF
        CGContextDrawPDFPage(ctx, pdfPage);
    }
    
}
