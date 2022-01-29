//
//  ForumViewController.swift
//  QRTrainerTruckAdminApp
//
//  Created by Koplányi Dávid on 2021. 11. 14..
//

import UIKit

class ForumViewController: UITableViewController {

    private var posts = [PostModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
    }
    
    func getData() {
        MyFirebase.db.collection("posts").addSnapshotListener { querySnapshot, error in
        guard let documents = querySnapshot?.documents else {
            print("NO documents")
            return
        }
            
            let tempPosts = documents.compactMap({ queryDocumentSnapshot -> PostModel? in
                return try? queryDocumentSnapshot.data(as: PostModel.self)
            })
            self.posts = tempPosts.sorted(by: { lPost, rPost in
                return lPost.sorter > rPost.sorter
            })
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(posts.count)
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCellModel
        
        let post = posts[indexPath.row]
        
        cell.profilePictureImageView.layer.masksToBounds = true
        cell.profilePictureImageView.layer.cornerRadius = cell.profilePictureImageView.frame.width / 2
        
        cell.authorName.text = post.authorName
        cell.postTitle.text = post.title
        cell.postDescription.text = post.description
        insertImageViaUrl(to: cell.postImageView, url: post.imageUrl)
        MyFirebase.getImageUrl(imagePath: "profile_pictures/\(post.authorId)") { result in
            switch result {
            case .success(let url):
                self.insertImageViaUrl(to: cell.profilePictureImageView, url: url)
            case .failure(let error):
                print("ERROR getting profpic url Forum: \(error.localizedDescription)")
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        buildPostDeleteDialog(postId: String(post.sorter), authorId: post.authorId)
    }
    
    func buildPostDeleteDialog(postId: String, authorId: String) {
        let dialog = UIAlertController(title: "Poszt törlése", message: "Biztosan törölni szeretnéd a posztot?", preferredStyle: .alert)
        
        dialog.addAction(UIAlertAction(title: "Törlés", style: .default, handler: { _ in
            MyFirebase.deleteDocument(collection: "posts", document: postId)
            MyFirebase.deleteDataFromStorage(path: "postimages/\(authorId)_\(postId).jpg")
            dialog.dismiss(animated: true, completion: nil)
        }))
        
        dialog.addAction(UIAlertAction(title: "Mégse", style: .default, handler: { _ in
            dialog.dismiss(animated: true, completion: nil)
        }))
        
        self.present(dialog, animated: true)
    }
    
    func insertImageViaUrl(to imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }.resume()
    }
    
}
