//
//

import UIKit

// Heavily inspired by https://github.com/surfstudio/iOS-Utils/blob/master/Utils/Utils/String/StringBuilder.swift
/// Tool that can help to create attributed text with given attributes
/// - How to use:
/// ```
/// let attributedString = AttributedTextBuilder()
///                             .add(.string("Example"))
///                             .add(.delimiterWithString(delimiter: .init(type: .space), string: "blue"), with: [.foregroundColor(.blue)])
///                             .add(.delimiterWithString(delimeter: .init(type: .lineBreak), string: "Base style on new line"))
///                             .add(.delimiterWithString(
///                                     delimiter: .init(type: .space),
///                                     string: "last word with it's own style"
///                              ),
///                             with: [.font(.boldSystemFont(ofSize: 16)), .foregroundColor(.red)])
///                             .build()
/// ```
public class AttributedTextBuilder {
    //MARK: - Constants
    private enum Constants {
        static let breakSymbol = "\n"
        static let spaceSymbol = " "
    }

    //MARK: - Public nested types
    public enum TextDelimiterType {
        case lineBreak
        case space

        var string: String {
            switch self {
            case .lineBreak:
                return Constants.breakSymbol
            case .space:
                return Constants.spaceSymbol
            }
        }
    }

    /// Struct for repeating delimiter and it's parameters
    public struct TextDelimiterRepeater {
        let type: TextDelimiterType
        let count: Int

        var string: String? {
            // swiftlint:disable empty_count
            guard count > 0 else {
                return nil
            }
            // swiftlint:enable empty_count
            return String(repeating: type.string, count: count)
        }

        public init(type: TextDelimiterType, count: Int = 1) {
            self.type = type
            self.count = count
        }
    }

    /// Enum for describing different types of text blocks in rendered attributed string
    /// - string - only string
    /// - delimiterWithString - string with delimiter
    /// - delimiter - only delimiter
    public enum TextBlock {
        case string(String?)
        case delimiterWithString(repeatedDelimiter: TextDelimiterRepeater, string: String?)
        case delimiter(repeatedDelimiter: TextDelimiterRepeater)

        var string: String? {
            switch self {
            case .string(let string):
                return string
            case .delimiterWithString(let delimeter, let string):
                guard
                        let string = string,
                        !string.isEmpty
                        else {
                    return nil
                }
                return (delimeter.string ?? "") + string
            case .delimiter(let delimeter):
                return delimeter.string
            }
        }
    }

    // MARK: - Internal nested types

    /// Part of string to render in attributed string
    class StringPart {
        let block: TextBlock
        let attributes: [StringAttribute]

        init(block: TextBlock, attributes: [StringAttribute] = []) {
            self.block = block
            self.attributes = attributes
        }
    }

    class StringPartNormalized {
        let string: String
        let attributes: [NSAttributedString.Key: Any]
        var range: NSRange?

        init?(from stringPart: StringPart) {
            guard let string = stringPart.block.string else {
                return nil
            }
            self.string = string
            self.attributes = stringPart.attributes.toDictionary()
        }
    }

    // MARK: - Properties
    private var parts: [StringPart] = []
    private var globalAttributes: [StringAttribute] = []

    // MARK: - Initialization
    public init(globalAttributes: [StringAttribute] = []) {
        self.globalAttributes = globalAttributes
    }

    // MARK: - Public methods
    /// Method for clearing string parts
    @discardableResult
    public func clear() -> AttributedTextBuilder {
        parts = []
        return self
    }

    /// Build NSMutableAttributedString with given text and attributes
    public func build() -> NSAttributedString {
        // create attributedString to render
        let attributedString = NSMutableAttributedString()

        // create normalized parts (empty string are not included)
        let normalizedParts = parts.compactMap { StringPartNormalized(from: $0) }
        for part in normalizedParts {
            part.range = NSRange(location: attributedString.length, length: part.string.count)
            attributedString.append(NSAttributedString(string: part.string))
        }

        // add global attributes
        attributedString.addAttributes(
                globalAttributes.toDictionary(),
                range: NSRange(location: 0, length: attributedString.length)
        )

        // add local attributes
        for part in normalizedParts {
            guard let range = part.range else {
                continue
            }
            attributedString.addAttributes(part.attributes, range: range)
        }

        return attributedString
    }

    /// Method for adding global attributes to whole string
    /// - Parameter globalAttributes: attributes to apply
    @discardableResult
    public func add(globalAttributes: [StringAttribute]) -> AttributedTextBuilder {
        self.globalAttributes.append(contentsOf: globalAttributes)
        return self
    }

    /// Method for adding global attributes with NSAttributedString
    /// - Parameter globalAttributes: attributes to apply
    @discardableResult
    public func add(with nsAttribute: NSAttributedString) -> AttributedTextBuilder {
        let attributes = nsAttribute.attributes(at: 0, effectiveRange: nil)
        let stringAttributes = StringAttribute.from(dictionary: attributes)
        self.add(.string(nsAttribute.string), with: stringAttributes)
        return self
    }

    /// Method for adding text block to attributed
    /// - Parameters:
    ///   - block: block to add
    ///   - attributes: attributes to apply
    @discardableResult
    public func add(_ block: TextBlock, with attributes: [StringAttribute] = []) -> AttributedTextBuilder {
        parts.append(StringPart(block: block, attributes: attributes))
        return self
    }
}

