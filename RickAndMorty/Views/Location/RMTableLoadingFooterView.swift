//
//  RMTableLoadingFooterView.swift
//  RickAndMorty
//
//  Created by Chingiz on 12.02.24.
//

import UIKit

class RMTableLoadingFooterView: UIView {

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
           spinner.translatesAutoresizingMaskIntoConstraints = false
           spinner.hidesWhenStopped = true
           return spinner
       }()

       override init(frame: CGRect) {
           super.init(frame: frame)

           addSubview(spinner)
           spinner.startAnimating()

           addConstraints()
       }

       required init?(coder: NSCoder) {
           fatalError()
       }

       private func addConstraints() {
           NSLayoutConstraint.activate([
               spinner.widthAnchor.constraint(equalToConstant: 55),
               spinner.heightAnchor.constraint(equalToConstant: 55),
               spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
               spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

           ])
       }

}
