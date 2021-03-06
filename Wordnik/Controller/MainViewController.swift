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
   
    //MARK: - UI Elements -
    
    lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    lazy var initialView : InitialView = {
        let initialView = InitialView()
        return initialView
    }()
    
    lazy var definition: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = Constants.specialPurple
        label.numberOfLines = 0
        return label
    }()
    
    lazy var pronunciation: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = Constants.specialPurple
        label.numberOfLines = 0
        return label
    }()
    
    lazy var voiceButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.voice, for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(voiceButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var synonimsAndAntonymsLabel: UILabel = {
        let label = UILabel()
        label.text = "Synonims and Antonyms"
        label.font = .boldSystemFont(ofSize: 16)
        label.alpha = 0
        label.textColor = Constants.specialPurple
        return label
    }()
    
    lazy var synonimsView: SynonimsView = {
        let view = SynonimsView()
        view.data = DataSingleton.sharedInstance.synonims
        return view
    }()
    
    lazy var antonymsView: AntonymsView = {
        let view = AntonymsView()
        return view
    }()
   
    //MARK: - Variables -
    
    var data = [String]()
    let provider = MoyaProvider<APIService>()
    var searchText: String = ""
    
    //MARK: - ViewDidLoad -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        searchBar.delegate = self
        setupViews()
        setNavigationBar()
    }
   
    //MARK: - Functions -
    
    private func setNavigationBar(){
        navigationController?.navigationBar.barTintColor = Constants.specialYellow
        navigationItem.title = "Wordnik"
        let textAttributes = [NSAttributedString.Key.foregroundColor:Constants.specialPurple]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    @objc func voiceButtonPressed(){
        let utterance = AVSpeechUtterance(string: searchText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Setup views -
    
    private func setupViews(){
        [searchBar, definition, pronunciation, voiceButton, definition, synonimsAndAntonymsLabel, initialView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        initialView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        initialView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        initialView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        initialView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        pronunciation.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20).isActive = true
        pronunciation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        voiceButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 17).isActive = true
        voiceButton.leadingAnchor.constraint(equalTo: pronunciation.trailingAnchor, constant: 10).isActive = true
        voiceButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        voiceButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        definition.topAnchor.constraint(equalTo: pronunciation.bottomAnchor, constant: 10).isActive = true
        definition.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        definition.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        definition.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        synonimsAndAntonymsLabel.topAnchor.constraint(equalTo: definition.bottomAnchor, constant: 10).isActive = true
        synonimsAndAntonymsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    }
    private func setupViewsForSynonims(){
        self.view.addSubview(synonimsView)
        synonimsView.translatesAutoresizingMaskIntoConstraints = false
        
        synonimsView.topAnchor.constraint(equalTo: synonimsAndAntonymsLabel.bottomAnchor, constant: 10).isActive = true
        synonimsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        synonimsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        synonimsView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func setupViewsForAntonyms(){
        self.view.addSubview(antonymsView)
        antonymsView.translatesAutoresizingMaskIntoConstraints = false
        
        antonymsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        antonymsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        antonymsView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        antonymsView.topAnchor.constraint(equalTo: synonimsAndAntonymsLabel.bottomAnchor, constant: 150).isActive = true
    }
    
    //MARK: - Networking -
    
    private func getSynonims(_ text: String){
        provider.request(.getSynonims(text: text)) { [weak self] result in
            switch result{
            case .success(let response):
                do {
                    let wordnikResponse = try JSONDecoder().decode([SynonymResponse].self, from: response.data)
                    guard let synonims = wordnikResponse.first else { return }
                    
                    self?.data = synonims.words
                    DataSingleton.sharedInstance.synonims = synonims.words
                    DispatchQueue.main.async {
                        self?.setupViewsForSynonims()
                    }
                } catch let error {
                    print("Error in parsing: \(error)")
                }
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
            }
        }
        
    }
    private func getAntonyms(_ text: String){
        provider.request(.getAntonym(text: text)) { [weak self] result in
            switch result{
            case .success(let response):
                do {
                    let antonymResponse = try JSONDecoder().decode([AntonymResponse].self, from: response.data)
                    guard let antonyms = antonymResponse.first else { return }
                    
                    self?.data = antonyms.words
                    DataSingleton.sharedInstance.antonyms = antonyms.words
                    DispatchQueue.main.async {
                        self?.setupViewsForAntonyms()
                    }
                    
                } catch let error {
                    print("Error in parsing: \(error)")
                }
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
            }
        }
        
    }
    
    private func getDefinitions(_ text: String){
        provider.request(.getDefinitions(text: text)) { [weak self] result in
            switch result{
            case .success(let response):
                do {
                    let responseDefinition = try JSONDecoder().decode([DefinitionResponse].self, from: response.data)
                    guard let definition = responseDefinition.first else { return }
                    
                    self?.definition.text = definition.text
                    
                } catch let error {
                    print("Error in parsing: \(error)")
                }
            case .failure(let error):
                let requestError = (error as NSError)
                print("Request Error message: \(error.localizedDescription), code: \(requestError.code)")
            }
        }
    }
    private func getPronunciations(_ text: String){
        provider.request(.getPronunciations(text: text)) { [weak self] result in
            switch result{
            case .success(let response):
                do {
                    let responsePronunciation = try JSONDecoder().decode([PronunciationResponse].self, from: response.data)
                    guard let pronunciation = responsePronunciation.first else { return }
                    
                    self?.pronunciation.text = pronunciation.raw
                    self?.voiceButton.alpha = 1
                    self?.synonimsAndAntonymsLabel.alpha = 1
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

//MARK: - Extensions -

extension MainViewController: UISearchBarDelegate{
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.initialView.alpha = 0
        guard let searchText = searchBar.text else { return }
        self.searchText = searchText
        self.getAntonyms(searchText.lowercased())
        self.getSynonims(searchText.lowercased())
        self.getDefinitions(searchText.lowercased())
        self.getPronunciations(searchText.lowercased())
        self.searchBar.endEditing(true)
    }
}
