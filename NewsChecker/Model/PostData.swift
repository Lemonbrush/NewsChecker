//
//  PostData.swift
//  NewsChecker
//
//  Created by Александр on 14.05.2021.
//

/*
 JSON file example:
 
 {
     "pagination": {
         "limit": 25,
         "offset": 0,
         "count": 25,
         "total": 6544
     },
     "data": [
         {
             "author": null,
             "title": "Chile speeding up its vaccination campaign: 455,000 from critical groups in two days",
             "description": "Chilean Health Minister Enrique Paris reported on Friday that 454,155 people have been vaccinated against COVID-19 in the country so far, as part of the mass vaccination plan that kicked off on Wednesday.",
             "url": "https://en.mercopress.com/2021/02/06/chile-speeding-up-its-vaccination-campaign-455-000-from-critical-groups-in-two-days?utm_source=feed&utm_medium=rss&utm_content=main&utm_campaign=rss",
             "source": "en",
             "image": "https://en.mercopress.com/data/cache/noticias/80065/100x80/chi.jpg",
             "category": "general",
             "language": "en",
             "country": "us",
             "published_at": "2021-02-06T08:01:05+00:00"
         }
 }
 */

import Foundation

struct PostData: Codable {
    let data: [Post]
}

struct Post: Codable {
    var title: String
    var category: String
    var description: String
    var url: String
    var image: String?
}
