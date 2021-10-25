//
//  ContentView.swift
//  FirstApp
//
//  Created by Lucas Inocencio on 05/07/21.
//

import SwiftUI

struct ContentView: View {
    @State var text = ""
    var body: some View {
        VStack {
            TextField("Informe seu nome", text: $text)
                .padding()
                .border(Color.black)
            
            Text("Olá, \(text)")
                .font(.largeTitle)
                .foregroundColor(Color.purple)
                .multilineTextAlignment(.center)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
