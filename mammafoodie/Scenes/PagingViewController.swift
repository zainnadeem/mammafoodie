

import UIKit

class PagingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {


   lazy var vCArray: [UIViewController] = {
    return [self.VCInstanse(name: "HomeViewController"),
            self.VCInstanse(name: "ChatListViewController"),
            self.VCInstanse(name: "RequestDishViewController")]
    }()

    private func VCInstanse(name:String) -> UIViewController {
        return UIStoryboard(name: "Siri", bundle: nil).instantiateViewController(withIdentifier:name)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        if let firstVC = vCArray.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                 view.frame = UIScreen.main.bounds
            }
            else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }

    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewIndex  = vCArray.index(of: viewController) else {
                return nil
        }
        let previousIndex = viewIndex - 1
        if previousIndex < 0 {
            return nil
        } else {
            return vCArray[previousIndex]
        }
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewIndex  = vCArray.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewIndex + 1
        if nextIndex > vCArray.count - 1 {
            return nil
        } else {
            return vCArray[nextIndex]
        }
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return vCArray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        guard let firstViewController  = viewControllers?.first,
            let firstViewIndex = vCArray.index(of: firstViewController) else
        {
            return 0
        }
        return firstViewIndex
    }

}
