//
//  AddNewTrainingViewController.swift
//  QRTrainerTruckAdminApp
//
//  Created by Koplányi Dávid on 2021. 11. 11..
//

import UIKit

class AddNewTrainingViewController: UIViewController {

    @IBOutlet weak var trainingTitle: UITextField!
    @IBOutlet weak var trainingTrainer: UITextField!
    @IBOutlet weak var trainingDatePicker: UIDatePicker!
    @IBOutlet weak var trainingLocation: UITextField!
    @IBAction func uploadNewTraining(_ sender: Any) {
        uploadTraining()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func uploadTraining() {
        let sorterFormatter = DateFormatter()
        sorterFormatter.dateFormat = "yyyyMMddHHmm"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd(EEEE) HH:mm"
        dateFormatter.locale = Locale(identifier: "hu")
        
        let training: [String : Any] = [
            "title" : trainingTitle.text! as String,
            "trainer" : trainingTrainer.text! as String,
            "location" : trainingLocation.text! as String,
            "date" : dateFormatter.string(from: trainingDatePicker.date),
            "sorter" : UInt64(sorterFormatter.string(from: trainingDatePicker.date))! as UInt64,
            "trainees" : Array<String>() as Array<String>
        ]
        
        MyFirebase.uploadDataToCollectionDocument(collection: "trainings", document: sorterFormatter.string(from: trainingDatePicker.date), data: training)
    }
    
}
