//
//  SentMemesViewController.swift
//  BuildMeme
//
//  Created by Nihal Erdal on 2/26/21.
//

import UIKit

class SentMemesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as! MemeTableViewCell 
        let memeForRow = memes[indexPath.row]
        cell.imageView?.image = memeForRow.memed
        cell.textLabel?.text = memeForRow.textTop + "..." + memeForRow.textBottom
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "MemeDetailViewController") as? MemeDetailViewController else {return}
        guard let meme = meme else {return}
        vc.imageView.image = meme.memed
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailRowSegue"{
            if let vc = segue.destination as? MemeDetailViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                
                let meme = memes[indexPath.row]
                vc.meme = meme
            }
        }
     }
     
    
}
