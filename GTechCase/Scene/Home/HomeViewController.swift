//
//  HomeViewController.swift
//  GTechCase
//
//  Created by Erhan on 14.09.2022.
//

import UIKit
import Foundation
import Kingfisher

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField! {
        didSet {
            searchField.delegate = self
        }
    }
    @IBOutlet weak var moviesButton: FilterButton! {
        didSet {
            moviesButton.setFilterType(filterType: .movie)
            moviesButton.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var musicsButton: FilterButton! {
        didSet {
            musicsButton.setFilterType(filterType: .music)
            musicsButton.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var ebooksButton: FilterButton! {
        didSet {
            ebooksButton.setFilterType(filterType: .ebook)
            ebooksButton.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var podcastsButton: FilterButton! {
        didSet {
            podcastsButton.setFilterType(filterType: .podcast)
            podcastsButton.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homeTableViewCell")
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: HomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    var list: [SearchResponse] = []
    var buttonList: [FilterButton] = []
    var filterType: FilterType!

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonList = [moviesButton,musicsButton,ebooksButton,podcastsButton]
        selectButton(moviesButton)
        viewModel.load()
    }
    
    @objc func selectButton(_ sender: FilterButton) {
        if sender.filterType == filterType {
            return
        }
        for button in buttonList {
            if button == sender {
                filterType = sender.getFilterType()
                sender.backgroundColor = UIColor.darkGray
            }else{
                button.backgroundColor = UIColor.lightGray
            }
        }
        if searchField.text!.count > 2 {
            viewModel.searchRequest(parameter: searchField.text!, media: filterType.filterString())
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    
    func handleHomeViewModelOutput(_ output: HomeViewModelOutput) {
        switch output {
        case .setLoading(let isLoading):
            self.activityIndicator.isHidden = !isLoading
        case .setError(let error):
            print("error from viewmodel: \(error)")
        case .setTitle(let title):
            self.title = title
        case .showList(let list):
            self.list = list
            self.tableView.reloadData()
        }
    }
    
    func navigate(route: HomeViewModelRoute) {
        switch route {
        case .showDetail(let detailViewModelProtocol):
            let viewController = DetailBuilder.make(viewModel: detailViewModelProtocol)
            show(viewController, sender: nil)
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count > 1 {
            viewModel.searchRequest(parameter: textField.text!, media: filterType.filterString())
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { 
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.selectItem(at: indexPath.row)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell", for: indexPath) as! HomeTableViewCell
        let item = list[indexPath.row]
        cell.cellImage.kf.setImage(with: URL(string: item.artworkUrl100 ?? "")) 
        cell.cellTitle.text = item.collectionName ?? item.trackName
        cell.cellPrice.text = item.currency! + " " + String(describing: item.collectionPrice ?? item.trackPrice ?? 0.00)
        cell.cellDate.text = item.releaseDate?.formattedDate(format: "yyyy-MM-dd'T'HH:mm:ssZ")
        return cell
    }
} 

enum FilterType: String {
    case movie
    case music
    case ebook
    case podcast
    
    func filterString()-> String {
        switch self {
        case .movie:
            return "movie"
        case .music:
            return "music"
        case .ebook:
            return "ebook"
        case .podcast:
            return "podcast"
        }
    }
}
