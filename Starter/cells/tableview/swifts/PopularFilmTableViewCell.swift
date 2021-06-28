//
//  PopularFilmTableViewCell.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 23/01/2021.
//

import UIKit

class PopularFilmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var collectionViewMovies: UICollectionView!
    
    var delegate:MovieItemDelegate?=nil
    
    var data : MovieListResponse? {
        didSet {
            if let _ = data {
                collectionViewMovies.reloadData()
            }
        }
    }
    
    var videoType : VideoType = .movie
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionViewMovies.dataSource = self
        collectionViewMovies.delegate = self
        collectionViewMovies.register(UINib(nibName: String(describing: PopularFilmCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension PopularFilmTableViewCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self), for: indexPath) as? PopularFilmCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.data = data?.results?[indexPath.row]
        cell.onTapItem = { [weak self] id in
            guard let self = self else { return }
            self.delegate?.onTapMovie(id: id, type: self.videoType)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth : CGFloat = 120
        let itemHeight : CGFloat = collectionView.frame.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
}
