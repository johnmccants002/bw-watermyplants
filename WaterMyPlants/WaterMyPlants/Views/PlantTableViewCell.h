//
//  PlantTableViewCell.h
//  WaterMyPlants
//
//  Created by John McCants on 2/26/21.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlantTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;



@end

NS_ASSUME_NONNULL_END
