//
//  ViewController.swift
//  HandWriteSignature
//
//  Created by ChenDanny on 2016/3/1.
//  Copyright © 2016年 ChenDanny. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HandwriteViewControllerDelegate {
    
    @IBOutlet weak var pdfView: HWSPdfView!
    
    var mouseSwiped = false
    var lastPoint = CGPoint(x: 0, y: 0)
    var pdfPage:CGPDFPage?
    var signatureImage:UIImage?
    @IBOutlet weak var signatureImageView: UIImageView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == kPopHandwriteViewController){
            let handwritingVC = segue.destinationViewController as! HandwriteViewController
            handwritingVC.delegate = self
        }
    }
    
    @IBAction func popSignature(sender: AnyObject) {
        performSegueWithIdentifier(kPopHandwriteViewController, sender: nil)
    }
    
    @IBAction func exportPdf(sender: AnyObject) {
        /*
            convert UIView to pdf
            http://stackoverflow.com/questions/5443166/how-to-convert-uiview-to-pdf-within-ios
            combine two pdf files into one
            http://stackoverflow.com/questions/9646203/is-it-possible-to-combine-multiple-pdf-files-into-a-single-pdf-file-programmatic
        */
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfView.bounds, nil)
        UIGraphicsBeginPDFPage()
        
        drawPdfToContext()
        drawSignature()
        
        UIGraphicsEndPDFContext()
        
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
            let documentsFileName = documentDirectories + "/" + "testData.pdf"
            debugPrint(documentsFileName)
            pdfData.writeToFile(documentsFileName, atomically: true)
        }
    }
    
    func drawPdfToContext(){
        let rect = pdfView.frame
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
        CGContextDrawPDFPage(ctx, pdfPage)
    }
    
    func drawSignature(){
        let ctx = UIGraphicsGetCurrentContext()

        let ciImage = CIImage(image: signatureImage!)
        let cgImage = convertCIImageToCGImage(ciImage!)
        
        CGContextDrawImage(ctx, CGRectMake(0, 0, signatureImageView.frame.width, signatureImageView.frame.height), cgImage)
    }
    
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        return context.createCGImage(inputImage, fromRect: inputImage.extent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadPdfFile()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadPdfFile(){
        let urlAddress = NSBundle.mainBundle().pathForResource("572495736", ofType: "pdf")
        let filePath = NSURL(fileURLWithPath: urlAddress!)
        let myDocumentRef = CGPDFDocumentCreateWithURL(filePath)
        pdfPage = CGPDFDocumentGetPage(myDocumentRef, 1)
        
        pdfView.displayPdfFile(pdfPage)
    }

    // HandwriteViewControllerDelegate
    func saveSignature(image: UIImage) {
        signatureImage = image
        signatureImageView.image = signatureImage
    }
}

