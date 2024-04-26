//
//  ViewController.swift
//  Assignment
//
//  Created by Seema Sharma on 4/26/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var baseTableView: UITableView!
    
    var totalInformation = [PostModel]()
    var currentPage = 1
    let numberOfItemsPerPage = 15
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.fetchContent()
    }
    
    func setUpTableView() {
        self.baseTableView.delegate = self
        self.baseTableView.dataSource = self
    }
    
    func fetchContent() {
        guard let baseUrl = URL(string:"https://jsonplaceholder.typicode.com/posts?_page=\(currentPage)&_limit=\(numberOfItemsPerPage)") else { return }
        URLSession.shared.dataTask(with: baseUrl) {responseData, response, error in
            guard let data = responseData, error == nil else { return }
            do {
                let decoder = JSONDecoder()
                let receivedPosts = try decoder.decode([PostModel].self, from: data)
                DispatchQueue.main.async {
                    self.totalInformation += receivedPosts
                    self.baseTableView.reloadData()
                }
            } catch {
                print("Error occured on fetch: \(error)")
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            if let indexPath = self.baseTableView.indexPathForSelectedRow {
                let selectedPost = totalInformation[indexPath.row]
                if let detailVC = segue.destination as? DetailViewController {
                    detailVC.selectedPost = selectedPost
                }
            }
        }
    }
    
    func calculateLength(_ title: String) -> Int {
        Thread.sleep(forTimeInterval: 1)
        return title.count
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath)
        let info = self.totalInformation[indexPath.row]
        if let row = info.id, let value = info.title {
            cell.textLabel?.text = "\(row). \(value)"
        // Perform heavy computation asynchronously
            DispatchQueue.global(qos: .background).async {
                let startTime = CFAbsoluteTimeGetCurrent()
                let titleLength = self.calculateLength(value)
                let endTime = CFAbsoluteTimeGetCurrent()
                let elapsedTime = endTime - startTime
                print("\(elapsedTime) seconds - Time taken to compute title length: \(titleLength)")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY>contentHeight - scrollView.frame.size.height {
            self.currentPage = self.currentPage + 1
            self.fetchContent()
        }
    }
    
}

