//
//  TrainingCellModel.swift
//  QRTrainerTruckAdminApp
//
//  Created by Koplányi Dávid on 2021. 11. 11..
//

import UIKit

class TrainingCellModel: UITableViewCell {
    @IBOutlet weak var trainingTitle: UILabel!
    @IBOutlet weak var trainingTrainer: UILabel!
    @IBOutlet weak var trainingDate: UILabel!
    @IBOutlet weak var trainingLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
