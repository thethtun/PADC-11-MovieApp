//
//  ViewMoreMovieShowCaseViewController.swift
//  Starter
//
//  Created by Thet Htun on 6/28/21.
//

import UIKit

class ViewMoreMovieShowCaseViewController: UIViewController {

    @IBOutlet weak var collectionViewMovies : UICollectionView!
    
    var initData : MovieListResponse?
    
    private var data : [MovieResult] = []
    private var currentPage : Int = 1
    private var totalPage : Int = 1
    
    private let networkAgent = MovieDBNetworkAgent.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
        setupData()
    }
    
    private func initView() {
        setupCollectionView()
    }
    
    private func setupData() {
        data = initData?.results ?? [MovieResult]()
        currentPage = initData?.page ?? 1
        totalPage = initData?.totalPages ?? 1
        
        collectionViewMovies.reloadData()
    }

    func setupCollectionView() {
        collectionViewMovies.dataSource = self
        collectionViewMovies.delegate = self
        collectionViewMovies.showsHorizontalScrollIndicator = false
        collectionViewMovies.showsVerticalScrollIndicator = false
        if let layout = collectionViewMovies.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        
        collectionViewMovies.register(UINib(nibName: String(describing: ShowCaseCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ShowCaseCollectionViewCell.self))
    }
    
    private func fetchData(page : Int) {
        networkAgent.getTopRatedMovieList(page: page) { (data) in
            self.data.append(contentsOf: data.results ?? [MovieResult]())
            self.collectionViewMovies.reloadData()
        } failure: { (error) in
            print(error.description)
        }

    }
    
}


//MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension ViewMoreMovieShowCaseViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShowCaseCollectionViewCell.self), for: indexPath) as? ShowCaseCollectionViewCell else { return UICollectionViewCell() }
        cell.data = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isAtLastRow = indexPath.row == self.data.count - 1
        let hasMorePages = self.currentPage < self.totalPage
        if (isAtLastRow && hasMorePages){
            currentPage = currentPage + 1
            fetchData(page: currentPage)
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ViewMoreMovieShowCaseViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.width
        let itemHeight = (itemWidth / 16) * 9
        return CGSize(width: itemWidth, height:  itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
