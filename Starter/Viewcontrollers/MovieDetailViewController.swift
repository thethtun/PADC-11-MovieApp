//
//  MovieDetailViewController.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 14/01/2021.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var ivBack: UIImageView!
    @IBOutlet weak var btnRateMovie: UIButton!
    @IBOutlet weak var labelReleasedYear : UILabel!
    @IBOutlet weak var labelMovieTitle : UILabel!
    @IBOutlet weak var labelMovieDescription : UILabel!
    @IBOutlet weak var labelDuration : UILabel!
    @IBOutlet weak var labelRating : UILabel!
    @IBOutlet weak var viewRatingCount : RatingControl!
    @IBOutlet weak var labelVoteCount : UILabel!
    @IBOutlet weak var labelAboutMovieTitle : UILabel!
    @IBOutlet weak var labelGenreCollectionString : UILabel!
    @IBOutlet weak var labelProductionCountriesString : UILabel!
    @IBOutlet weak var labelAboutMovieDescription : UILabel!
    @IBOutlet weak var labelReleaseDate : UILabel!
    @IBOutlet weak var imageViewMoviePoster : UIImageView!
    @IBOutlet weak var collectionViewActors: UICollectionView!
    @IBOutlet weak var collectionProductionCompanies : UICollectionView!
    @IBOutlet weak var collectionViewSimilarContent: UICollectionView!
    @IBOutlet weak var buttonPlayTrailer : UIButton!
    @IBOutlet weak var containerCastList : UIView!
    @IBOutlet weak var containerSimilarContentList : UIView!
    @IBOutlet weak var containerProductionCompanyList : UIView!
    
    private var bookmarkButton : UIBarButtonItem!
    
    //MARK: - Properties
    
    private let movieDetailModel : MovieDetailModel = MovieDetailModelImpl.shared
    private let watchListModel : WatchListModel = WatchListModelImpl.shared
    
    var itemId : Int = -1
    var contentType : VideoType = .movie
    
