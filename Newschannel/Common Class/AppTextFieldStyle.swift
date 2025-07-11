//
//  AppTextFieldStyle.swift
//  Newschannel
//
//  Created by apple on 10/07/25.
//


import SwiftUI

struct AppTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .font(.system(size: 16))
    }
}
