//
//  Request.swift
//  SneakShare
//
//  Created by EMRE ERTUNC on 14.11.2023.
//

import SwiftUI
import MessageUI

struct Request: View {
    @State private var descriptionText: String = ""
    @State private var requestedApp: String = ""
    @State private var exampleLink: String = ""
    @State private var isShowingMailView = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil

    var body: some View {
        VStack {
            Text("Please share the details of the format you would like the app to support. In order to use this function, the default Mail app of iOS must be installed on your device. If default Mail App is not installed and the Send Request button is greyed out, you can always contact me at 'emre@ertunc.com' ")
                .font(.callout)
                .padding()

            TextField("Requested App", text: $requestedApp)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Example link (e.g. vm.tiktok.com/abcdef)", text: $exampleLink)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Send Request") {
                self.isShowingMailView = true
            }
            .disabled(!MFMailComposeViewController.canSendMail())
            .sheet(isPresented: $isShowingMailView) {
                MailView(isShowing: self.$isShowingMailView, result: self.$mailResult, subject: "Request for a new application to be supported", body: "Explanation: \(self.descriptionText)\nRequested App: \(self.requestedApp)\nExample Link: \(self.exampleLink)", recipients: ["emre@ertunc.com"])
            }
        }
    }
}

struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    var subject: String
    var body: String
    var recipients: [String]

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing, result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject(subject)
        vc.setMessageBody(body, isHTML: false)
        vc.setToRecipients(recipients)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
    }
}

struct Request_Previews: PreviewProvider {
    static var previews: some View {
        Request()
    }
}

#Preview {
    Request()
}
