//
//  SearchViewController.swift
//  Whoops
//
//  Created by Li Jiatan on 3/5/15.
//  Copyright (c) 2015 Li Jiatan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating{

    @IBOutlet weak var searchTableView: UITableView!
    //var _db = ["Johns Hopkins University", "George Washington University", "GeorgeTown University", "American University", "New York University"]
    //var filteredTableData = [String]()
    var _db = NSMutableArray()
    var filteredTableData = []
    var myFavorite = NSMutableArray()
    //var myFavorite = ["Johns Hopkins University", "George Washington University"]
    //var nearby = ["GeorgeTown University"]
    var nearby = NSMutableArray()
    var resultSearchController = UISearchController()

    let dbUrl = "http://104.131.91.181:8080/whoops/school/getAll"
    let nearbyUrl = "http://104.131.91.181:8080/whoops/school/listSchoolByLocation?latitude=37.9&longitude=-122.4"
    let myFavoriteUrl = "http://104.131.91.181:8080/whoops/favorSchool/listByUid?uid=1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search your School"
            self.searchTableView.tableHeaderView = controller.searchBar
            return controller
        })()
        self.searchTableView.reloadData()
        loadDB(nearbyUrl, target: nearby)
        loadDB(dbUrl, target: _db)
        loadDB(myFavoriteUrl, target: myFavorite)
    }
    
    func loadDB(var url:String, var target: NSMutableArray)
    {
        //var url = "http://104.131.91.181:8080/whoops/school/getAll"
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                let myAltert=UIAlertController(title: "Alert", message: "No Network Access", preferredStyle: UIAlertControllerStyle.Alert)
                myAltert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(myAltert, animated: true, completion: nil)
                return
            }
            
            var arr = data["data"] as NSArray
            
            for data : AnyObject  in arr
            {
                target.addObject(data)
            }
            self.searchTableView.reloadData()
            // self.refreshView!.stopLoading()
            //self.page++
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.resultSearchController.active
        {
            return 1
        }else
        {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.resultSearchController.active
        {
            return self.filteredTableData.count
        }
        else
        {
            switch (section){
            case 0: return self.myFavorite.count
            case 1: return self.nearby.count
            default: return 0
            }
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headCell = tableView.dequeueReusableCellWithIdentifier("headCell") as SearchHeadCell
        headCell.backgroundView = nil
        
        if self.resultSearchController.active
        {
            return headCell
        }
        else
        {
            switch (section){
            case 0: headCell.header.text = "My Favorite"
            case 1: headCell.header.text = "Nearby"
            default: headCell.header.text = nil
            }
            
            switch (section){
            case 0: headCell.headImg.image = UIImage(named: "unlike")
            case 1: headCell.headImg.image = UIImage(named: "Nearby")
            default: headCell.headImg.image = nil
            }
        }
        return headCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  self.resultSearchController.active {return 0}
        else { return 50}
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("searchResult") as SearchResultCell
        var row = indexPath.row
        cell.currentIndex = indexPath.row
        
        if self.resultSearchController.active
        {
            var data = self.filteredTableData[row] as NSDictionary
            cell.title.text = data.stringAttributeForKey("nameEn")
            //cell.title.text = self.filteredTableData[row]
            cell.data = data
            
            cell.isHighLighted = false
            cell.backgroundView = nil
            cell.backgroundColor = UIColor.clearColor()
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.likeButton.setImage(UIImage(named: "115"), forState: UIControlState.Normal)
            return cell
        }
        else
        {
            if indexPath.section == 0
            {
                cell.favorite = self.myFavorite
                //cell.title.text = self.myFavorite[row]
                var data = self.myFavorite[row] as NSDictionary
                cell.title.text = data.stringAttributeForKey("nameEn")
                cell.data = data
                
                cell.isHighLighted = true
                cell.backgroundView = nil
                cell.backgroundColor = UIColor.clearColor()
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.likeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)

                return cell
            }
            
            if indexPath.section == 1
            {
                //cell.title.text = self.nearby[row]
                var data = self.nearby[row] as NSDictionary
                cell.title.text = data.stringAttributeForKey("nameEn")
                cell.data = data
                
                cell.isHighLighted = false
                cell.backgroundView = nil
                cell.backgroundColor = UIColor.clearColor()
                //cell.tailImg.image = UIImage(named: "115")
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.likeButton.setImage(UIImage(named: "115"), forState: UIControlState.Normal)
                return cell
            }
        }
        //cell.textLabel?.text = "Search Result"
        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        //filteredTableData.removeAll(keepCapacity: false)
        //filteredTableData.removeAllObjects()
        
        let searchPredicate = NSPredicate(format: "nameEn contains[cd] %@", searchController.searchBar.text)
        
        //let array = (_db as NSArray).filteredArrayUsingPredicate(searchPredicate!)
        let array = _db.filteredArrayUsingPredicate(searchPredicate!)
        filteredTableData = array
        
        self.searchTableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var university = segue.destinationViewController as UniversityViewController
        if let indexPath = self.searchTableView.indexPathForSelectedRow() {
            if self.resultSearchController.active
            {
                var data = self.filteredTableData[indexPath.row] as NSDictionary
                //let selectedUniversity = self.filteredTableData[indexPath.row]
                let selectedUniversity = data.stringAttributeForKey("nameEn")
                
                university.currentUniversity = selectedUniversity
                self.resultSearchController.resignFirstResponder()
                //self.searchDisplayController?.searchBar.resignFirstResponder()
                
            }
            else
            {
                if indexPath.section == 0{
                    //let selectedUniversity = self.myFavorite[indexPath.row]
                    var data = self.myFavorite[indexPath.row] as NSDictionary
                    let selectedUniversity = data.stringAttributeForKey("nameEn")
                    
                    university.currentUniversity = selectedUniversity
                    //  self.resultSearchController.resignFirstResponder()
                }
                if indexPath.section == 1{
                    //let selectedUniversity = self.nearby[indexPath.row]
                    var data = self.nearby[indexPath.row] as NSDictionary
                    let selectedUniversity = data.stringAttributeForKey("nameEn")
                    
                    university.currentUniversity = selectedUniversity
                    
                    //  self.resultSearchController.resignFirstResponder()
                }
            }
        }
    }


}
