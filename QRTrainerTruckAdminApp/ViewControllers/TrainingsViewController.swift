//
//  TrainingsViewController.swift
//  QRTrainerTruckAdminApp
//
//  Created by Koplányi Dávid on 2021. 11. 11..
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class TrainingsViewController: UITableViewController {

    private var sortedTrainings = [TrainingModel]()
    private var users = [UserModel]()
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
    }
    
    func getData() {
        let db = Firestore.firestore()
        //userek
        db.collection("users").addSnapshotListener { querySnapshot, error in
        guard let documents = querySnapshot?.documents else {
            print("NO documents")
            return
        }
            
            self.users = documents.compactMap({ queryDocumentSnapshot -> UserModel? in
                return try? queryDocumentSnapshot.data(as: UserModel.self)
            })
             
        }
        
        //edzesek
        db.collection("trainings").addSnapshotListener { querySnapshot, error in
        guard let documents = querySnapshot?.documents else {
            print("NO documents")
            return
        }
            
            let trainings = documents.compactMap({ queryDocumentSnapshot -> TrainingModel? in
                return try? queryDocumentSnapshot.data(as: TrainingModel.self)
            })
            self.sortedTrainings = trainings.sorted { lTraining, rTraining in
                return lTraining.sorter < rTraining.sorter
            }
            self.tableView.reloadData()
             
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTrainings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainingCell", for: indexPath) as! TrainingCellModel
        
        let training = sortedTrainings[indexPath.row]
        
        cell.trainingTitle.text = training.title
        cell.trainingTrainer.text = training.trainer
        cell.trainingDate.text = training.date
        cell.trainingLocation.text = training.location
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let training = sortedTrainings[indexPath.row]
        
        var traineesDatas = ""
        
        if training.trainees.isEmpty == false {
            
            for traineeID in training.trainees {
                for u in users {
                    if u.id == traineeID {
                        traineesDatas.append("\(u.name)\n\(u.rank)\n\(u.mobile)\n")
                    }
                }
            }
        }
        traineesAlertDialogBuilder(title: "Kliensek", message: traineesDatas, training: training)
    }
    
    private func traineesAlertDialogBuilder(title: String, message: String, training: TrainingModel) {
        
        let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        dialog.addAction(UIAlertAction(title: "Óra törlése", style: .default, handler: { action in
            Firestore.firestore().collection("trainings").document(String(training.sorter)).delete()
            //user trainingsbol is torolni az edzest
            let dataToRemove: NSDictionary = [
                "date" : training.date,
                "location" : training.location,
                "sorter" : training.sorter
            ]
            
            for traineeId in training.trainees {
                for u in self.users {
                    if u.id == traineeId {
                        Firestore.firestore().collection("users").document(u.id).updateData(["trainings" : FieldValue.arrayRemove([dataToRemove])])
                    }
                }
            }
        }))
        
        dialog.addAction(UIAlertAction(title: "Bezár", style: .default, handler: { action in
            dialog.dismiss(animated: true, completion: nil)
        }))
        
        self.present(dialog, animated: true, completion: nil)
    }

}
