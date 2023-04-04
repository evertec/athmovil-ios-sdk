//
//  ConfigurationSelectable.swift
//  athmovil-checkout-demo
//
//  Created by Hansy on 8/6/21.
//  Copyright © 2021 Evertec. All rights reserved.
//

import Foundation
import UIKit
import athmovil_checkout

enum selectableList {
    case theme(String)
    case newFlow(String)
    case enviroment(String)
    
    var rows: [String] {
        switch self {
            case .theme:
                return UserPreferences.shared.themeList
            case .newFlow:
                return UserPreferences.shared.isNewFlow
            default:
                return UserPreferences.shared.enviroments
        }
    }
    
}

class ConfigurationListViewController: UIViewController {
        
    @IBOutlet weak var picker: UIPickerView!
    let listRows: [String]
    let currentType: selectableList
    let onSelectedConfiguration: ((selectableList) -> Void)?
        
    init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?,
                  typeList: selectableList,
                  completion: @escaping (selectableList) -> Void) {
        listRows = typeList.rows
        currentType = typeList
        onSelectedConfiguration = completion
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        listRows = [String]()
        currentType = .enviroment("")
        onSelectedConfiguration = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidLoadPickerView()
    }
    
    func viewDidLoadPickerView() {
        var selectedIndex = 0
        switch currentType {
            case let .enviroment(selectedEnviroment):
                selectedIndex = listRows.firstIndex { $0 == selectedEnviroment } ?? 0
            case let .newFlow(selectedNewFlow):
                selectedIndex = listRows.firstIndex { $0 == selectedNewFlow } ?? 0
            case let .theme(selectedTheme):
                selectedIndex = listRows.firstIndex { $0 == selectedTheme } ?? 0
        }
        picker.selectRow(selectedIndex, inComponent: 0, animated: true)
    }
    
    @IBAction func accept_touchUpInside(_ sender: Any) {
        let selectedRow = picker.selectedRow(inComponent: 0)
        let selectedName = listRows[selectedRow]
        dismiss(animated: true) {
            switch self.currentType {
                case .enviroment:
                    self.onSelectedConfiguration?(.enviroment(selectedName))
                case .newFlow:
                    self.onSelectedConfiguration?(.newFlow(selectedName))
                case .theme:
                    self.onSelectedConfiguration?(.theme(selectedName))
            }
        }
        
    }
    
    @IBAction func cancel_touchUpInside(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension ConfigurationListViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        listRows.count
    }
}

extension ConfigurationListViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        listRows[row]
    }
}
