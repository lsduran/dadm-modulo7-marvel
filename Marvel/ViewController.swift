//
//  ViewController.swift
//  Marvel
//
//  Created by Luis Sergio Duran Arenas on 30/09/23.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    let myKeys = KeyLoader.shared
    let characterService = CharacterService()
    
    @IBOutlet var characterCollectionView: UICollectionView!
    
    @IBOutlet weak var btnCopyright: UIButton!
    
    private var attributedHtml: String?
    
    private var url: URL?
    
    private var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        characterCollectionView.dataSource = self
        characterCollectionView.delegate = self
                
        characterService.loadCharactersData(queryString: myKeys.getQueryString(limit: Constants.numberOfItemsRequested, offset: 0)) { response in
            print("qs: ", self.myKeys.getQueryString())
            DispatchQueue.main.async {
                self.attributedHtml = response?.attributionHTML
                self.btnCopyright.setTitle(response?.attributionText, for: .normal)
                self.characterService.offset = self.characterService.countCharacter()
                self.characterCollectionView.reloadData()
            }
        }
    }

    @IBAction func openURL(_ sender: UIButton) {
        // Solución de https://stackoverflow.com/a/31725839
        if let match = attributedHtml?.range(of: "(?<=\")[^\"]+", options: .regularExpression) {
            if let url = URL(string: (attributedHtml?.substring(with: match))!) {
                UIApplication.shared.open(url)
            }
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterService.countCharacter()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! CharacterCell
        
        cell.lblCharacterName.text = characterService.getCharacter(at: indexPath.row).name
        //Image implementation pending
        let urlThumbnail = URL(string: characterService.getCharacter(at: indexPath.row).thumbnail.url)
        cell.imgCharacter.sd_setImage(with: urlThumbnail)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.character = characterService.getCharacter(at: indexPath.row)
        performSegue(withIdentifier: "showDetailSegue", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            let destination = segue.destination as! CharacterDetailViewController
            destination.character = self.character
        }
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // size of scrollview content
        //print("contentSize.height", scrollView.contentSize.height)
        // screen's available space for scrollview element
        //print("bounds.height:", scrollView.bounds.height)
        // how much the content inside the scroll view has been scrolled vertically
        //print("contentOffset y:", scrollView.contentOffset.y)
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollviewHeight = scrollView.bounds.height
        
        if (offsetY > (contentHeight - scrollviewHeight)) && (!characterService.maxItemsLoaded && !characterService.isLoading ) {
            print("calling API...")
            self.characterService.isLoading = true
            let queryString = myKeys.getQueryString(limit: Constants.numberOfItemsRequested, offset: self.characterService.offset)
            
            self.characterService.loadCharactersData(queryString: queryString){_ in 
                DispatchQueue.main.async {
                    self.characterCollectionView.reloadData()
                    self.characterService.offset = self.characterService.countCharacter()
                    self.characterService.isLoading = false
                }
            }
        }
        else{
            print("Don't call API...")
        }
    }
}
