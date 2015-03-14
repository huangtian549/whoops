//
//  YRSendComment.swift
//  Whoops
//
//  Created by naikun on 15/3/10.
//  Copyright (c) 2015年 Li Jiatan. All rights reserved.
//

import Foundation

protocol YRRefreshCommentViewDelegate
{
    
    func refreshCommentView(refreshView:YRSendComment,didClickButton btn:UIButton)
}


class YRSendComment:UIView , UITextFieldDelegate{
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    var delegate:YRRefreshCommentViewDelegate!
    
    var postId:String = ""
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        commentText.delegate = self
        
        var width = UIScreen.mainScreen().bounds.width
        var height = UIScreen.mainScreen().bounds.height
        self.sendButton.frame = CGRectMake(0, width - 10, 30, 30)
        
        
        
    }
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        var comment:String = self.commentText.text
        if countElements(comment) > 5 {
            self.commentText.text = comment.substringToIndex(5)
            return false
        }
        return true
    }
   
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        var width = UIScreen.mainScreen().bounds.width
        var height = UIScreen.mainScreen().bounds.height
        self.frame = CGRectMake(0, height * 0.5 , width, 50)
        return true
    }

    func setPostId(postId:String){
        self.postId = postId
    }
    
    @IBAction func sendBtnClicked(sender:UIButton)
    {
        var content = commentText.text
        if content.isEmpty{
//            UIView.showAlertView("WARNING",message:"Comment should not be empty")
            return
        }
        
        var url = FileUtility.getUrlDomain() + "comment/add?"
        var paraData = "content=\(content)&postId=\(postId)"
        
        var data:NSMutableArray = YRHttpRequest.postWithURL(urlString: url, paramData: paraData)
        
        commentText.text = ""
        self.delegate.refreshCommentView(self,didClickButton:sender)
        
    }
    
}