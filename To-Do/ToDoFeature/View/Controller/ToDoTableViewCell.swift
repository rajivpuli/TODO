//
//  ToDoTableViewCell.swift
//  To-Do
//
//  Created by Rajiv Puli on 07/09/23.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var toDoInfoLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var data: ToDoModel?
    var updateStatus: ((ToDoModel, Bool) -> Void)?
    var deleteData: ((ToDoModel) -> Void)?
    var isCompleted: Bool = false {
        didSet {
            actionButton.isSelected = isCompleted
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpData(model: ToDoModel) {
        data = model
        toDoInfoLabel.text = data?.todoDescription ?? ""
        self.isCompleted = data?.isCompleted ?? false
    }
    
    @IBAction private func toDoStatusChangeButtonAction(_ sender: UIButton) {
        isCompleted = !isCompleted
        updateStatus?(data!, isCompleted)
    }
}
