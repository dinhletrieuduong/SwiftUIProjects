//
//  PDFViewer.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 9/8/24.
//

import SwiftUI
import PDFKit

// Step 1: Create a custom UIViewRepresentable
struct PDFViewer: UIViewRepresentable {
    let document: PDFDocument?
    @Binding var currentPage: Int
    @Binding var totalPages: Int

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.delegate = context.coordinator
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = document
        if let document = document, let page = document.page(at: currentPage - 1) {
            uiView.go(to: page)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PDFViewDelegate {
        var parent: PDFViewer

        init(_ parent: PDFViewer) {
            self.parent = parent
        }

        func pdfViewPageChanged(_ pdfView: PDFView) {
            if let currentPage = pdfView.currentPage, let document = pdfView.document {
                parent.currentPage = document.index(for: currentPage) + 1
                parent.totalPages = document.pageCount
            }
        }
    }
}

// Step 2: Use the custom PDFViewer in your SwiftUI view
struct PDFViewerDemo: View {
    @State private var pdfDocument: PDFDocument?
    @State private var currentPage = 1
    @State private var totalPages = 1
    @State private var isLoading = false
    @State private var scale: CGFloat = 1.0
    let pdfURL = URL(string: "https://ontheline.trincoll.edu/images/bookdown/sample-local-pdf.pdf")!

    var body: some View {
        ZStack {
            if let document = pdfDocument {
                PDFViewer(document: document, currentPage: $currentPage, totalPages: $totalPages)
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture()
                        .onChanged { value in
                            self.scale = value.magnitude
                        }
                    )

                VStack {
                    Spacer()
                    HStack {
                        Button(action: previousPage) {
                            Image(systemName: "arrow.left")
                        }
                        .disabled(currentPage == 1)

                        Text("\(currentPage) / \(totalPages)")

                        Button(action: nextPage) {
                            Image(systemName: "arrow.right")
                        }
                        .disabled(currentPage == totalPages)

                        Spacer()

                        Button(action: zoomIn) {
                            Image(systemName: "plus.magnifyingglass")
                        }

                        Button(action: zoomOut) {
                            Image(systemName: "minus.magnifyingglass")
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .foregroundColor(.white)
                }
            } else {
                Text("PDF not loaded")
            }

            if isLoading {
                ProgressView()
            }
        }
        .onAppear(perform: loadPDF)
    }

    private func loadPDF() {
        isLoading = true
        URLSession.shared.dataTask(with: pdfURL) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.pdfDocument = PDFDocument(data: data)
                    self.totalPages = self.pdfDocument?.pageCount ?? 0
                    self.isLoading = false
                }
            } else {
                print("Failed to load PDF: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }

    private func nextPage() {
        if currentPage < totalPages {
            currentPage += 1
        }
    }

    private func previousPage() {
        if currentPage > 1 {
            currentPage -= 1
        }
    }

    private func zoomIn() {
        scale *= 1.2
    }

    private func zoomOut() {
        scale /= 1.2
    }
}

#Preview {
    PDFViewerDemo()
}
