//
//  ServicesVC.m
//
//  Copyright © 2016 netset. All rights reserved.
//

#import "ServicesVC.h"
#import "MaleServicesVC.h"
#import "FemaleServicesVC.h"
#import "FemaleDetailServicesVC.h"
#import <CoreLocation/CoreLocation.h>
#import "CNPPopupController.h"
#praga mark ==================================== Animation ======================================
@interface ServicesVC ()<CLLocationManagerDelegate,UIAlertViewDelegate,CNPPopupControllerDelegate>
{
    UIButton *aButton;
    NSArray *arrayText;
    CGRect imageFrameSet;
    NSInteger imgViewTag;
    NSArray *arrayImages;
    NSString *strTitleForMale;
}
@property (nonatomic, strong) CNPPopupController *popupController;
@end

@implementation ServicesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=nil;
    [self.navigationController.navigationBar setHidden:NO];
    if (strLongitude==nil) {
        strLatitude=[arrayProfileData valueForKey:@"latitude"];
        strLongitude=[arrayProfileData valueForKey:@"longitude"];
        strCity=[arrayProfileData valueForKey:@"city"];
    }
    
//    if (strLatitude==nil) {
//        sleep(1);
//    }
    [self getServicesAPI];
    // [self getProfile];
    
    
    if ([strServiceUser isEqualToString:@"Male"] || [strServiceUser isEqualToString:@"male"]) {
        strServiceUser=@"M";
    }
    if ([strServiceUser isEqualToString:@"Female"] || [strServiceUser isEqualToString:@"female"]) {
        strServiceUser=@"F";
    }
}

-(void)addingText
{
    if ([strServiceUser isEqualToString:@"M"])
    {
        arrayText=[NSArray arrayWithObjects:@"               S T Y L E  &  S C I S S O R S  C U T",@"              F A D E S    &  B U Z Z  C U T", @"C H I Q U S", nil];
    }
    else {
        arrayText=[NSArray arrayWithObjects:@"H A I R",@"M A K E U P",@"H A I R  &  M A K E U P",@"C H I Q U S", nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)buttonAtRight:(id)sender
{
    if ([strServiceUser isEqualToString:@"M"]) {
        strServiceUser=@"F";
    }
    else
        strServiceUser=@"M";

    [aButton setImage:[self settingImage] forState:UIControlStateNormal] ;
    CGFloat imageY = self.view.frame.size.height;
    for (int i=0; i<arrayText.count; i++) {
        imageY=self.view.frame.origin.y;
        [self animationStart:(UIView*)[self.view viewWithTag:100+i] y:imageY boolValue:false];
    }
    [self addingText];
    [self imageViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)addToggleButtonOnRightSide
{
    UIImage *imageButon=[self settingImage];
    [aButton setImage:imageButon forState:UIControlStateNormal];
    aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundImage:imageButon forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, imageButon.size.width,   imageButon.size.height);
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(buttonAtRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:aBarButtonItem];
}

-(UIImage *)settingImage
{
    UIImage *image;
    if ([strServiceUser isEqualToString:@"M"]) {
        image = [UIImage imageNamed:@"toggle_male"];
    }
    else
        image = [UIImage imageNamed:@"toggle_female"];
    return image;
}

-(void)imageViews
{
    CGFloat height;
    if ([strServiceUser isEqualToString:@"F"]) {
        arrayImages=[NSArray arrayWithObjects:@"HAIR",@"MAKEUP",@"HAIR & MAKEUP-1",@"CHIQUS-1", nil];
        //        else
        height=self.view.bounds.size.height/4;
    }
    else
    {
        arrayImages=[NSArray arrayWithObjects:@"scissors_cut",@"fades_cut",@"male_chiqus", nil];
        height=self.view.bounds.size.height/3;
    }
    
    CGFloat imageY =self.navigationController.view.frame.origin.y;
    for (int i=0; i<arrayImages.count; i++) {
        
        // MainView Created
        UIView *viewImageLabel=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, height)];
        viewImageLabel.tag=i+100;
        
        // ImageView Created
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, viewImageLabel.frame.size.width, viewImageLabel.frame.size.height)];
        imageView.image=[UIImage imageNamed:[arrayImages objectAtIndex:i]];
        [viewImageLabel addSubview:imageView];
        
        // Label Created
        [self addingLabelOnMainView:imageView indexPath:i];
        
        //Label for price tag
        [self addingLabelPrice:imageView indexPath:i];
        
        [self.view addSubview:viewImageLabel];
        
        UITapGestureRecognizer *tapOnImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextScreenOnTap:)];
        [tapOnImage setNumberOfTapsRequired:1];
        tapOnImage.cancelsTouchesInView=NO;
        [viewImageLabel addGestureRecognizer:tapOnImage];
        
        //Showing Animation
        [self animationStart:viewImageLabel y:imageY boolValue:true];
        imageY = imageY+imageView.frame.size.height;
    }
}

