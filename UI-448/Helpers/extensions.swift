//
//  extensions.swift
//  UI-448
//
//  Created by nyannyan0328 on 2022/02/04.
//

import SwiftUI
import PhotosUI
import ReplayKit


extension View{
    
    func getRootView()->UIViewController{
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            
            return .init()
        }
        
        guard let rootView = screen.windows.first?.rootViewController else{
            
            return .init()
        }
        
        return rootView
    }
    
    
    func imageColorPicker(showPicker : Binding<Bool>,color : Binding<Color>)->some View{
        
        
        return self
            .fullScreenCover(isPresented: showPicker) {
                
            } content: {
                
                
                Helper(color: color, showPicker: showPicker)
                
                
               
            }


    }
    
    
    func startRecoding(enableMicroPhone : Bool = false,competition : @escaping(Error?) -> ()){
        
        let recoder = RPScreenRecorder.shared()
        recoder.isMicrophoneEnabled = false
        recoder.startRecording(handler: competition)
        
        
        
        
    }
    
    func stopRecording() async throws -> URL{
        
        
        let name = UUID().uuidString + " .mov"
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name)
        
        
        let recorder = RPScreenRecorder.shared()
        
        try await recorder.stopRecording(withOutput: url)
        
        
        return url
        
        
        
        
    }
    
    func shareSheet(show : Binding<Bool>,items : [Any?])->some View{
        
        return self
        
        
            .fullScreenCover(isPresented: show) {
                
            } content: {
                
                let items = items.compactMap { item -> Any? in
                    return item
                }
                
                if !items.isEmpty{
                    
                    ShareView(items: items)
                }
                
                
                
            }

        
        
        
    }
    
    func stopRecordingWidthEdit(){
        
        let recoder = RPScreenRecorder.shared()
        let delegate = ReplayDelegate()
        
        
        recoder.stopRecording { controller, err in
            
            
            if let cont = controller{
                
                cont.modalPresentationStyle = .fullScreen
                cont.previewControllerDelegate = delegate
                DispatchQueue.main.async {
                    
                    getRootView().present(cont, animated: true)
                
                    
                }
            }
            
          
        }
        
        
    }
    
    
    
    
    
    
    func cancelRecording(){
        let recorder = RPScreenRecorder.shared()
        recorder.discardRecording {
            
        }
        
        
    }
    
    
    
}

struct Helper : View{
    
    @Binding var color : Color
    @Binding var showPicker : Bool
    
    @State var showimagePicker : Bool = false
    @State var imageData : Data = .init(count: 0)
    
    var body: some View{
        
        NavigationView{
            
            
            VStack(spacing:20){
                
                GeometryReader{proxy in
                    
                    let size = proxy.size
                    
                    VStack(spacing:10){
                        
                        if let image = UIImage(data: imageData){
                            
                            
                        Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size.width, height: size.height)
                            
                            
                        }
                        else{
                            
                            
                            Image(systemName: "plus")
                                .font(.system(size: 15, weight: .bold))
                               
                            
                            Text("Tap To Image")
                                .font(.system(size: 15, weight: .bold))
                           
                            
                            
                        }
                      
                            

                    }
                  
                    .frame(maxWidth:.infinity,maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        
                        withAnimation{
                            
                            showimagePicker.toggle()
                        }
                        
                        
                    }
                
                    
                    
                }
                
                
                ZStack(alignment:.top){
                    
                    Rectangle()
                        .fill(color)
                        .frame(height: 90)
                    
                    CustomColorPicker(color: $color)
                        .frame(width: 100, height: 50,alignment: .topTrailing)
                        .clipped()
                        .offset(x: 20)
                    
                    
               
                    
                    
                    
                    
                    
                }
                
                
            }
            .ignoresSafeArea(.container, edges: .bottom)
            
            .navigationTitle("Image Color Picker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                Button("Cancel"){
                    
                    showPicker.toggle()
                }
            }
            .sheet(isPresented: $showimagePicker) {
                
            } content: {
                
                ImagePicker(showPicker: $showimagePicker, imageData: $imageData)
            }

          
              
        }
        
        
        
        
        
        
        
    }
}


struct ImagePicker : UIViewControllerRepresentable{
    
    @Binding var showPicker : Bool
    
    @Binding var imageData : Data
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let view = PHPickerViewController(configuration: config)
        view.delegate = context.coordinator
        
        return view
        
        

        
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
        
    }
    
    class Coordinator : NSObject,PHPickerViewControllerDelegate{
      
        
        var parent : ImagePicker
        
        init(parent : ImagePicker) {
            self.parent = parent
        }
        
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            if let first = results.first{
                
                
                first.itemProvider.loadObject(ofClass: UIImage.self) {[self] result, err in
                    
                    
                    guard let image = result as? UIImage else{
                        
                        parent.showPicker.toggle()
                        
                        return
                    }
                    
                    parent.imageData = image.jpegData(compressionQuality: 1) ?? .init(count: 0)
                    parent.showPicker.toggle()
                    
                }
                
                
            }
            
            else{
                
                parent.showPicker.toggle()
            }
            
            
        }
        
        
    }
    
    
}

struct CustomColorPicker : UIViewControllerRepresentable{
    
    @Binding var color : Color
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = false
        picker.title = ""
        picker.selectedColor = UIColor(color)
        picker.delegate = context.coordinator
        
        return picker
        
    }
    
    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {
        
        uiViewController.view.tintColor = (color.isDarkColor ? .white:.black)
        
        
    }
    
    class Coordinator : NSObject,UIColorPickerViewControllerDelegate{
        
        var parent : CustomColorPicker
        
        init(parent : CustomColorPicker) {
            self.parent = parent
        }
        
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            
            parent.color = Color(viewController.selectedColor)
            
        }
        
        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            
            parent.color = Color(color)
            
            
            
        }
        
        
    }
}

extension Color{
    
    var isDarkColor : Bool{
        
        return UIColor(self).isDarkColor
    }
    
    
}

extension UIColor{
    
    
    var isDarkColor : Bool{
        
        var (r, g, b, a): (CGFloat,CGFloat,CGFloat,CGFloat) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50
        
    }
}


class ReplayDelegate : NSObject,RPPreviewViewControllerDelegate{
    
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        
        previewController.dismiss(animated: true)
    }
}
