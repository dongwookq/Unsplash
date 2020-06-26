//
//  TestCollectionViewController.swift
//  unsplash
//
//  Created by Dong-Wook Han on 2020/06/26.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import UIKit
import Alamofire

//private let reuseIdentifier = "Cell"

class ListPhotosViewController: UICollectionViewController {
    private let cellReuseIdentifier: String = "listCell"
    var currentIndex: Int = 0
    
    struct Dependency {
      let unsplashService: UnsplashServiceProtocol!
    }
    var dependency: Dependency!
    
    var currentListRequest: DataRequest?
    private var photos: [PhotoListResult] = []

    
    private func configureCell(_ cell: ListPhotosViewCell,
                               collectionView: UICollectionView,
                               indexPath: IndexPath) {
        
        guard indexPath.row < self.photos.count else { return }
        
        let imageUrl: URL = URL(string: (self.photos[indexPath.row].urls?.regular)!)!
        
        self.dependency.unsplashService.download(imageUrl, contentsView: cell.contentView) { (image: UIImage?) in
            cell.imageView.image = image
        }
    }
    
    func requestPhotos() {
        self.currentListRequest = self.dependency.unsplashService.list() { result in
            
            switch result {
            case let .success(photoListResult):
                self.setSearchResult(photoListResult)
                
            case let .failure(error):
                self.showErrorAlert(error: error, viewController: self)
            }
        }
    }
    
    private func setSearchResult(_ searchResult: [PhotoListResult]) {
        self.photos = searchResult
        print(searchResult.count)
        
//        OperationQueue.main.addOperation {
//            self.collectionView?.reloadSections(IndexSet(0...0))
//        }

        self.collectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestPhotos()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        // 서치바
        
//        let searchViewController = UISearchController(searchResultsController: nil)
//        self.navigationItem.searchController = searchViewController
        

    }

    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.collectionViewLayout.invalidateLayout()
//    }
    
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        if let layout =  self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
//            layout.itemSize = CGSize(width: 200, height: 200)
//
//            let controller = UICollectionViewController(collectionViewLayout: layout)
//
//        }
//
//
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//        }
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ListPhotosViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier,
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
    

    // MARK: UICollectionViewDelegate

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

        self.makeUI()

        
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
    
    func makeUI() {
        let closeButton = UIButton(type: .system)
        closeButton.frame = CGRect(x: 20, y: 20, width: 100, height: 50)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }
    
    @objc func buttonAction(_ sender:UIButton!) {
        
       print("Button tapped")

        self.collectionView.isPagingEnabled = false

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.collectionView.backgroundColor = .white

        self.collectionView.scrollToItem(at: IndexPath(row: self.currentIndex, section: 0), at: .top, animated: false)


    }


}


extension ListPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print(indexPath.row)
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
