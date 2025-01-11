//
//  Styles.swift
//  Triangle
//
//  Created by Josef Zemlicka on 18.01.2025.
//

import SwiftUI


// TODO: Import Montserrat font and apply to the UI
// This will make the buttons more readable


struct NavbarButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 20)
            .padding()
            .foregroundColor(Color(hex: 0x4C708A))
            .font(.headline)
            .fontWeight(.black)
            .background(Color(hex: 0xD9D9D9))
            .foregroundStyle(.white)
            .cornerRadius(60)
            .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
    }
}

struct TrianglePrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 50, minHeight: 20, idealHeight: 20, maxHeight: 20)
            .padding(.vertical, 15)
            .foregroundColor(Color(hex: 0xDAE8F6))
            .font(.title2)
            .fontWeight(.black)
            .background(Color(hex: 0x4C708A))
            .foregroundStyle(.white)
            .cornerRadius(60)
            .overlay(
                RoundedRectangle(cornerRadius: 60)
                    .stroke(Color(hex: 0x4C708A), lineWidth: 3) // Optional border
            )
    }
}

struct TriangleSecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 20)
            .padding(.vertical, 15)
            .foregroundColor(Color(hex: 0x4C708A))
            .font(.title2)
            .fontWeight(.black)
            .background(Color(hex: 0xDAE8F6))
            .foregroundStyle(.white)
            .cornerRadius(60)
            .overlay(
                RoundedRectangle(cornerRadius: 60)
                    .stroke(Color(hex: 0xDAE8F6), lineWidth: 3) // Optional border
            )
    }
}

struct TriangleTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 20)
            .padding(.vertical, 15)
            .background(Color(hex: 0xD9D9D9, opacity: 0.1))
            .cornerRadius(60)
            .font(.title2)
            .fontWeight(.black)
            .foregroundColor(Color(hex: 0x4C708A)) // Text color
            .overlay(
                RoundedRectangle(cornerRadius: 60)
                    .stroke(Color(hex: 0x4C708A), lineWidth: 3) // Optional border
            )
            .multilineTextAlignment(.center)
            .autocapitalization(.none)
            .autocorrectionDisabled(true)
    }
}

