//
//  SearchResultViewController.swift
//  20230227-EkambaramEswaran-Chase
//
//  Created by Ekambaram E on 2/27/23.
//

import UIKit

protocol SearchResultDelegate {
    func updateRecentlySearchResult(keySearch: String)
    func refreshTableView()
}

class SearchResultViewController: UIViewController {
    
    var delegate: SearchResultDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


//MARK: - UISearchBarDelegate
extension SearchResultViewController : UISearchBarDelegate {
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.delegate?.updateRecentlySearchResult(keySearch: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.delegate?.refreshTableView()
    }

}
