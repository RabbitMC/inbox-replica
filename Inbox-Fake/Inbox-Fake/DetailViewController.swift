import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView : UIView!
    
    let transition = ExpandingCellTransition()

    var navigationBarSnapshot: UIView!
    var navigationBarHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height*2);
        self.transitioningDelegate = transition
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if navigationBarSnapshot != nil {
            navigationBarSnapshot.frame.origin.y = -navigationBarHeight
            scrollView.addSubview(navigationBarSnapshot)
        }
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        if scrollView.contentOffset.y < -navigationBarHeight/2 {
            return .lightContent
        }
        return .default
    }
    
    class var identifier: String {
        return "DetailViewController"
    }

    @IBAction func handleCloseButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: ExpandingTransitionPresentedViewController
extension DetailViewController: ExpandingTransitionPresentedViewController {

    func expandingTransition(_ transition: ExpandingCellTransition, navigationBarSnapshot: UIView) {
        self.navigationBarSnapshot = navigationBarSnapshot
        self.navigationBarHeight = navigationBarSnapshot.frame.height
    }
}

// MARK: UIScrollViewDelegate
extension DetailViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isBeingDismissed {
            navigationBarSnapshot.frame = CGRect(x: 0, y: scrollView.contentOffset.y, width: view.bounds.width, height: -scrollView.contentOffset.y)
        }

        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -navigationBarHeight/2 {
            dismiss(animated: true, completion: nil)
        }
    }
}
