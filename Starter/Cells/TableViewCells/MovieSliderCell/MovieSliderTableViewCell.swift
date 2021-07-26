//
//  MovieSliderTableViewCell.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 14/01/2021.
//

import UIKit

class MovieSliderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionViewMovie: UICollectionView!
    
    var delegate:MovieItemDelegate? = nil
    
    var data : [MovieResult]? {
        didSet {
            if let data = data {
                pageControl.numberOfPages = data.count 
                collectionViewMovie.reloadData()
            }
        }
    }
    
    var videoType : VideoType = .movie
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionViewMovie.dataSource = self
        collectionViewMovie.delegate = self
        collectionViewMovie.register(UINib(nibName: String(describing:MovieSliderCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing:MovieSliderCollectionViewCell.self))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MovieSliderTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieSliderCollectionViewCell.self), for: indexPath) as? MovieSliderCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.data = data?[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data?[indexPath.row]
        delegate?.onTapMovie(id: item?.id ?? -1, type: videoType)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: CGFloat(240))
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame
                                                                            .width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame
                                                                            .width)
    }

}
