//
//  CloudKitCRUDView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 4.06.2022.
//

import SwiftUI
import CloudKit
import Combine

protocol CloudKitableProtocol {
    init?(record: CKRecord)
    var record: CKRecord { get }
}

struct FruitModel: Hashable, CloudKitableProtocol {
    let name: String
    let imageURL: URL?
    let record: CKRecord
    
    init?(record: CKRecord) {
        guard let name = record["name"] as? String else { return nil }
        self.name = name
        let imageAsset = record["image"] as? CKAsset
        self.imageURL = imageAsset?.fileURL
        self.record = record
    }
    
    init?(name: String, imageURL: URL?) {
        let record = CKRecord(recordType: "Fruits")
        record["name"] = name
        if let url = imageURL {
            let asset = CKAsset(fileURL: url)
            record["image"] = asset
        }
        self.init(record: record)
    }
    
    func update(newName: String) -> FruitModel? {
        let record = record
        record["name"] = newName
        return FruitModel(record: record)
    }
}

class CloudKitCRUDViewModel: ObservableObject {
    
    @Published var text: String = ""
    @Published var fruits: [FruitModel] = []
    var cancellables = Set<AnyCancellable>()
        
    init() {
        fetchItems()
    }
    
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        
        addItem(name: text)
        
    }
    
    private func addItem(name: String) {
        
        guard
            let image = UIImage(named: "thumb"),
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("thumb.png"),
            let data = image.pngData()
        else { return  }
        
        do {
            try data.write(to: url)
            guard let newFruit = FruitModel(name: name, imageURL: url) else { return }
            CloudKitUtility.add(item: newFruit) { result in
                DispatchQueue.main.async { [weak self] in
                    self?.fetchItems()
                }
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
    private func saveItem(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
            
            DispatchQueue.main.async {
                self?.text = ""
                self?.fetchItems()
            }
        }
    }
    
    func fetchItems() {
        
        // let predicate = NSPredicate(value: true)
        // let query = CKQuery(recordType: "Fruit", predicate: predicate)
        // query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        // query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        // let queryOperation = CKQueryOperation(query: query)
        //queryOperation.resultsLimit = 2
        
        let predicate = NSPredicate(format: "name = %@", argumentArray: ["Coconut"])
        
        CloudKitUtility.fetch(predicate: predicate, recordType: "Fruits")
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self]  returnedItems in
                self?.fruits = returnedItems
            }
            .store(in: &cancellables)

                
    }
        
    func updateItem(fruit: FruitModel) {
        guard let newFruit = fruit.update(newName: "NEW NAME!!!") else { return }
        CloudKitUtility.update(item: newFruit) { [weak self] result in
            self?.fetchItems()
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        let fruit = fruits[index]
        CloudKitUtility.delete(item: fruit)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] success in
                self?.fruits.remove(at: index)
            }
            .store(in: &cancellables)

    }
}

struct CloudKitCRUDView: View {
    
    @StateObject private var vm = CloudKitCRUDViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                header
                textField
                addButton

                List {
                    ForEach(vm.fruits, id: \.self) { fruit in
                            HStack {
                                Text(fruit.name)
                                if let url = fruit.imageURL, let data = try? Data(contentsOf: url),
                                   let image = UIImage(data: data)
                                {
                                    Image(uiImage: image)
                                        .resizable()
                                    frame(width: 50, height: 50)
                                }
                                    
                            }
                            .onTapGesture {
                                vm.updateItem(fruit: fruit)
                            }
                    }
                    .onDelete(perform: vm.deleteItem)
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

struct CloudKitCRUDView_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitCRUDView()
    }
}


extension CloudKitCRUDView {
    
    private var header: some View {
        Text("CloudKit Cloud☁☁☁")
            .font(.headline)
            .underline()
    }
    
    private var textField: some View {
        TextField("Add something here...", text: $vm.text)
            .frame(height: 55)
            .padding(.leading)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
    }
    
    private var addButton: some View {
        Button {
            vm.addButtonPressed()
        } label: {
            Text("Add")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.pink)
                .cornerRadius(10)
        }
    }
}
