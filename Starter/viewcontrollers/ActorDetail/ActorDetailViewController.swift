//
//  ActorDetailViewController.swift
//  Starter
//
//  Created by Thet Htun on 6/28/21.
//

import UIKit

class ActorDetailViewController: UIViewController {
    
    @IBOutlet weak var ivBack: UIImageView!
    @IBOutlet weak var labelActorName : UILabel!
    @IBOutlet weak var labelAboutActorBiography : UILabel!
    @IBOutlet weak var imageViewActorPoster : UIImageView!
    @IBOutlet weak var labelActorDOB : UILabel!
    @IBOutlet weak var labelPopularity : UILabel!
    @IBOutlet weak var collectionViewTVCredits : UICollectionView!
    @IBOutlet weak var collectionViewOtherImages: UICollectionView!
    @IBOutlet weak var stackViewButtonsActorInfo : UIStackView!
    @IBOutlet weak var buttonReadMore : UIButton!
    
    let networkAgent = MovieDBNetworkAgent.shared
    
    var itemId : Int = -1
    
    var actionInfo : ActorDetailInfo? {
        didSet {
            if let data = actionInfo {
                bindData(data: data)
            }
        }
    }
    
    private var tvCredits : [MovieResult] = [] {
        didSet {
            collectionViewTVCredits.reloadData()
        }
    }
    
    private var actorImages : [ActorImageDetails] = [] {
        didSet {
            collectionViewOtherImages.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
        fetchData(id: itemId)
    }
    
    private func initView() {
        registerCollectionViewCells()
        initGestureRecognizers()
    }
    
    private func registerCollectionViewCells(){
        collectionViewTVCredits.delegate = self
        collectionViewTVCredits.dataSource = self
        collectionViewTVCredits.register(UINib(nibName: String(describing: PopularFilmCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self))
        collectionViewTVCredits.showsHorizontalScrollIndicator = false
        collectionViewTVCredits.showsVerticalScrollIndicator = false
        
        collectionViewOtherImages.delegate = self
        collectionViewOtherImages.dataSource = self
        collectionViewOtherImages.register(UINib(nibName: String(describing: ActorCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ActorCollectionViewCell.self))
        collectionViewOtherImages.showsHorizontalScrollIndicator = false
        collectionViewOtherImages.showsVerticalScrollIndicator = false
        
    }
    
    private func initGestureRecognizers(){
        let tapGestureForBack = UITapGestureRecognizer(target: self, action: #selector(onTapBack))
        ivBack.isUserInteractionEnabled = true
        ivBack.addGestureRecognizer(tapGestureForBack)
    }
    
    private func fetchData(id : Int) {
        fetchActorDetails(id)
        fetchTVCredits(id)
//        fetchOtherImages(id)
    }
    
    private func fetchActorDetails(_ id: Int) {
        networkAgent.getActorDetails(id: id) { (data) in
            self.actionInfo = data
        } failure: { (error) in
            print(error.description)
        }
    }
    
    private func fetchTVCredits(_ id : Int) {
        networkAgent.getTVCredits(id: id) { (data) in
            self.tvCredits = data.cast ?? [MovieResult]()
        } failure: { (error) in
            print(error)
        }
    }
    
    private func fetchOtherImages(_ id : Int) {
        networkAgent.getActorGallery(id: id) { (data) in
            self.actorImages = data.profiles ?? [ActorImageDetails]()
        } failure: { (error) in
            print(error)
        }
    }
    
    
    @IBAction func onClickReadMore(_ sender : UIButton) {
        if let externalLink = actionInfo?.homepage {
            UIApplication.shared.open(URL(string: externalLink)!, options: [:], completionHandler: nil)
        }
    }
    
    private func bindData(data: ActorDetailInfo) {
        labelActorName.text = data.name
        labelActorDOB.text = data.birthday
        labelAboutActorBiography.text = data.biography
        labelPopularity.text = "\(data.popularity ?? 0)"
        labelPopularity.isHidden = true //Hide for now -
        
        let posterPath = "\(AppConstants.baseImageUrl)/\(data.profilePath ?? "")"
        imageViewActorPoster.sd_setImage(with: URL(string: posterPath))
        
        buttonReadMore.isHidden = data.homepage == nil
        stackViewButtonsActorInfo.isHidden = buttonReadMore.isHidden
    }
    
    @objc func onTapBack(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension ActorDetailViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if collectionView == collectionProductionCompanies {
        //            return productionCompanies.count
        //        }
        //        else if collectionView == collectionViewActors {
        //            return casts.count
        //        }
        if collectionView == collectionViewTVCredits {
            return tvCredits.count
        }
        else if collectionView == collectionViewOtherImages {
            return actorImages.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewTVCredits {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self), for: indexPath) as? PopularFilmCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.data = tvCredits[indexPath.row]
            cell.onTapItem = { id in
                self.navigateToMovieDetailViewController(movieId: id)
            }
            return cell
        }
        else if collectionView == collectionViewOtherImages {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ActorCollectionViewCell.self), for: indexPath) as? ActorCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.ivHeart.isHidden = true
            cell.ivHeartFill.isHidden = true
            cell.imageViewActorProfile .isHidden = true
            cell.labelActorName .isHidden = true
            cell.labelKnownForDepartment .isHidden = true
            
            if actorImages.isEmpty { return UICollectionViewCell() }
            
            let itemData = actorImages[indexPath.row]
            let posterPath = "\(AppConstants.baseImageUrl)\(itemData.filePath ?? "")"
            cell.imageViewActorProfile.sd_setImage(with: URL(string:  posterPath), completed: nil)
            
            return cell
            
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewTVCredits {
            let itemWidth : CGFloat = 120
            let itemHeight : CGFloat = collectionView.frame.height
            return CGSize(width: itemWidth, height: itemHeight)
        } else if collectionView == collectionViewOtherImages {
            let itemWidth : CGFloat = 120
            let itemHeight : CGFloat = itemWidth * 1.5
            return CGSize(width: itemWidth, height: itemHeight)
        }
        
        return CGSize.zero
    }
    
    
}
