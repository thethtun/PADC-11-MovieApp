//
//  MovieDetailViewController.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 14/01/2021.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
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
    
    let networkAgent = MovieDBNetworkAgent.shared
    
    var itemId : Int = -1
    var contentType : VideoType = .movie
    
//    private var objects = Array.init(repeating: "Hello", count: 10000000)
    
    private var productionCompanies : [ProductionCompany] = []
    private var casts : [MovieCast] = []
    private var similarMovies: [MovieResult] = []
    private var movieTrailers: [MovieTrailer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
        
        fetchContentDetail(id : itemId)
    }
    
    
    private func initView() {
        registerCollectionViewCells()
        initGestureRecognizers()
        
        btnRateMovie.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btnRateMovie.layer.borderWidth = 2
        btnRateMovie.layer.cornerRadius = 20
        
        self.buttonPlayTrailer.isHidden = true
        
        
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
    }
    
    private func fetchMovieDetails(id : Int) {
        networkAgent.getMovieDetailById(id: id) { [weak self](result) in
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
        networkAgent.getSerieDetailById(id: id) { [weak self](result) in
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
//        networkAgent.getSimilarMovies(id: id) { (data) in
//            switch data {
//
//            }
//            self.similarMovies = data.results ?? [MovieResult]()
//            self.containerSimilarContentList.isHidden = self.similarMovies.isEmpty
//            self.collectionViewSimilarContent.reloadData()
//        } failure: { (error) in
//            print(error)
//        }
        
    }
    
    private func getMovieCreditsById(id : Int) {
//        networkAgent.getMovieCreditById(id: id) { [weak self](result) in
//            guard let self = self else { return }
//            //MovieCreditResponse
//            self.casts = data.cast ?? [MovieCast]()
//            self.containerCastList.isHidden = self.casts.isEmpty
//            self.collectionViewActors.reloadData()
//        } failure: { (error) in
//            print(error)
//        }
        
    }
    
    private func fetchMovieTrailer(id : Int) {
        networkAgent.getMovieTrailers(id: id) { [weak self](result) in
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
    
    @IBAction func onClickPlayTrailer(_ sender : UIButton) {
        let item = movieTrailers.first
        let youtubeId = item?.key
        let playerVC = YouTubePlayerViewController()
        playerVC.youtubeId = youtubeId
        self.present(playerVC, animated: true, completion: nil)
    }
    
    private func bindData(data: MovieDetailResponse) {
        
        productionCompanies = data.productionCompanies ?? [ProductionCompany]()
        containerProductionCompanyList.isHidden = productionCompanies.isEmpty
        
        collectionProductionCompanies.reloadData()
        
        let posterPath = "\(AppConstants.baseImageUrl)/\(data.backdropPath ?? "")"
        imageViewMoviePoster.sd_setImage(with: URL(string: posterPath))
        
        let releaseDate = data.releaseDate ?? data.firstAirDate
        labelReleasedYear.text = String(releaseDate?.split(separator: "-").first ?? "")
        labelMovieTitle.text = data.originalTitle
        navigationItem.title = data.originalTitle
        labelMovieDescription.text = data.overview
        
        let runTimeHour = Int((data.runtime ?? 0) / 60)
        let runTimeMinutes = (data.runtime ?? 0) % 60
        labelDuration.text = "\(runTimeHour) hr \(runTimeMinutes) mins"
        labelRating.text = "\(data.voteAverage ?? 0.0)"
        viewRatingCount.rating = Int((data.voteAverage ?? 0.0) * 0.5)
        labelVoteCount.text = "\(data.voteCount ?? 0) votes"
        labelAboutMovieTitle.text = data.originalTitle ?? data.name
        
        var genreListStr = ""
        data.genres?.forEach({ (item) in
            genreListStr += "\(item.name), "
        })
        if genreListStr.count > 2 {
            genreListStr.removeLast()
            genreListStr.removeLast()
        }
        
        
        labelGenreCollectionString.text = genreListStr
        
        var countryListStr = ""
        data.productionCountries?.forEach({ (item) in
            countryListStr += "\(item.name ?? ""), "
        })
        if countryListStr.count > 2 {
            countryListStr.removeLast()
            countryListStr.removeLast()
        }
        
        labelProductionCountriesString.text = countryListStr
        
        labelAboutMovieDescription.text = data.overview
        labelReleaseDate.text = data.releaseDate
    }
    
    @objc func onTapBack(){
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

extension MovieDetailViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
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
            cell.onTapItem = { [weak self] id in
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
