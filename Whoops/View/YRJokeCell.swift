//
//  YRJokeCell.swift
//  JokeClient-Swift
//
//  Created by YANGReal on 14-6-6.
//  Copyright (c) 2014年 YANGReal. All rights reserved.
//

import UIKit


class YRJokeCell: UITableViewCell {
    
//    @IBOutlet var avatarView:UIImageView?
    @IBOutlet var pictureView:UIImageView?
    @IBOutlet var nickLabel:UILabel?
    @IBOutlet var contentLabel:UILabel?
 
    @IBOutlet var commentLabel:UILabel?
    @IBOutlet var bottomView:UIView?
    
    @IBOutlet weak var likeImage: UIImageView!
    
    
    @IBOutlet weak var likeHotLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
   
    @IBOutlet weak var dislikeImage: UIImageView!
    
    var largeImageURL:String = ""
    var data :NSDictionary!
    
    var mainWidth:CGFloat = 0
    
    var likeHot:String = "0"
    var postId:String = ""
    //let avatarPlaceHolder = UIImage(named: "avatar.jpg")
    
    @IBAction func shareBtnClicked()
    {
        // self.delegate!.jokeCell(self, didClickShareButtonWithData:self.data)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        mainWidth = UIScreen.mainScreen().bounds.width
       
        var tap = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
        self.pictureView!.addGestureRecognizer(tap)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
       // // Configure the view for the selected state
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.nickLabel!.text = self.data.stringAttributeForKey("nickName")
        var content = self.data.stringAttributeForKey("content")
        var width = self.contentLabel?.width()
        var height = content.stringHeightWith(17,width:width!)

        self.contentLabel!.setHeight(height)
        self.contentLabel!.text = content
        
        var imgSrc = self.data.stringAttributeForKey("image") as NSString
        if imgSrc.length == 0
        {
            self.pictureView!.hidden = true
            //self.bottomView!.setY(self.contentLabel!.bottom())
        }
        else
        {
            
            var imagURL = FileUtility.getUrlImage() + imgSrc
            self.pictureView!.hidden = false
            self.pictureView!.setImage(imagURL,placeHolder: UIImage(named: "avatar.jpg"))
            self.largeImageURL = FileUtility.getUrlDomain() + imgSrc
            //self.pictureView!.setY(self.contentLabel!.bottom()+5)
            //self.bottomView!.setY(self.pictureView!.bottom())
        }
        
       
        if self.data.stringAttributeForKey("likeNum") == NSNull(){
            self.likeHotLabel!.text = "0"
        }else{
            self.likeHotLabel!.text = self.data.stringAttributeForKey("likeNum")
            likeHot = self.data.stringAttributeForKey("likeNum")
        }
            
        if self.data.stringAttributeForKey("dislikeNum") == NSNull(){
            self.dateTimeLabel!.text = "0"
        }else{
            self.dateTimeLabel!.text = self.data.stringAttributeForKey("dislikeNum")
        }
        
        
        var commentCount = self.data.stringAttributeForKey("commentCount") as String
        if commentCount == "" || commentCount == "0" {
            commentCount = "0 Reply"
        }else if commentCount == "1" {
            commentCount = "1 Reply"
        }else {
            commentCount = "\(commentCount) Replies"
        }
        self.commentLabel!.text = "\(commentCount) "
        
        
        var cellHeight:CGFloat = YRJokeCell.cellHeightByData(self.data);
        //self.dislikeLabel?.setY(cellHeight/2)
        
        
        var nickName = self.data.stringAttributeForKey("nickName") as String
        if nickName == ""{
           contentLabel?.frame = CGRectMake(0, 0, cellContentWidth(), content.stringHeightWith(17,width:cellContentWidth()))
        }else{
            self.nickLabel!.text = "@" + nickName
            //contentLabel?.frame = CGRectMake(20, 30, 300, content.stringHeightWith(17,width:300))
        }
        self.dateTimeLabel!.text = self.data.stringAttributeForKey("createDateLabel") as String
        
       postId = self.data.stringAttributeForKey("id") as String
    
    }
    
    func cellContentWidth()->CGFloat{
        let mainWidth = UIScreen.mainScreen().bounds.width
        return mainWidth - 80
    }
    
    class func cellHeightByData(data:NSDictionary)->CGFloat
    {
        let mainWidth = UIScreen.mainScreen().bounds.width

        var nickName = data.stringAttributeForKey("nickName")
        var content = data.stringAttributeForKey("content")
        var height = content.stringHeightWith(17,width:mainWidth-100)
        var imgSrc = data.stringAttributeForKey("image") as NSString
        var value = CGFloat()
        
        if imgSrc.length == 0
        {
            if nickName == "" {
                value = 59.0 + height + 40
            }else{
                value = 59.0 + height + 60
            }
            if value < 140 {
                return 140
            } else {
                return value
            }
        }
        
        return 59.0 + height + 5.0 + 140.0 + 100
        
    }
    
    func imageViewTapped(sender:UITapGestureRecognizer)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("imageViewTapped", object:self.largeImageURL)
        
    }
    
    var likeCilcke:Bool = true
    var unLikeClick:Bool = true
    
    @IBAction func likeImageClick(){
        if likeCilcke {
            var url = FileUtility.getUrlDomain() + "post/like?id=\(postId)&likeNum=\(likeHot)"
            
            YRHttpRequest.requestWithURL(url,completionHandler:{ data in
                
                if data as NSObject == NSNull()
                {
                    UIView.showAlertView("提示",message:"加载失败")
                    return
                }

                
            })
            
            var intLikeHot:Int =  likeHot.toInt()!
            self.likeHotLabel!.text = String(intLikeHot + 1)
            
            likeCilcke = false
        }
        
    }
    
    @IBAction func unlikeImageClick(){
        if likeCilcke {
            var url = FileUtility.getUrlDomain() + "post/unlike?id=\(postId)&dislikeNum=\(likeHot)"
            
            YRHttpRequest.requestWithURL(url,completionHandler:{ data in
                
                if data as NSObject == NSNull()
                {
                    UIView.showAlertView("提示",message:"加载失败")
                    return
                }
                
                
            })
            
            var intLikeHot:Int =  likeHot.toInt()!
            self.likeHotLabel!.text = String(intLikeHot - 1)
            
            likeCilcke = false
        }
    }
    
}
