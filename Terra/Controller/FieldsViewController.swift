//
//  MyFieldsController.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 2/05/22.
//

import UIKit

class FieldsViewController: UITableViewController {
    
    var terraManager = TerraManager()
    var fieldsModel = FieldsModel()
    
    func loadFieldNames(){
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        terraManager.delegate = self
        terraManager.getSecrets()
        terraManager.fetchFields()
        
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return fieldsName.count + 1
        return fieldsModel.mdlName!.count + 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //if indexPath.row < fieldsName.count
        if indexPath.row < fieldsModel.mdlName!.count
        {
            //            cell.textLabel?.text = fieldsName[indexPath.row]
            cell.textLabel?.text = fieldsModel.mdlName![indexPath.row]
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
            
            
            destinationVC.name = fieldsModel.mdlName![indexPath.row]
            destinationVC.coordinates = fieldsModel.mdlCoordinates![indexPath.row]
            destinationVC.center = fieldsModel.mdlCenter![indexPath.row]
            destinationVC.area = fieldsModel.mdlArea![indexPath.row]
            destinationVC.polygonId = fieldsModel.mdlId![indexPath.row]
           
            
        }
    }
    
}
extension FieldsViewController : TerraManagerDelegate{
    
    func didUpdateFields(_ fieldsManager: TerraManager, fields : FieldsModel){
        
        fieldsModel = fields
        DispatchQueue.main.async {
            self.loadFieldNames()
        }
    }
    
    func didFailWithError(error: Error) {
        print("FieldsManagerDelegate error: \(error)")
    }
}

