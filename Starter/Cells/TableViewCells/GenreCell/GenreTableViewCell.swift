//
//  GenreTableViewCell.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 28/01/2021.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionViewGenre: UICollectionView!
    @IBOutlet weak var collectionViewMovie: UICollectionView!
    
    var onTapGenreMovie : ((Int)->Void)?
    //    let genreList = [GenreVO(name: "ACTION", isSelected: true),GenreVO(name: "DRAMA", isSelected: false),GenreVO(name: "COMEDY", isSelected: false),GenreVO(name: "ADVENTURE", isSelected: false),GenreVO(name: "BIOGRAPHY", isSelected: false)]
    var genreList : [GenreVO]? {
        didSet {
            if let _ = genreList {
                collectionViewGenre.reloadData()
               
                genreList?.removeAll(where: { (genreVO) -> Bool in
                    let genreID = genreVO.id
                    
                    let results = movieListByGenre.filter { (key, value) -> Bool in
                        genreID == key
                    }
                    
                    return results.count == 0
                })
            }
        }
    }
    
    var allMoviesAndSeries : [MovieResult] = [] {
        didSet {
            //computation
            allMoviesAndSeries.forEach { (movieSeries) in
                movieSeries.genreIDS?.forEach({ (genreId) in
                    let key = genreId // 12 -> nil
                    
                    /**
                     first time -> 12 -> nil -> [MovieResult]() -> 12 = [MovieResult]()
                     second time -> 12 -> [MovieResult] -> .append(newMovieData)
                     third time ....
                     fourth time ....
                     nth time ....
                     */
                    
                    if var _ = movieListByGenre[key] {
                        movieListByGenre[key]!.insert(movieSeries) // [MovieResult]?
                    } else {
                        movieListByGenre[key] = [movieSeries]
                    }
                    
                })
            }
            
            onTapGenre(genreId: genreList?.first?.id ?? 0)
        }
    }
    private var selectedMovieList : [MovieResult] = []
    private var movieListByGenre : [Int: Set<MovieResult>] = [:]
    /**
     let movieListKeyValuePair : [MovieGenreID : [MovieResult]]
     
     14 -> movieList
     12 -> movieList
     
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionViewGenre.dataSource = self
        collectionViewGenre.delegate = self
        
        collectionViewGenre.register(UINib(nibName: String(describing: GenreCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: GenreCollectionViewCell.self))
        
        collectionViewMovie.dataSource = self
        collectionViewMovie.delegate = self
        
        collectionViewMovie.register(UINib(nibName: String(describing: PopularFilmCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension GenreTableViewCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewMovie {
            return selectedMovieList.count
        }
        return genreList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewMovie {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self), for: indexPath) as? PopularFilmCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.data = selectedMovieList[indexPath.row]
            cell.onTapItem = onTapGenreMovie
            
            return cell
            
        } else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GenreCollectionViewCell.self), for: indexPath) as? GenreCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.data = genreList?[indexPath.row]
            cell.onTapItem = { genreId in
                self.onTapGenre(genreId: genreId)
                
            }
            return cell
        }
    }
    
    private func onTapGenre(genreId: Int) {
        self.genreList?.forEach { (genreVO) in
            if genreId == genreVO.id {
                genreVO.isSelected = true
            }else{
                genreVO.isSelected = false
            }
        }
        let movieList = self.movieListByGenre[genreId] // [MovieResult]?
        self.selectedMovieList = movieList?.map { $0 } ?? [MovieResult]()
        
        self.collectionViewGenre.reloadData()
        self.collectionViewMovie.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewMovie {
            let itemWidth : CGFloat = 120
            let itemHeight : CGFloat = collectionView.frame.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
        return CGSize(width: widthOfString(text: genreList?[indexPath.row].name ?? "",font: UIFont(name: "Geeza Pro Regular", size: 14) ?? UIFont.systemFont(ofSize: 14))+20, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func widthOfString(text:String,font:UIFont)->CGFloat{
        let fontAttributes = [NSAttributedString.Key.font : font]
        let textSize = text.size(withAttributes: fontAttributes)
        return textSize.width
    }
    
}
