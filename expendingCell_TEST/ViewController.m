//
//  ViewController.m
//  expendingCell_TEST
//
//  Created by vlaskos on 30.01.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"
#import "Utils.h"
#import "SignInViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property  NSArray* dataList;
@property NSDictionary *list;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    selectedIndex = -1;

    [self readDataFromFile];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)readDataFromFile
{
    NSString * filePath =[[NSBundle mainBundle] pathForResource:@"list" ofType:@"json"];
    
    NSError * error;
    NSString* fileContents =[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    
    if(error)
    {
        NSLog(@"Error reading file: %@",error.localizedDescription);
    }
    
    
    self.dataList = (NSArray *)[NSJSONSerialization
                                JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding]
                                options:0 error:NULL];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CustomCell = @"CustomTableViewCell";
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (selectedIndex == indexPath.row) {
        
        cell.contentView.backgroundColor = [UIColor grayColor];
        cell.typeLabel.textColor = [UIColor whiteColor];
        cell.modelLabel.textColor = [UIColor whiteColor];
        cell.statusLabel.textColor = [UIColor whiteColor];
        cell.colorLabel.textColor = [UIColor whiteColor];
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.phoneNumberLabel.textColor = [UIColor whiteColor];
    } else {
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.typeLabel.textColor = [UIColor whiteColor];
        cell.modelLabel.textColor = [UIColor whiteColor];
        cell.statusLabel.textColor = [UIColor whiteColor];
        cell.colorLabel.textColor = [UIColor whiteColor];
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.phoneNumberLabel.textColor = [UIColor whiteColor];
    }
    
    
    id keyValuePair = self.dataList[indexPath.row];
    
    cell.typeLabel.text = keyValuePair[@"type"];
    cell.modelLabel.text= keyValuePair[@"model"];
    cell.statusLabel.text = keyValuePair[@"color"];
    cell.colorLabel.text = keyValuePair[@"status"];
    cell.nameLabel.text = keyValuePair[@"name"];
    cell.phoneNumberLabel.text = keyValuePair[@"phone_number"];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedIndex == indexPath.row) {
        return 100;
    } else {
        return 70;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([Utils sharedInstance].isLogged == NO) {
        [self textAllertMessage:@"Sign in, please!"];
    } else {
        if (selectedIndex == indexPath.row) {
            selectedIndex = -1;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
        if (selectedIndex != -1) {
            NSIndexPath *previusPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
            selectedIndex = indexPath.row;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previusPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) textAllertMessage:(NSString*) name{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: name
                                                                        message: nil
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Закрыть"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                            NSLog(@"Dismiss button tapped!");
                                                        }];
    
    UIAlertAction *alertCall = [UIAlertAction actionWithTitle: @"Sign In"
                                                        style: UIAlertActionStyleDestructive
                                                      handler: ^(UIAlertAction *action) {
                                                          
                                                          [self performSegueWithIdentifier:@"signInSegue" sender:nil];
                                                      }];
    
    [controller addAction: alertAction];
    [controller addAction:alertCall];
    
    [self presentViewController: controller animated: YES completion: nil];
}

@end
