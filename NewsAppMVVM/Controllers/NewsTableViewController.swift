//
//  NewsTableViewController.swift
//  NewsAppMVVM
//
//  Created by Mohammad Azam on 3/11/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    private var articleListVM: ArticleListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateNews()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListVM == nil ? 0 : self.articleListVM.articlesVM.count
    }
    
    private func populateNews() {
        
        let resource = Resource<ArticleResponse>(url: URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=0cf790498275413a9247f8b94b3843fd")!)
        
        
        URLRequest.load(resource: resource)
            .map { articleResponse -> [ArticleViewModel] in
                return ArticleListViewModel(articleResponse.articles).articlesVM
            }.bind(to: self.tableView.rx.items(cellIdentifier: "ArticleTableViewCell", cellType: ArticleTableViewCell.self)) { (row, element, cell) in
                
                // I know it is stilly to bind it like this here  ...
                element.title.bind(to: cell.titleLabel.rx.text)
                .disposed(by: self.disposeBag)
                
                element.description.bind(to: cell.descriptionLabel.rx.text)
                .disposed(by: self.disposeBag)
                
                
            }.disposed(by: disposeBag)
        
        /*
        URLRequest.load(resource: resource)
            .subscribe(onNext: { articleResponse in
                
                let articles = articleResponse.articles
                self.articleListVM = ArticleListViewModel(articles)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }).disposed(by: disposeBag) */
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleViewModel", for: indexPath) as? ArticleTableViewCell else {
            fatalError("ArticleViewModel is not found.")
        }
        
        
        let articleVM = self.articleListVM.articleAt(indexPath.row)
        
        articleVM.title.asDriver(onErrorJustReturn: "")
        .drive(cell.titleLabel.rx.text)
        .disposed(by: disposeBag)
        
        articleVM.description.asDriver(onErrorJustReturn: "")
        .drive(cell.descriptionLabel.rx.text)
        .disposed(by: disposeBag)
        
        //articleVM.title
        //.observeOn(MainScheduler.instance)
        //.bind(to: cell.titleLabel.rx.text)
        //.disposed(by: disposeBag)
        /*
        articleVM.description
        .observeOn(MainScheduler.instance)
        .bind(to: cell.descriptionLabel.rx.text)
        .disposed(by: disposeBag) */
        
        
        return cell
    }
    
}
