//
//  OnBoardingViewController.swift
//  Traductor
//
//  Created by Zara Davtyan on 10.05.21.
//  Copyright © 2021 Traductor. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var onboardingItems = [OnboardingItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillInOnboardingItems()
        collectionView.reloadData()
    }
    
    func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        nextButton.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
        nextButton.layer.cornerRadius = 6
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
    func fillInOnboardingItems() {

        let item_1 = OnboardingItem(text: NSLocalizedString("onboarding_1", comment: ""), image: UIImage(named: "onboarding_1") ?? UIImage())
        let item_2 = OnboardingItem(text: NSLocalizedString("onboarding_2", comment: ""), image: UIImage(named: "onboarding_2") ?? UIImage())
        let item_3 = OnboardingItem(text: NSLocalizedString("onboarding_3", comment: ""), image: UIImage(named: "onboarding_3") ?? UIImage())
        onboardingItems.append(item_1)
        onboardingItems.append(item_2)
        onboardingItems.append(item_3)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if let visibleCell = collectionView.visibleCells.first {
            let visibleIndexPath = collectionView.indexPath(for: visibleCell)
            if let item = visibleIndexPath?.item, item == onboardingItems.count - 1 {
                showHomeScreen()
            } else if let item = visibleIndexPath?.item {
                collectionView.scrollToItem(at: IndexPath(item: item + 1, section: 0), at: .left, animated: true)
            }
        }
    }
    
    func showHomeScreen() {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension OnBoardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = onboardingItems.count
        return onboardingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: OnboardingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as? OnboardingCell {
            let onboardingItem = onboardingItems[indexPath.row]
            cell.descriptionLbl.text = onboardingItem.text
            cell.imgView.image = onboardingItem.image
            return cell
            
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
        if indexPath.item == onboardingItems.count - 1 {
            nextButton.setTitle(NSLocalizedString("Start app", comment: ""), for: .normal)
        } else {
            nextButton.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
        }
    }
    
}
