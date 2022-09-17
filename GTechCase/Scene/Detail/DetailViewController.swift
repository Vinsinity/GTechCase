//
//  DetailViewController.swift
//  GTechCase
//
//  Created by Erhan on 15.09.2022.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailArtistName: UILabel!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailPrice: UILabel!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var viewArtistButton: UIButton!
    @IBOutlet weak var viewCollectionButton: UIButton!
    
    var viewModel: DetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
    }
    
    func setupDetail(item: SearchResponse) {
        let dummyText = "This not found this is dummy text from viewcontroller"
        self.detailImage.kf.setImage(with: URL(string: item.artworkUrl100 ?? ""))
        self.detailTitle.text = item.collectionName ?? dummyText
        self.detailArtistName.text = item.artistName ?? dummyText
        self.detailPrice.text = (item.currency ?? "$") + " " + (String(describing: item.collectionPrice ?? 0.00))
        self.detailDate.text = item.releaseDate?.formattedDate(format: "yyyy-MM-dd'T'HH:mm:ssZ")
    } 
}

extension DetailViewController: DetailViewModelDelegate {
    func handleViewModelOutput(_ output: DetailViewModelOutput) {
        switch output {
        case .updateTitle(let title):
            self.title = title
        case .showDetail(let item): 
            self.setupDetail(item: item)
        }
    }
}
