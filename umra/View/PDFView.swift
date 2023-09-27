//
//  PDFView.swift
//  umra
//
//  Created by Akhmed on 12.02.23.
//





import SwiftUI
import PDFKit

struct PDFViewWrapper: View {
    var body: some View {
        PDFViewRepresented()
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
    }
}



struct PDFViewRepresented: UIViewRepresentable {
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        if let url = Bundle.main.url(forResource: "hadj_i_umra", withExtension: "pdf") {
            pdfView.document = PDFDocument(url: url)
        }
                pdfView.autoScales = true
                pdfView.minScaleFactor = 0.5
                pdfView.displayMode = .singlePageContinuous
                pdfView.usePageViewController(true, withViewOptions: nil)
                pdfView.backgroundColor = UIColor.white
                return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // Update the view if needed
    }
}

















struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        PDFViewWrapper()
    }
}
