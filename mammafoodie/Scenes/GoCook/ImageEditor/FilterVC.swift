//
//  FilterVC.swift
//  Filters
//
//  Created by Arjav Lad on 18/05/17.
//  Copyright © 2017 Aakar Solutions. All rights reserved.
//

import UIKit

typealias FilterCompletion = (Image) -> Void

class FilterVC: UIViewController {
    
    @IBOutlet weak var colOptions: UICollectionView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollImage: UIScrollView!
    
    var imageEditorDelegate : ImageEditorDelegate?
    var completion : FilterCompletion?
    var editedImages = [Image]()
    var originalImage : Image!
    var selectedEdit : Image!
    var filters = [Filter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let btnSave = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(onSave(_:)))
        self.navigationItem.rightBarButtonItem = btnSave
        self.navigationController?.navigationBar.tintColor = .white
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollImage.clipsToBounds = false
        self.scrollImage.delegate = self
        self.scrollImage.setZoomScale(1.0, animated: true)
        self.scrollImage.maximumZoomScale = 3.5
        self.scrollImage.minimumZoomScale = 1.0
        
        
        self.prepareOptions()
        self.generateFilters()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = self.originalImage.image
        self.colOptions.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func prepareOptions() {
        self.colOptions.register(UINib.init(nibName: "EditOptionsCell", bundle: nil), forCellWithReuseIdentifier: "EditOptionsCell")
        self.colOptions.delegate = self
        self.colOptions.dataSource = self
        self.colOptions.backgroundColor = .clear
        if let flow = self.colOptions.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.scrollDirection = .horizontal
        }
        self.colOptions.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    func generateFilters() {
        self.filters.append(Filter.init(name: "Original", filterName: ""))
        self.filters.append(Filter.init(name: "Chrome", filterName: "CIPhotoEffectChrome"))
        self.filters.append(Filter.init(name: "Fade", filterName: "CIPhotoEffectFade"))
        self.filters.append(Filter.init(name: "Instant", filterName: "CIPhotoEffectInstant"))
        self.filters.append(Filter.init(name: "Noir", filterName: "CIPhotoEffectNoir"))
        self.filters.append(Filter.init(name: "Process", filterName: "CIPhotoEffectProcess"))
        self.filters.append(Filter.init(name: "Tonal", filterName: "CIPhotoEffectTonal"))
        self.filters.append(Filter.init(name: "Transfer", filterName: "CIPhotoEffectTransfer"))
        self.filters.append(Filter.init(name: "Sepia", filterName: "CISepiaTone"))
        self.generateFilterImages()
    }
    
    func generateFilterImages() {
        if self.originalImage.thumbnail == nil {
            self.originalImage.thumbnail = UIImage.generateThumb(self.originalImage.image)
        }
        if let originalFilter = self.filters.first {
            var filterImage : Image
            filterImage = Image.init(self.originalImage.image, thumb: self.originalImage.thumbnail!)
            filterImage.appliedfilter = originalFilter
            self.editedImages.append(filterImage)
            self.selectedEdit = self.editedImages.first
            self.colOptions.reloadData()
        }
        let coreImageMain = CIImage(image:self.originalImage.image)
        let coreImageThumb = CIImage(image:self.originalImage.thumbnail!)
        let ciContext = CIContext(options: nil)
        for filter in self.filters {
            if filter.filterName == "" {
            } else {
                DispatchQueue.global().async {
                    if let filteredImage = coreImageMain?.applyFilter(ciFilterName: filter.filterName, ciContext:ciContext) {
                        let fileredThumb = coreImageThumb?.applyFilter(ciFilterName: filter.filterName, ciContext:ciContext)
                        let filterImage : Image = Image.init(filteredImage, thumb: fileredThumb, filter: filter)
                        DispatchQueue.main.async {
                            self.editedImages.append(filterImage)
                            self.colOptions.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        self.imageEditorDelegate?.imageEdited(self.selectedEdit)
        self.completion?(self.selectedEdit)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FilterVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.editedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : EditOptionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditOptionsCell", for: indexPath) as! EditOptionsCell
        //        cell.backgroundColor = .red
        let image = self.editedImages[indexPath.row]
        cell.imageView.image = image.thumbnail
        cell.lblFilterName.text = image.appliedfilter?.name
        if self.selectedEdit.appliedfilter?.filterName == image.appliedfilter?.filterName {
            cell.backgroundColor = .lightGray
        } else {
            cell.backgroundColor = .clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = collectionView.frame.size.height
        let width = height - 5
        height = height - 10
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(2.5, 2.5, 2.5, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = self.editedImages[indexPath.row]
        self.imageView.image = image.image
        self.selectedEdit = image
        collectionView.reloadData()
    }
}

extension FilterVC : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}

