//
//  ImageViewExt.swift
//  ReFoot
//
//  Created by merengue on 13/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadFromURL(_ urlString: String?) {
        guard let strongUrl = urlString else { return }
        self.kf.setImage(with: URL(string: strongUrl))
    }
}
