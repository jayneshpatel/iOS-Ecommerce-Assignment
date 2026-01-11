//
//  ImageLoader.swift
//  ECommerceApp
//
//  Created by Jaynesh Patel on 10/01/26.
//

import UIKit

final class ImageLoader {

    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()

    func loadImage(from urlString: String,
                   completion: @escaping (UIImage?) -> Void) {

        if let cached = cache.object(forKey: urlString as NSString) {
            completion(cached)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)
            if let image {
                cache.setObject(image, forKey: urlString as NSString)
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
