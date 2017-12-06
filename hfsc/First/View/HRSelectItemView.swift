//
//  HRSelectItemView.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
protocol HRSelectItemViewDelegate:NSObjectProtocol {
    func selectItem(index:Int)
}
class HRSelectItemView: UIView,UITableViewDelegate,UITableViewDataSource {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private var itemArr:[String] = []
    weak var delegate:HRSelectItemViewDelegate!
    lazy private var mainTV:UITableView = {
        let tempTV = UITableView(frame: HR_FULL_FRAME, style: .plain)
        tempTV.delegate = self
        tempTV.dataSource = self
        tempTV.showsHorizontalScrollIndicator = false
        tempTV.tableFooterView = UIView(frame: CGRect.zero)
        tempTV.backgroundColor = HR_WHITE_COLOR
        tempTV.separatorColor = HR_LINE_COLOR
        tempTV.separatorInset = UIEdgeInsetsMake(0, HR_MARGIN, 0, 0)
        tempTV.backgroundColor = HR_BG_COLOR
        return tempTV
    }()
    let cellH:CGFloat = 40
    
    //MARK:单例
//    static let shared = HRSelectItemView.init()
    override init(frame: CGRect) {
        super.init(frame:CGRect(x: 0, y: HR_TOP_HEIGHT+HR_HEADER_HEIGHT, width: HR_SCREEN_WIDTH, height: HR_SCREEN_HEIGHT-HR_TOP_HEIGHT-HR_HEADER_HEIGHT))
        self.backgroundColor = HR_BLACK_COLOR.withAlphaComponent(0.3)
        self.addSubview(self.mainTV)
        self.mainTV.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(cellH*CGFloat(6))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItems(itemArr:[String]){
        self.itemArr = itemArr
        if self.itemArr.count < 6 {
            self.mainTV.snp.updateConstraints({ (make) in
                make.height.equalTo(cellH*CGFloat(self.itemArr.count))
            })
        }else{
            self.mainTV.snp.updateConstraints({ (make) in
                make.height.equalTo(cellH*CGFloat(6))
            })
        }
        self.mainTV.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        }
        tableView.rowHeight = cellH
        if self.itemArr.count > indexPath.row {
            cell?.textLabel?.text = self.itemArr[indexPath.row]
            cell?.textLabel?.textColor = HR_BLACK_COLOR
            cell?.textLabel?.font = HR_NORMAL_FONT
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.delegate != nil {
            self.delegate.selectItem(index: indexPath.row)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isHidden = true
        if self.delegate != nil {
            self.delegate.selectItem(index: -1)
        }
    }
    
}
