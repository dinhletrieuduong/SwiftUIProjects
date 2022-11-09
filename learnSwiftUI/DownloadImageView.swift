//
//  DownloadImageView.swift
//  learnSwiftUI
//
//  Created by LAP14482 on 01/11/2021.
//

import SwiftUI

struct DownloadImageView: View {
    let imageURL = URL(string: "https://blckbirds.com/wp-content/uploads/2021/10/pexels-kammeran-gonzalezkeola-6128227-2.jpg")
    var body: some View {
        if #available(iOS 15.0, *) {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 240)
                
                
            } placeholder: {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        } else {
                // Fallback on earlier versions
        }
        
        if #available(iOS 15.0, *) {
            AsyncImage(url: imageURL, transaction: .init(animation: .spring(response: 1.6))) { phase in
                switch phase {
                    case .empty:
                        ProgressView()
                            .progressViewStyle(.circular)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 240)
                    case .failure:
                        Text("Failed fetching image. Make sure to check your data connection and try again.")
                            .foregroundColor(.red)
                    @unknown default:
                        Text("Unknown error. Please try again.")
                            .foregroundColor(.red)
                }
            }
        } else {
                // Fallback on earlier versions
        }
    }
}

struct DownloadImageView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageView()
    }
}