//    private var objects = Array.init(repeating: "Hello", count: 10000000)
    
    private var productionCompanies : [ProductionCompany] = []
    private var casts : [MovieCast] = []
    private var similarMovies: [MovieResult] = []
    private var movieTrailers: [MovieTrailer] = []
    
    private var isWatchList: Bool = false {
        didSet {
            if isWatchList {
                bookmarkButton.image = UIImage(systemName: "bookmark.fill")
            } else {
                bookmarkButton.image = UIImage(systemName: "bookmark")
            }
        }
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
        
        fetchContentDetail(id : itemId)
//        similarMovies.popL
        similarMovies.elementsEqual(similarMovies)
//        similarMovies.append(contentsOf: [MovieResult]())
    }
    
    
    //MARK: - View Setup
    private func initView() {
        registerCollectionViewCells()
        initGestureRecognizers()
        
        btnRateMovie.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btnRateMovie.layer.borderWidth = 2
        btnRateMovie.layer.cornerRadius = 20
        
        self.buttonPlayTrailer.isHidden = true
        
        bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(onSelectBookmark))
        self.navigationItem.rightBarButtonItem = bookmarkButton
    }
    
    private func registerCollectionViewCells(){
        collectionViewActors.delegate = self
        collectionViewActors.dataSource = self
        collectionViewActors.register(UINib(nibName: String(describing: ActorCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ActorCollectionViewCell.self))
        collectionViewActors.showsHorizontalScrollIndicator = false
        collectionViewActors.showsVerticalScrollIndicator = false
        
        collectionViewSimilarContent.delegate = self
        collectionViewSimilarContent.dataSource = self
        collectionViewSimilarContent.register(UINib(nibName: String(describing: PopularFilmCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self))
        collectionViewSimilarContent.showsHorizontalScrollIndicator = false
        collectionViewSimilarContent.showsVerticalScrollIndicator = false
        
        collectionProductionCompanies.delegate = self
        collectionProductionCompanies.dataSource = self
        collectionProductionCompanies.register(UINib(nibName: String(describing: ProductionCompanyCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductionCompanyCell.self))
        collectionProductionCompanies.showsHorizontalScrollIndicator = false
        collectionProductionCompanies.showsVerticalScrollIndicator = false
    }
    
    private func initGestureRecognizers(){
        let tapGestureForBack = UITapGestureRecognizer(target: self, action: #selector(onTapBack))
        ivBack.isUserInteractionEnabled = true
        ivBack.addGestureRecognizer(tapGestureForBack)
    }
    
    
    //MARK: - Network Call
    private func fetchContentDetail(id : Int) {
        switch contentType {
        case .serie:
            fetchSerieDetails(id: id)
        case .movie:
            fetchMovieDetails(id: id)
        }
        
        getMovieCreditsById(id : id)
        fetchSimilarMovies(id: id)
        fetchMovieTrailer(id : id)
        
//        MovieRepositoryImpl.shared.testDummy()
        
        watchListModel.checkIfItemInWatchList(id: id) { (isWatchList) in
            self.isWatchList = isWatchList
        }
    }
    
    
    
    private func fetchMovieDetails(id : Int) {
        movieDetailModel.getMovieDetailById(id: id) { [weak self](result) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.bindData(data: data)
            case .failure(let message):
                print(message.debugDescription)
            }
        }
    }
    
    private func fetchSerieDetails(id : Int) {
        movieDetailModel.getSerieDetailById(id: id) { [weak self](result) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.bindData(data: data)
            case .failure(let message):
                print(message.debugDescription)
            }
        }
        
    }
    
    private func fetchSimilarMovies(id : Int) {
        movieDetailModel.getSimilarMovies(id: id) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.similarMovies = data
                self.containerSimilarContentList.isHidden = self.similarMovies.isEmpty
                self.collectionViewSimilarContent.reloadData()
            case .failure(let message):
                print(message.debugDescription)
            }
        }
        
    }
    
    private func getMovieCreditsById(id : Int) {
        movieDetailModel.getMovieCreditById(id: id) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.casts = data
                self.containerCastList.isHidden = self.casts.isEmpty
                self.collectionViewActors.reloadData()
            case .failure(let message):
                print(message.debugDescription)
            }
        }
    }
    
    private func fetchMovieTrailer(id : Int) {
        movieDetailModel.getMovieTrailers(id: id) { [weak self](result) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.movieTrailers = data.results ?? [MovieTrailer]()
                self.buttonPlayTrailer.isHidden = self.movieTrailers.isEmpty
            case .failure(let message):
                print(message.debugDescription)
            }
        }
        
    }
    
    
    //MARK: - UI Logic Handlers
    @objc func onSelectBookmark(_ sender : Any) {
        if isWatchList {
            watchListModel.removeWatchList(id: itemId, completion: nil)
        } else {
            watchListModel.saveWatchList(id: itemId, completion: nil)
        }
        
        isWatchList.toggle()
    }
    
    @IBAction func onClickPlayTrailer(_ sender : UIButton) {
        let item = movieTrailers.first
        let youtubeId = item?.key
        let playerVC = YouTubePlayerViewController()
        playerVC.youtubeId = youtubeId
        self.present(playerVC, animated: true, completion: nil)
    }
    
    private func bindData(data: MovieDetailResponse) {
        
        bindDataGeneralInfo(data)
        
        bindDataAppendixInfo(data)
        
        /// Navigation Title
        self.navigationItem.title = data.originalTitle ?? data.title ?? data.name ?? ""
    }
    
    private func bindDataGeneralInfo(_ data: MovieDetailResponse) {
        let posterPath = "\(AppConstants.baseImageUrl)/\(data.backdropPath ?? "")"
        imageViewMoviePoster.sd_setImage(with: URL(string: posterPath))
        
        let releaseDate = data.releaseDate ?? data.firstAirDate
        labelReleasedYear.text = String(releaseDate?.split(separator: "-").first ?? "")
        labelMovieTitle.text = data.originalTitle ?? data.title ?? data.name ?? ""
        
        labelMovieDescription.text = data.overview
        
        let runTimeHour = Int((data.runtime ?? 0) / 60)
        let runTimeMinutes = (data.runtime ?? 0) % 60
        labelDuration.text = "\(runTimeHour) hr \(runTimeMinutes) mins"
        labelRating.text = "\(data.voteAverage ?? 0.0)"
        viewRatingCount.rating = Int((data.voteAverage ?? 0.0) * 0.5)
        labelVoteCount.text = "\(data.voteCount ?? 0) votes"
        labelAboutMovieTitle.text = data.originalTitle ?? data.name
        
//        isWatchList = data.isWatchList ?? false
    }
    
    private func bindDataAppendixInfo(_ data: MovieDetailResponse) {
        labelGenreCollectionString.text = data.genres?.map { $0.name }.joined(separator: ",")
        labelProductionCountriesString.text = data.productionCountries?.map { $0.name ?? "" }.joined(separator: ",")
        
        labelAboutMovieDescription.text = data.overview
        labelReleaseDate.text = data.releaseDate
        
        productionCompanies = data.productionCompanies ?? [ProductionCompany]()
        containerProductionCompanyList.isHidden = productionCompanies.isEmpty
        
        collectionProductionCompanies.reloadData()
    }
    
    @objc func onTapBack(){
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
extension MovieDetailViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionProductionCompanies {
            return productionCompanies.count
        }
        else if collectionView == collectionViewActors {
            return casts.count
        }
        else if collectionView == collectionViewSimilarContent {
            return similarMovies.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionProductionCompanies {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductionCompanyCell.self), for: indexPath) as? ProductionCompanyCell else {
                return UICollectionViewCell()
            }
            
            cell.data = productionCompanies[indexPath.row]
            
            return cell
        }
        else if collectionView == collectionViewActors {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ActorCollectionViewCell.self), for: indexPath) as? ActorCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let item : MovieCast = casts[indexPath.row]
            cell.data = item.convertToActorInfoResponse()
            cell.delegate = self
            return cell
        }
        else if collectionView == collectionViewSimilarContent {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self), for: indexPath) as? PopularFilmCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.data = similarMovies[indexPath.row]
            cell.onTapItem = { [weak self] id, _ in
                guard let self = self else { return }
                self.navigateToMovieDetailViewController(movieId: id)
            }
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionProductionCompanies {
            let itemWidth : CGFloat = collectionView.frame.height
            let itemHeight = itemWidth
            return CGSize(width: itemWidth, height: itemHeight)
        }
        else if collectionView == collectionViewActors {
            let itemWidth : CGFloat = 120
            let itemHeight : CGFloat = itemWidth * 1.5
            return CGSize(width: itemWidth, height: itemHeight)
        }
        else if collectionView == collectionViewSimilarContent {
            let itemWidth : CGFloat = 120
            let itemHeight : CGFloat = collectionView.frame.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
        else {
            return CGSize.zero
        }
    }
    
    
    
}

extension MovieDetailViewController : ActorActionDelegate {
    func onTapFavorite(isFavorte: Bool) {
        //DO NOTHING
    }
    
    func onTapItem(data: ActorInfoResponse) {
        self.navigateToActorDetailViewController(id: data.id ?? 1)
    }
    
}
