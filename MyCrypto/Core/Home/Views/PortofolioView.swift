//
//  PortofolioView.swift
//  MyCrypto
//
//  Created by Micheal on 05/12/2024.
//

import SwiftUI

struct PortofolioView: View {
    @EnvironmentObject var vm: HomeViewModel
    @State var selectedCoin: Coin?
    @State var amountText: String = ""
    @State var showCheckMark: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView() {
                VStack {
                    SearchBarView(searchText: $vm.searchText)
                
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portofolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portofolio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DismissButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    trailingNavigationButtons
                }
            }
            .onChange(of: vm.searchText) { oldValue, newValue in
                if newValue == "" {
                    selectedCoin = nil
                }
            }
        }
        
    }
}

#Preview {
    PortofolioView()
        .environmentObject(DeveloperPreview.instance.vm)
}

extension PortofolioView {
    private var coinLogoList: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(vm.searchText.isEmpty ? vm.portofolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .onTapGesture(perform: {
                            withAnimation {
                                updateCoin(coin: coin)
                            }
                        })
                        .padding(4)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    selectedCoin?.id == coin.id ?  Color.green :
                                        Color.clear,
                                    lineWidth: 1
                                )
                        }
                }
            }
            .frame(height: 120)
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
    
    private func updateCoin(coin: Coin) {
        selectedCoin = coin
        
        if let portofolioCoin = vm.portofolioCoins.first(where: {$0.id == coin.id}), let amount = portofolioCoin.currentHoldings {
            amountText = amount.description
        } else {
            amountText = ""
        }
    }
    
    private func calculateCurrentValue() -> Double {
        if let quantitiy = Double(amountText) {
            return quantitiy * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portofolioInputSection: some View {
        VStack {
            HStack {
                Text("Current price of \(selectedCoin?.symbol ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            .padding(.bottom)
            
            Divider()
            HStack {
                Text("Amount in Profile:")
                Spacer()
                TextField("Ex: 1.4", text: $amountText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            .padding(.vertical)
            
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(calculateCurrentValue().asCurrencyWith2Decimals())
            }
            .padding(.top)
        }
        .animation(nil, value: UUID())
        .padding()
        .font(.headline)
    }
    
    private var trailingNavigationButtons: some View{
        HStack {
            if showCheckMark {
                Image(systemName: "checkmark")
            }
            
            
            Button {
                saveButtonPressed()
            } label: {
                Text("save".uppercased())
            }
            .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(amountText) ? 1.0 : 0.0)

        }
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin, let amount = Double(amountText) else {return}
        
        // save logic
        vm.updatePortofolio(coin: coin, amount: amount)
        
        withAnimation(.easeIn) {
            showCheckMark = true
            
            selectedCoin = nil
            vm.searchText = ""
            amountText = ""
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        }
    }
}
