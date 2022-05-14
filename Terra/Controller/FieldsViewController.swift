//
//  MyFieldsController.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 2/05/22.
//

import UIKit

class FieldsViewController: UITableViewController {
    
    var terraManager = TerraManager()
    var fieldsName : [String] = []
    var fieldsCoordinates : [[[Double]]] = []
    var fieldsCenter : [[Double]] = []
    var fieldsArea : [Double] = []
    
    func loadFieldNames(){
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        terraManager.delegate = self
        terraManager.getUrl()
        terraManager.fetchFields()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldsName.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.row < fieldsName.count
        {
            cell.textLabel?.text = fieldsName[indexPath.row]
            cell.textLabel?.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.numberOfLines = 0
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToDetail", sender: self)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let destinationVC = segue.destination as! FieldDetailController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.name = fieldsName[indexPath.row]
            destinationVC.coordinates = fieldsCoordinates[indexPath.row]
            destinationVC.center = fieldsCenter[indexPath.row]
            destinationVC.area = fieldsArea[indexPath.row]
        }
    }
}

//MARK: - FieldsManagerDelegate

extension FieldsViewController : TerraManagerDelegate{
    
    func didUpdateFields(_ fieldsManager: TerraManager, fields: FieldsModel){
        
        DispatchQueue.main.async {
            self.fieldsName = fields.mdlName
            self.fieldsCoordinates = fields.mdlCoordinates
            self.fieldsCenter = fields.mdlCenter
            self.fieldsArea = fields.mdlArea
            self.loadFieldNames()
        }
    }
    
    func didFailWithError(error: Error) {
        print("FieldsManagerDelegate error: \(error)")
    }
}


