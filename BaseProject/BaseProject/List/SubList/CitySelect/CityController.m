//
//  CityController.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/16.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "CityController.h"

typedef enum : NSUInteger {
    
    City_Province   = 0,
    City_City       = 1,
    City_Area       = 2,
    
} CityType;

@interface CityController ()

@end

@implementation CityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.title;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityCellId"];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellId = @"cityCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    

    NSDictionary *dict = self.array[indexPath.row];
    
    if ([dict isKindOfClass:[NSDictionary class]]) {
        cell.textLabel.text = dict[@"name"];
    }
    else {
        cell.textLabel.text = self.array[indexPath.row];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = _array[indexPath.row];
    
    NSString *str = @"";
    if ([dict isKindOfClass:[NSDictionary class]]) {
        str = dict[@"name"];
    }else {
        str = _array[indexPath.row];
    }

    NSString *newStr = str;
    if (self.selectedStr) {
        newStr = [NSString stringWithFormat:@"%@ %@",self.selectedStr,str];
    }
    self.selectBlock(newStr);
    
    if (NO == [dict isKindOfClass:[NSDictionary class]]) {
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:NSClassFromString(@"CitySelectController")]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        return;
    }
    
    
    CityController *cityController = [[CityController alloc] init];
    cityController.currentTitle = dict[@"name"];
    cityController.array = dict[@"sub"];
    cityController.selectedStr = newStr;
    cityController.selectBlock = self.selectBlock;
    if (cityController.array.count > 0) {
        [self.navigationController pushViewController:cityController animated:YES];
    }else {
        
    }
}

- (void)popToSelectBefore {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:NSClassFromString(@"CitySelectController")]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
