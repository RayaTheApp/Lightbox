import UIKit
import AVKit
import AVFoundation

public class LightboxConfig {
  /// Whether to show status bar while Lightbox is presented
  public static var hideStatusBar = true
    
  public static var imageBackgroundColor = UIColor.black

  /// Provide a closure to handle selected video
  public static var handleVideo: (_ from: UIViewController, _ videoURL: URL) -> Void = { from, videoURL in
    let videoController = AVPlayerViewController()
    videoController.player = AVPlayer(url: videoURL)

    from.present(videoController, animated: true) {
      videoController.player?.play()
    }
  }

  /// How to load image onto SDAnimatedImageView
  public static var loadImage: ((UIImageView, URL, ((UIImage?) -> Void)?) -> Void)?

  /// Stops the load that `loadImage` started for an image view.
  ///
  /// A page calls this before it shows a different image, including when it leaves the preload window. A load that
  /// finishes after that point would put the old image back on the page.
  public static var cancelImageLoad: ((UIImageView) -> Void)?

  /// Indicator is used to show while image is being fetched
  public static var makeLoadingIndicator: () -> UIView = {
    return LoadingIndicator()
  }

  /// Which pages hold their image. Pages outside the window show an empty stub, which frees their image.
  public static var preload: Preload = .allPages

  public enum Preload: Equatable {
    case allPages
    /// Keeps `behind` pages before the current page and `ahead` pages after it. A count below zero counts as zero.
    case window(behind: Int, ahead: Int)

    /// The pages that hold their image while `page` shows, or nil when there are no pages.
    public func pageIndices(around page: Int, pageCount: Int) -> ClosedRange<Int>? {
      guard pageCount > 0 else { return nil }
      let lastPage = pageCount - 1
      switch self {
      case .allPages:
        return 0...lastPage
      case let .window(behind, ahead):
        let center = min(lastPage, max(0, page))
        return max(0, center - max(0, behind))...min(lastPage, center + max(0, ahead))
      }
    }
  }

  public struct PageIndicator {
    public static var enabled = true
    public static var separatorColor = UIColor(hex: "3D4757")

    public static var textAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12),
      .foregroundColor: UIColor(hex: "899AB8"),
      .paragraphStyle: {
        var style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
      }()
    ]
  }

  public struct CloseButton {
    public static var enabled = true
    public static var size: CGSize?
    public static var text = NSLocalizedString("Close", comment: "")
    public static var image: UIImage?

    public static var textAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.boldSystemFont(ofSize: 16),
      .foregroundColor: UIColor.white,
      .paragraphStyle: {
        var style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
      }()
    ]
  }

  public struct DeleteButton {
    public static var enabled = false
    public static var size: CGSize?
    public static var text = NSLocalizedString("Delete", comment: "")
    public static var image: UIImage?

    public static var textAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.boldSystemFont(ofSize: 16),
      .foregroundColor: UIColor(hex: "FA2F5B"),
      .paragraphStyle: {
        var style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
      }()
    ]
  }

  public struct InfoLabel {
    public static var enabled = true
    public static var textColor = UIColor.white
    public static var ellipsisText = NSLocalizedString("Show more", comment: "")
    public static var ellipsisColor = UIColor(hex: "899AB9")

    public static var textAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12),
      .foregroundColor: UIColor(hex: "DBDBDB")
    ]
  }

  public struct Zoom {
    public static var minimumScale: CGFloat = 1.0
    public static var maximumScale: CGFloat = 3.0
  }

  public struct Transition {
    public static var enabled = true
  }
}
