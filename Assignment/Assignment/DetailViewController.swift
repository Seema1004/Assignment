//
//  DetailViewController.swift
//  Assignment
//
//  Created by Seema Sharma on 4/26/24.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    var selectedPost: PostModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = selectedPost?.title ?? ""
        self.detailLabel.text = selectedPost?.body ?? ""
    }
    
    @IBAction func closeView() {
        self.dismiss(animated: true)
    }
}
