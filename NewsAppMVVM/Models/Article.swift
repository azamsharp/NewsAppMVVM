//
//  Article.swift
//  NewsAppMVVM
//
//  Created by Mohammad Azam on 3/11/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ArticleResponse: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
    let description: String
}
