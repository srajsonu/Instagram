//
//  HomeViewController.swift
//  Instagram
//
//  Created by ARY@N on 29/04/19.
//  Copyright © 2019 ARYAN. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ImagePicker

class HomeViewController: UIViewController {
    
    var posts = [Posts]()

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadPosts()
    }
    func loadPosts(){
        Database.database().reference().child("Posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            print(Thread.isMainThread)
            if let dict = snapshot.value as? [String: Any]{
                let captionText = dict["caption"] as! String
                //let postText = dict["postURL"] as! String
                let post = Posts(caption: captionText)
                self.posts.append(post)
                print(self.posts)
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func logOutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let logoutError{
            print(logoutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signinVC = storyboard.instantiateViewController(withIdentifier: "SigninViewController")
        self.present(signinVC, animated: true, completion: nil)
    }
}
extension HomeViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
    
}
