//
//  StatisticView.swift
//  MyCrypto
//
//  Created by Micheal on 04/12/2024.
//

import SwiftUI

struct StatisticView: View {
    let stat: Statistic
    
    var body: some View {
        VStack {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(.accent)
            HStack (spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (stat.percentageChange ?? 0) >= 0.0 ? 0.0 : 180)
                    )
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .opacity(stat.percentageChange != nil ? 1.0 : 0.0)
            .foregroundStyle((stat.percentageChange ?? 0) >= 0.0 ? Color(.green) : Color(.red))
            
        }
    }
}

#Preview (traits: .sizeThatFitsLayout) {
    StatisticView(stat: DeveloperPreview.instance.stat1)
}
