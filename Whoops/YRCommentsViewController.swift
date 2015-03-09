//
//  YRCommentsViewController.swift
//  JokeClient-Swift
//
//  Created by YANGReal on 14-6-7.
//  Copyright (c) 2014年 YANGReal. All rights reserved.
//

import UIKit

class YRCommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,YRRefreshViewDelegate {

    var tableView:UITableView?
    let identifier = "cell"
    
    var dataArray = NSMutableArray()
    var page :Int = 1
    var refreshView:YRRefreshView?
    var jokeId:String!

    var postData:NSDictionary!
    var headerView:YRJokeCell?
  
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        self.title = "Detail"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func setupViews()
    {
        var width = self.view.frame.size.width
        var height = self.view.frame.size.height
        self.tableView = UITableView(frame:CGRectMake(0,0,width,height))
        self.tableView!.delegate = self;
        self.tableView!.dataSource = self;
//        self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView?.backgroundColor = UIColor.clearColor()
        //self.tableView!.style = UITableViewStyle.Grouped
        var nib = UINib(nibName:"YRJokeCell", bundle: nil)
        
        self.tableView?.registerNib(nib, forCellReuseIdentifier: identifier)
        
        
        loadPostData()
        
//        headerView.initData()

       
      
        
//        var arr =  NSBundle.mainBundle().loadNibNamed("YRRefreshView" ,owner: self, options: nil) as Array
//        self.refreshView = arr[0] as? YRRefreshView
//        self.refreshView!.delegate = self
//        
//        self.tableView!.tableFooterView = self.refreshView
        self.view.addSubview(self.tableView!)
    }
    
    func loadData()
    {
        var url = FileUtility.getUrlDomain() + "comment/getCommentByPostId?postId=\(jokeId)"
//        self.refreshView!.startLoading()
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                UIView.showAlertView("提示",message:"加载失败")
                return
            }
            
            var arr = data["data"] as NSArray
            if arr.count  == 0
            {
                UIView.showAlertView("提示",message:"暂无新评论哦")
                self.tableView!.tableFooterView = nil
            }
            for data : AnyObject  in arr
            {
                self.dataArray.addObject(data)
            }
            self.tableView!.reloadData()
//            self.refreshView!.stopLoading()
            self.page++


            
            
            })

    }
    
    func loadPostData()
    {
        var url = FileUtility.getUrlDomain() + "post/get?id=\(self.jokeId)"
        
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                UIView.showAlertView("提示",message:"加载失败")
                return
            }
            
            
            
            var arrHeader =  NSBundle.mainBundle().loadNibNamed("YRJokeCell" ,owner: self, options: nil) as Array
            
            self.headerView = arrHeader[0] as? YRJokeCell
            var post = data["data"] as NSDictionary
            self.headerView?.data = post
            self.headerView?.frame = CGRectMake(0, 0, self.view.frame.size.width,YRJokeCell.cellHeightByData(post))

            self.tableView!.tableHeaderView = self.headerView
        })
        
    }

    
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.dataArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? YRJokeCell
        var index = indexPath.row
        var data = self.dataArray[index] as NSDictionary
        cell!.data = data
        return cell!
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
//        
//        
//    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        var index = indexPath!.row
        var data = self.dataArray[index] as NSDictionary
        return  YRCommnentsCell.cellHeightByData(data)
    }
//    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
//    {
//        var index = indexPath!.row
//        var data = self.dataArray[index] as NSDictionary
//        println(data)
//    }
    
    func refreshView(refreshView:YRRefreshView,didClickButton btn:UIButton)
    {
        //refreshView.startLoading()
        loadData()
    }    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
