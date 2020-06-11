//
//  TextView.swift
//  Character Organizer
//
//  Created by Wayne Ohmer on 6/3/20.
//  Copyright © 2020 Tryal by Fyre. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

@available (macOS 10.15, iOS 13, *)
@available (tvOS, unavailable)
@available (watchOS, unavailable)
fileprivate struct JustifiedTextEnvironmentKey: EnvironmentKey {
    typealias Value = Bool
    static var defaultValue: Bool = false
}

@available (macOS 10.15, iOS 13, *)
@available (tvOS, unavailable)
@available (watchOS, unavailable)
fileprivate extension EnvironmentValues {
    var justifiedText: Bool {
        get { self[JustifiedTextEnvironmentKey.self] }
        set { self[JustifiedTextEnvironmentKey.self] = newValue }
    }
}

fileprivate func _alignment(from environment: EnvironmentValues) -> NSTextAlignment {
    switch environment.multilineTextAlignment {
    case .center:
        return .center
    case .leading where environment.layoutDirection == .leftToRight:
        return .left
    case .leading where environment.layoutDirection == .rightToLeft:
        return .right
    case .trailing where environment.layoutDirection == .leftToRight:
        return .right
    case .trailing where environment.layoutDirection == .rightToLeft:
        return .left
    default:
        return environment.justifiedText ? .justified : .natural
    }
}

fileprivate struct TextDidChangePublisherKey: EnvironmentKey {
    typealias Value = PassthroughSubject<Bool, Never>?
    static var defaultValue: PassthroughSubject<Bool, Never>? = nil
}
fileprivate struct TextDidCommitPublisherKey: EnvironmentKey {
    typealias Value = PassthroughSubject<Void, Never>?
    static var defaultValue: PassthroughSubject<Void, Never>? = nil
}

fileprivate extension EnvironmentValues {
    var textDidChangePublisher: PassthroughSubject<Bool, Never>? {
        get { self[TextDidChangePublisherKey.self] }
        set { self[TextDidChangePublisherKey.self] = newValue }
    }
    var textDidCommitPublisher: PassthroughSubject<Void, Never>? {
        get { self[TextDidCommitPublisherKey.self] }
        set { self[TextDidCommitPublisherKey.self] = newValue }
    }
}

@available (macOS 10.15, iOS 13, *)
@available (tvOS, unavailable)
@available (watchOS, unavailable)
public struct TextView: View {
    private typealias _PlatformView = _UIKitTextView

    private let platform: _PlatformView

    public init(text: Binding<String>) {
        self.platform = _PlatformView(text: text)
    }

    public var body: some View { platform }

    public func justified() -> some View {
        environment(\.justifiedText, true)
    }
}

fileprivate struct SubjectSinkView<Output, Content: View>: View {
    typealias Publisher = PassthroughSubject<Output, Never>
    let subject: AnyPublisher<Output, Never>
    var cancellable: Set<AnyCancellable> = []
    let body: AnyView

    init(_ body: Content, keyPath: WritableKeyPath<EnvironmentValues, Publisher?>, perform action: ((Output) -> Void)?) {
        if let action = action {
            let subject = Publisher()
            self.subject = AnyPublisher(subject)
            self.body = AnyView(body.environment(keyPath, subject))
            subject.sink(receiveValue: action)
                .store(in: &cancellable)
        }
        else {
            self.subject = AnyPublisher(Empty(completeImmediately: false))
            self.body = AnyView(body)
        }
    }
}

// This bit of syntactic sugar is needed because (() -> Void) doesn't map ((Void) -> Void),
// and ((Void) -> Void) generates a warning that as of Swift 4 you need to use () -> Void instead.
extension SubjectSinkView where Output == Void {
    init(_ body: Content, keyPath: WritableKeyPath<EnvironmentValues, Publisher?>, perform action: (() -> Void)?) {
        if let action = action {
            let subject = Publisher()
            self.subject = AnyPublisher(subject)
            self.body = AnyView(body.environment(keyPath, subject))
            subject.sink(receiveValue: action)
                .store(in: &cancellable)
        }
        else {
            self.subject = AnyPublisher(Empty(completeImmediately: false))
            self.body = AnyView(body)
        }
    }
}

@available (macOS 10.15, iOS 13, *)
@available (tvOS, unavailable)
@available (watchOS, unavailable)
public extension View {
    func onTextChanged(perform action: ((Bool) -> Void)?) -> some View {
        SubjectSinkView(self, keyPath: \.textDidChangePublisher, perform: action)
    }
    func onTextEditCommit(perform action: (() -> Void)?) -> some View {
        SubjectSinkView(self, keyPath: \.textDidCommitPublisher, perform: action)
    }
}


extension UIContentSizeCategory {
    fileprivate init(_ swiftuiValue: ContentSizeCategory) {
        switch swiftuiValue {
        case .extraSmall:
            self = .extraSmall
        case .small:
            self = .small
        case .medium:
            self = .medium
        case .large:
            self = .large
        case .extraLarge:
            self = .extraLarge
        case .extraExtraLarge:
            self = .extraExtraLarge
        case .extraExtraExtraLarge:
            self = .extraExtraExtraLarge
        case .accessibilityMedium:
            self = .accessibilityMedium
        case .accessibilityLarge:
            self = .accessibilityLarge
        case .accessibilityExtraLarge:
            self = .accessibilityExtraLarge
        case .accessibilityExtraExtraLarge:
            self = .accessibilityExtraExtraLarge
        case .accessibilityExtraExtraExtraLarge:
            self = .accessibilityExtraExtraExtraLarge
        @unknown default:
            self = .unspecified
        }
    }
}
extension UITraitCollection {
    fileprivate convenience init(swiftUIContentSizeCategory value: ContentSizeCategory) {
        self.init(preferredContentSizeCategory: UIContentSizeCategory(value))
    }
}


fileprivate struct _UIKitTextView: UIViewRepresentable {
    @Binding var text: String
    @State var justified: Bool = false

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.textColor = UIColor.label
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.textColor = .label

        let traits = UITraitCollection(traitsFrom: [
            uiView.traitCollection,
            UITraitCollection(swiftUIContentSizeCategory: context.environment.sizeCategory)
        ])
        // I wish I could read this info from context.environment.font...
        uiView.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: traits)
        uiView.textAlignment = _alignment(from: context.environment)

        context.coordinator.change = context.environment.textDidChangePublisher
        context.coordinator.commit = context.environment.textDidCommitPublisher
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: _UIKitTextView
        var change: PassthroughSubject<Bool, Never>?
        var commit: PassthroughSubject<Void, Never>?

        init(_ parent: _UIKitTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            change?.send(true)
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            commit?.send()
            change?.send(false)
        }
    }
}


//struct TextView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            StatefulPreviewWrapper("This is the sample text.\n\nIt has many lines.") {
//                TextView(text: $0)
//            }
//            StatefulPreviewWrapper("This is the sample text.\n\nIt has many lines.") {
//                TextView(text: $0)
//                    .environment(\.colorScheme, .dark)
//            }
//        }
//        .previewLayout(.fixed(width: 400, height: 200))
//    }
//}
