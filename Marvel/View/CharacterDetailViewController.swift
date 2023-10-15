//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Luis Sergio Duran Arenas on 15/10/23.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet var ivThumbnail: UIImageView!
    
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblDescription: UILabel!
    
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.text = character?.name
        
        lblDescription.text = character?.description
        
        //Image implementation pending
        let urlThumbnail = URL(string: (character?.thumbnail.url)!)
        ivThumbnail.sd_setImage(with: urlThumbnail)
        /*
        DispatchQueue.global().async {
            if let url = URL(string: character?.thumbnail){
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.ivThumbnail.image = UIImage(data: data!)
                }
            }
        }
         */
        
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

extension CharacterDetailViewController:  UITableViewDelegate,  UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return character?.urls.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell", for: indexPath)
        
        cell.textLabel?.text = character?.urls[indexPath.row].type
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: character!.urls[indexPath.row].url) {
            UIApplication.shared.open(url)
        }
    }
    
}
