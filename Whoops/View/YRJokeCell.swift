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
    @IBOutlet var likeLabel:UILabel?
    @IBOutlet var dislikeLabel:UILabel?
    @IBOutlet var commentLabel:UILabel?
    @IBOutlet var bottomView:UIView?
    
    @IBOutlet weak var likeImage: UIImageView!
    
    
   
    @IBOutlet weak var dislikeImage: UIImageView!
    
    var largeImageURL:String = ""
    var data :NSDictionary!
    
    var mainWidth:CGFloat = 0
    
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
        // var uid = self.data["id"] as String
//        var user : AnyObject!  = self.data["user"]
//        
//        if user as NSObject != NSNull()
//        {
//            var userDict = user as NSDictionary
//            userDict["login"] as NSString
//            
//            var icon : AnyObject! = userDict["icon"] //as NSString
//            if icon as NSObject != NSNull()
//            {
//                var userIcon = icon as String
//                var userId =  userDict["id"] as NSString
//                var prefixUserId = userId.substringToIndex(3)
//                var userImageURL = "http://pic.moumentei.com/system/avtnew/\(prefixUserId)/\(userId)/thumb/\(userIcon)"
////                self.avatarView!.setImage(userImageURL,placeHolder: UIImage(named: "avatar.jpg"))
//            }
//            else
//            {
////                self.avatarView!.image =  UIImage(named: "avatar.jpg")
//            }
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
            var imageId = self.data.stringAttributeForKey("id") as NSString
            var prefiximageId = imageId.substringToIndex(5)
            var imagURL = "http://pic.qiushibaike.com/system/pictures/\(prefiximageId)/\(imageId)/small/\(imgSrc)"
            self.pictureView!.hidden = false
            self.pictureView!.setImage(imagURL,placeHolder: UIImage(named: "avatar.jpg"))
            self.largeImageURL = "http://pic.qiushibaike.com/system/pictures/\(prefiximageId)/\(imageId)/medium/\(imgSrc)"
            //self.pictureView!.setY(self.contentLabel!.bottom()+5)
            //self.bottomView!.setY(self.pictureView!.bottom())
        }
        
       
        if self.data.stringAttributeForKey("likeNum") == NSNull(){
            self.likeLabel!.text = "顶(0)"
        }else{
            self.likeLabel!.text = self.data.stringAttributeForKey("likeNum")
        }
            
        if self.data.stringAttributeForKey("dislikeNum") == NSNull(){
            self.dislikeLabel!.text = "踩(0)"
        }else{
            self.dislikeLabel!.text = self.data.stringAttributeForKey("dislikeNum")
        }
        
        
        var commentCount = self.data.stringAttributeForKey("commentsCount") as String
        self.commentLabel!.text = "评论(\(commentCount))"
        
        
        var cellHeight:CGFloat = YRJokeCell.cellHeightByData(self.data);
        //self.dislikeLabel?.setY(cellHeight/2)
        
        
        var nickName = self.data.stringAttributeForKey("nickName") as String
        if nickName == ""{
            //contentLabel?.frame = CGRectMake(1, 1, 300, content.stringHeightWith(17,width:300))
        }else{
            self.nickLabel!.text = "@" + nickName
            //contentLabel?.frame = CGRectMake(20, 30, 300, content.stringHeightWith(17,width:300))
        }
        
        //likeImage.frame = CGRectMake(mainWidth - 20 - 25, cellHeight * 0.2, 25, 25)
        
        //dislikeImage.frame = CGRectMake(mainWidth - 20 - 25, cellHeight * 0.7, 25, 25)
        
        //bottomView?.frame = CGRectMake(10, cellHeight - 35 , mainWidth-150, 30)
    
    }
    
    
    class func cellHeightByData(data:NSDictionary)->CGFloat
    {
        let mainWidth = UIScreen.mainScreen().bounds.width
        
        var content = data.stringAttributeForKey("content")
        var height = content.stringHeightWith(17,width:mainWidth-100)
        var imgSrc = data.stringAttributeForKey("image") as NSString
        var value = CGFloat()
        
        if imgSrc.length == 0
        {
            //return 59.0 + height + 10
            value = 59.0 + height + 60
            if value < 140 {return 140} else {return value}
        }
        
        return 59.0 + height + 5.0 + 140.0 + 100
        
    }
    
    func imageViewTapped(sender:UITapGestureRecognizer)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("imageViewTapped", object:self.largeImageURL)
        
    }
    
    
    
}
