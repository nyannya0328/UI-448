//
//  Home.swift
//  UI-448
//
//  Created by nyannyan0328 on 2022/02/04.
//

import SwiftUI

struct Home: View {
    @State var selectedColor : Color = .white
    @State var showPicker : Bool = false
    
    @State var isRecording : Bool = false
    
    @State var  url : URL?
    
    @State var shareView : Bool = false
    var body: some View {
        ZStack{
            
            
            Rectangle()
                .fill(selectedColor)
                .ignoresSafeArea()
            
            Button {
                
                withAnimation{
                    
                    showPicker.toggle()
                }
                
            } label: {
                
                Text("Show Image Picker")
                    .font(.largeTitle.weight(.black))
                    .foregroundColor(selectedColor.isDarkColor ? .white : .black)
                
            }

            
        }
        .imageColorPicker(showPicker: $showPicker, color: $selectedColor)
        .overlay(alignment: .bottomTrailing) {
            
            
            Button {
                
                
                if isRecording{
                    
                    
                    
                    Task{
                        
                        stopRecordingWidthEdit()
                        
                        
                        do{
                            
                            self.url = try await stopRecording()
                            
                            isRecording = false
                            
                            shareView.toggle()
                            
                            
                        
                            
                            
                        }
                        catch{
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                }
                else{
                    
                    
                    startRecoding { error in
                        if let error = error{
                            
                            
                            print(error.localizedDescription)
                            
                           
                        }
                        isRecording = true
                    }
                }
               
                
            } label: {
                
                
                
                Image(systemName:isRecording ?  "record.circle.fill" : "record.circle")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(isRecording ? .red : .black)
            
                
                
                
                
                
            }
            .padding(.trailing,20)

            
            
            
        }
        .shareSheet(show: $showPicker, items: [url])
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
