//
//  YRCommentsViewController.swift
//  JokeClient-Swift
//
//  Created by YANGReal on 14-6-7.
//  Copyright (c) 2014年 YANGReal. All rights reserved.
//

import UIKit

class YRCommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,YRRefreshViewDelegate ,UITextFieldDelegate,YRRefreshCommentViewDelegate{

    var tableView:UITableView?
    let identifier = "cell"
    
    var dataArray = NSMutableArray()
    var page :Int = 1
    var refreshView:YRRefreshView?
    var jokeId:String!

    var postData:NSDictionary!
    var headerView:YRJokeCell?
    
    var sendView:YRSendComment?
  
    
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
        //self.tableView?.backgroundColor = UIColor(red: 0.173, green: 0.133, blue: 0.361, alpha: 1.0)
        // Do any additional setup after loading the view.
    }
    
    func setupViews()
    {
        var width = self.view.frame.size.width
        var height = self.view.frame.size.height
        self.tableView = UITableView(frame:CGRectMake(0,0,width,height), style:.Grouped)
        self.tableView!.delegate = self;
        self.tableView!.dataSource = self;
        
//        self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView?.backgroundColor = UIColor(red: 0.173, green: 0.133, blue: 0.361, alpha: 1.0)
        //var nib = UINib(nibName:"YRJokeCell", bundle: nil)
        var nib = UINib(nibName: "YRCommnentsCell", bundle: nil)
        
        self.tableView?.registerNib(nib, forCellReuseIdentifier: identifier)
        self.view.addSubview(self.tableView!)
        
        
        var arr =  NSBundle.mainBundle().loadNibNamed("YRSendComment" ,owner: self, options: nil) as Array
        self.sendView = arr[0] as? YRSendComment
        self.sendView?.delegate = self
        self.sendView?.setPostId(jokeId)
        
        self.sendView?.frame = CGRectMake(0, height - 50 , width, 50)
        self.view.addSubview(sendView!)

        
        loadPostData()
        
//        headerView.initData()

       
      
        
//        var arr =  NSBundle.mainBundle().loadNibNamed("YRRefreshView" ,owner: self, options: nil) as Array
//        self.refreshView = arr[0] as? YRRefreshView
//        self.refreshView!.delegate = self
//        
//        self.tableView!.tableFooterView = self.refreshView
        
    }
    
    func loadData()
    {
        var url = FileUtility.getUrlDomain() + "comment/getCommentByPostId?postId=\(jokeId)"
//        self.refreshView!.startLoading()
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                UIView.showAlertView("WARNING",message:"Network error!")
                return
            }
            
            var arr = data["data"] as NSArray
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
        
        //var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? YRJokeCell
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as YRCommnentsCell
        var index = indexPath.row
        var data = self.dataArray[index] as NSDictionary
        cell.data = data
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
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
    
    
    func refreshCommentView(refreshView:YRSendComment,didClickButton btn:UIButton){
        loadData()
        var width = self.view.frame.size.width
        var height = self.view.frame.size.height
        self.sendView?.frame = CGRectMake(0, height - 50 , width, 50)
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
