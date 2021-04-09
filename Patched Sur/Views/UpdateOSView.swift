//
//  UpdateOSView.swift
//  Patched Sur
//
//  Created by Ben Sova on 4/7/21.
//

import VeliaUI

struct UpdateOSView: View {
    let installers: InstallAssistants?
    @Binding var installInfo: InstallAssistant?
    @Binding var releaseTrack: ReleaseTrack
    let buildNumber: String
    @State var hovered = nil as String?
    @State var showMoreTracks = false
    @State var showOtherInstallers = false
    @State var customInstaller = nil as String?
    @Binding var p: Int
    @State var alert: Alert?
    
    var body: some View {
        HStack(spacing: 30) {
            VStack {
                SideImageView(releaseTrack: releaseTrack.rawValue, scale: 90)
                    .padding(.vertical, -5)
                    .padding(.top, -20)
                Text("You are using the")
                VIButton(id: "RELEASETRACK", h: $hovered) {
                    Text(releaseTrack == .developer ? "Beta" : "Release")
                } onClick: {
                    UserDefaults.standard.setValue(releaseTrack == .developer ? "Release" : "Developer", forKey: "UpdateTrack")
                    releaseTrack = releaseTrack == .developer ? .release : .developer
                    withAnimation {
                        p = 0
                    }
                }.inPad()
                .padding(.vertical, -5)
                Text("update track.")
                    .padding(.bottom, -2.5)
                Text(releaseTrack.rawValue == "Developer" ? "These updates can be unstable and is not always suggested for daily use." : "These updates are normally more stable and is the default update track.")
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }.frame(width: 130)
            .font(.caption)
            VStack(alignment: .leading) {
                if installInfo?.buildNumber != .some(buildNumber) || AppInfo.reinstall {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("An update is available!")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("macOS Big Sur \(installInfo?.version ?? "v0.0.0")")
                            .font(.title)
                            .bold()
                        Text("Released \(installInfo?.date ?? "0.0.0") • Build \(installInfo?.buildNumber ?? "0.0.0")")
                            .font(.caption)
                        Button {
                            withAnimation {
                                p = 5
                            }
                        } label: {
                            Text("View Other Versions")
                        }.buttonStyle(BorderlessButtonStyle())
                        .font(.caption)
                        .padding(.top, 2)
                    }.fixedSize()
                    VIButton(id: "STARTUPDATE", h: $hovered) {
                        Text("Start the macOS Update")
                            .font(.caption)
                    }.inPad()
                    .padding(.bottom, -7.5)
                    Text("To update, the patcher will first download the latest patches and then the new version of macOS directly from Apple, and after that Apple’s updater will be started without the compatibility check.")
                        .font(.caption)
                    VIButton(id: "NOTES", h: $hovered) {
                        Text("See the Release Notes")
                            .font(.caption)
                    } onClick: {
                        let versionPieces = installInfo!.version.split(separator: " ")
                        NSWorkspace.shared.open(URL(string: installInfo!.notes ?? "https://developer.apple.com/documentation/macos-release-notes/macos-big-sur-\(versionPieces[0].replacingOccurrences(of: ".", with: "_"))\(versionPieces.contains("Beta") || versionPieces.contains("RC") ? "-beta" : "")-release-notes")!)
                    }.inPad()
                    .padding(.bottom, -7.5)
                    Text("See what’s new in macOS before updating. Thanks to Mr. Macintosh for providing these.")
                        .font(.caption)
                }
                VIButton(id: "NOTIFIS", h: $hovered) {
                    Text("Configure Update Notifications")
                        .font(.caption)
                }.inPad()
                .padding(.bottom, -7.5)
                Text("Get notifications for updates for both macOS and the patcher.")
                    .font(.caption)
            }
        }.padding(.top, -20)
    }
}