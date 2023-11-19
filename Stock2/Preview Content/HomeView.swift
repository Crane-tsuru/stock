//
//  ContentView.swift
//  stock
//
//  Created by 鶴見駿 on 2023/09/12.
//

import SwiftUI

struct ContentView: View {
    @State var stocks: [Stock]
    @State private var editting = false
    @State var text: String = ""
    
    
    var body: some View {

        
        NavigationStack {
            List(stocks) { stock in
                NavigationLink(destination:
                                stockDataView(stock: stock)) {
                    Text("\(stock.metaData.Symbol)")
                }
            }
            .navigationTitle("company_names")
            .toolbar {
                Button(action: {
                    editting = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $editting) {
            EdittingView(editting: $editting, text: $text ,stocks: $stocks)
        }
        .onAppear() {
            loadStocks(stocks: stocks)
        }
    }
    
    func loadStocks(@State stocks: [Stock]) {
        if let savedStocks = UserDefaults.standard.data(forKey: "Stocks") {
            if let decodedStocks = try? JSONDecoder().decode([Stock].self, from: savedStocks) {
                stocks = decodedStocks
            } else {
                stocks = []
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject static var viewModel = AlphavantageViewModel()
    static var previews: some View {
        ContentView(stocks: Stock.exampleStocks)
    }
}
