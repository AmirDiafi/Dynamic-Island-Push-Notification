//
//  DynamicIsland.swift
//  Dynamic Island
//
//  Created by mac on 10/10/22.
//

import SwiftUI

//Mark: Make sure to put this in the top of your View.
struct DynamicIslandNotification: View {
    let width = UIScreen.main.bounds.width
    @State var isOpen: Bool = false
    let value: NotificationValue
    
    var body: some View {
        ZStack {
        }
        .background(
            HStack(spacing: 20) {
                Image("tony_stark")
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 65, height: 65)
                    .cornerRadius(20)
                VStack(alignment:.leading) {
                    Text(value.content?.title ?? "Tony Stark Message")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(value.content?.subtitle ?? "This is Iron Man!")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
                Spacer()
            }
            .padding(20)
            .opacity(isOpen ? 1 : 0)
            .frame(
                width: isOpen ? width*0.95 : Constants.width,
                height: isOpen ? 100 : Constants.height
            )
            .padding(.vertical, isOpen ? 10 : 0)
            .background(Color.primary)
            .cornerRadius(Constants.corner)
        )
        .position(
            x: width/2,
            y: isOpen ? 110/2+11 : 11 + Constants.height/2
        )
        .ignoresSafeArea(.all)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    isOpen.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    withAnimation {
                        isOpen.toggle()
                    }
                }
            }
        }
        
    }
}


struct Constants {
    static let width: CGFloat = 126.0
    static let height: CGFloat = 37.33
    static let corner: CGFloat = 45
}

struct Previews_DynamicIslandNotification_Previews: PreviewProvider {
    static var previews: some View {
        DynamicIslandNotification(isOpen: true, value: NotificationValue(content: nil, imageName: nil))
    }
}
