//
//  ViewController.swift
//  Movie Searcher
//
//  Created by Sarah Lee on 2/21/21.
//

import UIKit

// UI (table view for the results, search bar)
// Network request
// tap a cell to see info about the movie
// custom cell to show the movie

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    }

    // Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }

    func searchMovies(){
        field.resignFirstResponder()
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        // Remove the prior searches
        movies.removeAll()
        
        let query = text.replacingOccurrences(of: " ", with: "%20")
        
        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?apikey=feba5cbd&s=\(query)&type=movie")!,
                                   completionHandler: {data, response, error in
                                    // Check if there is any error && if data exist
                                    guard let data = data, error == nil else {
                                        return
                                    }
                                    
                                    // Convert the data to the movie struct "Codable"
                                    var result:MovieResult?
                                    do {
                                        result = try JSONDecoder().decode(MovieResult.self, from: data)
                                    } catch {
                                        print("error")
                                    }
                                    
                                    // Validate that the converter succeed by unwrapping the result
                                    guard let finalResult = result else {
                                        return
                                    }
                                    
                                    // Update movies array
                                    let newMovies = finalResult.Search
                                    self.movies.append(contentsOf: newMovies)
                                    
                                    // Refresh table
                                    DispatchQueue.main.async {
                                        self.table.reloadData()
                                    }
                                    
        }).resume() // This is how to kick off the request
        
    }

    // Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // show movie details
    }
}

struct MovieResult: Codable {
    let Search: [Movie]
}

struct Movie : Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let _Type: String
    let Poster: String
    
    private enum CodingKeys: String, CodingKey {
        case Title, Year, imdbID, _Type="Type", Poster
    }
}

