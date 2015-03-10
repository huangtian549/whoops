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
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        commentText.delegate = self
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

    
}