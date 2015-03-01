//
//  YRNewPostViewController.swift
//  Whoops
//
//  Created by huangyao on 15-2-26.
//  Copyright (c) 2015年 Li Jiatan. All rights reserved.
//

import UIKit

class YRNewPostViewController: UIViewController, UIImagePickerControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var contentTextView: UITextView!
 
    @IBOutlet weak var sendItem: UIBarButtonItem!

    
    @IBOutlet weak var photoButton: UIButton!
    
    
    var imgView = UIImageView()
    
    
    var img = UIImage()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.textViewDidChangeSelection(contentTextView)
     
        
//        var footNib:UINib = UINib(nibName: "YRSendViewCell", bundle: NSBundle.mainBundle())
//        var yrSendViewCell:YRSendViewCell = footNib.instantiateWithOwner(nil, options: nil).last as YRSendViewCell
//        self.view.addSubview(yrSendViewCell)
        imgView.frame = CGRectMake(100, 240, 100, 100)
        
        
        self.view.addSubview(imgView)

        
    }
    
//    func textViewDidChangeSelection(textView: UITextView) {
//        var range:NSRange = NSRange(location: 0, length: 0)
//        range.location = 0
//        range.length = 0
//        textView.selectedRange = range
//    }
    
    @IBAction func unwindToList(segue:UIStoryboardSegue){
        println("bbb")

    }
    
    
    @IBAction func photoButtonClick(sender: AnyObject) {
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        var sourceType = UIImagePickerControllerSourceType.Camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true//设置可编辑
        picker.sourceType = sourceType
        
        self.presentViewController(picker, animated: true, completion: nil)//进入照相界面
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
        img = info[UIImagePickerControllerEditedImage] as UIImage
        imgView.image = img
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    //cancel后执行的方法
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "sendSegue" {
            if (contentTextView!.text.isEmpty) {
                UIView.showAlertView("提示",message:"内容不能为空")
                
            }else{
                println(contentTextView.text)
            }
            println("aaaaccccc")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}