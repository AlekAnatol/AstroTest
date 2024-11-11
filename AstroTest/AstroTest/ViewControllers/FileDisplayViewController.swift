//
//  FileDisplayViewController.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 07.11.2024.
//

import UIKit
import WebKit

class FileDisplayViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: FileDisplayViewModel?
    
    // MARK: - Visual components
    
    private let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(#colorLiteral(red: 0, green: 0.3351471424, blue: 0.5525879264, alpha: 1))
        setupView()
        loadURL(viewModel?.urlString)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
    }
    
    private func loadURL(_ urlString: String?) {
        let url = URL(string: urlString ?? "")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
}
