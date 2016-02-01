//
//  SignInViewController.m
//  expendingCell_TEST
//
//  Created by vlaskos on 31.01.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import "SignInViewController.h"
#import "ViewController.h"
#import "Utils.h"

@interface SignInViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *desciptionLable;
@property (strong, nonatomic) IBOutlet UITextField *loginTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordtextField;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation SignInViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUIElements];
    [self hideKyyboardTouchingOutside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUIElements {
    
    
    self.view.backgroundColor = [UIColor blackColor];
    self.desciptionLable.text = @"Please, enter your login and password";
    self.desciptionLable.textColor = [UIColor whiteColor];
    
    self.loginTextField.delegate = self;
    self.passwordtextField.delegate = self;
    
    self.signInButton.backgroundColor = [UIColor blackColor];
    self.signInButton.titleLabel.textColor = [UIColor whiteColor];
    [self.signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [self.signInButton setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (BOOL) isEnterInfo {
    
    BOOL isEnterInfo = YES;
    
    if (self.loginTextField.text.length == 0) {
        return NO;
    } else  if (self.passwordtextField.text.length == 0) {
        return NO;
    }
    return isEnterInfo;
}

#pragma mark - Actions

- (IBAction)signInButtonAction:(id)sender {
    if ([self isEnterInfo] == YES) {
        if (![self.loginTextField.text isEqualToString:@"admin"] | ![self.passwordtextField.text isEqualToString:@"1111"]) {
            [self textOfAllertMessage:@"Incorrect info!"];
        } else {
            
            [Utils sharedInstance].isLogged = YES;

            [[NSUserDefaults standardUserDefaults] setBool:[Utils sharedInstance].isLogged forKey:@"isLogged"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        }
    } else {
        [self textOfAllertMessage:@"Enter your login and password, please"];
    }
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(textField == self.loginTextField | textField == self.passwordtextField){
        //take up keyboard whan edit in textField
        float moveSpeed = 0.2f;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:moveSpeed];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(0, -50.0f, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    

    if(textField == self.loginTextField | textField == self.passwordtextField){
        
        ///take down keyboard whan edit in textField
        float moveSpeed = 0.2f;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:moveSpeed];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

#pragma mark  - UITextFieldDelegate

- (void) hideKyyboardTouchingOutside {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.loginTextField resignFirstResponder];
    [self.passwordtextField resignFirstResponder];
}

#pragma mark - Alert Action

- (void) textOfAllertMessage:(NSString*) name{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: name
                                                                        message: nil
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Закрыть"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                        }];
    
    [controller addAction: alertAction];
    
    [self presentViewController: controller animated: YES completion: nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
