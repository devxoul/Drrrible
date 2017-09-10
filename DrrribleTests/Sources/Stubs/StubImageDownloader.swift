//
//  StubImageDownloader.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 23/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Kingfisher

final class StubImageDownloader: ImageDownloader {
  private(set) var url: URL? = nil

  init() {
    super.init(name: "StubImageDownloader")
  }

  override func downloadImage(
    with url: URL,
    retrieveImageTask: RetrieveImageTask? = nil,
    options: KingfisherOptionsInfo? = nil,
    progressBlock: ImageDownloaderProgressBlock? = nil,
    completionHandler: ImageDownloaderCompletionHandler? = nil
  ) -> RetrieveImageDownloadTask? {
    self.url = url
    return nil
  }
}

extension Array where Element == KingfisherOptionsInfoItem {
  static func stub(downloader: ImageDownloader? = nil) -> KingfisherOptionsInfo {
    let downloader = downloader ?? StubImageDownloader()
    return [.forceRefresh, .downloader(downloader)]
  }
}
