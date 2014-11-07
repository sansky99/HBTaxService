//
//  PictureNewsTableViewCell.m
//  XJTaxService
//
//  Created by hellen.zhou on 14-9-15.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "PictureNewsTableViewCell.h"

@implementation PictureNewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleTextLable = [[UILabel alloc] initWithFrame:CGRectMake(90, 3, 210, 40)];
        _timeTextLable.backgroundColor = [UIColor clearColor];
        _titleTextLable.textColor = [UIColor blackColor];
        _titleTextLable.font =   [UIFont fontWithName:@"ArialRoundedMTBold" size:16.0] ;
        _titleTextLable.numberOfLines = 2;
        
        [self.contentView addSubview:_titleTextLable];
        
        _timeTextLable = [[UILabel alloc] initWithFrame:CGRectMake(90, 42, 210 , 17.f)];
        _timeTextLable.font = [UIFont fontWithName:@"CourierNewPSMT" size:13.0];
        _timeTextLable.textColor = [UIColor blackColor];
        _timeTextLable.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeTextLable];
        
        
        _newsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 72, 54)];
        _newsImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:_newsImageView];
        
        UILabel *lineLabel =  [[UILabel alloc] initWithFrame:CGRectMake(15, 61.5, 290, 0.5)];
        lineLabel.backgroundColor =  [UIColor grayColor];
        lineLabel.alpha = 0.35;
        
        [self.contentView addSubview:lineLabel];
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
