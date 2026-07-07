//
// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct GymnasiumTrackSelectionView: View {

    let onSelect: (GymnasiumTrack) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Für welches Gymnasium möchtest du üben?")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                VStack(spacing: 16) {
                    ForEach(GymnasiumTrack.allCases, id: \.self) { track in
                        Button { onSelect(track) } label: {
                            TrackCard(track: track)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 32)
            .navigationTitle("MyGymiPrep")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

private struct TrackCard: View {

    let track: GymnasiumTrack

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: track.systemImage)
                .font(.system(size: 36))
                .foregroundStyle(.blue)
                .frame(width: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text(track.displayName)
                    .font(.headline)
                Text(track.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    GymnasiumTrackSelectionView { _ in }
}
