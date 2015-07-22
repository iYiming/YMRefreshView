//
//  ViewController.swift
//  RefreshView
//
//  Created by Yiming on 15/7/18.
//  Copyright (c) 2015年 Yiming. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var dataArray:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        settingUI()//设置界面
        
        for i in 0...100{
            dataArray.append(i)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 自定义方法
    
    /**
    设置界面
    */
    func settingUI(){
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        
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
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        let index = dataArray.count - 1 - indexPath.row
        
        cell.textLabel?.text = "\(dataArray[index])"
        
        return cell
    }
    
    
    
    

}

