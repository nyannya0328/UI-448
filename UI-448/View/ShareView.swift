//
//  ShareView.swift
//  UI-448
//
//  Created by nyannyan0328 on 2022/02/04.
//

import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    
    var items : [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        
        let view = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        return view
        
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}


