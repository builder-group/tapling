//
//  HomeView.swift
//  Tapling
//
//  Created by Benno on 04.12.25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Query(sort: \KeyboardSession.createdAt, order: .reverse) private var sessions: [KeyboardSession]
    
    var totalKeystrokes: Int {
        sessions.reduce(0) { $0 + $1.keystrokeCount }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Summary
                VStack(alignment: .leading, spacing: 8) {
                    Text("Keyboard Sessions")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Total Sessions: \(sessions.count)")
                        .font(.headline)
                    
                    Text("Total Keystrokes: \(totalKeystrokes)")
                        .font(.headline)
                }
                .padding()
                
                Divider()
                
                // Session List
                if sessions.isEmpty {
                    Text("No sessions yet")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(Array(sessions.prefix(20))) { session in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(session.keystrokeCount) keystrokes")
                                .font(.headline)
                            
                            Text("\(session.startDate.formatted(date: .abbreviated, time: .shortened)) - \(session.endDate.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
        .previewDataContainer()
}
