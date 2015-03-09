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
    
    @IBOutlet weak var likeButton: UIButton!
   
   
    @IBOutlet weak var unlikeButton: UIButton!
    
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
        
        var content = self.data.stringAttributeForKey("content")
        var height = content.stringHeightWith(17,width:cellContentWidth())
        
        self.contentLabel!.setHeight(height)

        self.contentLabel!.text = content
        
        var imgSrc = self.data.stringAttributeForKey("image") as NSString
        if imgSrc.length == 0
        {
            self.pictureView!.hidden = true
//            self.bottomView!.setY(YRJokeCell.cellHeightByData(data) - 21)
//            self.bottomView?.frame = CGRectMake(0,YRJokeCell.cellHeightByData(data) - 18, 280, 20)
//            self.bottomView?.backgroundColor = UIColor.redColor()
        }
        else
        {
            var imageId = self.data.stringAttributeForKey("id") as NSString
            var prefiximageId = imageId.substringToIndex(5)
            var imagURL = "http://pic.qiushibaike.com/system/pictures/\(prefiximageId)/\(imageId)/small/\(imgSrc)"
            self.pictureView!.hidden = false
            self.pictureView!.setImage(imagURL,placeHolder: UIImage(named: "avatar.jpg"))
            self.largeImageURL = "http://pic.qiushibaike.com/system/pictures/\(prefiximageId)/\(imageId)/medium/\(imgSrc)"
            self.pictureView!.setY(self.contentLabel!.bottom()+5)
//            self.bottomView!.setY(self.pictureView!.bottom())
        }
        
       
        if self.data.stringAttributeForKey("likeNum") == NSNull(){
            self.likeLabel!.text = ""
        }else{
            self.likeLabel!.text = self.data.stringAttributeForKey("likeNum")
        }
            
        if self.data.stringAttributeForKey("dislikeNum") == NSNull(){
            self.dislikeLabel!.text = ""
        }else{
            self.dislikeLabel!.text = self.data.stringAttributeForKey("dislikeNum")
        }
        
        
        var commentCount = self.data.stringAttributeForKey("commentCount") as String
        self.commentLabel!.text = "\(commentCount) Replies"
        
        
        var cellHeight:CGFloat = YRJokeCell.cellHeightByData(self.data);
        
        var nickName = self.data.stringAttributeForKey("nickName") as String
        if nickName == ""{
            contentLabel?.frame = CGRectMake(20, 1, cellContentWidth(), content.stringHeightWith(17,width:cellContentWidth()))
        }else{
            self.nickLabel!.text = "@" + nickName
            contentLabel?.frame = CGRectMake(20, 30, cellContentWidth(), content.stringHeightWith(17,width:cellContentWidth()))
        }
        
        var likeNum:String = self.data.stringAttributeForKey("likeNum") as String
        if cellHeight < 100 {
            self.likeLabel?.frame = CGRectMake(mainWidth - 20 - 25, cellHeight * 0.35, 25, 25)
        }else if cellHeight >= 100 && cellHeight < 200 {
            self.likeLabel?.frame = CGRectMake(mainWidth - 20 - 25, cellHeight * 0.3, 25, 25)
        } else {
            self.likeLabel?.frame = CGRectMake(mainWidth - 20 - 25, cellHeight * 0.25, 25, 25)
        }
        
        likeButton.frame = CGRectMake(mainWidth - 20 - 25, cellHeight * 0.1, 25, 25)
        
        unlikeButton.frame = CGRectMake(mainWidth - 20 - 25, cellHeight * 0.7, 25, 25)
        
        bottomView?.frame = CGRectMake(10, cellHeight - 25 , mainWidth-150, 20)
    
    }
    
    
    @IBAction func likeImageClick(){
        let myalert = UIAlertView()
        myalert.title = "准备好了吗"
        myalert.message = "准备好开始了吗？"
        myalert.addButtonWithTitle("Ready, go!")
        myalert.show()
    }
    
    @IBAction func unlikeImageClick(){
        let myalert = UIAlertView()
        myalert.title = "准备好了吗"
        myalert.message = "准备好开始了吗？"
        myalert.addButtonWithTitle("Ready, go!")
        myalert.show()
    }

    func cellContentWidth()->CGFloat{
        let mainWidth = UIScreen.mainScreen().bounds.width
        return mainWidth - 70
    }
    
    class func cellHeightByData(data:NSDictionary)->CGFloat
    {
        let mainWidth = UIScreen.mainScreen().bounds.width
        var content = data.stringAttributeForKey("content")
        var nickName = data.stringAttributeForKey("nickName")
        var height = content.stringHeightWith(17,width:mainWidth - 70)
        var imgSrc = data.stringAttributeForKey("image") as NSString
        
        if imgSrc.length == 0
        {
            if nickName == "" {
                return 59.0 + height + 10
            } else {
                return 59.0 + height + 10
            }
        }
        
        return 59.0 + height + 5.0 + 140.0 + 100
        
    }
    
    func imageViewTapped(sender:UITapGestureRecognizer)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("imageViewTapped", object:self.largeImageURL)
        
    }
    
    
    
}
