//
//  FillBLViewController.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/9.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "FillBLViewController.h"
#import "ProductSortModel.h"

@interface FillBLViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UITextView *titleTextField;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet UITextField *sortTextField;
@property (weak, nonatomic) IBOutlet UIView *reasonView;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UITextView *reasonTextField;
@property (weak, nonatomic) IBOutlet UIView *reasonLineView;


@property (nonatomic,strong) UIPickerView *dataPickerView;
@property (nonatomic,strong) UIView *pickerView;

@property (nonatomic,strong) ProductSortModel *selectedProduct;

@property(nonatomic,retain)NSMutableDictionary* dict;
@property(nonatomic,retain)NSArray* pickerArray;
@property(nonatomic,retain)NSArray* subPickerArray;

@end

@implementation FillBLViewController
{
     CGFloat changeheight ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNaviBarView];
    self.reasonTextField.delegate = self;
    self.navBarTitleLabel.text = @"我的爆料";
    self.dict = [NSMutableDictionary new];
    self.pickerArray = @[];
    self.subPickerArray = @[];
    [self.view addSubview:self.pickerView];
    [self getProductSortData];
    
    if (self.model.title ) {
        self.titleTextField.text = self.model.title;
    }
    if (_model.source ) {
        self.nameTextField.text = _model.source;
    }
    if (_model.price ) {
        self.priceTextField.text = _model.price;
    }
    if (_model.productType) {
        self.sortTextField.text = _model.productType;
    }
    if (_model.shareReason) {
        self.reasonTextField.text = _model.shareReason;
    }
    
    self.sortTextField.delegate = self;
    
    self.titleView.width = self.nameView.width = self.priceView.width = self.sortView.width  = self.reasonView.width = mScreenWidth-40;
    [self addBottomBorderWithView:self.titleView];
    [self addBottomBorderWithView:self.nameView];
    [self addBottomBorderWithView:self.priceView];
    [self addBottomBorderWithView:self.sortView];
    self.reasonLineView.height = 0.5f;
//    [self.titleView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
//    [self.nameView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
//    [self.priceView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
//    [self.sortView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
//    [self.reasonView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    
    self.sortTextField.enabled = NO;
    UITapGestureRecognizer *tapOnSort = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSortView)];
    [self.sortView addGestureRecognizer:tapOnSort];
    
    self.okBtn.layer.cornerRadius = 25;
    [self.scrollView setContentSize:CGSizeMake(mScreenWidth, self.okBtn.bottom + 20)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)addBottomBorderWithView:(UIView *)mainview
{
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, mainview.height - kLayerBorderWidth, mainview.width, kLayerBorderWidth)];
    lineview.backgroundColor = kLayerBorderColor;
    [mainview addSubview:lineview];
}
-(void)tapOnSortView{
    [self.view endEditing:YES];
    [self showPickerView];
}

- (void) getProductSortData{
    NSDictionary *params = @{@"uid":@"getSortInfos"};
    [APIOperation GET:@"getSource.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            NSArray *jsonArray = [responseData objectForKey:@"beans"];
            [jsonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *subJsonArray = [obj objectForKey:@"subsorts"];
                NSMutableArray *subArray = [NSMutableArray new];
                [subJsonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ProductSortModel *subSortModel = [[ProductSortModel alloc] initWithDictionary:obj];
                    [subArray addObject:subSortModel];
                }];
                [_dict setObject:subArray forKey:[obj objectForKey:@"name"]];
            }];
            self.pickerArray=[_dict allKeys];
            self.subPickerArray=[_dict objectForKey:[[_dict allKeys] objectAtIndex:0]];

            [self.dataPickerView reloadAllComponents];
        }else{
            mAlertAPIErrorInfo(error);
        }
    }];
}

-(UIView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, mScreenHeight, mScreenWidth, 219)];
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        _dataPickerView = [[UIPickerView alloc] init];
        _dataPickerView.top = 0;
        _dataPickerView.width = mScreenWidth;
        _dataPickerView.height = 219 ;
        _dataPickerView.dataSource = self;
        _dataPickerView.delegate = self;
        
        [_dataPickerView reloadAllComponents];
        [_pickerView addSubview:_dataPickerView];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setFrame:CGRectMake(0, 0, 50, 44)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:mRGBToColor(0x999999) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView addSubview:cancelBtn];
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [okBtn setFrame:CGRectMake(mScreenWidth-50, 0, 50, 44)];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [okBtn setTitleColor:mRGBToColor(0x333333) forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(okPickerView) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView addSubview:okBtn];
        [_pickerView addTopBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    }
    return _pickerView;
}

