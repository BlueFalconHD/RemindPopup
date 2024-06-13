//
//  PopupWindowContentView.swift
//  RemindPopup
//
//  Created by Hayes Dombroski on 6/13/24.
//

import SwiftUI

class PopupContentViewModel: ObservableObject {
    @Published var openTime: Date
    @Published var remainingTime: Double
    var timer: Timer?
    var onTimeout: () -> Void
    
    
    init(openTime: Date, duration: Double, onTimeout: @escaping () -> Void) {
        self.openTime = openTime
        self.remainingTime = duration
        self.onTimeout = onTimeout
    }
    
    func startTimer() {
        print("INFO :: Popup startTimer() called")
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 0.1
            } else {
                self.stopTimer()
                self.onTimeout()
            }
        }
    }
    
    func stopTimer() {
        print("INFO :: Popup stopTimer() called")
        
        timer?.invalidate()
        timer = nil
    }
}

struct PopupContentView: View {
    @ObservedObject var viewModel: PopupContentViewModel

    var appSettings: AppSettings = AppSettings()
    
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                Text("\(appSettings.popupQuoteToShow)")
                    .font(.largeTitle)
                Spacer()
            }
            .padding()
            Spacer()
            HStack {
                Image(systemName: "hourglass")
                Text("\(formattedRemainingTime)")
            }
            .padding()
            .font(.headline)
            .foregroundStyle(.secondary)
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
    
    private var formattedRemainingTime: String {
        let time = Int(viewModel.remainingTime)
        let hours = time / 3600
        let minutes = (time % 3600) / 60
        let seconds = time % 60
        
        var timeComponents: [String] = []
        if hours > 0 { timeComponents.append("\(hours)h") }
        if minutes > 0 { timeComponents.append("\(minutes)m") }
        if seconds > 0 || timeComponents.isEmpty { timeComponents.append("\(seconds)s") }
        
        return timeComponents.joined(separator: " ")
    }
}

#Preview {
    PopupContentView(viewModel: PopupContentViewModel(openTime: Date(), duration: 1, onTimeout: {
        print("timeout")
    }))
}