-(void)animationStart:(UIView *)imgView y:(CGFloat)y boolValue:(BOOL)boolValue
{
    [UIView animateWithDuration:1.0 delay:0.2 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
        CGRect imgRect = imgView.frame;
        imgRect.origin.y = y;
        imgView.frame = imgRect;
        
    } completion:^(BOOL finished) {
        if (boolValue) {
        }
        else
        {
            [imgView removeFromSuperview];
        }
    }];
}


-(void)addingLabelOnMainView:(UIImageView *)imageViewLayer indexPath:(int)index
{
    UILabel *label=[[UILabel alloc]init];
    label.textAlignment=NSTextAlignmentRight;
    label.text=[arrayText objectAtIndex:index];
    label.font=[UIFont fontWithName:@"Ubuntu-Medium" size:17.0f];
    CGSize textSize = [[label text] sizeWithAttributes:@{NSFontAttributeName:[label font]}];
    CGFloat strikeWidth = textSize.width;
    if (strikeWidth>(self.view.frame.size.width/2)+20) {
        label.frame=CGRectMake((self.view.frame.size.width/2)-10, imageViewLayer.frame.size.height-(30*2),self.view.frame.size.width-(self.view.frame.size.width/2), 60);
        label.numberOfLines=2;}
    
    else{
        label.numberOfLines=1;
        label.frame=CGRectMake(self.view.frame.origin.x+120 , imageViewLayer.frame.size.height-30,self.view.frame.size.width-(self.view.frame.origin.x+130), 30);
    }
    
    label.textColor=[UIColor whiteColor];
    [imageViewLayer addSubview:label];
}

-(void)addingLabelPrice:(UIImageView *)imageViewLayer indexPath:(int)index
{
    if ([strServiceUser isEqualToString:@"F"]) { }
    else
    {
        UILabel *label=[[UILabel alloc]init];
        label.textAlignment=NSTextAlignmentCenter;
        if (arrayServices==nil) {
            if (index==0 || index==1) {
                label.text=[NSString stringWithFormat:@"$%@",[[arrayServices valueForKeyPath:@"men.hair.service_cost"]objectAtIndex:index]];
            }
        }
        label.font=[UIFont fontWithName:@"Ubuntu-Medium" size:17];
        label.numberOfLines=1;
        label.frame=CGRectMake(10 , imageViewLayer.frame.size.height-40,40,40);
        label.textColor=[UIColor whiteColor];
        [imageViewLayer addSubview:label];
    }
}

