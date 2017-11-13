//  CustomLayout.swift


import Foundation
import  UIKit

class CustomLayout: UICollectionViewLayout{
    
   
    private var cache = [UICollectionViewLayoutAttributes]()

 
    //Public Customizable properties
    public let cellSpacing:CGFloat = 3

    public let smallCellHeight:CGFloat = 200
    
    public let leftOverCellsHeight:CGFloat = 260
    
    
    
    //MARK: - Private properties
    private var bigCellHeight:CGFloat!
    
    private var bigCellWidth:CGFloat!
    
    private var sectionHeightIncludingSpacing : CGFloat!
    
    private var contentHeight: CGFloat  = 0
    
    private let numberOfColumnsForLeftOverCells:CGFloat = 2
    
    private var numberOfColumns:CGFloat = 3
    
    private var itemSize : CGSize!
    
    
    override func prepare() {
        super.prepare()
        
        if cache.isEmpty{
           
            var column:CGFloat = 1

            itemSize = CGSize(width: self.collectionView!.frame.size.width/3 - (cellSpacing * CGFloat(numberOfColumns - 2)), height: smallCellHeight)
            
            bigCellHeight = (smallCellHeight * 2) + cellSpacing
            
            bigCellWidth = (itemSize.width * 2) + cellSpacing
            
            sectionHeightIncludingSpacing = bigCellHeight + cellSpacing
            
            
            let totalCount = collectionView!.numberOfItems(inSection: 0)
            
            let itemsPerSection = 3 //Each section contains 3 cells -> 2 small and 1 big
            
            var numberOfSections = totalCount/itemsPerSection
            
            var leftOverCells:CGFloat = 0
           
            while numberOfSections > 0 { //Calculate number of sections that can be formed leaving behind even number of cells if any
                
                 leftOverCells = CGFloat(totalCount - (numberOfSections * itemsPerSection))
                
                if leftOverCells.truncatingRemainder(dividingBy: 2) != 0 {
                    numberOfSections -= 1
                } else {
                    break
                }
                
            }
      
            contentHeight = CGFloat(numberOfSections) * (sectionHeightIncludingSpacing) + (((leftOverCells/2) * leftOverCellsHeight) + cellSpacing)
            print(contentHeight)
            
            var currentSection = 1
            
            var x:CGFloat = cellSpacing/2
            var y:CGFloat = CGFloat(numberOfSections) * (sectionHeightIncludingSpacing) //Initial Y position to layout leftover cells
            
            cache = (0 ..< self.collectionView!.numberOfItems(inSection: 0)).map({ (i:Int) -> UICollectionViewLayoutAttributes in
                
                let attribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
                
                
                if currentSection > numberOfSections { // left over cells
                    
                    attribute.size = CGSize(width: collectionView!.frame.size.width/2 - cellSpacing , height: leftOverCellsHeight)
                    
                    
                    if i % 2 == 0 {
                        x = cellSpacing/2
                    } else {
                        x = attribute.size.width + cellSpacing * 1.5
                    }
                    
                    
                    attribute.frame = CGRect(x: x, y: y, width: attribute.size.width, height: attribute.size.height)
                    
                    if column.truncatingRemainder(dividingBy: 2) == 0 {
                        y += leftOverCellsHeight + cellSpacing
                    }
                    
                    column = column >= self.numberOfColumnsForLeftOverCells  ?  1 : column + 1
                    
                    
                    return attribute
                }
                
                
                
                //IndexPath for big cells -- 0 4 6 10 12 ....
                
                if currentSection % 2 != 0 {
                    
                    //First cell is big
                    let bigCellIndexPath = ((currentSection * itemsPerSection) - 2) - 1
                    
                    
                    if i == bigCellIndexPath { //BigCell Attributes
                        
                        attribute.zIndex = 1 //Just act like a flag to check if cell is big or small in cellForItem method
                        attribute.size =  CGSize(width: bigCellWidth, height: bigCellHeight)
                      
                        attribute.frame = CGRect(x: cellSpacing/2, y: CGFloat(currentSection - 1) * (sectionHeightIncludingSpacing)  , width: bigCellWidth, height: bigCellHeight)
                        
                    } else { //SmallCell Attributes
                        
                        attribute.size = itemSize
                        
                        //Check if the cell is the last small cell within the section, then add a cellspacing to its top
                        let y = (currentSection * itemsPerSection) - 1 == i ? (CGFloat(currentSection - 1) * sectionHeightIncludingSpacing) + itemSize.height + cellSpacing : (CGFloat(currentSection - 1) * sectionHeightIncludingSpacing)
                        
                        attribute.frame = CGRect(x: bigCellWidth + cellSpacing * 1.5 , y: y, width: itemSize.width, height: itemSize.height)
                    }
                    
                } else {
                    
                    //Second cell is big
                    let bigCellIndexPath = ((currentSection * itemsPerSection) - 1) - 1
                    
                    if i == bigCellIndexPath {
                        
                        attribute.zIndex = 1
                        attribute.size = CGSize(width: bigCellWidth, height: bigCellHeight)
                        
                        attribute.frame = CGRect(x: itemSize.width + cellSpacing * 1.5, y: CGFloat(currentSection - 1) * (sectionHeightIncludingSpacing)  , width: bigCellWidth, height: bigCellHeight)
                        
                        
                    } else {
                        attribute.size = itemSize
                        
                         let y = (currentSection * itemsPerSection) - 1 == i ? (CGFloat(currentSection - 1) * sectionHeightIncludingSpacing) + itemSize.height + cellSpacing : (CGFloat(currentSection - 1) * sectionHeightIncludingSpacing)
                        
                        attribute.frame = CGRect(x: cellSpacing/2, y: y, width: itemSize.width, height: itemSize.height)
                        
                    }
                    
                }
                
                
                
                if (i+1) % itemsPerSection == 0 {
                    currentSection += 1
                }

                return attribute
                    
            })
                
            }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView!.frame.size.width , height: contentHeight)
    }
}
