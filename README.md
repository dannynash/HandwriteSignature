# HandwriteSignature

使用CoreGraphics完成簽名在PDF上的功能

# HandwriteViewController 接收使用者簽名軌跡，把簽名檔存成UIImage。

# ViewController負責
- 載入目標PDF，顯示在畫面上
- 接收來自HandwriteViewController的簽名檔，顯示在畫面上
- 將PDF與簽名檔重新壓成PDF


Reference:

Convert UIView to pdf
http://stackoverflow.com/questions/5443166/how-to-convert-uiview-to-pdf-within-ios
Combine two pdf files into one
http://stackoverflow.com/questions/9646203/is-it-possible-to-combine-multiple-pdf-files-into-a-single-pdf-file-programmatic
Image convert
http://wiki.hawkguide.com/wiki/Swift:_Convert_between_CGImage,_CIImage_and_UIImage#Swift:_Convert_UIImage_to_CIImage
Handwriting signature
http://www.ifans.com/forums/threads/tutorial-drawing-to-the-screen.132024/
