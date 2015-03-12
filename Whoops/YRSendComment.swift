//
//  YRSendComment.swift
//  Whoops
//
//  Created by naikun on 15/3/10.
//  Copyright (c) 2015年 Li Jiatan. All rights reserved.
//

import Foundation

class YRSendComment:UIView , UITextFieldDelegate{
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var postId:String = ""
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        commentText.delegate = self
        
        var width = UIScreen.mainScreen().bounds.width
        var height = UIScreen.mainScreen().bounds.height
        self.sendButton.frame = CGRectMake(0, width - 10, 30, 30)
        
        
    }
    
    
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        var width = UIScreen.mainScreen().bounds.width
//        var height = UIScreen.mainScreen().bounds.height
//        self.frame = CGRectMake(0, height * 0.5 , width, 50)
//    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        var width = UIScreen.mainScreen().bounds.width
        var height = UIScreen.mainScreen().bounds.height
        self.frame = CGRectMake(0, height * 0.5 , width, 50)
        return true
    }

    func setPostId(postId:String){
        self.postId = postId
    }
    
    @IBAction func sendBtnClicked()
    {
        var content = commentText.text
        if content.isEmpty{
            UIView.showAlertView("WARNING",message:"Comment should not be empty")
            return
        }
        
        var url = FileUtility.getUrlDomain() + "comment/add?content=\(content)&postId=\(postId)"
        
        
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                UIView.showAlertView("WARNING",message:"Network error!")
                return
            }
            
            
        })

    }
    
}