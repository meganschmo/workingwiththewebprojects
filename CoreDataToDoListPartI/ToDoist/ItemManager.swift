//
//  ItemManager.swift
//  ToDoist
//
//  Created by Parker Rushton on 10/21/22.
//

import Foundation
import CoreData
protocol ItemManagerDelegate: AnyObject {
    func refreshData()
}

    class ItemManager {
        static let shared = ItemManager()
        weak var delegate: ItemManagerDelegate?
        
        
        private func fetchItems(matching predicate: NSPredicate) -> [Item] {
            let fetchRequest = Item.fetchRequest()
            fetchRequest.predicate = predicate
            //        fetchRequest.sortDescriptors = [sortDescriptor]
            do {
                let context = PersistenceController.shared.viewContext
                return try context.fetch(fetchRequest)
            } catch {
                print("Error fetching items: \(error)")
                return []
            }
        }
        func fetchIncompleteItems() -> [Item] {
            return fetchItems(matching: NSPredicate(format: "completedAt == nil"))
        }
        func fetchCompletedItems() -> [Item] {
            return fetchItems(matching: NSPredicate(format: "completedAt != nil"))
        }
        // Create
        
        func createNewItem(with title: String) {
            let newItem = Item(context: PersistenceController.shared.viewContext)
            newItem.id = UUID().uuidString
            newItem.title = title
            newItem.createdAt = Date()
            newItem.completedAt = nil
            PersistenceController.shared.saveContext()
            delegate?.refreshData()
        }
        
        // Retrieve
        
//        func incompleteItems() -> [Item] {
//            let incomplete = allItems.filter { $0.completedAt == nil }
//            return incomplete.sorted(by: { $0.sortDate >  $1.sortDate })
//        }
//        
//        func completedItems() -> [Item] {
//            let completed = allItems.filter { $0.completedAt != nil }
//            return completed.sorted(by: { $0.sortDate >  $1.sortDate })
//        }
        
        // Update
        
        //    func toggleItemCompletion(_ item: Item) {
        //        var updatedItem = item
        //        updatedItem.completedAt = item.isCompleted ? nil : Date()
        //        if let index = allItems.firstIndex(of: item) {
        //            allItems.remove(at: index)
        //        }
        //        allItems.append(updatedItem)
        //    }
        func toggleItemCompletion(_ item: Item) {
            item.completedAt = item.isCompleted ? nil : Date()
            PersistenceController.shared.saveContext()
            delegate?.refreshData()
        }
        
        // Delete
        func remove(_ item: Item) {
            let context = PersistenceController.shared.viewContext
            context.delete(item)
            PersistenceController.shared.saveContext()
            delegate?.refreshData()
        }
//            func delete(at indexPath: IndexPath) {
//                remove(item(at: indexPath))
//            }
        //
        //    func remove(_ item: Item) {
        //        guard let index = allItems.firstIndex(of: item) else { return }
        //        allItems.remove(at: index)
        //    }
        //
        //    private func item(at indexPath: IndexPath) -> Item {
        //        let items = indexPath.section == 0 ? incompleteItems() : completedItems()
        //        return items[indexPath.row]
        //    }
        
    }

