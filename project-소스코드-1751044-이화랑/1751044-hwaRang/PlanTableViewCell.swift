//
//  PlanTableViewCell.swift
//  ch12-1751044-storePlan
//
//  Created by mac036 on 2022/06/09.
//

import UIKit

class PlanTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        if selected {
//            contentView.layer.borderWidth = 2
//            contentView.layer.borderColor = UIColor.blue.cgColor
//        } else {
//            contentView.layer.borderWidth = 1
//            contentView.layer.borderColor = UIColor.lightGray.cgColor
//        }
    }
    override func layoutSubviews() {
        
         super.layoutSubviews()

        date.font = UIFont(name: "NanumSquare_acL", size: 20)
        name.font = UIFont(name: "NanumSquare_acL", size: 17)
        comment.font = UIFont(name: "NanumSquare_acL", size: 15)
        
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        //        contentView.layer.backgroundColor = CGColor(red: 193/255, green: 220/255, blue: 228/255, alpha: 1)
        contentView.layer.borderColor =  CGColor(red: 47/255, green: 72/255, blue: 225/255, alpha: 1)
//        contentView.layer.backgroundColor =  CGColor(red: 193/255, green: 217/255, blue: 254/255, alpha: 1)
       
//
        // 테이블 뷰 셀 사이의 간격
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    
        
     }
    
    
}
