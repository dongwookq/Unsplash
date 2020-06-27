//
//  TestCollectionViewController.swift
//  unsplash
//
//  Created by Dong-Wook Han on 2020/06/26.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import UIKit
import Alamofire

class ListPhotosViewController: UICollectionViewController {
    
    // MARK: - Properties
    struct Dependency {
      let unsplashService: UnsplashServiceProtocol!
    }
    var dependency: Dependency!
    
    let searchController = UISearchController(searchResultsController: nil)
    let closeButton = UIButton(type: .system)

    private var currentListRequest: DataRequest?
    private var photos: [PhotoListResult] = []
    private var currentIndex: Int = 0
    private var currentSearchRequest: DataRequest?
    private var searchs: [Results] = []
    var currentSceenType: SceenType = .list
    var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.autocapitalizationType = .none
        
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false

        self.closeButton.frame = CGRect(x: 20, y: 20, width: 100, height: 50)
        self.closeButton.setTitle("Close", for: .normal)
        self.closeButton.addTarget(self, action: #selector(closeAction(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        self.closeButton.isHidden = true
        
        self.requestList()
    }
    
}

// MARK: - Private Methods
extension ListPhotosViewController {
    
    private func configureCell(_ cell: ListPhotosViewCell,
                               collectionView: UICollectionView,
                               indexPath: IndexPath) {
        
        guard indexPath.row < self.photos.count else { return }
        
        
        var imgUrlString: String = ""
        switch self.currentSceenType {
        case .list:
            imgUrlString = (self.photos[indexPath.row].urls?.regular)!
        case .search:
            imgUrlString = (self.searchs[indexPath.row].urls?.regular)!
        }
        
        let imageUrl: URL = URL(string: imgUrlString)!
        
        self.dependency.unsplashService.download(imageUrl, contentsView: cell.contentView) { (image: UIImage?) in
            cell.imageView.image = image
        }
    }
    
    private func requestList() {
        let pageNumber = self.photos.count / 20
        
        self.currentListRequest = self.dependency.unsplashService.list(page: pageNumber) { result in
            
            switch result {
            case let .success(photoListResult):
                self.setListResult(photoListResult)
                
            case let .failure(error):
                self.showErrorAlert(error: error, viewController: self)
            }
        }
    }
    
    private func requestSearch(keyword: String) {
        self.cancelPreviousSearchRequest()
        self.currentSearchRequest = self.dependency.unsplashService.search(keyword: keyword) { result in
            
              switch result {
              case let .success(searchResult):
                self.setSearchResult(searchResult)

              case let .failure(error):
                self.showErrorAlert(error: error, viewController: self)
              }

        }
    }
    
    private func setListResult(_ listResult: [PhotoListResult]) {
        self.photos = listResult
        print(listResult.count)
        self.collectionView.reloadData()
    }
    
    private func setSearchResult(_ searchResult: SearchResult) {
        self.searchs = searchResult.results!
        print(self.searchs)
        self.collectionView.reloadData()
    }
    
    
    private func cancelPreviousSearchRequest() {
      self.currentSearchRequest?.cancel()
    }

    private func searchCloseButton(_ isShow: Bool) {
        if isShow {
            let searchCloseButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(searchCloseAction(_:)))
            self.navigationItem.rightBarButtonItem  = searchCloseButton
            self.navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            self.navigationItem.rightBarButtonItem  = nil
            self.searchController.dismiss(animated: true, completion: nil)
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    @objc func closeAction(_ sender:UIButton!) {
        self.collectionView.isPagingEnabled = false

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.collectionView.backgroundColor = .white

        self.collectionView.scrollToItem(at: IndexPath(row: self.currentIndex, section: 0), at: .top, animated: false)

        self.closeButton.isHidden = true
        
    }
    
    @objc func searchCloseAction(_ sender:Any!) {
        self.searchCloseButton(false)

        self.currentSceenType = .list
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionView DataSource
extension ListPhotosViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch self.currentSceenType {
        case .list:
            return self.photos.count
        case .search:
            return self.searchs.count
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ListPhotosViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell",
                                                  for: indexPath) as! ListPhotosViewCell
        

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        
        guard let cell: ListPhotosViewCell = cell as? ListPhotosViewCell else {
            return
        }
        
        self.configureCell(cell, collectionView: collectionView, indexPath: indexPath)
        
        self.currentIndex = indexPath.row
        
    }

}


// MARK: - UICollectionView Delegate
extension ListPhotosViewController {

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        // paging
        self.collectionView.isPagingEnabled = true

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.collectionView.backgroundColor = .black

        //self.makeUI()
        self.closeButton.isHidden = false

        
        self.collectionView.scrollToItem(at: indexPath, at: .right, animated: false)

        return true
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

// MARK: - UICollectionViewDelegate FlowLayout
extension ListPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout: UICollectionViewFlowLayout =
            self.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero}
        
        let numberOfCellsInRow: CGFloat = 1
        let viewSize: CGSize = self.view.frame.size
        let sectionInset: UIEdgeInsets = flowLayout.sectionInset
        
        let interitemSpace: CGFloat = flowLayout.minimumInteritemSpacing * (numberOfCellsInRow - 1)
        
        var itemWidth: CGFloat
        itemWidth = viewSize.width - sectionInset.left - sectionInset.right - interitemSpace
        itemWidth /= numberOfCellsInRow
        
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
}



// MARK: - UISearchBar Delegate
extension ListPhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.currentSceenType = .search
        
      if let text = searchBar.text {
        self.requestSearch(keyword: text)
      }
        
        self.searchController.dismiss(animated: true, completion: nil)
        self.searchCloseButton(true)
        
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        self.searchController.dismiss(animated: true, completion: nil)
//
//        self.currentSceenType = .list
//
//    }

}




// MARK: - UIViewController Extension
extension UIViewController {

    func showErrorAlert(error: Error, viewController: UIViewController) {
      let alertController = UIAlertController(title: "⚠️", message: error.localizedDescription, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      viewController.present(alertController, animated: true, completion: nil)
    }

}


// MARK: - Custom CellectionViewCell
class ListPhotosViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }

}

enum SceenType {
    case list, search
}
