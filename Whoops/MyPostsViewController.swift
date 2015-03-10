//
//  MyPostsViewController.swift
//  Whoops
//
//  Created by Li Jiatan on 2/27/15.
//  Copyright (c) 2015 Li Jiatan. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class MyPostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YRRefreshViewDelegate{

    var myPosts = NSMutableArray()
    let identifier = "myPost"
    var page:Int = 1
    var refreshView: YRRefreshView?
    var uid = String()
    
    @IBOutlet weak var PostTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupRefresh()
        //uid = FileUtility.getUserId()
        //self.uid = "1"
        //self.addRefreshControl()
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageViewTapped:", name: "imageViewTapped", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "imageViewTapped", object:nil)
        
    }
    
    func imageViewTapped(noti:NSNotification)
    {
        
        var imageURL = noti.object as String
        var imgVC = YRImageViewController(nibName: nil, bundle: nil)
        imgVC.imageURL = imageURL
        self.navigationController?.pushViewController(imgVC, animated: true)
        
        
    }
    
    func setupRefresh(){
        var arr =  NSBundle.mainBundle().loadNibNamed("YRRefreshView" ,owner: self, options: nil) as Array
        self.refreshView = arr[0] as? YRRefreshView
        self.refreshView?.delegate = self
        self.PostTableView.tableFooterView = self.refreshView
        self.addRefreshControl()
    }
    
    func addRefreshControl(){
        
        
        var refresh = UIRefreshControl()
        refresh.addTarget(self, action: "actionRefreshHandler:", forControlEvents: UIControlEvents.ValueChanged)
        refresh.tintColor = UIColor.whiteColor()
        self.PostTableView.addSubview(refresh)
    }
    
    func actionRefreshHandler(sender:UIRefreshControl){
        
        page = 1
        var url = urlString()
        self.refreshView!.startLoading()
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                let myAltert=UIAlertController(title: "Alert", message: "Refresh Failed", preferredStyle: UIAlertControllerStyle.Alert)
                myAltert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(myAltert, animated: true, completion: nil)
                return
            }
            
            var arr = data["data"] as NSArray
            
            self.myPosts = NSMutableArray()
            for data : AnyObject  in arr
            {
                self.myPosts.addObject(data)
                
            }
            self.PostTableView.reloadData()
            self.refreshView!.stopLoading()
            
            sender.endRefreshing()
        })
    }
    
    
    func loadData(){
        var url = urlString()
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                let myAltert=UIAlertController(title: "Alert", message: "Refresh Failed", preferredStyle: UIAlertControllerStyle.Alert)
                myAltert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(myAltert, animated: true, completion: nil)
                return
            }
            
            var arr = data["data"] as NSArray
            
            for data : AnyObject  in arr
            {
                self.myPosts.addObject(data)
            }
            self.PostTableView.reloadData()
           // self.refreshView!.stopLoading()
            self.page++
        })
    }
    
    func urlString() ->String{
        //return "http://m2.qiushibaike.com/article/list/latest?count=20&page=\(page)"
        return "http://104.131.91.181:8080/whoops/post/listByUid?uid=1&pageNum=\(page)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myPosts.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? PostTableViewCell
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as PostTableViewCell
        
        var data = self.myPosts[indexPath.row] as NSDictionary
        cell.data = data
        return cell
        
    }
    
    func refreshView(refreshView:YRRefreshView,didClickButton btn:UIButton)
    {
        loadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var index = indexPath.row
        var data = self.myPosts[index] as NSDictionary
        return  PostTableViewCell.cellHeightByData(data)
    }
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
     {
        var postComment = segue.destinationViewController as MyPostCommentViewController
        if let indexPath = self.PostTableView.indexPathForSelectedRow()
        {
            var comment = self.myPosts[indexPath.row] as NSDictionary
            postComment.jokeId = comment.stringAttributeForKey("id")

        }
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
