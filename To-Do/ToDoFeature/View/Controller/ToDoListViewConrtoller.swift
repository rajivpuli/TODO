//
//  ToDoListViewConrtoller.swift
//  To-Do
//
//  Created by Rajiv Puli on 07/09/23.
//

import UIKit
import Combine

class ToDoListViewConrtoller: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: ToDoListViewModel = ToDoListViewModel()
    var cancellables = Set<AnyCancellable>()
    var ac = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        bindData()
        
//        printZeroMatrix(size: 4)
        printCheckBoardPattern(size: 5)
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let bundle = Bundle(for: ToDoTableViewCell.self)
        let nib = UINib(nibName: NibNames.toDoTableViewCell.rawValue, bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: CellIdentifiers.toDoTableViewCell.rawValue)
        
        viewModel.getToDoList()
    }
    
    private func bindData() {
        viewModel.$toDoList
            .receive(on: RunLoop.main)
            .sink{ [weak self] data in
                self?.tableView.reloadData()
                if data.count == 0 {
                    self?.showNoData()
                } else {
                    self?.tableView.backgroundView = nil
                }
            }
            .store(in: &cancellables)
    }
    
    @IBAction private func addNotesAction(_ sender: UIBarButtonItem) {
        promptForInput()
    }
    
    private func promptForInput() {
        ac = UIAlertController(title: "To Do", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?.first?.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)

        let createAction = UIAlertAction(title: "Create", style: .default) { [unowned self] _ in
            let description = ac.textFields![0].text ?? ""
            if !description.isEmpty {
                self.viewModel.createToDo(description: description.trimmingCharacters(in: .whitespaces))
            }
        }
        createAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        ac.addAction(createAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    @objc func textChanged(_ textField: UITextField) {
        if textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            ac.actions.first?.isEnabled = false
        } else {
            ac.actions.first?.isEnabled = true
        }
    }
    
    private func alertForDeleteConfirmation(data: ToDoModel) {
        let ac = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [unowned self] _ in
            self.viewModel.remove(data: data)
        }
        confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(confirmAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    private func showNoData() {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text = "No Data"
        noDataLabel.textColor = UIColor.lightGray
        noDataLabel.textAlignment = .center
        noDataLabel.font = .boldSystemFont(ofSize: 20)
        tableView.backgroundView = noDataLabel
    }

}

// MARK: - Table view data source methods
extension ToDoListViewConrtoller: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.toDoTableViewCell.rawValue, for: indexPath) as? ToDoTableViewCell else {
            fatalError("\(CellIdentifiers.toDoTableViewCell.rawValue) deque failed")
        }
        let data = viewModel.toDoList[indexPath.row]
        cell.setUpData(model: data)
        cell.updateStatus = { [unowned self] (data, status) in
            self.viewModel.updateToDo(data: data, isCompleted: status)
        }
        return cell
    }
    
}

// MARK: - Table view delegate methods
extension ToDoListViewConrtoller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            alertForDeleteConfirmation(data: viewModel.toDoList[indexPath.row])
        }
    }
}

extension ToDoListViewConrtoller {
    func printZeroMatrix(size: Int) {
        for i in (0..<size) {
            for j in (0..<size) {
                print("0", terminator: "")
            }
            print("")
        }
    }
    
    func printCheckBoardPattern(size: Int) {
        for i in (0..<size) {
            var printingNum = 0
            if i % 2 == 0 {
                printingNum = 0
            } else {
                printingNum = 1
            }
            for j in (0..<size) {
                if printingNum == 0 {
                    print("\(printingNum)", terminator: " ")
                    printingNum = 1
                } else {
                    print("\(printingNum)", terminator: " ")
                    printingNum = 0
                }
            }
            print("", separator: "\n")
        }
    }
    
    func filterBasedOn(data: [Employee], age: Int) -> [Employee]{
        return data.filter({$0.age == 25 && $0.salary > 15000}).sorted(by: {$0.age > $1.age})
    }
}

class Employee: NSObject {
    var age = 0
    var salary: Int = 0
}
