//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Chingiz on 11.02.24.
//

import UIKit

/// Configurable controller to search
final class RMSearchViewController: UIViewController {
    
    private let viewModel: RMSearchViewViewModel
    
    private let searchView: RMSearchView
    
    /// Configuration of search session
    struct Config {
        enum `Type` {
            case character
            case episode
            case location
            
            var endpoint: RMEndpoint{
                switch self{
                case .character:
                    return .character
                case .episode:
                    return .episode
                case .location:
                    return .location
                }
            }
            
            var searchResultResponseType: Any.Type{
                switch self {
                case .character:
                    return RMGetAllCharactersResponse.self
                case .episode:
                    return RMGetAllLocationsResponse.self
                case .location:
                    return RMGetAllLocationsResponse.self
                }
            }
            
            var title: String{
                switch self{
                case .character:
                    return "Search Characters"
                case .episode:
                    return "Search Episodes"
                case .location:
                    return "Search Locations"
                }
            }
        }
        
        let type: `Type`
        
    }
    
    
    init(config: Config){
        let viewModel = RMSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
            }
    
    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(didTapExecuteSearch))
        searchView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchView.presentKeyboard()
    }
    
    @objc private func didTapExecuteSearch() {
        viewModel.executeSearch()
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension RMSearchViewController: RMSearchViewDelegate{
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        let vc = RMSearchOptionPickerViewController(option: option) { [weak self] selection in
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
        }
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        present(vc, animated: true)
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectCharacter character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectEpisode episode: RMEpisode) {
        let vc = RMEpisodeDetailViewController(url: URL(string: episode.url))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
