//
//  ViewController.swift
//  iOS_Final_Project
//
//  Copyright © 2018 Team TCH. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //var data : [String] = ["Row1", "Row2", "Row3", "#POUNDINGIT"]
    var data : [String] = []
    var selectedRow : Int = -1
    var newRowText : String = ""
    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //table.delegate = self //optional because it was done via drag and dropping
        self.title = "Notes"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        load()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //print("Row: \(indexPath.row) Section \(indexPath.section) value\(data[indexPath.row])")\
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //Creating object cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "mycell")! //works VERY differently than UITableViewCell(), the rows are queued and then dequeued from a stack, rather than deleted and regenerated like with UITableViewCell
        //To be used, a prototype cell must be created from the tableview, and then access the prototype cell and rename the identifier as the same as listed above: "mycell"
        
        //let cell : UITableViewCell = UITableViewCell() //it is let becuase the location of the variable 'cell' will never change; only the value which is changed via the next line
        
        cell.textLabel!.text = data[indexPath.row] //'!' is used since we know for SURE that it will never be nil
        //'?' is used in the case when a value retrival could potentially be nil
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
        save()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let refToDetailVC : DetailViewController = segue.destination as! DetailViewController
        
        refToDetailVC.refToSourceVC = self
        selectedRow = (table.indexPathForSelectedRow?.row)!
        
        refToDetailVC.setText(t: data[selectedRow])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if selectedRow == -1 {
            return
        }
        data[selectedRow] = newRowText
        
        if newRowText == "" {
            data.remove(at: selectedRow)
        }
        table.reloadData()
        save()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addNote(){
        if (table.isEditing){
            return
        }
        let name : String = "Row \(data.count + 1)"
        data.insert(name, at: 0)
        let indexPath : IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "detail", sender: nil)
        //save()
    }
    
    func save(){
        //Easiest way to save data
        UserDefaults.standard.set(data, forKey: "mynotes")
        UserDefaults.standard.synchronize()
        
    }
    
    func load(){
        if let loadedData = UserDefaults.standard.value(forKey: "mynotes") as? [String]{
            data = loadedData
            table.reloadData()
        }
    }


}

