//
//  WenoiVisualPanelView.swift
//  Oasis
//
//  Created by Roushil singla on 5/27/21.
//  Copyright © 2021 Nikhil Narayan. All rights reserved.
//

import UIKit

public class WenoiVisualPanelView: UIView {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var panelTableView: UITableView!
    
    
    lazy var visualPanelModel: [WenoiVisualPanelModel] = []
    lazy var searchedModel = [WenoiVisualPanelModel]()
    public var selectedModel: [WenoiVisualPanelModel] = []
    public var previouslySelectedModel: [WenoiVisualPanelModel] = []
    var isSearching = false
    var maximumSelection = 1
    var defaultImageName: String?
    var loadImageFromAssets = false
    var needToShowImage = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        searchBar.delegate = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        searchBar.delegate = self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.barTintColor = .clear
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
    
    private func commonInit() {
        let bundle = Bundle.init(for: WenoiVisualPanelView.self)
        if let viewsToAdd = bundle.loadNibNamed("WenoiVisualPanelView", owner: self, options: nil),
           let contentView = viewsToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
    
    
    /* Setup CollectionView with Model or Default values */
    public func setUpVisualPanel(with model: [WenoiVisualPanelModel]?, defaultImageName: String?, hideSearchBar: Bool, maximumSelectionAllowed: Int, loadImageFromAssets: Bool = false, needToShowImage: Bool = true) {
        guard let visualModel = model else { return }
        visualPanelModel                = visualModel
        searchBar.isHidden              = hideSearchBar
        maximumSelection                = maximumSelectionAllowed
        self.defaultImageName           = defaultImageName
        self.loadImageFromAssets        = loadImageFromAssets
        self.needToShowImage = needToShowImage
        if visualPanelModel.contains(where: { previouslySelectedModel.first?.id == $0.id }) {
            selectedModel.append(previouslySelectedModel.first ?? WenoiVisualPanelModel())
        }
        registerForCells()
    }
    
    
    func registerForCells() {
        panelTableView.register(UINib(nibName: "VIsualPanelTableViewCell", bundle: Bundle(for: VIsualPanelTableViewCell.self)), forCellReuseIdentifier: "VIsualPanelTableViewCell")
        panelTableView.dataSource = self
        panelTableView.delegate   = self
        panelTableView.tableFooterView = UIView()
        panelTableView.keyboardDismissMode = .onDrag
    }
    
    
    func removeAllCheckmarks() {
        panelTableView.visibleCells.forEach { cell in
            cell.accessoryType = .none
        }
        selectedModel.removeAll()
        previouslySelectedModel.removeAll()
    }
    
}

extension WenoiVisualPanelView: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedModel = visualPanelModel.filter{($0.name?.contains(searchText) ?? false)}
        isSearching = !searchText.isEmpty
        DispatchQueue.main.async {
            self.panelTableView.reloadData()
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}



extension WenoiVisualPanelView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? (searchedModel.count) : (visualPanelModel.count)
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VIsualPanelTableViewCell", for: indexPath) as! VIsualPanelTableViewCell
        var model: WenoiVisualPanelModel!
        model = isSearching ? searchedModel[indexPath.row] : visualPanelModel[indexPath.row]
        cell.defaultImageName = defaultImageName
        cell.loadImageFromAssets = loadImageFromAssets
        cell.needToShowImage = needToShowImage
        cell.panelModel = model
        cell.selectionStyle = .none
    
        ///* Checkmark cell if they have previous selected Members
        if previouslySelectedModel.count > 0 {
            if previouslySelectedModel.contains(model) {
                cell.accessoryType = .checkmark
                selectedModel.append(model)
            } else {
                cell.accessoryType = .none
            }
        }
        
        if selectedModel.count > 0 {
            cell.accessoryType = selectedModel.contains(model) ? .checkmark : .none
        }
        
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell  = tableView.cellForRow(at: indexPath)
        var model: WenoiVisualPanelModel!
        model = isSearching ? searchedModel[indexPath.row] : visualPanelModel[indexPath.row]

        
        if maximumSelection > 1 {
            if cell?.accessoryType == .checkmark {
                self.selectedModel.removeAll(where: {$0 == model})
                cell?.accessoryType = .none
            }
            else {
                if selectedModel.count < maximumSelection {
                    selectedModel.append(model)
                    cell?.accessoryType = .checkmark
                }
            }
        } else {
            removeAllCheckmarks()
            selectedModel.append(model)
            cell?.accessoryType = .checkmark
        }
        
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
