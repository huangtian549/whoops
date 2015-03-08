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
    var _db = ["Johns Hopkins University", "George Washington University", "GeorgeTown University", "American University", "New York University"]
    var filteredTableData = [String]()
    var myFavorite = ["Johns Hopkins University", "George Washington University"]
    var nearby = ["GeorgeTown University"]
    var resultSearchController = UISearchController()

    
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
            cell.title.text = self.filteredTableData[row]
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
                cell.title.text = self.myFavorite[row]
                cell.isHighLighted = true
                cell.backgroundView = nil
                cell.backgroundColor = UIColor.clearColor()
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.likeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)

                return cell
            }
            
            if indexPath.section == 1
            {
                cell.title.text = self.nearby[row]
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
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredTableData.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        let array = (_db as NSArray).filteredArrayUsingPredicate(searchPredicate!)
        filteredTableData = array as [String]
        self.searchTableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var university = segue.destinationViewController as UniversityViewController
        if let indexPath = self.searchTableView.indexPathForSelectedRow() {
            if self.resultSearchController.active
            {
                let selectedUniversity = self.filteredTableData[indexPath.row]
                university.currentUniversity = selectedUniversity
                //self.resultSearchController.resignFirstResponder()
            }
            else
            {
                if indexPath.section == 0{
                    let selectedUniversity = self.myFavorite[indexPath.row]
                    university.currentUniversity = selectedUniversity
                    //  self.resultSearchController.resignFirstResponder()
                }
                if indexPath.section == 1{
                    let selectedUniversity = self.nearby[indexPath.row]
                    university.currentUniversity = selectedUniversity
                    //  self.resultSearchController.resignFirstResponder()
                }
            }
        }
    }


}
