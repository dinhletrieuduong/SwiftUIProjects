//
//  QRScannerView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 05/02/2024.
//

import SwiftUI
import AVKit

/// Remember to add Camera Permission Usage to Plist
struct QRScannerView: View {
    
    /// Scanner Properties
    @State private var isScanning: Bool = false
    @State private var cameraPermission: QRScannerPermission = .idle
    
    @State private var session: AVCaptureSession = .init()
    
    /// Scanner AV Output
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    
    /// Error properties
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    @StateObject private var delegate: QRScannerViewDelegate = .init()
    
    @Environment(\.openURL) private var openURL
    
    @State private var scannedCode: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundStyle(.blue)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Place the QR code inside the area")
                .font(.title3)
                .foregroundStyle(.black.opacity(0.8))
            
            Text("Scanning will start automatically")
                .font(.callout)
                .foregroundStyle(.gray)
            
            Spacer(minLength: 0)
            
            /// Scanner
            GeometryReader {
                let size = $0.size
                
                ZStack {
                    QRCameraView(frameSize: .init(width: size.width, height: size.width), session: $session)
                        .scaleEffect(0.97)
                    
                    ForEach(0..<4, id: \.self) { index in
                        let angle = Double(index) * 90
                        
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                        /// Trimming to get Scanner like Edges
                            .trim(from: 0.61, to: 0.64)
                            .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.init(degrees: angle))
                    }
                }
                /// Square shape
                .frame(width: size.width, height: size.width)
                /// Scanner Animation
                .overlay(alignment: .top, content: {
                    Rectangle()
                        .fill(.blue)
                        .frame(height: 2.5)
                        .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: isScanning ? 15 : -15)
                        .offset(y: isScanning ? size.width : 0)
                })
                /// Make view center
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 45)
            
            Spacer(minLength: 15)
            
            Button {
                if !session.isRunning && cameraPermission == .approved {
                    reactiveCamera()
                    activateScannerAnimation()
                }
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)
                
            }
            
            Spacer(minLength: 45)
            
        }
        .padding(15)
        .onAppear {
            /// Check camera permission when view is visible
            checkCameraPermission()
        }
        .alert(errorMessage, isPresented: $showError) {
            if cameraPermission == .denied {
                Button("Settings") {
                    let settingsString = UIApplication.openSettingsURLString
                    if let settingsURL = URL(string: settingsString) {
                        openURL.callAsFunction(settingsURL)
                    }
                    
                }
                
                Button("Cancel", role: .cancel) {
                }
            }
        }
        .onChange(of: delegate.scannedCode) { oldValue, newValue in
            if let code = newValue {
                scannedCode = code
                session.stopRunning()
                deActivateScannerAnimation()
                
                delegate.scannedCode = nil
            }
        }
    }
    
    func reactiveCamera() {
        /// Session must be started on Background
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    func activateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    func deActivateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }
    
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .notDetermined:
                    if await AVCaptureDevice.requestAccess(for: .video) {
                        cameraPermission = .approved
                        if session.inputs.isEmpty {
                            setupCamera()
                        } else {
                            reactiveCamera()
                        }
                    } else {
                        cameraPermission = .denied
                        presentError("Please provide access to Camera for scanning QRCode")
                    }
                case .denied, .restricted:
                    cameraPermission = .denied
                    presentError("Please provide access to Camera for scanning QRCode")
                case .authorized:
                    cameraPermission = .approved
                    setupCamera()
                @unknown default:
                    cameraPermission = .idle
            }
        }
    }
    
    func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera], mediaType: .video, position: .back).devices.first else {
                presentError("UNKNOWN DEVICE ERROR")
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("UNKNOWN INPUT/OUTPUT ERROR")
                return
            }
            
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)

            /// Setting Output config to read QR Codes
            qrOutput.metadataObjectTypes = [.qr]
            
            qrOutput.setMetadataObjectsDelegate(delegate, queue: .main)
            
            session.commitConfiguration()
            reactiveCamera()
            
            activateScannerAnimation()
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    func presentError(_ error: String) {
        errorMessage = error
        showError.toggle()
    }
}

// MARK: - QRScannerPermission
enum QRScannerPermission: String {
    case idle = "Not Determine"
    case approved = "Access Granter"
    case denied = "Access Denied"
}

// MARK: - QRScannerViewDelegate
class QRScannerViewDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String?
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let scannedCode = readableObject.stringValue else { return }
            self.scannedCode = scannedCode
        }
    }
    
}

//#Preview {
//    QRScannerView()
//}
