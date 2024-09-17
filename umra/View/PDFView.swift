//
//  PDFView.swift
//  umra
//
//  Created by Akhmed on 12.02.23.
//



/*
 import SwiftUI
 import PDFKit

 // MARK: - Model

 struct PDFDocumentModel: Identifiable {
     var id: String { fileName }
     let fileName: String
     let displayName: String
 }

 // MARK: - Main View

 struct PDFViewWrapper: View {
     @State private var isPDFViewerPresented: Bool = false
     private let documents: [PDFDocumentModel] = [
         PDFDocumentModel(fileName: "hadj_i_umra", displayName: "Обряды хаджа и умры"),
         PDFDocumentModel(fileName: "hadj_proroka", displayName: "Хадж Пророка"),
         PDFDocumentModel(fileName: "", displayName: "")
     ]
     
     
     var body: some View {
         NavigationView {
             GeometryReader { geometry in
                 List(documents) { document in
                     VStack {
                         NavigationLink(destination: PDFViewScreen(pdfFileName: document.fileName)) {
                             HStack {
                                 ImageViewRepresented(image: firstPageOfPDF(named: document.fileName))
                                     .frame(width: geometry.size.width * 0.35, height: geometry.size.width * 0.5)
                                     .background(.white)
                                     .clipShape(RoundedRectangle(cornerRadius: 5))
                                     .shadow(radius: 5)
                                 
                                 Text(document.displayName)
                                     .font(.headline)
                                     .foregroundColor(.primary)
                                     .frame(maxWidth: .infinity, alignment: .leading)
                                     .padding(.horizontal, 8)
                             }
                         }
                         .frame(maxWidth: .infinity)
                     }
                 }
             }
         }
         .navigationViewStyle(StackNavigationViewStyle())
     }
 }

 // MARK: - PDF View Screen

 struct PDFViewScreen: View {
     var pdfFileName: String
     @Environment(\.presentationMode) var presentationMode
     @State private var isShowingPDFsList = true
     
     var body: some View {
         VStack {
             PDFViewRepresented(pdfFileName: pdfFileName)
                 .background(Color.white.ignoresSafeArea())
                 .navigationBarBackButtonHidden(true)
             
             Spacer()
             
             Button(action: {
                 if self.isShowingPDFsList {
                     self.presentationMode.wrappedValue.dismiss()
                 }
             }) {
                 Text(self.isShowingPDFsList ? Image(systemName: "arrowshape.turn.up.backward.fill") : Image(systemName: ""))
                     .font(.headline)
                     .foregroundStyle(.blue)
                     .padding()
                 Spacer()
             }
         }
         .onAppear {
             self.isShowingPDFsList = true
         }
     }
 }

 // MARK: - UIViewRepresentable for PDF View

 struct PDFViewRepresented: UIViewRepresentable {
     var pdfFileName: String
     
     func makeUIView(context: Context) -> PDFView {
         let pdfView = PDFView()
         if let url = Bundle.main.url(forResource: pdfFileName, withExtension: "pdf") {
             pdfView.document = PDFDocument(url: url)
         }
         pdfView.autoScales = true
         pdfView.displayMode = .singlePageContinuous
         pdfView.backgroundColor = UIColor.white
         return pdfView
     }
     
     func updateUIView(_ uiView: PDFView, context: Context) {
 //        if uiView.document != nil {
 //            uiView.scaleFactor = uiView.scaleFactorForSizeToFit
 //        }
     }
 }

 // MARK: - Helper function for obtaining the first page of PDF as UIImage

 func firstPageOfPDF(named fileName: String) -> UIImage? {
     guard let url = Bundle.main.url(forResource: fileName, withExtension: "pdf"),
           let document = PDFDocument(url: url),
           let page = document.page(at: 0) else {
         return nil
     }
     
     let pageSize = page.bounds(for: .mediaBox)
     let renderer = UIGraphicsImageRenderer(size: pageSize.size)
     return renderer.image { ctx in
         ctx.cgContext.translateBy(x: 0, y: pageSize.height)
         ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
         
         page.draw(with: .mediaBox, to: ctx.cgContext)
     }
 }

 // MARK: - ImageViewRepresented

 struct ImageViewRepresented: View {
     let image: UIImage?
     
     var body: some View {
         if let image = image {
             Image(uiImage: image)
                 .resizable()
                 .aspectRatio(contentMode: .fill)
         } else {
             Image(systemName: "doc")
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .padding(20)
         }
     }
 }
 */





















//struct PDFView_Previews: PreviewProvider {
//    static var previews: some View {
//        PDFViewWrapper()
//    }
//}
