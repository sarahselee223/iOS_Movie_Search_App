//
//  MovieTableViewCell.swift
//  Movie Searcher
//
//  Created by Sarah Lee on 2/21/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieYearLabel: UILabel!
    @IBOutlet var moviePosterImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // return the cell so that it can be registered in table
    // nib is represent to cell
    static let identifier = "MovieTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }
    
    // take the movie data and configure to cell
    func configure(with model: Movie){
        self.movieTitleLabel.text = model.Title
        self.movieYearLabel.text = model.Year
        let url = model.Poster
        let data = try! Data(contentsOf: URL(string: url)!)
        self.moviePosterImageView.image = UIImage(data:data)
    }
}
