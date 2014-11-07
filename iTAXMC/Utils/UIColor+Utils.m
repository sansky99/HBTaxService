//
//  UIColor+ServYouColor.m
//  iTAXMC
//
//  Created by hellen.zhou on 14-8-26.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "UIColor+Utils.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]


@implementation UIColor (Utils)

+(instancetype) viewBackgroundColor
{
    return ([UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1]);
}

+(instancetype) tableViewBackgroundColor
{
    return ([UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1]);
}

+(instancetype)Fourormat
{
    return UIColorFromRGB(0xfb0a2a);
}

+ (instancetype)FiveHundredPX
{
    return UIColorFromRGB(0x02adea);
}

+ (instancetype)AboutMeBlue
{
    return UIColorFromRGB(0x00405d);
}

+ (instancetype)AboutMeYellow
{
    return UIColorFromRGB(0xffcc33);
}

+ (instancetype)Addvocate
{
    return UIColorFromRGB(0xff6138);
}

+ (instancetype)Adobe
{
    return UIColorFromRGB(0xff0000);
}

+ (instancetype)Aim
{
    return UIColorFromRGB(0xfcd20b);
}

+ (instancetype)Amazon
{
    return UIColorFromRGB(0xe47911);
}

+ (instancetype)Android
{
    return UIColorFromRGB(0xa4c639);
}

+ (instancetype)Asana
{
    return UIColorFromRGB(0x1d8dd5);
}

+ (instancetype)Atlassian
{
    return UIColorFromRGB(0x003366);
}

+ (instancetype)Behance
{
    return UIColorFromRGB(0x005cff);
}

+ (instancetype)bitly
{
    return UIColorFromRGB(0xee6123);
}

+ (instancetype)Blogger
{
    return UIColorFromRGB(0xfc4f08);
}

+ (instancetype)Carbonmade
{
    return UIColorFromRGB(0x613854);
}

+ (instancetype)Cheddar
{
    return UIColorFromRGB(0xff7243);
}

+ (instancetype)CocaCola
{
    return UIColorFromRGB(0xb50900);
}

+ (instancetype)CodeSchool
{
    return UIColorFromRGB(0x3d4944);
}

+ (instancetype)Delicious
{
    return UIColorFromRGB(0x205cc0);
}

+ (instancetype)Dell
{
    return UIColorFromRGB(0x3287c1);
}

+ (instancetype)Designmoo
{
    return UIColorFromRGB(0xe54a4f);
}

+ (instancetype)Deviantart
{
    return UIColorFromRGB(0x4e6252);
}

+ (instancetype)DesignerNews
{
    return UIColorFromRGB(0x2d72da);
}

+ (instancetype)Dewalt
{
    return UIColorFromRGB(0xfebd17);
}

+ (instancetype)DisqusBlue
{
    return UIColorFromRGB(0x59a3fc);
}
+ (instancetype)DisqusOrange
{
    return UIColorFromRGB(0xdb7132);
}
+ (instancetype)Dribbble
{
    return UIColorFromRGB(0xea4c89);
}

+ (instancetype)Dropbox
{
    return UIColorFromRGB(0x3d9ae8);
}

+ (instancetype)Drupal
{
    return UIColorFromRGB(0x0c76ab);
}

+ (instancetype)Dunked
{
    return UIColorFromRGB(0x2a323a);
}

+ (instancetype)eBay
{
    return UIColorFromRGB(0x89c507);
}

+ (instancetype)Ember
{
    return UIColorFromRGB(0xf05e1b);
}

+ (instancetype)Engadget
{
    return UIColorFromRGB(0x00bdf6);
}

+ (instancetype)Envato
{
    return UIColorFromRGB(0x528036);
}