#pragma mark Hide Keyboard on Tap Gesture
- (void)nextScreenOnTap:(UITapGestureRecognizer *)gestureRecognizer;
{
    NSArray *arrSendData;
    imgViewTag=gestureRecognizer.view.tag;
    if ([strServiceUser isEqualToString:@"M"])
    {
        if (gestureRecognizer.view.tag==100 || gestureRecognizer.view.tag==101 ) {
            UIImageView *imgView=[[gestureRecognizer.view subviews]objectAtIndex:0];
            arrSendData=[NSArray arrayWithObjects:imgView.image, nil];
            [dictDataForBookAppointment setValue:@"N" forKey:@"serviceType"];
            imageFrameSet=gestureRecognizer.view.frame;
        }
        else
        {
            UIImageView *imgView=[[(UIView *)[self.view viewWithTag:100]subviews]objectAtIndex:0];
            UIImageView *imgView1=[[(UIView *)[self.view viewWithTag:101]subviews]objectAtIndex:0];
            arrSendData=[[NSArray alloc]initWithObjects:imgView.image,imgView1.image,nil];
            [dictDataForBookAppointment setValue:@"C" forKey:@"serviceType"];
        }
        if (gestureRecognizer.view.tag==100) {
            strTitleForMale=@"STYLE & SCISSORS CUT";
        }
        else if (gestureRecognizer.view.tag==101) {
            strTitleForMale=@"FADES & BUZZ CUT";
        }
        else{
            strTitleForMale=@"CHIQUS";
        }
        
        [self performSegueWithIdentifier:@"maleServicesView" sender:arrSendData];
    }
    else
    {
        if (gestureRecognizer.view.tag==101) {
            UIImageView *imgView=[[gestureRecognizer.view subviews]objectAtIndex:0];
            arrSendData=[NSArray arrayWithObjects:imgView.image, nil];
            imageFrameSet=gestureRecognizer.view.frame;
            [self performSegueWithIdentifier:@"femaleDetails" sender:arrSendData];
        }
        else
        {
            if (gestureRecognizer.view.tag==102)
            {
                imageFrameSet=gestureRecognizer.view.frame;
            }else{
                
            }
            if ([[arrayImages objectAtIndex:gestureRecognizer.view.tag-100]containsString:@"-1"]) {
                [self performSegueWithIdentifier:@"servicesDetailView" sender:[[arrayImages objectAtIndex:gestureRecognizer.view.tag-100] substringToIndex:[[arrayImages objectAtIndex:gestureRecognizer.view.tag-100]length]-2]];
            }
            else
                [self performSegueWithIdentifier:@"servicesDetailView" sender:[arrayImages objectAtIndex:gestureRecognizer.view.tag-100]];
            
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"spewEffect";
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    if ([segue.identifier isEqualToString:@"maleServicesView"]) {
        MaleServicesVC *objMaleServicesVC=[segue destinationViewController];
        [dictDataForBookAppointment setValue:[self getServiceId:@"M"] forKey:@"id"];
        objMaleServicesVC.arrayMaleData=sender;
        objMaleServicesVC.strTitle=strTitleForMale;
        objMaleServicesVC.frameView=imageFrameSet;
    }
    if ([segue.identifier isEqualToString:@"servicesDetailView"]) {
        FemaleServicesVC *objFemaleServicesVC=[segue destinationViewController];
        objFemaleServicesVC.strServiceType=sender ;
        if ([sender isEqualToString:@"HAIR & MAKEUP"]) {
            objFemaleServicesVC.frameView=imageFrameSet;
        }
    }
    if ([segue.identifier isEqualToString:@"femaleDetails"]) {
        FemaleDetailServicesVC *objFemaleDetailServicesVC=[segue destinationViewController];
        objFemaleDetailServicesVC.arrayFemaleData=sender;
        objFemaleDetailServicesVC.strServiceTitle=@"MAKEUP";
        objFemaleDetailServicesVC.frameView=imageFrameSet;
        [dictDataForBookAppointment setValue:[self getServiceId:@"W"] forKey:@"id"];
        //objFemaleDetailServicesVC.rectFrame=imageFrameSet;
    }
}

-(NSString *)getServiceId :(NSString *)strServiceTaker
{
    NSString *strServicesId;
    if (arrayServices==nil)
    {
        [self getServicesAPI];
    }
    if ([strServiceTaker isEqualToString:@"M"]) {
        
        if (imgViewTag==100 || imgViewTag==101) {
            strServicesId=[[arrayServices valueForKeyPath:@"men.hair.id"]objectAtIndex:imgViewTag-100];
        }
        else
        {
            for (int i=0; i<[[arrayServices valueForKeyPath:@"men.men_chiqus.id"]count]-1;i++) {
                if (i==0) {
                    strServicesId = [[arrayServices valueForKeyPath:@"men.men_chiqus.id"]objectAtIndex:i];
                }
                else
                {
                    strServicesId = [NSString stringWithFormat:@"%@,%@",strServicesId,[[arrayServices valueForKeyPath:@"men.men_chiqus.id"]objectAtIndex:i]];
                }
            }
        }
    }
    else
    {
        if (imgViewTag==101) {
            strServicesId=[[arrayServices valueForKeyPath:@"women.makeup.id"]objectAtIndex:0];
        }
    }
    return strServicesId;
}



#pragma Mark ------------- (10) Get Services(getServices)---------------
-(void)getServicesAPI
{
    if (strLatitude==nil )
    {
        [[[UIAlertView alloc]initWithTitle:nil message:@"Unable to get your location" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLocation" object:self];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                  target:self
                                                  action:@selector(refresh)];
    }
    else{
        
        WebService *servercall=[WebService sharedInstance];
        [AppDelegate ShowProgressHud:self.navigationController.view string:@"Fetching Services"];
//        NSString *strDeviceToken;
//        if ([[NSUserDefaults standardUserDefaults] valueForKeyPath:@"DeviceToken"]==nil) {
//            strDeviceToken=@"1";
//        }
//        else
//        {
//            strDeviceToken=[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"DeviceToken"];
//        }
        
       NSDictionary *dict=@{@"latitude":strLatitude,@"longitude":strLongitude,@"user_id":strUserId,@"city":strCity};
      //    NSDictionary *dict=@{@"latitude":@"40.759211000000001",@"longitude":@"-73.984638000000003",@"user_id":strUserId};
        [servercall getJsonData:nil actionmethod:@"getServices" parameters:dict onComplete:^(NSDictionary *json) {
            NSLog(@"%@",json);
            NSNumber *boolCheck = [json valueForKeyPath:@"data.card_status"];
            if (boolCheck == [NSNumber numberWithBool:YES]) {
                boolCardStatus=true;
            }
            else
            {  boolCardStatus=false;}
            [AppDelegate HideProgressHud:self.navigationController.view];
            if ([[json valueForKey:@"status"]isEqual:@YES]) {
                arrayServices=[json valueForKey:@"data"];
                [self addingText];
                [self addToggleButtonOnRightSide];
                boolValue=false;
                [self imageViews];
                boolIsFromConfirmed=false;
                [self performSelector:@selector(getPoints) withObject:nil afterDelay:1.5];
            }
        } onError:^(NSError *error)
         {
             UIAlertView *alert=  [[UIAlertView alloc]initWithTitle:@"Message" message:@"Unable to get services list" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
             //alert.tag=-3;
             [alert show];
             [AppDelegate HideProgressHud:self.navigationController.view];
         }];
    }
}
//}


-(void)refresh{
    self.navigationItem.rightBarButtonItem=nil;
    
    if (strLatitude==nil )
    {//&& locationManager.location==nil) {
        AlertWithParam(nil, @"Unable to get your location");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLocation" object:self];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                  target:self
                                                  action:@selector(refresh)];
    }
    else{
        [self getServicesAPI];
    }
}


-(void)getPoints
{
    if (checkProfileFirstTime)
    {
        checkProfileFirstTime=NO;
        [self showPopupWithStyle:CNPPopupStyleCentered withType:@"Hey Good Looking" andwithPoints:@"2"];
    }else if (_arrPointsNotificationdata.count!=0)
    {
        switch ([[_arrPointsNotificationdata valueForKey:@"number_of_time"]integerValue]) {
            case 1:
                [arrBadgesData addObject:@"Tell-A-Friend,badge8_active"];
                break;
            case 2:
                [arrBadgesData addObject:@"Chatter Mouth,badge9_active"];
                break;
            case 4:
                [arrBadgesData addObject:@"Trend Setter,badge10_active"];
                break;
            default:
                break;
        }
        [self showPopupWithStyle:CNPPopupStyleCentered withType:nil andwithPoints:[_arrPointsNotificationdata valueForKey:@"points"]];
    }
}


- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle withType:(NSString *)type andwithPoints:(NSString *)point {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Congratulations!!!" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:type attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"You have earned %@ points.",point] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0], NSParagraphStyleAttributeName : paragraphStyle}];
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:@"Close Me" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    button.layer.cornerRadius = 4;
    button.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        [arrBadgesData removeAllObjects];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    UILabel *badgeName = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height+10, 150, 21)];
    
    if ([type isEqualToString:@"Hey Good Looking"]) {
        imageView.image=[UIImage imageNamed:@"badge1_active"];
        badgeName.attributedText=lineOne;
        
    }else{
        
        NSArray *items=[[arrBadgesData objectAtIndex:0]componentsSeparatedByString:@","];
        imageView.image=[UIImage imageNamed:[items objectAtIndex:1]];
        
        badgeName.textColor=[UIColor blackColor];
        badgeName.textAlignment=NSTextAlignmentCenter;
        badgeName.font=[UIFont systemFontOfSize:12];
        badgeName.text = [items objectAtIndex:0];
    }
    
    UILabel *lineTwoLabel = [[UILabel alloc] init];
    lineTwoLabel.numberOfLines = 0;
    lineTwoLabel.attributedText = lineTwo;
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel,imageView ,badgeName, lineTwoLabel,button]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}

#pragma mark - CNPPopupController Delegate

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    NSLog(@"Dismissed with button title: %@", title);
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    NSLog(@"Popup controller presented.");
}



//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    //   if (alertView.tag==-3) {
//    [self getServicesAPI];
//    // }
//}

- (IBAction)unwindToHomeServices:(UIStoryboardSegue *)unwindSegue {
    
}


//-(void)getProfile
//{
//    WebService *servercall=[WebService sharedInstance];
//    NSDictionary *dict=@{@"user_id":strUserId};
//    [servercall getJsonData:nil actionmethod:@"getProfile" parameters:dict onComplete:^(NSDictionary *json) {
//        NSLog(@"%@",json);
//        arrayProfileData=[json valueForKey:@"data"];
//        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
//        NSData* data=[NSKeyedArchiver archivedDataWithRootObject:arrayProfileData];
//        [currentDefaults setObject:data forKey:@"profileData"];
//        [currentDefaults synchronize];
//     } onError:^(NSError *error) {
//    }];
//}
BOOL boolValue;
@end
