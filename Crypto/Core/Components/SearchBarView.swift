//
//  SearchBarView.swift
//  Crypto
//
//  Created by parth kanani on 08/07/24.
//

import SwiftUI

struct SearchBarView: View 
{
    @Binding var searchText: String
    
    var body: some View
    {
        HStack
        {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ?
                    Color.theme.secondaryText : Color.theme.accent
                )
            
            TextField("Search by name or symbol...", text: $searchText)
                .autocorrectionDisabled(true) // this removes the correction suggestion from keyboard
                .foregroundStyle(Color.theme.accent)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.theme.accent)
                        .padding()
                        .offset(x: 10)
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                    , alignment: .trailing
                )
            
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.20),
                        radius: 10, x: 0.0, y: 0.0)
        )
        .padding()
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
