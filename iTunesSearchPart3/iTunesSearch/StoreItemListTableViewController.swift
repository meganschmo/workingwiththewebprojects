
import UIKit

@MainActor
class StoreItemListTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
     
    var storeItemController = StoreItemController()
    // add item controller property
    
    var items = [StoreItem]()
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    let queryOptions = ["movie", "music", "software", "ebook"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func fetchMatchingItems() {
        
        self.items = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]
        
        if !searchTerm.isEmpty {
            let query: [String: String] = [
                "term": searchTerm,
                "media": mediaType,
                "lang": "en_us",
                "limit": "10"
            ]

            Task {
                do {
                    let storeItems = try await storeItemController.fetchStoreItems(matching: query)
                        self.items = storeItems
                        self.tableView.reloadData()
                    
                    
                    
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            // set up query dictionary
            
            // use the item controller to fetch items
            // if successful, use the main queue to set self.items and reload the table view
            // otherwise, print an error to the console
        }
    }
    
    func configure(cell: ItemCell, forItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        cell.name = item.name
        cell.artist = item.artist
        cell.artworkImage = nil
        
        let task = Task {
            do {
                let imageData = try await fetchArtworkImage(for: item.artworkURL!)
                if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath == indexPath {
                    cell.artworkImage = UIImage(data: imageData)
                }
            } catch {
                print("Error fetching artwork image: \(error.localizedDescription)")
            }
        }
            imageLoadTasks[indexPath] = task

        // set cell.name to the item's name
        
        // set cell.artist to the item's artist
        
        // set cell.artworkImage to nil
        
        // initialize a network task to fetch the item's artwork keeping track of the task
        // in imageLoadTasks so they can be cancelled if the cell will not be shown after
        // the task completes.
        //
        // if successful, set the cell.artworkImage using the returned image
    }
    func fetchArtworkImage(for url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }

    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        
        fetchMatchingItems()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // cancel the image fetching task if we no longer need it
        imageLoadTasks[indexPath]?.cancel()
    }
}

extension StoreItemListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        fetchMatchingItems()
        searchBar.resignFirstResponder()
    }
}

