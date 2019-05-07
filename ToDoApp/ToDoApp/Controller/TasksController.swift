import UIKit

class TasksController: UITableViewController {
    // add data source
    var taskStore:  TaskStore!{
        didSet{
            // get data
            taskStore.tasks = TaskSave.load() ?? [[Task](), [Task]()]
            
            // load data to view
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
   
    
    @IBAction func addTasks(_ sender: UIBarButtonItem) {
        // set up alert
        let controllerAlert = UIAlertController(title: "Add A New Task", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        // set up all actions
       // let actionAdd = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: nil)
        let actionAdd = UIAlertAction(title: "Add", style: UIAlertAction.Style.default){ action in
            // get text
            // there is only one textfiled in the box
            // so it is the first one
            guard let text = controllerAlert.textFields?.first?.text
                else {
                    // stop teh action if there is any failure
                    return
            }
            // create task
            let task = Task(name : text)
            
            // push task to store
            // add the new task to the top of the list
            self.taskStore.add(task, at: 0)
            
            // update the view controller
            // new task is at ongoing category which is section 0 in the task store
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with:  UITableView.RowAnimation.fade )
            
            //persistent data
            // save
            TaskSave.save(self.taskStore.tasks)
            
        }
        // teh user is forced to enter some valid text
        // before the add button is enable
        actionAdd.isEnabled = false
        
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        // make a UI
        controllerAlert.addTextField { textField in
            textField.placeholder = "Enter the task name"
            textField.addTarget(self, action: #selector(self.textFieldHandler), for: UIControl.Event.editingChanged)
        }
        
        // add actions to controlller
        // first action
        controllerAlert.addAction(actionAdd)
        // second action
        controllerAlert.addAction(actionCancel)
        
        // show the UI
        present(controllerAlert, animated: true, completion: nil)
    }
    
    
    // add action to a specific target, which is the textfield in the alert controller
    // we have to use object-c
    @objc func textFieldHandler(_ sender : UITextView){
        
        // geet the controller
        
        // get the control of the caller
        guard let controller = presentedViewController as? UIAlertController,
            // actionAdd is the first action which is add to the controller
                let actionAdd = controller.actions.first,
                let text = sender.text
            else {
                // stop the function if one of above task fails
                return
        }
        
        // trim text from all white space
        // disable add button if the result is an empty string
        if text.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
            actionAdd.isEnabled = false
        } else {
            actionAdd.isEnabled = true
        }
        
        
        
        
    }
}

// MARK: - delegate

extension TasksController{
    
    // edit the selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // set up alert
        let controllerAlert = UIAlertController(title: "Alter The Task", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        // set up all actions
     
        let actionEdit = UIAlertAction(title: "Edit", style: UIAlertAction.Style.default){ action in
            // get text
            // there is only one textfiled in the box
            // so it is the first one
            guard let text = controllerAlert.textFields?.first?.text
                else {
                    // stop teh action if there is any failure
                    return
            }
            
            // update name
            self.taskStore.tasks[indexPath.section][indexPath.row].name = text
            
            // reload view controller
            self.tableView.reloadRows(at: [indexPath], with:  UITableView.RowAnimation.fade )
            
            //persistent data
            // save
            TaskSave.save(self.taskStore.tasks)
            
        }
        // teh user is forced to enter some valid text
        // before the add button is enable
        actionEdit.isEnabled = false
        
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        // make a UI
        controllerAlert.addTextField { textField in
            textField.text = self.taskStore.tasks[indexPath.section][indexPath.row].name
            textField.addTarget(self, action: #selector(self.textFieldHandler), for: UIControl.Event.editingChanged)
        }
        
        // add actions to controlller
        // first action
        controllerAlert.addAction(actionEdit)
        // second action
        controllerAlert.addAction(actionCancel)
        
        // show the UI
        present(controllerAlert, animated: true, completion: nil)
        
        
    }
    
    // swipe from right to left
    // to remove the task
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: UIContextualAction.Style.destructive, title: nil) { (action, sourceView, completionHandler) in
            // deleted the task if is had been done
            guard let done = self.taskStore.tasks[indexPath.section][indexPath.row].done
                else{
                    return
            }
            
            // remove the task from store
            self.taskStore.eliminate(at: indexPath.row, done: done)
            
            // reload the view
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
            //persistent data
            // save
            TaskSave.save(self.taskStore.tasks)
            
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
       
        
        let action = UIContextualAction(style: UIContextualAction.Style.normal, title: nil) { (action, sourceView, completionHandler) in
            
                // toggle the task as being done
               // print(self.taskStore.tasks[indexPath.section][indexPath.row].name)
                self.taskStore.tasks[0][indexPath.row].done = true
                
                // get that task
                let task = self.taskStore.eliminate(at: indexPath.row)
                
                // remove row from the view
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
               
                // add task to done section
                self.taskStore.add(task, at: 0, done: true)
                
                // insert row to view
                tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: UITableView.RowAnimation.automatic)
            
            //persistent data
            // save
            TaskSave.save(self.taskStore.tasks)
            
            completionHandler(true)
        }
        
        action.backgroundColor = #colorLiteral(red: 0.6219166541, green: 0.8359386541, blue: 0.1170023125, alpha: 1)
        
        if indexPath.section == 0 {
            return  UISwipeActionsConfiguration(actions: [action])       }
        
        return nil
    }
    
    // height of section header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
}

// MARK: - datasource

extension TasksController{
    
    // show header of each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "On-going"
        }
        return "Done"
    }
    
    // return number of section in task store
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    
    // return number of task per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // show nmber of rows on screen
        return taskStore.tasks[section].count
    }
    
    // return the cell that matches the content of a cell in a task of task store
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // modify it
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name
        return cell
    }
}
