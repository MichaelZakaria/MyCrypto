//
//  HomeStateView.swift
//  MyCrypto
//
//  Created by Micheal on 04/12/2024.
//

import SwiftUI

struct HomeStateView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    @Binding var showPortofolio: Bool
    
    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortofolio ? .trailing : .leading)
    }
}

#Preview {
    HomeStateView(showPortofolio: .constant(false))
}
