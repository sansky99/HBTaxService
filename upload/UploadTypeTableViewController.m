//
//  UploadTypeTableViewController.m
//  HBTaxService
//
//  Created by khuang on 14-11-4.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "UploadTypeTableViewController.h"
#import "UploadTypeInfoViewController.h"
#import "UploadSourceViewController.h"
#include "CompatibleaPrintf.h"



enum Col_index{
    UploadCol_ID      = 0,
    UploadCol_Name,
    UploadCol_Info
};


@interface UploadTypeTableViewController ()

@property (nonatomic, strong) NSArray *uploadTypes;

@end

@implementation UploadTypeTableViewController
@synthesize uploadTypes;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NeedOffsetWhenIOS7NavBar
    
    self.hidesBottomBarWhenPushed = TRUE;
    self.title = @"上传电子影像";
    
    self.tableView.rowHeight = 60;
    
    uploadTypes = @[
                    @[@1101, @"税务证件", @"A、 税务登记证副本：在申请存款账户账号报告时，要提供税务登记证副本。\n\
B、 购货方加盖一般纳税人戳记的税务登记证副本：申请增值税专用发票代开或申请货运增值税专用发票代开时，需要上传购货方加盖一般纳税人戳记的税务登记证副本。"]
                    ,   @[@1201, @"工商及其他机构证件", @"A、 工商营业执照：如果您已经取得工商营业执照，在税务登记变更时，如果涉及到工商营业执照上的内容变更时，需要上传新的工商营业执照。\n\
B、 其它机构核准文件：如果您未取得工商营业执照但是获得其它营业核准文件，涉及到这些文件中的内容变更的，要上传最新的核准文件。\n\
C、 组织机构统一代码证书：如果您取得组织机构统一代码证书，在变更登记时如果涉及到组织统一代码机构证上内容变更的，要上船最新的组织统一机构代码证书。"]
                    ,   @[@1301, @"银行证件", @"A、 银行开户许可证：您在进行存款帐户帐号报告备案时，如果取得了银行开户许可证，请上传您的银行开户许可证书。"]
                    ,   @[@1401, @"合同及交易文件", @"A、 合同及交易文件：您在申请普通发票、增值税专用发票、货运增值税专用发票代开时，需要上传合同文件。"]
                    ,   @[@1501, @"身份证件", @"A、 法定代表人身份证件：如果您的变更您的法人代表身份证件，请上传最新的法人代表身份证件。\n\
B、 财务负责人身份证件：如果您要新增财务负责人或修改财务负责人身份证件，请上传财务负责人身份证件。\n\
C、 办税人员居民身份证：如果您要新增办税人人或修改财务负责人身份证件，请上传财务负责人身份证件\n\
D、 业主身份证件：如果您是个体工商户、个人或何人合伙企业，在业主身份证件变化时，请上传最新的业主身份证件。\n\
E、 发票经办人身份证件：在办理发票使用申请或票中核定信息变更时，如果有发票经办人变化的，上传变更后的发票经办人身份证件。\n\
F、 身份证件：未办理税务登记的个人在申请代开普通发票时，要上传身份证件。"]
                    ,   @[@1801, @"公司内部文件", @"A、 决议文件：如果要变更到股东、注册资本等信息变更的，需要上传新的决议及有关证明文件。\n\
B、 验资报告：如果要变更到股东、注册资本等信息变更的，需要上传新或有关注册资本、投资状况变更的章程修正案或验资报告。"]
                    ,   @[@1701, @"印章", @"A、 发票专用章印模：发票使用申请（首次领用）时，需要上传发票专用章印模。"]
                    ,   @[@1601, @"产权及资质证明", @"A、 产权证：您的注册地址或生产经营地址如果取得了产权证，在税务登记变更时如果涉及到注册地址、生产经营地址变更的，请上传新的产权证 。\n\
B、 租赁协议：如果您的注册地址或生产经营地址是租赁的，在税务登记变更时如果涉及到注册地址、生产经营地址变更的，请上传新的租赁协议。\n\
C、 营运资质证明：申请代开货运增值税专用发票的，要上传营运资质证明复印件、供承包、承租合同及运输工具有效证明的复印件；自有运输工具营运的，提供所有运输工具有效证明复印件。"]
                    ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.uploadTypes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UploadTypeCellID"];
    
    cell.textLabel.text = (self.uploadTypes[indexPath.section])[UploadCol_Name];
    cell.imageView.image = [UIImage imageNamed:
                            [NSString stringWithFormat:@"%@", (self.uploadTypes[indexPath.section])[UploadCol_ID]]];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = self.parentViewController.parentViewController.storyboard;
    
    UploadSourceViewController * sourceViewController = [storyboard instantiateViewControllerWithIdentifier: NSStringFromClass( [UploadSourceViewController class])];
    sourceViewController.typeID = (self.uploadTypes[indexPath.section])[UploadCol_ID];
    sourceViewController.typeName = (self.uploadTypes[indexPath.section])[UploadCol_Name];
    sourceViewController.title = sourceViewController.typeName;

    [self.navigationController pushViewController:sourceViewController animated:TRUE];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UploadTypeInfoViewController *info = [[UploadTypeInfoViewController alloc] init];
    info.info = (self.uploadTypes[indexPath.section])[UploadCol_Info];
    info.title = (self.uploadTypes[indexPath.section])[UploadCol_Name];
    [self.navigationController pushViewController:info animated:TRUE];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