//MARK: - StringAttribute's
/// Attributes for string.
public enum StringAttribute {
    /// Text line spacing
    case lineSpacing(CGFloat)
    /// Letter spacing
    case kern(CGFloat)
    /// Text font
    case font(UIFont)
    /// Text foreground (letter) color
    case foregroundColor(UIColor)
    /// Text aligment
    case aligment(NSTextAlignment)
    /// Text crossing out
    case crossOut(style: CrossOutStyle)
    /// Text line break mode
    case lineBreakMode(NSLineBreakMode)
    /// Text base line offset (vertical)
    case baselineOffset(CGFloat)

    /// Figma friendly case means that lineSpacing = lineHeight - font.lineHeight
    /// This case provide possibility to set both `font` and `lineSpacing`
    /// First parameter is Font and second parameter is lineHeight property from Figma
    /// For more details see [#14](https://github.com/surfstudio/iOS-Utils/issues/14)
    case lineHeight(CGFloat, font: UIFont)
}

// MARK: - Nested types
extension StringAttribute {
    /// Enum for configuring style of crossOut text
    public enum CrossOutStyle {
        case single
        case double

        var coreValue: NSUnderlineStyle {
            switch self {
            case .double:
                return NSUnderlineStyle.double
            case .single:
                return NSUnderlineStyle.single
            }
        }

        init?(with style: NSUnderlineStyle) {
            switch style {
            case .double:
                self = .double
            case .single:
                self = .single
            default:
                return nil
            }
        }
    }
}

// MARK: - StringAttribute extension
extension StringAttribute {
    var attributeKey: NSAttributedString.Key {
        switch self {
        case .lineSpacing,
            .aligment,
            .lineHeight,
            .lineBreakMode:
            return NSAttributedString.Key.paragraphStyle
        case .kern:
            return NSAttributedString.Key.kern
        case .font:
            return NSAttributedString.Key.font
        case .foregroundColor:
            return NSAttributedString.Key.foregroundColor
        case .crossOut:
            return NSAttributedString.Key.strikethroughStyle
        case .baselineOffset:
            return NSAttributedString.Key.baselineOffset
        }
    }

    fileprivate var value: Any {
        switch self {
        case .lineSpacing(let value):
            return value
        case .kern(let value):
            return value
        case .font(let value):
            return value
        case .foregroundColor(let value):
            return value
        case .aligment(let value):
            return value
        case .lineHeight(let lineHeight, let font):
            return lineHeight - font.lineHeight
        case .crossOut(let style):
            return style.coreValue.rawValue
        case .lineBreakMode(let value):
            return value
        case .baselineOffset(let value):
            return value
        }
    }
}

// MARK: - Public static methods
public extension StringAttribute {
    /// Init from attributs array
    static func from(dictionary: [NSAttributedString.Key: Any]) -> [StringAttribute] {
        var stringAttributedArray = [StringAttribute]()

        if let baselineOffset = dictionary[.baselineOffset] as? CGFloat {
            stringAttributedArray.append(.baselineOffset(baselineOffset))
        }

        if let strikethroughStyle = dictionary[.strikethroughStyle] as? NSUnderlineStyle,
           let crossOutStyle = CrossOutStyle(with: strikethroughStyle) {
            stringAttributedArray.append(.crossOut(style: crossOutStyle))
        }

        if let foregroundColor = dictionary[.foregroundColor] as? UIColor {
            stringAttributedArray.append(.foregroundColor(foregroundColor))
        }

        if let font = dictionary[.font] as? UIFont {
            stringAttributedArray.append(.font(font))
        }

        if let kernValue = dictionary[.kern] as? CGFloat {
            stringAttributedArray.append(.kern(kernValue))
        }

        if let value = dictionary[.paragraphStyle],
           let mutableParagraphStyle = value as? NSMutableParagraphStyle {
            stringAttributedArray.append(.aligment(mutableParagraphStyle.alignment))
            stringAttributedArray.append(.lineBreakMode(mutableParagraphStyle.lineBreakMode))

            if let font = dictionary[.font] as? UIFont {
                stringAttributedArray.append(.lineHeight(mutableParagraphStyle.lineSpacing, font: font))
            } else {
                stringAttributedArray.append(.lineSpacing(mutableParagraphStyle.lineSpacing))
            }
        }

        return stringAttributedArray
    }
}

// MARK: - String extension
public extension String {
    /// Apply attributes to string and returns new attributes string
    func with(attributes: [StringAttribute]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes.toDictionary())
    }
}

// MARK: - Private array extension
private extension Array where Element == StringAttribute {
    func normalizedAttributes() -> [StringAttribute] {
        var result = [StringAttribute](self)

        self.forEach { item in
            switch item {
            case .lineHeight(_, let font):
                result.append(.font(font))
            default:
                break
            }
        }

        return result
    }
}

// MARK: - Public array extension
public extension Array where Element == StringAttribute {
    func toDictionary() -> [NSAttributedString.Key: Any] {
        var resultAttributes = [NSAttributedString.Key: Any]()
        let paragraph = NSMutableParagraphStyle()
        for attribute in self.normalizedAttributes() {
            switch attribute {
            case .lineHeight(let lineHeight, let font):
                paragraph.lineSpacing = lineHeight - font.lineHeight
                resultAttributes[attribute.attributeKey] = paragraph
            case .lineSpacing(let value):
                paragraph.lineSpacing = value
                resultAttributes[attribute.attributeKey] = paragraph
            case .lineBreakMode(let value):
                paragraph.lineBreakMode = value
                resultAttributes[attribute.attributeKey] = paragraph
            case .aligment(let value):
                paragraph.alignment = value
                resultAttributes[attribute.attributeKey] = paragraph
            default:
                resultAttributes[attribute.attributeKey] = attribute.value
            }
        }
        return resultAttributes
    }
}