-(void)okPickerView{
    
    if (!self.selectedProduct && [self.subPickerArray count]>0) {
        self.selectedProduct = [self.subPickerArray firstObject];
    }
    self.sortTextField.text = self.selectedProduct.name;
    
    [self hidePickerView];
}

-(void)showPickerView{
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.top = mScreenHeight - _pickerView.height ;
    }];
}

-(void)hidePickerView{
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.top = mScreenHeight ;
    }];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.pickerArray.count;
    }else{
        return self.subPickerArray.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [self.pickerArray objectAtIndex:row];
            break;
        case 1:{
            ProductSortModel *sortModel =[self.subPickerArray objectAtIndex:row];
            return sortModel.name;

        }
            break;
        default:
            break;
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        
        self.subPickerArray= [_dict objectForKey:[self.pickerArray objectAtIndex:row]];
        //[pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:1];
        self.selectedProduct =nil;
    }else{
        ProductSortModel *sortModel =[self.subPickerArray objectAtIndex:row];
        self.selectedProduct = sortModel;
        
    }
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return  40;
}

- (IBAction)okAction:(id)sender {
    NSString *title = self.titleTextField.text;
    NSString *name = self.nameTextField.text;
    NSString *price = self.priceTextField.text;
    NSString *sort = self.selectedProduct.sortId;
    NSString *reason = self.reasonTextField.text;
    
    if ([title length]==0) {
        mAlertView(@"提示", @"商品标题不能为空");
        return;
    }
    if ([name length]==0) {
        mAlertView(@"提示", @"商城名称不能为空");
        return;
    }
    if ([price length]==0) {
        mAlertView(@"提示", @"价格不能为空");
        return;
    }
    if ([sort length]==0) {
        mAlertView(@"提示", @"请选择分类");
        return;
    }
    if ([reason length]==0) {
        mAlertView(@"提示", @"推荐理由不能为空");
        return;
    }
   
    NSDictionary *params = @{
                             @"uid":@"saveShareInfo",
                             @"userId":[AppCache getUserId],
                             @"type":@"1",
                             @"productType":sort,
                             @"title":title,
                             @"price":price,
                             @"source":name,
                             @"sourceLink":_model.sourceLink,
                             @"sharePic":_model.sharePic,
                             @"shareReason":reason
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            [mAppUtils showHint:@"爆料成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            mAlertAPIErrorInfo(error);
        }
    }];

}

#pragma mark - Keyboard status

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    
    // Orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // User Info
    NSDictionary *info = notification.userInfo;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // Keyboard Size
    //Checks if IOS8, gets correct keyboard height
    CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.000000) ? keyboardEnd.size.height : keyboardEnd.size.width : keyboardEnd.size.height;
    // Correct Curve
    UIViewAnimationOptions animationOptions = curve << 16;
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            
            //scrollView高度
          
           
            self.scrollView.height = self.view.frame.size.height - keyboardHeight;
    
        } completion:nil];
        
    } else {
        
        //scrollView高度
        self.scrollView.height = self.view.frame.size.height ;
        
    }//end
    
}

#pragma mark - textview的代理
-(void)textViewDidChange:(UITextView *)textView{

    CGRect frame = textView.frame;
    frame.size.height = textView.contentSize.height;
    changeheight = frame.size.height - textView.height;
    textView.frame = frame;
        
    
   
    
    if (changeheight != 0) {
        self.reasonView.height = self.reasonView.height + changeheight;
        self.okBtn.top = self.okBtn.top + changeheight;
        CGSize scrollViewsize = self.scrollView.contentSize;
        scrollViewsize.height = scrollViewsize.height + changeheight;
        self.scrollView.contentSize = scrollViewsize;
        CGFloat height = self.scrollView.contentOffset.y + changeheight;
         [self.scrollView setContentOffset:CGPointMake(0,height) animated:NO];
    }
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.textView endEditing:YES];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
