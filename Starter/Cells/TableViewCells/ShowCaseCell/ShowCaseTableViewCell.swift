//
//  ShowCaseTableViewCell.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 29/01/2021.
//

import UIKit

class ShowCaseTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonMoreShowCases : UIButton!
    @IBOutlet weak var lblShowCases: UILabel!
    @IBOutlet weak var collectionViewShowCases: UICollectionView!
    @IBOutlet weak var heightCollectionViewShowCases : NSLayoutConstraint!
    
    var data : [MovieResult]? {
        didSet {
            if let _ = data {
                collectionViewShowCases.reloadData()
            }
        }
    }
    
    var delegate : MovieItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonMoreShowCases.underlineText(text: "More Showcases".uppercased())
        
        collectionViewShowCases.dataSource = self
        collectionViewShowCases.delegate = self
        collectionViewShowCases.register(UINib(nibName: String(describing: ShowCaseCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing:ShowCaseCollectionViewCell.self))
        
        let itemWidth : CGFloat = collectionViewShowCases.frame.width - 50
        let itemHeight : CGFloat = (itemWidth / 16) * 9
        heightCollectionViewShowCases.constant = itemHeight
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
     @IBAction func onClickViewMore(_ sender : Any) {
        delegate?.onTapViewMore()
     }
    
}

extension ShowCaseTableViewCell : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShowCaseCollectionViewCell.self), for: indexPath) as? ShowCaseCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.data = data?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth : CGFloat = collectionView.frame.width - 50
        let itemHeight : CGFloat = (itemWidth / 16) * 9
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ((scrollView.subviews[(scrollView.subviews.count-1)]).subviews[0]).backgroundColor = UIColor(named: "color_yellow")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data?[indexPath.row]
        delegate?.onTapMovie(id: item?.id ?? -1, type: .movie) //This could be serie
    }
    
}
