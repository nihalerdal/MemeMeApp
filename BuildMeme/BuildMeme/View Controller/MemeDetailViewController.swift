//
//  MemeDetailViewController.swift
//  BuildMeme
//
//  Created by Nihal Erdal on 2/27/21.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme : Meme?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        

        // Do any additional setup after loading the view.
    }
    
    func updateView(){
        
        guard let meme = meme else {return}
        imageView.image = meme.memed
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
