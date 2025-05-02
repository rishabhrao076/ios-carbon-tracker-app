//
//  LoadingOverlayView.swift
//  carbonTracker
//
//  Created by Rishabh Rao on 01/05/25.
//
import UIKit

class LoadingOverlayView: UIView {

    static let shared = LoadingOverlayView()

    private var backgroundView: UIView!
    private var spinner: UIActivityIndicatorView!
    private var timeoutTask: DispatchWorkItem?

    private override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        backgroundColor = UIColor(white: 0.9, alpha: 0.6)
        isUserInteractionEnabled = true

        spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .darkGray
        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(on parentView: UIView, timeout: TimeInterval = 5.0, onTimeout: (() -> Void)? = nil) {
        frame = parentView.bounds
        parentView.addSubview(self)
        spinner.startAnimating()

        timeoutTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.hide()
            onTimeout?()
        }
        timeoutTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: task)
    }

    func hide() {
        spinner.stopAnimating()
        timeoutTask?.cancel()
        removeFromSuperview()
    }
}
