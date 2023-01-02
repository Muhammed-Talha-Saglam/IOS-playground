//
//  Camera.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 17.12.2022.
//

import Foundation

class Camera {
    func start() async {
            let authorized = await checkAuthorization()
            guard authorized else {
                logger.error("Camera access was not authorized.")
                return
            }
            
            if isCaptureSessionConfigured {
                if !captureSession.isRunning {
                    sessionQueue.async { [self] in
                        self.captureSession.startRunning()
                    }
                }
                return
            }
            
            sessionQueue.async { [self] in
                self.configureCaptureSession { success in
                    guard success else { return }
                    self.captureSession.startRunning()
                }
            }
        }
        
        func stop() {
            guard isCaptureSessionConfigured else { return }
            
            if captureSession.isRunning {
                sessionQueue.async {
                    self.captureSession.stopRunning()
                }
            }
        }
}
