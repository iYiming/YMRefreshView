//
//  ViewController.swift
//  RefreshView
//
//  Created by Yiming on 15/7/18.
//  Copyright (c) 2015年 Yiming. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var dataArray:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingUI()//设置界面
        
        for i in 0...100 {
            dataArray.append(i)
        }
    }
    
    // MARK: 自定义方法
    
    /**
     设置界面
     */
    func settingUI() {
        tableView.headerView = YMRefreshView.refreshWithBlock({
            //测试用
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(2 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.dataArray.append(self.dataArray.count)
                
                self.tableView.reloadData()
                self.tableView.headerView?.stopRefresh();
            }
        })
    }
    
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let index = dataArray.count - 1 - indexPath.row
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell.textLabel?.text = "\(dataArray[index])"
        
        return cell
    }
}

