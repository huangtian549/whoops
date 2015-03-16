//
//  YRCommnentsCell.swift
//  JokeClient-Swift
//
//  Created by YANGReal on 14-6-7.
//  Copyright (c) 2014年 YANGReal. All rights reserved.
//

import UIKit

class YRCommnentsCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var likeHotLabel: UILabel!
    
    var likeClick:Bool = true
    var likeHot = Int()
    var data :NSDictionary!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        var content = self.data.stringAttributeForKey("content")
        var width = self.contentLabel.width()
        var height = content.stringHeightWith(17,width:width)
        
        self.contentLabel.setHeight(height)
        self.contentLabel.text = content
        
        self.createdDate.text = self.data.stringAttributeForKey("createDate") as String
        
        if self.data.stringAttributeForKey("likeNum") == NSNull(){
            self.likeHot = 0
        } else {
            self.likeHot = self.data.stringAttributeForKey("likeNum").toInt()!
        }
        
        if self.data.stringAttributeForKey("dislikeNum") != NSNull(){
            self.likeHot = self.likeHot - self.data.stringAttributeForKey("dislikeNum").toInt()!
        }
        
        self.likeHotLabel.text = String(self.likeHot)
        
    }

    
    @IBAction func likeImageClick(){
        /*let myalert = UIAlertView()
        myalert.title = "准备好了吗"
        myalert.message = "准备好开始了吗？"
        myalert.addButtonWithTitle("Ready, go!")
        myalert.show()*/
        var id = self.data.stringAttributeForKey("id")
        var like = self.data.stringAttributeForKey("likeNum")
        if self.likeClick {
            var url = FileUtility.getUrlDomain() + "comment/like?id=\(id)"
            YRHttpRequest.requestWithURL(url,completionHandler:{ data in
                
                if data as NSObject == NSNull()
                {
                    UIView.showAlertView("提示",message:"加载失败")
                    return
                }
                
                
            })
            
            self.likeHotLabel.text = String(self.likeHot + 1)
            self.likeClick = false
        }
        
    }
    
    @IBAction func unlikeImageClick(){
        /*let myalert = UIAlertView()
        myalert.title = "准备好了吗"
        myalert.message = "准备好开始了吗？"
        myalert.addButtonWithTitle("Ready, go!")
        myalert.show()*/
        
        var id = self.data.stringAttributeForKey("id")
        var dislike = self.data.stringAttributeForKey("dislikeNum")
        if self.likeClick {
            var url = FileUtility.getUrlDomain() + "comment/unlike?id=\(id)"
            YRHttpRequest.requestWithURL(url,completionHandler:{ data in
                
                if data as NSObject == NSNull()
                {
                    UIView.showAlertView("提示",message:"加载失败")
                    return
                }
                
                
            })
            
            self.likeHotLabel.text = String(self.likeHot - 1)
            self.likeClick = false
        }
    }

    
    
    class func cellHeightByData(data:NSDictionary)->CGFloat
    {
        var content = data.stringAttributeForKey("content")
        var height = content.stringHeightWith(17,width:300)
        return 53.0 + height + 24.0
    }

    
}
