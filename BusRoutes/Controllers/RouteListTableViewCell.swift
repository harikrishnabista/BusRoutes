//
//  RouteListTableViewCell.swift
//  BusRoutes
//
//  Created by Hari Krishna Bista on 1/30/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class RouteListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgRoute: UIImageView!
    @IBOutlet weak var lblRouteName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