+ (instancetype)Etsy
{
    return UIColorFromRGB(0xeb6d20);
}
+ (instancetype)Evernote
{
    return UIColorFromRGB(0x5ba525);
}
+ (instancetype)Fab
{
    return UIColorFromRGB(0xdd0017);
}
+ (instancetype)Facebook
{
    return UIColorFromRGB(0x3b5998);
}
+ (instancetype)Firefox
{
    return UIColorFromRGB(0xe66000);
}
+ (instancetype)FlickrBlue
{
    return UIColorFromRGB(0x0063dc);
}
+ (instancetype)FlickrPink
{
    return UIColorFromRGB(0xff0084);
}
+ (instancetype)Forrst
{
    return UIColorFromRGB(0x5b9a68);
}
+ (instancetype)Foursquare
{
    return UIColorFromRGB(0x25a0ca);
}
+ (instancetype)Garmin
{
    return UIColorFromRGB(0x007cc3);
}
+ (instancetype)GetGlue
{
    return UIColorFromRGB(0x2d75a2);
}
+ (instancetype)Gimmebar
{
    return UIColorFromRGB(0xf70078);
}
+ (instancetype)GitHub
{
    return UIColorFromRGB(0x171515);
}
+ (instancetype)GoogleBlue
{
    return UIColorFromRGB(0x0140ca);
}
+ (instancetype)GoogleGreen
{
    return UIColorFromRGB(0x16a61e);
}
+ (instancetype)GoogleRed
{
    return UIColorFromRGB(0xdd1812);
}
+ (instancetype)GoogleYellow
{
    return UIColorFromRGB(0xfcca03);
}
+ (instancetype)GooglePlus
{
    return UIColorFromRGB(0xdd4b39);
}
+ (instancetype)Grooveshark
{
    return UIColorFromRGB(0xf77f00);
}
+ (instancetype) Groupon
{
    return UIColorFromRGB(0x82b548);
}
+ (instancetype) HackerNews
{
    return UIColorFromRGB(0xff6600);
}
+ (instancetype) HelloWallet
{
    return UIColorFromRGB(0x0085ca);
}
+ (instancetype) HerokuLight
{
    return UIColorFromRGB(0xc7c5e6);
}
+ (instancetype) HerokuDark
{
    return UIColorFromRGB(0x6567a5);
}
+ (instancetype) HootSuite
{
    return UIColorFromRGB(0x003366);
}
+ (instancetype) Houzz
{
    return UIColorFromRGB(0x73ba37);
}
+ (instancetype) HP
{
    return UIColorFromRGB(0x0096d6);
}
+ (instancetype) HTML5
{
    return UIColorFromRGB(0xec6231);
}
+ (instancetype) Hulu
{
    return UIColorFromRGB(0x8cc83b);
}
+ (instancetype) IBM
{
    return UIColorFromRGB(0x003e6a);
}
+ (instancetype) IKEA
{
    return UIColorFromRGB(0xffcc33);
}
+ (instancetype) IMDb
{
    return UIColorFromRGB(0xf3ce13);
}
+ (instancetype) Instagram
{
    return UIColorFromRGB(0x3f729b);
}
+ (instancetype) Instapaper
{
    return UIColorFromRGB(0x1c1c1c);
}
+ (instancetype) Intel
{
    return UIColorFromRGB(0x0071c5);
}
+ (instancetype) Intuit
{
    return UIColorFromRGB(0x365ebf);
}
+ (instancetype) Kickstarter
{
    return UIColorFromRGB(0x76cc1e);
}
+ (instancetype) kippt
{
    return UIColorFromRGB(0xe03500);
}
+ (instancetype) Kodery
{
    return UIColorFromRGB(0x00af81);
}
+ (instancetype) LastFM
{
    return UIColorFromRGB(0xc3000d);
}
+ (instancetype) LinkedIn
{
    return UIColorFromRGB(0x0e76a8);
}
+ (instancetype) Livestream
{
    return UIColorFromRGB(0xcf0005);
}
+ (instancetype) Lumo
{
    return UIColorFromRGB(0x576396);
}
+ (instancetype) MakitaRed
{
    return UIColorFromRGB(0xd82028);
}
+ (instancetype) MakitaBlue
{
    return UIColorFromRGB(0x29a0b7);
}
+ (instancetype) Mixpanel
{
    return UIColorFromRGB(0xa086d3);
}
+ (instancetype) Meetup
{
    return UIColorFromRGB(0xe51937);
}
+ (instancetype) Netflix
{
    return UIColorFromRGB(0xb9070a);
}
+ (instancetype) Nokia
{
    return UIColorFromRGB(0x183693);
}
+ (instancetype) NVIDIA
{
    return UIColorFromRGB(0x76b900);
}
+ (instancetype) Odnoklassniki
{
    return UIColorFromRGB(0xed812b);
}
+ (instancetype) Opera
{
    return UIColorFromRGB(0xcc0f16);
}
+ (instancetype) Path
{
    return UIColorFromRGB(0xe41f11);
}
+ (instancetype) PayPalDark
{
    return UIColorFromRGB(0x1e477a);
}
+ (instancetype) PayPalLight
{
    return UIColorFromRGB(0x3b7bbf);
}
+ (instancetype) Pinboard
{
    return UIColorFromRGB(0x0000e6);
}
+ (instancetype) Pinterest
{
    return UIColorFromRGB(0xc8232c);
}
+ (instancetype) PlayStation
{
    return UIColorFromRGB(0x665cbe);
}
+ (instancetype) Pocket
{
    return UIColorFromRGB(0xee4056);
}
+ (instancetype) Prezi
{
    return UIColorFromRGB(0x318bff);
}
+ (instancetype) Pusha
{
    return UIColorFromRGB(0x0f71b4);
}
+ (instancetype) Quora
{
    return UIColorFromRGB(0xa82400);
}
+ (instancetype) QuoteFm
{
    return UIColorFromRGB(0x66ceff);
}
+ (instancetype) Rdio
{
    return UIColorFromRGB(0x008fd5);
}
+ (instancetype) Readability
{
    return UIColorFromRGB(0x9c0000);
}
+ (instancetype) RedHat
{
    return UIColorFromRGB(0xcc0000);
}
+ (instancetype) RedditBlue
{
    return UIColorFromRGB(0xcee2f8);
}
+ (instancetype) RedditOrange
{
    return UIColorFromRGB(0xff4500);
}
+ (instancetype) Resource
{
    return UIColorFromRGB(0x7eb400);
}
+ (instancetype) Rockpack
{
    return UIColorFromRGB(0x0ba6ab);
}
+ (instancetype) Roon
{
    return UIColorFromRGB(0x62b0d9);
}
+ (instancetype) RSS
{
    return UIColorFromRGB(0xee802f);
}
+ (instancetype) Salesforce
{
    return UIColorFromRGB(0x1798c1);
}
+ (instancetype) Samsung
{
    return UIColorFromRGB(0x0c4da2);
}
+ (instancetype) Shopify
{
    return UIColorFromRGB(0x96bf48);
}
+ (instancetype) Skype
{
    return UIColorFromRGB(0x00aff0);
}
+ (instancetype) SmashingMagazine
{
    return UIColorFromRGB(0xf0503a);
}
+ (instancetype) Snagajob
{
    return UIColorFromRGB(0xf47a20);
}
+ (instancetype) Softonic
{
    return UIColorFromRGB(0x008ace);
}
+ (instancetype) SoundCloud
{
    return UIColorFromRGB(0xff7700);
}
+ (instancetype) SpaceBox
{
    return UIColorFromRGB(0xf86960);
}
+ (instancetype) Spotify
{
    return UIColorFromRGB(0x81b71a);
}
+ (instancetype) Sprint
{
    return UIColorFromRGB(0xfee100);
}
+ (instancetype) Squarespace
{
    return UIColorFromRGB(0x121212);
}
+ (instancetype) StackOverflow
{
    return UIColorFromRGB(0xef8236);
}
+ (instancetype) Staples
{
    return UIColorFromRGB(0xcc0000);
}
+ (instancetype) StatusChart
{
    return UIColorFromRGB(0xd7584f);
}
+ (instancetype) Stripe
{
    return UIColorFromRGB(0x008cdd);
}
+ (instancetype) StudyBlue
{
    return UIColorFromRGB(0x00afe1);
}
+ (instancetype) StumbleUpon
{
    return UIColorFromRGB(0xf74425);
}
+ (instancetype) TMobile
{
    return UIColorFromRGB(0xea0a8e);
}
+ (instancetype) Technorati
{
    return UIColorFromRGB(0x40a800);
}
+ (instancetype) TheNextWeb
{
    return UIColorFromRGB(0xef4423);
}
+ (instancetype) Treehouse
{
    return UIColorFromRGB(0x5cb868);
}
+ (instancetype) Trello
{
    return UIColorFromRGB(0x256a92);
}
+ (instancetype) Trulia
{
    return UIColorFromRGB(0x5eab1f);
}
+ (instancetype) Tumblr
{
    return UIColorFromRGB(0x34526f);
}
+ (instancetype) TwitchTv
{
    return UIColorFromRGB(0x6441a5);
}
+ (instancetype) Twitter
{
    return UIColorFromRGB(0x00acee);
}
+ (instancetype) Typekit
{
    return UIColorFromRGB(0x9aca3c);
}
+ (instancetype) TYPO3
{
    return UIColorFromRGB(0xff8700);
}
+ (instancetype) Ubuntu
{
    return UIColorFromRGB(0xdd4814);
}
+ (instancetype) Ustream
{
    return UIColorFromRGB(0x3388ff);
}
+ (instancetype) Venmo
{
    return UIColorFromRGB(0x3d95ce);
}
+ (instancetype) Verizon
{
    return UIColorFromRGB(0xef1d1d);
}
+ (instancetype) Vimeo
{
    return UIColorFromRGB(0x44bbff);
}
+ (instancetype) Vine
{
    return UIColorFromRGB(0x00a478);
}
+ (instancetype) Virb
{
    return UIColorFromRGB(0x06afd8);
}
+ (instancetype) VirginMedia
{
    return UIColorFromRGB(0xcc0000);
}
+ (instancetype) VKontakte
{
    return UIColorFromRGB(0x45668e);
}
+ (instancetype) Wooga
{
    return UIColorFromRGB(0x5b009c);
}
+ (instancetype) WordPressBlue
{
    return UIColorFromRGB(0x21759b);
}
+ (instancetype) WordPressOrange
{
    return UIColorFromRGB(0xd54e21);
}
+ (instancetype) WordPressGrey
{
    return UIColorFromRGB(0x464646);
}
+ (instancetype) Wunderlist
{
    return UIColorFromRGB(0x2b88d9);
}
+ (instancetype) XBOX
{
    return UIColorFromRGB(0x9bc848);
}
+ (instancetype) XING
{
    return UIColorFromRGB(0x126567);
}
+ (instancetype) Yahoo
{
    return UIColorFromRGB(0x720e9e);
}
+ (instancetype) Yandex
{
    return UIColorFromRGB(0xffcc00);
}
+ (instancetype) Yelp
{
    return UIColorFromRGB(0xc41200);
}
+ (instancetype) YouTube
{
    return UIColorFromRGB(0xc4302b);
}
+ (instancetype) Zalongo
{
    return UIColorFromRGB(0x5498dc);
}
+ (instancetype) Zendesk
{
    return UIColorFromRGB(0x78a300);
}
+ (instancetype) Zerply
{
    return UIColorFromRGB(0x9dcc7a);
}
+ (instancetype) Zootool
{
    return UIColorFromRGB(0x5e8b1d);
}

@end
