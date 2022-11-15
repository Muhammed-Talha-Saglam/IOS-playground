//
//  PortfolioDataView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 14.11.2022.
//

import SwiftUI

struct PortfolioDataView: View {

    @FetchRequest(sortDescriptors: [SortDescriptor(\.amount)])
    private var myPortfolio: FetchedResults<PortfolioEntity>
    @Environment(\.managedObjectContext) var viewContext

    var body: some View {
        NavigationStack {

                List(myPortfolio) { portFolio in
                    Text("\(portFolio.amount)")
                        .foregroundColor(.black)
            }
            .navigationTitle("Portfolio")
            .toolbar {
                Button {
                    let entity = PortfolioEntity(context: viewContext)
                    entity.counID = UUID().uuidString
                    entity.amount = Double.random(in: 0...100)

                    do {
                        try viewContext.save()
                    } catch let error {
                        print("Error saving data: \(error)")
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }


}

struct PortfolioDataView_Previews: PreviewProvider {

    static var previews: some View {
        PortfolioDataView()
            .environment(\.managedObjectContext, PortfolioDataService().container.viewContext)
    }
}
