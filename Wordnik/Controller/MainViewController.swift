//
//  MainViewController.swift
//  WordnikMVCApp
//
//  Created by Korlan Omarova on 12.02.2021.
//

import UIKit
import Moya
import AVFoundation

class MainViewController: UIViewController {
    
    lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    var cardView = CardView()
        
    lazy var collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(SynonimsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var data = [String]()
    let provider = MoyaProvider<APIService>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        searchBar.delegate = self
        setupViews()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let button = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(recognizeCards))
        self.navigationItem.rightBarButtonItem  = button
    }
   
    @objc func recognizeCards(){
        DataSynonims.sharedInstance.arr = data
        let cardsViewController = CardsViewController()
        self.navigationController?.pushViewController(cardsViewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        collectionView.endEditing(true)
    }
    private func setupViews(){
        [searchBar, collectionView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    
        
    }
    //MARK: - Networking -
    
    private func getSynonims(_ text: String){
        provider.request(.getSynonims(text: text)) { [weak self] result in
            switch result{
            case .success(let response):
                do {
                    let wordnikResponse = try JSONDecoder().decode([WordnikRespons].self, from: response.data)
                    guard let synonims = wordnikResponse.first else { return }
                    
                    self?.data = synonims.words
                    self?.collectionView.reloadData()
                    
                } catch let error {
                    print("Error in parsing: \(error)")
                }
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
            }
        }
        
    }
    
}

extension MainViewController: UISearchBarDelegate{
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }

        self.getSynonims(searchText.lowercased())
        self.searchBar.endEditing(true)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SynonimsCollectionViewCell
        
        cell.textLabel.text = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        
        let utterance = AVSpeechUtterance(string: data[indexPath.row])
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }

}
class DataSynonims {
    static let sharedInstance = DataSynonims()
    var arr = [String]()
}
