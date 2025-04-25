//
//  MailView.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 13.02.2025.
//

import SwiftUI
import MessageUI
import DeviceKit

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    let recipient: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = context.coordinator
        
        let device = Device.current
        let deviceName = device.description
        let osVersion = UIDevice.current.systemVersion
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
        
        let messageBody = """
            \n\n\
            Device: \(deviceName)\n\
            iOS: \(osVersion)\n\
            App version: \(appVersion)
        """
        
        mailComposeViewController.setToRecipients([recipient])
        mailComposeViewController.setSubject("AI Music - User Question")
        mailComposeViewController.setMessageBody(messageBody, isHTML: false)
        
        return mailComposeViewController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}
